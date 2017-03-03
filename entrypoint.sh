# Workdir: /project

if [ -z "${STORAGEBOX_METHOD}" ] ; then 
	STORAGEBOX_METHOD="sftp"
fi

sed \
	-e "s~%%RANCHER_URL%%~${RANCHER_URL}~g" \
	-e "s~%%RANCHER_KEY%%~${RANCHER_KEY}~g" \
	-e "s~%%RANCHER_SECRET%%~${RANCHER_SECRET}~g" \
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
