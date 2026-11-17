## Docker Development Environment

This repository includes a Docker Compose setup for local development and testing of Grafana configurations.

### Services

- **Grafana** (port 3000): Web-based analytics and monitoring platform
- **Prometheus** (port 9090): Time series database and monitoring system

### Quick Start

1. Start the services:
```bash
docker compose up -d
```

2. Access the applications:
   - Grafana: http://localhost:3000 (admin/admin, local development only)
   - Prometheus: http://localhost:9090

3. Create a Grafana service account with the Admin role and generate a token
   (Administration → Users and access → Service accounts). Use it as `grafana_api_key`
   in `environments/dev/terraform.tfvars` or export it as `TF_VAR_grafana_api_key`.

4. Stop the services:
```bash
docker compose down
```

### Configuration

- Prometheus configuration: `prometheus.yml`
- Data persistence: Grafana data is stored in the `grafana-storage` Docker volume
- Grafana resources (datasources, folders, dashboards) are managed by Terraform from `environments/dev`, not by provisioning files

This setup provides a complete monitoring stack for testing Terraform-managed Grafana configurations locally.
