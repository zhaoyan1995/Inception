# User/Administrator Documentation - Inception 

## Overview of provided service 
- **NGINX**: Web server acting as TLS Reverse Proxy (Port 443)
- **WordPress + PHP-FPM**: Dynamic website engine and Fast CGI handler
- **MariaDB**: Relational database management system.


## Quick Start: How to start or stop the project? 
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

## Accessing the Website & Admin Dashboard

### Main Website:
- **URL**: `https://yanzhao.42.fr`
- **Browser Access**: Upon entering the URL in your web browser, click on **Advanced** and select **Accept the Risk and Continue** (or *Proceed*) to bypass the self-signed SSL certificate warning.
- **Features**: You can view blog posts, navigate pages, or post comments.

### WordPress Administration Panel:
- **URL**: `https://yanzhao.42.fr/wp-admin`
- **Authentication**: Enter the username and password saved in your secrets files to log into the `wp-admin` dashboard.
- **Features**: You can manage posts, comments, user accounts, themes, and plugins in this section.

---

## Credentials Management

- **Location of Secrets**:
  The secrets directory should always be stored in the root directory of this project: `./secrets/`

- **Required Secret Files**:
  You should create three different files:
  1. `credentials.txt`: A dedicated file to save all sensitive information related to the WordPress service (e.g., admin credentials, user passwords).
  2. `db_root_password.txt`: A dedicated file to save the password for the MariaDB `root` user.
  3. `db_user_password.txt`: A dedicated file to save the password for the regular MariaDB database user.

---

## Service Health & Status Verification

```bash
# Check the container status
docker ps

# Expected output example (Verify that the "STATUS" column always shows the "Up" keyword to ensure containers run smoothly)
CONTAINER ID   IMAGE       COMMAND                  CREATED        STATUS       PORTS                                     NAMES
76052d6485d4   wordpress   "/entrypoint.sh"         20 hours ago   Up 3 hours   9000/tcp                                  wordpress
19c7fa167c00   nginx       "nginx -g 'daemon of…"   20 hours ago   Up 3 hours   0.0.0.0:443->443/tcp, [::]:443->443/tcp   nginx
5b0910a8d27b   mariadb     "/entrypoint.sh"         20 hours ago   Up 3 hours   3306/tcp                                  mariadb


# Check service logs to follow up on how the container works
docker logs <container_name> #(nginx or mariadb or wordpress)


# Check website health (Expected HTTP status code: 200 OK or 302 Found)
curl -kI https://yanzhao.42.fr