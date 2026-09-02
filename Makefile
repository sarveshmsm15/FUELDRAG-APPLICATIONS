.PHONY: help dev prod stop logs shell migrate seed test clean certs

help: ## Show this help
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

dev: ## Start development environment
	docker compose up -d

prod: ## Start production environment
	@cp .env.production .env 2>/dev/null || echo "⚠️  Copy .env.production.example to .env.production and fill in values first!"
	docker compose -f docker-compose.prod.yml up -d --build

stop: ## Stop all containers
	docker compose down
	docker compose -f docker-compose.prod.yml down

logs: ## Tail logs from all services
	docker compose logs -f

logs-prod: ## Tail production logs
	docker compose -f docker-compose.prod.yml logs -f

shell: ## Open shell in API container
	docker compose exec api sh

migrate: ## Run database migrations
	docker compose exec api npx prisma migrate deploy

seed: ## Seed database
	docker compose exec api npx tsx prisma/seed.ts

test: ## Run all tests
	cd server && npm test
	cd apps/mobile && flutter test

test-server: ## Run server tests only
	cd server && npm test

test-mobile: ## Run Flutter tests only
	cd apps/mobile && flutter test

certs: ## Generate SSL certificates with Let's Encrypt
	docker compose -f docker-compose.prod.yml run --rm certbot certonly --webroot -w /var/www/certbot -d $(DOMAIN)

certs-renew: ## Renew SSL certificates
	docker compose -f docker-compose.prod.yml run --rm certbot renew

clean: ## Remove all containers, volumes, and images
	docker compose down -v --rmi all
	docker compose -f docker-compose.prod.yml down -v --rmi all

health: ## Check API health
	curl -s http://localhost:3000/health | python3 -m json.tool

metrics: ## Check Prometheus metrics
	curl -s http://localhost:9090/metrics | head -20
