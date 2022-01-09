.PHONY: $(MAKECMDGOALS)

dc=docker-compose -f docker-compose.yml $(1)
dc-run-web=$(call dc, run --rm web $(1))
dc-run-hutch=$(call dc, run --rm hutch $(1))
dc-up=$(call dc, up $(1))
dc-upd=$(call dc, up -d $(1))

usage:
	@echo "Available targets:"
	@echo "  * setup         		  - Initiates everything (building images and installing gems"
	@echo "  * build         		  - Build image"
	@echo "  * update         		- Install/update depenencies and run migrations after pulling upstream updates"
	@echo "  * shell         		  - Fires a shell inside your container"
	@echo "  * console         		- Starts up an interactive ruby console"
	@echo "  * app         		    - Runs the development server"
	@echo "  * down          			- Removes all the containers and tears down the setup"
	@echo "  * clean         		  - remove built containers"
	@echo "  * logs         		  - View logs from the running services"
	@echo "  * db-console        	- Start a postgres psql console session
	@echo "  * test         		  - Runs rspec"
	@echo "  * guard         		  - Runs guard"


app:
	@echo "=> Starting all services..."
	$(call dc, up)
up:
	@echo "=> Starting all services (Detached)..."
	docker-compose up

## DEPENDENCIES AND BUILD
build:
	$(call dc, build)
bundle:
	$(call dc-run-web, bundle install)
setup:
	@echo "=> Running Rails setup..."
	$(call dc-run-web, bin/setup)
clean:
	@echo "=> Cleaning workspace..."
	docker-compose down --volumes --remove-orphans
stop:
	@echo "=> Stopping containers..."
	$(call dc, stop)

## DEVELOP
update:
	$(call dc-run-web, bin/update)
status:
	$(call dc, ps)
shell:
	@echo "=> Starting a bash shell..."
	$(call dc-run-web, bash)
db-console:
	@echo "=> Starting psql PG console..."
	docker-compose exec core-db psql -U postgres
console:
	@echo "=> Starting an interactive ruby console..."
	$(call dc-run-web, bundle exec rails console)
test:
	@echo "=> Running application tests..."
	$(call dc-run-web, bundle exec rspec $(SPEC))
logs:
	docker-compose logs -f
down:
	docker-compose down --remove-orphans
