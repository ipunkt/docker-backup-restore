FROM ipunktbs/php-composer:7.0.9-1.2.0
ENV HOME=/home/user
LABEL maintainer "Sven Speckmaier <sps@ipunkt.biz>"

ADD rancherize.tpl /opt/rancherize.tpl
ADD rancherize.json /project/rancherize.json
ADD entrypoint.sh /
RUN chmod +x /entrypoint.sh \
	 && mkdir -p /home/user \
	 && mkdir -p /project \
	 && cd /project \
	 && composer require ipunkt/rancherize:^2.3.0 \
	 && vendor/bin/rancherize plugin:install ipunkt/rancherize-backup-storagebox:1.0.0
WORKDIR /project
ENTRYPOINT ["bash", "/entrypoint.sh"]
