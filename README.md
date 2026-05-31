# Docker Setup Scripts for Google Cloud Compute Instances

Simple bash scripts to install and completely uninstall Docker on Debian-based Google Cloud Compute instances.

---

## Files

| File | Description |
|---|---|
| `install_docker.bash` | Installs Docker Engine and related components |
| `uninstall_docker.bash` | Completely removes Docker and all its data |

---

## Requirements

- Debian-based Google Cloud Compute instance (Debian 12 Bookworm or later)
- `sudo` privileges

---

## Usage

### Install Docker

Download the script:

```bash
curl -fsSLO https://raw.githubusercontent.com/PinSpuGM/docker-setup/main/install_docker.bash
# or
wget https://raw.githubusercontent.com/PinSpuGM/docker-setup/main/install_docker.bash
```

Run it:

```bash
bash install_docker.bash
```

After the script finishes, **log out and log back in** for the group permission changes to take effect.

### Uninstall Docker

Download the script:

```bash
curl -fsSLO https://raw.githubusercontent.com/PinSpuGM/docker-setup/main/uninstall_docker.bash
# or
wget https://raw.githubusercontent.com/PinSpuGM/docker-setup/main/uninstall_docker.bash
```

> **Warning:** This will permanently delete all Docker images, containers, and volumes on the machine. This action cannot be undone.

Run it:

```bash
bash uninstall_docker.bash
```

---

## What Each Script Does

### `install_docker.bash`

1. Removes any previously installed Docker versions to avoid conflicts
2. Installs required dependencies (`ca-certificates`, `curl`, `gnupg`, `lsb-release`)
3. Adds Docker's official GPG key for package verification
4. Adds the official Docker APT repository
5. Installs Docker Engine and plugins:
   - `docker-ce` — Docker Engine
   - `docker-ce-cli` — Docker command-line interface
   - `containerd.io` — Container runtime
   - `docker-buildx-plugin` — Extended build capabilities
   - `docker-compose-plugin` — Multi-container management
6. Starts the Docker service and enables it to start automatically on boot

### `uninstall_docker.bash`

1. Stops and disables the Docker services (`docker`, `docker.socket`, `containerd`)
2. Removes all Docker packages, including any legacy versions
3. Deletes all Docker data — images, containers, volumes, and networks (`/var/lib/docker`)
4. Removes Docker configuration and runtime directories
5. Removes the Docker APT repository and GPG key
6. Removes the Docker CLI configuration from the current user's home directory
7. Removes the `docker` system group
8. Refreshes the APT package index

---

## Author

Written by Pin
