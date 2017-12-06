{
	"rancher": {
		"default": {
			"url": "%%RANCHER_URL%%",
			"key": "%%RANCHER_KEY%%",
			"secret": "%%RANCHER_SECRET%%",
			"rancher-compose":"%%RANCHER_COMPOSE%%"
		}
	},
		"docker": {
			"default": {
				"user":"",
				"password":""
			}
		},
		"database": {
			"default-database": {
				"service":"db",
				"stack":"db",
				"backup":{
					"method":"storagebox",
					"box": "default-storagebox",
					"volume":"%%BACKUP_VOLUME%%",
					"volume-driver":"%%BACKUP_DRIVER%%"
					%%BACKUP_PMA_LINE%%
				}
			}
		},
		"storagebox": {
			"default-storagebox": {
				"method": "%%STORAGEBOX_METHOD%%",
				"access": {
					"url":"%%STORAGEBOX_URL%%",
					"user":"%%STORAGEBOX_USER%%",
					"password":"%%STORAGEBOX_PASSWORD%%"
				}
			}
		}
}
