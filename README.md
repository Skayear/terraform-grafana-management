# terraform-grafana-management

Infrastructure as Code (IaC) repository for centralized Grafana management using Terraform. Provides reusable modules to manage dashboards, panels, alerts, folders, and other resources in a standardized, versioned, and GitOps-aligned way.

## Layout

- `environments/<env>/` — Terraform root modules, one per Grafana instance.
- `modules/dashboards/` — folders and dashboards read from a directory of JSON files (used for migration).
- `modules/panels/*` — typed panel builders (`text`, `graph`, `stat`, `gauge`, `table`, `barchart`, `piechart`) for dashboards written in HCL.
- `scripts/export_grafana.py` — exports folders and dashboards from Grafana into the layout used by `modules/dashboards`.
- `docker/` — local Grafana + Prometheus for development.

## Migrating existing dashboards and folders

`modules/dashboards` reads a directory that mirrors the Grafana folder tree:

```
dashboards/
  home.json                      # dashboard in the General folder
  team-a/_folder.json            # folder "team-a" ({"title": "Team A"})
  team-a/overview.json           # dashboard in team-a
  team-a/services/_folder.json   # nested folder (up to 4 levels)
  team-a/services/api.json
```

Directories are named by folder UID and dashboard files hold the dashboard model as Grafana stores it (every dashboard needs a `uid`).

1. Export everything from Grafana (needs a service account token with the Admin role):

   ```bash
   cd environments/dev
   GRAFANA_AUTH=<token> ../../scripts/export_grafana.py \
     --url http://localhost:3000 \
     --out dashboards \
     --imports imports.tf \
     --module module.dashboards
   ```

   Use `--exclude-folder <uid>` for folders managed elsewhere in Terraform (for example the folder of the HCL dashboards).

2. `terraform plan` must show only imports (`N to import, 0 to add, 0 to destroy`). The only in-place change expected on folders is `prevent_destroy_if_not_empty`, a Terraform-side safeguard.
3. `terraform apply` to adopt the resources. Nothing is recreated in Grafana.

## Maintaining changes

- **Change in Git** (edit, add, move or delete a JSON file) → `terraform plan` / `apply`.
- **Change in the Grafana UI** → `terraform plan` shows it as drift and would revert it. Run the export again to pull it into Git, review the diff and commit; new dashboards get an import block automatically.
- When deleting a dashboard in Git, apply before exporting again: the export mirrors Grafana and would bring it back. Also remove its block from `imports.tf` (or regenerate the file after the apply).
- Folders are not destroyed while they still contain dashboards (`prevent_destroy_if_not_empty`).
- Dashboards provisioned from files on the Grafana server are skipped by the export: they cannot be managed through the API.

## Checks

```bash
terraform fmt -check -recursive
for module in $(find modules -type d -name tests -exec dirname {} \;); do
  terraform -chdir="$module" init -backend=false && terraform -chdir="$module" test
done
```

CI runs the same checks plus `terraform validate` on every push and pull request.
