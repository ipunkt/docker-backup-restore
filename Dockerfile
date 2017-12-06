FROM ipunktbs/php-composer:7.0.9-1.2.0
ENV HOME=/home/user
LABEL maintainer="Sven Speckmaier <sps@ipunkt.biz>"

ADD rancherize.tpl /opt/rancherize.tpl
ADD rancherize.json /project/rancherize.json
ADD entrypoint.sh /
RUN chmod +x /entrypoint.sh \
	 && mkdir -p /home/user \
	 && mkdir -p /project/.rancherize \
	 && cd /project \
	 && apt-get update \
	 && apt-get -y install libssh2-1-dev \
	 && rm -Rf /var/lib/apt/lists/* \
	 && pecl install -a ssh2-1.0 \
	 && docker-php-ext-enable ssh2 \
	 && composer require --update-with-dependencies 'ipunkt/rancherize:^2.18' \
	 && vendor/bin/rancherize plugin:install ipunkt/rancherize-backup-storagebox:^2.0.1 \
	 && vendor/bin/rancherize plugin:install ipunkt/rancherize-publish-traefik-rancher:^1.0.2
WORKDIR /project
ENTRYPOINT ["bash", "/entrypoint.sh"]
