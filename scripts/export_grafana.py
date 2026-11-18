#!/usr/bin/env python3
"""Export Grafana folders and dashboards into the layout read by modules/dashboards.

Writes one directory per folder (named by folder UID, with a _folder.json) and one
<dashboard-uid>.json per dashboard, plus a Terraform file with import blocks so
existing resources are adopted instead of recreated.

The output directory is owned by this script: dashboard and folder files that no
longer exist in Grafana are removed. Run it again to pull changes made in the UI.

Authentication is read from GRAFANA_AUTH: a service account token, or "user:password".

Example:
  GRAFANA_AUTH=glsa_... scripts/export_grafana.py \
    --url http://localhost:3000 \
    --out environments/dev/dashboards \
    --imports environments/dev/imports.tf \
    --module module.dashboards
"""

import argparse
import base64
import json
import os
import sys
import urllib.parse
import urllib.request
from pathlib import Path

PAGE_SIZE = 1000
FOLDER_FILE = "_folder.json"
MAX_DEPTH = 4
# Server-managed fields; the Terraform provider ignores them as well.
VOLATILE_KEYS = ("id", "version")


class Grafana:
    def __init__(self, url, auth):
        self.url = url.rstrip("/")
        if ":" in auth:
            self.header = "Basic " + base64.b64encode(auth.encode()).decode()
        else:
            self.header = "Bearer " + auth

    def get(self, path, **params):
        query = f"?{urllib.parse.urlencode(params)}" if params else ""
        request = urllib.request.Request(
            f"{self.url}{path}{query}", headers={"Authorization": self.header}
        )
        try:
            with urllib.request.urlopen(request) as response:
                return json.load(response)
        except urllib.error.HTTPError as error:
            sys.exit(f"GET {path} failed: HTTP {error.code} {error.read().decode()[:300]}")

    def search(self, kind):
        results, page = [], 1
        while True:
            batch = self.get("/api/search", type=kind, limit=PAGE_SIZE, page=page)
            results.extend(batch)
            if len(batch) < PAGE_SIZE:
                return results
            page += 1


def folder_paths(folders, excluded):
    """Map folder UID -> list of UIDs from the top-level folder down to it."""
    parents = {f["uid"]: f.get("folderUid") or None for f in folders}
    paths = {}
    for uid in parents:
        chain, current = [], uid
        while current:
            if current not in parents:
                sys.exit(f"Folder {uid} has unknown parent {current}")
            chain.insert(0, current)
            current = parents[current]
        if not excluded.intersection(chain):
            paths[uid] = chain
    return paths


def write_json(path, data):
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(json.dumps(data, indent=2, ensure_ascii=False) + "\n", encoding="utf-8")


def remove_stale(out, keep):
    for path in sorted(out.rglob("*.json")):
        if path not in keep:
            path.unlink()
            print(f"removed  {path}")
    for path in sorted(out.rglob("*"), key=lambda p: len(p.parts), reverse=True):
        if path.is_dir() and not any(path.iterdir()):
            path.rmdir()


def import_block(address, resource_id):
    return f'import {{\n  to = {address}\n  id = "{resource_id}"\n}}\n'


def main():
    parser = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument("--url", required=True, help="Grafana base URL")
    parser.add_argument("--out", required=True, type=Path, help="dashboards directory to write")
    parser.add_argument("--imports", required=True, type=Path, help="Terraform file to write import blocks to")
    parser.add_argument("--module", default="module.dashboards", help="address of the modules/dashboards instance")
    parser.add_argument(
        "--exclude-folder", action="append", default=[], metavar="UID",
        help="skip this folder, its subfolders and their dashboards (repeatable)",
    )
    args = parser.parse_args()

    auth = os.environ.get("GRAFANA_AUTH")
    if not auth:
        sys.exit("Set GRAFANA_AUTH to a service account token or user:password")
    grafana = Grafana(args.url, auth)
    excluded = set(args.exclude_folder)

    folders = {f["uid"]: f for f in grafana.search("dash-folder")}
    paths = folder_paths(folders.values(), excluded)
    too_deep = [uid for uid, chain in paths.items() if len(chain) > MAX_DEPTH]
    if too_deep:
        sys.exit(f"Folders nested deeper than {MAX_DEPTH} levels: {', '.join(too_deep)}")

    written, imports = set(), []

    for uid, chain in sorted(paths.items(), key=lambda item: item[1]):
        path = args.out.joinpath(*chain, FOLDER_FILE)
        write_json(path, {"title": folders[uid]["title"]})
        written.add(path)
        imports.append(import_block(f'{args.module}.grafana_folder.level{len(chain)}["{uid}"]', uid))

    skipped = 0
    for hit in sorted(grafana.search("dash-db"), key=lambda h: h["uid"]):
        folder = hit.get("folderUid") or None
        if folder and folder not in paths:
            skipped += 1
            continue
        response = grafana.get(f"/api/dashboards/uid/{urllib.parse.quote(hit['uid'])}")
        if response["meta"].get("provisioned"):
            print(f"skipped  {hit['uid']} (provisioned from files, not manageable through the API)")
            skipped += 1
            continue
        dashboard = {k: v for k, v in response["dashboard"].items() if k not in VOLATILE_KEYS}
        path = args.out.joinpath(*(paths[folder] if folder else []), f"{hit['uid']}.json")
        write_json(path, dashboard)
        written.add(path)
        imports.append(import_block(f'{args.module}.grafana_dashboard.this["{hit["uid"]}"]', hit["uid"]))

    remove_stale(args.out, written)

    args.imports.parent.mkdir(parents=True, exist_ok=True)
    args.imports.write_text(
        "# Generated by scripts/export_grafana.py. Import blocks are no-ops for\n"
        "# resources already in the Terraform state, so this file can be kept.\n\n"
        + "\n".join(imports),
        encoding="utf-8",
    )

    print(
        f"exported {len(paths)} folders and {len(written) - len(paths)} dashboards"
        f" ({skipped} skipped) to {args.out}; import blocks in {args.imports}"
    )


if __name__ == "__main__":
    main()
