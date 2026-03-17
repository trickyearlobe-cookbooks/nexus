# Nexus Cookbook

[![Cookbook](https://img.shields.io/github/v/tag/trickyearlobe-cookbooks/nexus?label=cookbook&sort=semver)](https://github.com/trickyearlobe-cookbooks/nexus)

Chef cookbook to install and configure [Sonatype Nexus Repository Manager OSS](https://www.sonatype.com/products/sonatype-nexus-oss) on EL (RHEL, CentOS, AlmaLinux, Rocky, Amazon Linux, Oracle Linux, Fedora) and Debian-derived (Debian, Ubuntu) Linux distributions.

Nexus is installed from the official Sonatype tarball distribution. The cookbook creates a dedicated system user, extracts the archive, manages JVM and application configuration via templates, and runs Nexus as a systemd service.

## Requirements

### Chef

- Chef Infra Client **>= 16.0**

### Platforms

- AlmaLinux 9
- Amazon Linux 2023
- CentOS Stream 9
- Debian 12
- Fedora (latest)
- Oracle Linux 9
- Rocky Linux 9
- Ubuntu 24.04

### Dependencies

None — this cookbook has no external cookbook dependencies.

## Attributes

| Attribute | Default | Description |
|---|---|---|
| `node['nexus']['version']` | `'3.90.1-01'` | Nexus version to install. Used to template the download URL and extraction path. |
| `node['nexus']['download_url']` | `https://download.sonatype.com/nexus/3/nexus-<version>-linux-x86_64.tar.gz` | Full URL for the Nexus tarball. Automatically derived from the version attribute. |
| `node['nexus']['user']` | `'nexus'` | System user that owns and runs Nexus. |
| `node['nexus']['group']` | `'nexus'` | System group for the Nexus user. |
| `node['nexus']['home']` | `'/opt/nexus'` | Base directory where Nexus versions are extracted. |
| `node['nexus']['data_dir']` | `'/opt/sonatype-work/nexus3'` | Directory for Nexus persistent data (blobs, databases, logs, etc.). |
| `node['nexus']['jvm']['xms']` | `'2703m'` | JVM minimum heap size (`-Xms`). |
| `node['nexus']['jvm']['xmx']` | `'2703m'` | JVM maximum heap size (`-Xmx`). |
| `node['nexus']['jvm']['xss']` | `'250k'` | JVM thread stack size (`-Xss`). |
| `node['nexus']['host']` | `'0.0.0.0'` | IP address Nexus binds to. |
| `node['nexus']['port']` | `8081` | HTTP port Nexus listens on. |
| `node['nexus']['context_path']` | `'/'` | Web context path for the Nexus UI. |

## Recipes

### `nexus::default`

Includes all sub-recipes in order:

1. `nexus::user`
2. `nexus::install`
3. `nexus::configure`
4. `nexus::service`

### `nexus::user`

Creates the `nexus` system group and user, plus the installation (`home`) and data (`data_dir`) directories with correct ownership.

### `nexus::install`

Installs the `tar` and `gzip` packages, downloads the Nexus tarball from Sonatype, extracts it into the installation directory, and creates a `nexus-current` convenience symlink.

### `nexus::configure`

Manages the following configuration files via ERB templates:

- **`bin/nexus.vmoptions`** — JVM heap, stack, GC, and logging settings.
- **`bin/nexus.rc`** — run-as user for the Nexus process.
- **`etc/nexus-default.properties`** — HTTP host, port, context path, and edition settings.

All templates notify the Nexus service to restart on change.

### `nexus::service`

Creates and enables a `nexus.service` systemd unit, then starts the Nexus service. The service is configured as a forking process with `LimitNOFILE=65536` and a 600-second startup timeout.

## Usage

### Basic

Add `nexus::default` to your node's run list:

```json
{
  "run_list": ["recipe[nexus::default]"]
}
```

### Policyfile

```ruby
name 'nexus'
default_source :supermarket
run_list 'nexus::default'
cookbook 'nexus', github: 'trickyearlobe-cookbooks/nexus'
```

### Customizing the version

Override the version attribute in a role, environment, Policyfile, or wrapper cookbook:

```ruby
default['nexus']['version'] = '3.90.1-01'
```

The download URL is automatically derived. If you need to point to an internal mirror or artifact cache, override `download_url` directly:

```ruby
default['nexus']['download_url'] = 'https://artifacts.internal.example.com/nexus/nexus-3.90.1-01-linux-x86_64.tar.gz'
```

### Tuning JVM memory

For production workloads, Sonatype recommends at least 4 GB of heap. Adjust via attributes:

```ruby
default['nexus']['jvm']['xms'] = '4096m'
default['nexus']['jvm']['xmx'] = '4096m'
```

## Testing

### Unit tests (ChefSpec)

```bash
chef exec rspec
```

### Integration tests (Test Kitchen + InSpec)

```bash
kitchen converge
kitchen verify
kitchen destroy
```

Or run the full cycle:

```bash
kitchen test
```

The `kitchen.yml` is preconfigured with Vagrant and covers multiple EL and Debian-family platforms.

## Upgrading Nexus

To upgrade Nexus to a new version:

1. Update `node['nexus']['version']` to the desired version string (e.g. `'3.91.0-01'`).
2. Run Chef. The cookbook will download the new tarball, extract it alongside the old version, update the `nexus-current` symlink, and restart the service.
3. The previous version directory remains on disk under `node['nexus']['home']` for easy rollback.

## Post-install notes

- The default admin password is written to `<data_dir>/admin.password` on first startup. Retrieve it and change it immediately via the Nexus UI.
- Nexus bundles its own JRE, so no separate Java installation is required.
- The service listens on port **8081** by default. Adjust `node['nexus']['port']` or place a reverse proxy (nginx, Apache, HAProxy) in front.

## Source

- **Repository**: [github.com/trickyearlobe-cookbooks/nexus](https://github.com/trickyearlobe-cookbooks/nexus)
- **Issues**: [github.com/trickyearlobe-cookbooks/nexus/issues](https://github.com/trickyearlobe-cookbooks/nexus/issues)

## License

Apache-2.0

## Authors

Richard Nixon