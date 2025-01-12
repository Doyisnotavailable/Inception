# Set the name of the docker-compose service
DC_FILE=srcs/docker-compose.yaml
DB=srcs-mariadb
WP=srcs-wordpress
NG=srcs-nginx

all: build up
# Build the containers defined in docker-compose.yml
build:
	docker-compose -f $(DC_FILE) build

# Start the containers in detached mode
up:
	docker-compose -f $(DC_FILE) up -d

# Stop the containers
down:
	docker-compose -f $(DC_FILE) down

# Show logs for the containers
logs:
	docker-compose -f $(DC_FILE) logs -f

# Check the status of the containers
ps:
	docker-compose -f $(DC_FILE) ps

# Remove all containers, networks, and volumes (WARNING: will delete data)
clean:
	docker-compose -f $(DC_FILE) down --volumes

# Rebuild the containers and restart them
restart: down up

# View the logs for a specific service (e.g., db, nginx)
logs-service:
	docker-compose -f $(DC_FILE) logs -f $(service)

# Execute a command inside a running container (e.g., db)
exec:
	docker-compose -f $(DC_FILE) exec $(service) $(command)

fclean: down
	@docker rmi $(DB) $(WP) $(NG)