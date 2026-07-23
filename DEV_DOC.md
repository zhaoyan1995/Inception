# Developper Documentation - Inception 

## Set up the environment
### Prerequisites
Ensure the host machine has the following packages installed:
* `make`
* `docker.io`
* `docker compose`

### Environment Variables (`./srcs/.env`)
💡 Replace <your_login> and <your_db_username> with your actual 42 session login and preferred database user name.

Create a `.env` file inside the `./srcs/` directory that contains non-sensitive runtime parameters; 
```env
# User Configuration & Storage Paths
USER_NAME=<your_login>
DATA_PATH=/home/<your_login>/data
SECRETS_PATH=/home/<your_login>/Inception/secrets

# Database Non-Sensitive Configurations
MYSQL_DATABASE=wordpress_db
MYSQL_USER=<your_db_username>
```

### Secrets Setup (`./secrets/`)
Create the secret files inside the `./secrets/` directory at the project root to securely pass credentials to Docker Compose via Docker Secrets:

```env
# WordPress General Settings
WP_URL=https://<your_login>.42.fr
WP_TITLE=Inception

# Admin Account Credentials
WP_ADMIN_USER=admin_user
WP_ADMIN_PASSWORD=your_secure_admin_password
WP_ADMIN_EMAIL=admin@example.com

# Regular User Credentials
WP_USER=regular_user
WP_USER_EMAIL=user@example.com
WP_USER_PASSWORD=your_secure_user_password
```

## How to start or stop the project with Makefile? 
```bash
# Build Docker images for Nginx, WordPress, and MariaDB services and start running them in containers
make

# Stop and remove containers, networks, and Docker volumes created by compose
make clean

# Remove all containers, volumes, all unused Docker images, and clear host data directory
make fclean

# Rebuild the entire project from scratch
make re
```

## How to start or stop the project using docker compose directly? 

While the `Makefile` provides convenient shortcuts, developers can directly manage the container stack lifecycle using native `docker compose` commands from the ./srcs directory:

### 1. Build and Start All Containers
```bash
docker compose --env-file srcs/.env -f srcs/docker-compose.yml up -d --build

# -d: Runs containers in detached (background) mode.
# --build: Forces Docker to rebuild custom images from local Dockerfiles before starting.
# --env-file: Explicitly loads environment variables from srcs/.env.
```


### 2. Stop Containers without Removing Volumes
```bash 
docker compose --env-file srcs/.env -f srcs/docker-compose.yml stop

# Stop all active containers while preserving container instances, networks, and persistent data volumes.
```

### 3. Restart Container
```bash
docker compose --env-file srcs/.env -f srcs/docker-compose.yml start

# Restarts previously stopped containers without re-building images or re-creating network bridges.
```

### 3. Stop and remove stack
```bash
docker compose --env-file srcs/.env -f srcs/docker-compose.yml down -v

#down: Stops and removes running containers and custom bridge networks.
#-v: Purges named Docker volumes associated with the stack (mariadb_data and wordpress_data).
```

## Container, Network, and Volume Management Commands 
Use relevant commands to manage the containers and volumes.
* Container Lifecycle & Health Monitoring
```bash
docker ps
```
* Track services log to facilite the debug session 
```bash
docker logs <container_name>
```
* List Persistent Data Volumes (Displays mounted volumes):
```bash
docker volume ls
```
* Inspect Specific Volume Metadata (Check out the actual physical storage path on the host machine):
```bash
docker volume inspect <volume_name>
```

* Inspect Custom Bridge Network (Verifies NGINX, WordPress, and MariaDB are in the same isolated birdge network and checks their allocated internal IPs):
```bash
docker network ls
docker network inspect <network_name>
```

* Interactive Debugging (Shell Execution)
```bash
docker exec -it <container_name> sh
```

## Data Storage & Persistence

* **Storage Location**: Persistent volume data is stored on the host machine at `/home/<login_id>/data/mariadb` and `/home/<login_id>/data/wordpress`.
* **Container Lifecycle Resilience**: Running `make clean` or `docker compose down` removes containers and networks but preserves the host data. Running `make` re-attaches the containers to the existing persistent data seamlessly.
* **Complete Data Purge**: Executing `make fclean` (which runs `sudo rm -rf /home/<login_id>/data` and `docker system prune -af`) permanently deletes all saved data from the host machine.

