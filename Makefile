build:
	rocker build --pull -var tag="tasks:1" .

db:
	kubectl run tasks-mysql --image=mysql:5.7 --env="MYSQL_DATABASE=forge" --env="MYSQL_USER=forge" --env="MYSQL_PASSWORD=forge" --env="MYSQL_RANDOM_ROOT_PASSWORD=true" --port 3306
	kubectl expose deploy/tasks-mysql

redis:
	kubectl run tasks-redis --image=redis:alpine --port 6379
	kubectl expose deploy/tasks-redis

cache:
	kubectl run tasks-memcached --image=memcached:alpine --port 11211
	kubectl expose deploy/tasks-memcached

deploy:
	kubectl run tasks-app --image=tasks:1 --env="APP_KEY=base64:jOLirBjqGtigLqYTSSdLsiVUQTMBnyQ0T1Dq3UiF/dU=" --env="APP_VERSION=1" --env="DB_HOST=tasks-mysql" --env="REDIS_HOST=tasks-redis" --env="MEMCACHED_HOST=tasks-memcached" --env="DB_PASSWORD=forge" --port 8000 -- php artisan serve --host=0.0.0.0
	kubectl expose deploy/tasks-app --type=NodePort

