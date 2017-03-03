{
	"rancher": {
		"default": {
			"url": "%%RANCHER_URL%%",
				"key": "%%RANCHER_KEY%%",
				"secret": "%%RANCHER_SECRET%%"
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
				"backup":{
					"method":"storagebox",
					"box": "default-storagebox",
					"volume":"%%BACKUP_VOLUME%%",
					"volume-driver":"%%BACKUP_DRIVER%%"
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
