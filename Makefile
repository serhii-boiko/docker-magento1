# import environment variables
env_file := build.env
build_args := -i --rm --env-file ${env_file} -v $${PWD}/magento:/var/www/html --network magento magentoweb:latest
magento_version := 1.9.3.8
install_dir := /var/www/html

all: build up
build:
	@[[ -d ./magento ]] && { echo '\n./magento directory already exist\n'; exit 1; } || true

	@echo "\n\033[1;92m--> Build magentoweb container\033[0m\n"
	docker build -t magentoweb:latest ./magento-web

	@echo "\n\033[1;92m--> Download magento project\033[0m\n"
	docker run ${build_args} bash  -c 'cd /tmp \
		&& curl https://codeload.github.com/OpenMage/magento-mirror/tar.gz/${magento_version} -o ${magento_version}.tar.gz \
		&& tar xvf ${magento_version}.tar.gz \
		&& mv magento-mirror-${magento_version}/* magento-mirror-${magento_version}/.htaccess ${install_dir}'

	@echo "\n\033[1;92m--> Change file permission\033[0m\n"
	docker run ${build_args} bash  -c 'chown -R www-data:www-data ${install_dir}'

up:
	@echo "\n\033[1;92m--> Up all docker containers\033[0m\n"
	docker-compose up -d

down:
	@echo "\n\033[1;92m--> Down all docker containers\033[0m\n"
	docker-compose down

ps:
	@echo && docker-compose ps && echo

destroy:
	@echo "\n\033[1;91mWARNING: All created docker resources and volumes will be destroyed!\033[0m\n"
	@echo "Press Ctrl+C to cancel\n"
	@sleep 10
	docker-compose down -v
	docker-compose rm -f -v
	docker-compose images -q | xargs docker rmi
	rm -rf ./db-data || true
	rm -rf ./magento || true

login:
	docker-compose exec magento-web bash

mysql:
	docker-compose exec magento-db bash -c 'mysql -uroot -p$${MYSQL_ROOT_PASSWORD} --database $${MYSQL_DATABASE}'

install:
	@echo "\n\033[1;92m--> Installing magento\033[0m\n"
	docker-compose exec magento-web install-magento
	@echo "\n\033[1;92m--> Done.\033[0m\n"

sampledata:
	@echo "\n\033[1;92m--> Deploying sample data. It will take a few minutes.\033[0m\n"
	docker-compose exec magento-web install-sampledata
	@echo "\n\033[1;92m--> Sample data deployment completed.\033[0m\n"
