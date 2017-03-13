# Workdir: /project

if [ -z "${STORAGEBOX_METHOD}" ] ; then 
	STORAGEBOX_METHOD="sftp"
fi

if [ ! -d ".rancherize" ] ; then
	mkdir .rancherize
fi

if [ -z "${RANCHER_COMPOSE_VERSION}" ] ; then
	RANCHER_COMPOSE_VERSION="0.12.2"
fi

RANCHER_COMPOSE="rancher-compose-${RANCHER_COMPOSE_VERSION}"
TARGET_RANCHER_COMPOSE="/usr/local/bin/$RANCHER_COMPOSE"
if [ ! -f "$TARGET_RANCHER_COMPOSE" ] ; then
	echo "rancher-compose version $RANCHER_COMPOSE_VERSION not found. Downloading."
	curl "https://releases.rancher.com/compose/v${RANCHER_COMPOSE_VERSION}/rancher-compose-linux-amd64-v${RANCHER_COMPOSE_VERSION}.tar.gz" \
		| gunzip | tar -C /tmp -x
	cp /tmp/rancher-compose-v${RANCHER_COMPOSE_VERSION}/rancher-compose "$TARGET_RANCHER_COMPOSE"
	chmod +x "$TARGET_RANCHER_COMPOSE"
	echo "Installed Rancher compose $RANCHER_COMPOSE_VERSION to $TARGET_RANCHER_COMPOSE"
fi

sed \
	-e "s~%%RANCHER_URL%%~${RANCHER_URL}~g" \
	-e "s~%%RANCHER_KEY%%~${RANCHER_KEY}~g" \
	-e "s~%%RANCHER_SECRET%%~${RANCHER_SECRET}~g" \
	-e "s~%%RANCHER_COMPOSE%%~${RANCHER_COMPOSE}~g" \
	-e "s~%%BACKUP_VOLUME%%~${BACKUP_VOLUME}~g" \
	-e "s~%%BACKUP_DRIVER%%~${BACKUP_DRIVER}~g" \
	-e "s~%%STORAGEBOX_METHOD%%~${STORAGEBOX_METHOD}~g" \
	-e "s~%%STORAGEBOX_URL%%~${STORAGEBOX_URL}~g" \
	-e "s~%%STORAGEBOX_USER%%~${STORAGEBOX_USER}~g" \
	-e "s~%%STORAGEBOX_PASSWORD%%~${STORAGEBOX_PASSWORD}~g" \
	/opt/rancherize.tpl > /home/user/.rancherize

case $1 in
	list)
		vendor/bin/rancherize backup:list db
		;;
	restore)
		shift
		BACKUP="$1"
		vendor/bin/rancherize backup:restore db "$BACKUP"
		;;
	run)
		shift
		$*
		;;
esac
