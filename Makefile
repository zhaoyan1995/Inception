NAME = inception
SRCS = srcs/docker-compose.yml

USER_NAME = $(shell whoami)
DATA_DIR = /home/$(USER_NAME)/data

all:
	# 1. build database dir
	@mkdir -p $(DATA_DIR)/wordpress
	@mkdir -p $(DATA_DIR)/mariadb
	chmod 777 $(DATA_DIR)/wordpress
	chmod 777 $(DATA_DIR)/mariadb

	# 2. build docker volume dir
	@sudo mkdir -p /var/lib/docker/volumes/srcs_wp_data
	@sudo mkdir -p /var/lib/docker/volumes/srcs_db_data
	# 3. remove the _data dir in order to establish shortcut 
	@sudo rm -rf /var/lib/docker/volumes/srcs_wp_data/_data
	@sudo rm -rf /var/lib/docker/volumes/srcs_db_data/_data
	# 4. establish shortcut so container can transfer data to the host machine
	@sudo ln -s $(DATA_DIR)/wordpress /var/lib/docker/volumes/srcs_wp_data/_data
	@sudo ln -s $(DATA_DIR)/mariadb /var/lib/docker/volumes/srcs_db_data/_data

	@docker compose -f $(SRCS) up -d --build

up: all

down:
	@docker compose -f $(SRCS) down

clean:
	@docker compose -f $(SRCS) down

fclean: clean
	@docker system prune -af
	@sudo rm -rf $(DATA_DIR)
	@sudo rm -rf /var/lib/docker/volumes/srcs_wp_data
	@sudo rm -rf /var/lib/docker/volumes/srcs_db_data

re: fclean all

.PHONY: all up down clean fclean re
