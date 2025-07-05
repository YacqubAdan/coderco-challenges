NAME=challenge1
IMAGE=ubuntu:22.04
FILES= ./app/.env ./app/server.py ./service/coderco-app.service ./scripts/setup.sh ./scripts/test.sh ./scripts/healthcheck.sh


.PHONY: up run test destroy shell

up:
	@if multipass info $(NAME) >/dev/null 2>&1; then \
		echo "$(NAME) already exists..."; \
	else \
		echo "Launching $(NAME)..."; \
		multipass launch --name $(NAME) --memory 1G --disk 5G; \
	fi
	multipass exec $(NAME) -- sudo apt update
	multipass exec $(NAME) -- sudo apt install -y systemd
	multipass exec $(NAME) -- sudo apt install -y ufw
	@chmod +x ./scripts/setup.sh ./scripts/test.sh ./scripts/healthcheck.sh
	@echo "Transferring files to VM..."
	@for file in $(FILES); do \
		echo "Transferring $$file..."; \
		multipass transfer $$file $(NAME):/home/ubuntu/ || echo "Failed to transfer $$file"; \
	done 

shell:
	multipass shell $(NAME)

run:
	@multipass exec $(NAME) -- bash /home/ubuntu/setup.sh

health:
	@multipass exec $(NAME) -- bash /home/ubuntu/healthcheck.sh

test:
	@multipass exec $(NAME) -- bash /home/ubuntu/test.sh

destroy:
	@echo "Destroying VM..."
	multipass delete $(NAME) --purge || echo "Nothing to destroy."