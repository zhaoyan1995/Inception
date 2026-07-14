NAME = inception
SRCS = srcs/docker-compose.yml

USER_NAME = $(shell whoami)
DATA_DIR = /home/$(USER_NAME)/data

all:
	@mkdir -p $(DATA_DIR)/wordpress
	@mkdir -p $(DATA_DIR)/mariadb
	@docker compose -f $(SRCS) up -d --build

up: all

down:
	@docker compose -f $(SRCS) down

clean:
	@docker compose -f $(SRCS) down -v

fclean: clean
	@docker system prune -af
	@sudo rm -rf $(DATA_DIR)

re: fclean all

.PHONY: all up down clean fclean re
