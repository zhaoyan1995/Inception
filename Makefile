NAME = inception
SRCS = srcs/docker-compose.yml
ENV_FILE = srcs/.env

USER_NAME = $(shell whoami)
DATA_DIR = /home/$(USER_NAME)/data

all:
	# 1. build database dir
	@mkdir -p $(DATA_DIR)/wordpress
	@mkdir -p $(DATA_DIR)/mariadb
	@docker compose --env-file $(ENV_FILE) -f $(SRCS) up -d --build

up: all

down:
	@docker compose --env-file $(ENV_FILE) -f $(SRCS) down -v

clean: down

fclean: clean
	@docker system prune -af
	@sudo rm -rf $(DATA_DIR)

re: fclean all

.PHONY: all up down clean fclean re
