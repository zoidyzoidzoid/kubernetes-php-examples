build:
	rocker build --pull -var tag="tasks:1" .

db:
	kubectl run tasks-mysql --image=mysql:5.7 --env="MYSQL_DATABASE=forge" --env="MYSQL_USERNAME=forge" --env="MYSQL_RANDOM_ROOT_PASSWORD=true" --port 3306
	kubectl expose deploy/tasks-mysql

redis:
	kubectl run tasks-redis --image=redis:alpine --port 6379
	kubectl expose deploy/tasks-redis

cache:
	kubectl run tasks-memcached --image=memcached:alpine --port 11211
	kubectl expose deploy/tasks-memcached

