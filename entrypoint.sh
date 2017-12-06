# Workdir: /project

if [ -z "${STORAGEBOX_METHOD}" ] ; then
	STORAGEBOX_METHOD="sftp"
fi

if [ ! -d ".rancherize" ] ; then
	mkdir .rancherize
fi

BACKUP_PMA_URL=${BACKUP_PMA_URL:-}
BACKUP_PMA_LINE=""
if [ ! -z "${BACKUP_PMA_URL}" ]  ; then
	BACKUP_PMA_LINE=',"pma-url":"'${BACKUP_PMA_URL}'"'
fi

download_rancher_compose() {

	RANCHER_COMPOSE_VERSION="$1"

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

}

download_rancher_compose "$RANCHER_COMPOSE_VERSION"

# \\\\/ -> \\/ which is escaped by the shell to \/
JSON_ESCAPED_RANCHER_URL=`echo "${RANCHER_URL}" | sed -e 's~/~\\\\/~g'`
#echo "JSON_ESCAPED: $JSON_ESCAPED_RANCHER_URL"
# \\\\\\\\ -> \\\\ which is then escaped by the shell to \\
SED_ESCAPED_RANCHER_URL=`echo "${JSON_ESCAPED_RANCHER_URL}" | sed -e 's~[\]~\\\\\\\\~g'`
#echo "SED_ESCAPED: $SED_ESCAPED_RANCHER_URL"
sed \
	-e "s~%%RANCHER_URL%%~${SED_ESCAPED_RANCHER_URL}~g" \
	-e "s~%%RANCHER_KEY%%~${RANCHER_KEY}~g" \
	-e "s~%%RANCHER_SECRET%%~${RANCHER_SECRET}~g" \
	-e "s~%%RANCHER_COMPOSE%%~${RANCHER_COMPOSE}~g" \
	-e "s~%%BACKUP_VOLUME%%~${BACKUP_VOLUME}~g" \
	-e "s~%%BACKUP_DRIVER%%~${BACKUP_DRIVER}~g" \
	-e "s~%%STORAGEBOX_METHOD%%~${STORAGEBOX_METHOD}~g" \
	-e "s~%%STORAGEBOX_URL%%~${STORAGEBOX_URL}~g" \
	-e "s~%%STORAGEBOX_USER%%~${STORAGEBOX_USER}~g" \
	-e "s~%%STORAGEBOX_PASSWORD%%~${STORAGEBOX_PASSWORD}~g" \
	-e "s~%%BACKUP_PMA_LINE%%~${BACKUP_PMA_LINE}~g" \
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
