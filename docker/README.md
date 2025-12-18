## Docker Development Environment

This repository includes a Docker Compose setup for local development and testing of Grafana configurations.

### Services

- **Grafana** (port 3000): Web-based analytics and monitoring platform
- **Prometheus** (port 9090): Time series database and monitoring system

### Quick Start

1. Start the services:
```bash
docker-compose up -d
```

2. Access the applications:
   - Grafana: http://localhost:3000 (admin/admin)
   - Prometheus: http://localhost:9090

3. Stop the services:
```bash
docker-compose down
```

### Configuration

- Prometheus configuration: `prometheus.yml`
- Grafana provisioning: `grafana/provisioning/` (for datasources, dashboards, etc.)
- Data persistence: Grafana data is stored in a Docker volume

This setup provides a complete monitoring stack for testing Terraform-managed Grafana configurations locally.