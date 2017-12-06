# docker-backup-restore
Use an internal rancherize to restore a specific backup

# Usage
## With ipunktbs/xtrabackup
This image is designed to be used in conjunction with ipunktbs/xtrabackup. Both
to restore backups from ipunktbs/xtrabackup and in a comming mode where
ipunktbs/xtrabackup creates - but does not run - an instance of this image for
every taken backup.

## Manually
To run the image manually set at least all environment variables listed below
that do not have a default value in a `docker run` command.
Available commands:

- run COMMAND: Run `command` in a shell withing the container. Ment for
  debugging
- list: show available backups
- restore BACKUP\_KEY: Restore the backup given as parameter

```sh
	docker run \
		-e RANCHER\_URL=http:\\/\\/example.com\\/v1\\/projects\\/1a1 \
		-e RANCHER\_KEY=XYZ \
		-e RANCHER\_SECRET=XYZ \
		-e RANCHER\_COMPOSE\_VERSION=0.12.2 \
		-e BACKUP\_DRIVER=convoy \
		-e BACKUP\_VOLUME=backup \
		-e STORAGEBOX\_METHOD= \
		-e STORAGEBOX\_URL=sftp://u123456.your-storagebox.de/backup-directory/ \
		-e STORAGEBOX\_USER=u123456 \
		-e STORAGEBOX\_PASSWORD=xzy \
		ipunktbs/backup-restore:latest restore XXXX-XX-XX-XXXXX
```

Since there are a few environment variables to keep track of here I recommend
writing a docker-compose.yml to run it instead:

```yaml
backupper:
  image: ipunktbs/backup-restore:latest
  environment:
    - RANCHER_URL=http:\\/\\/example.com\\/v1\\/projects\\/1a5
    - RANCHER_KEY=XYZ
    - RANCHER_SECRET=XYZ
    - RANCHER_COMPOSE_VERSION=0.12.2
    - BACKUP_VOLUME=backup
    - BACKUP_DRIVER=convoy
    - STORAGEBOX_URL=sftp://u123456.your-storagebox.de/backup/
    - STORAGEBOX_USER=u123456
    - STORAGEBOX_PASSWORD=xzy
  command: restore BACKUP_KEY
  restart: "no"
```

	docker-compose up


# Environment variables

| environment variable | default value | description |
| -------------------- | ------------- | ----------- |
| RANCHER\_URL | - | Rancher api url as seen in the environment api tab. |
IMPORTANT: This is set using sed replacement and inserted into a json file. |
double escape slashes -> http:\\/\\/example.com\\/ |
| RANCHER\_KEY | - | Rancher api key to be used by rancher-compose and rancherize |
| RANCHER\_SECRET | - | Rancher api secret to be used by rancher-compose and rancherize  |
| RANCHER\_COMPOSE\_VERSION | 0.12.2 | Rancherize version to use - will be downloaded if necessary |
| BACKUP\_VOLUME | - | Backup storagebox option - on which global volumes are the backups kept? |
| BACKUP\_DRIVER | - | Backup storagebox option - which storage-driver needs to be set so the BACKUP\_VOLUME will access the backups|
| BACKUP\_PMA\_URL | - | Backup storagebox option - which the url which pma should attempt to publish |
| STORAGEBOX\_METHOD | sftp | Backup storagebox option - method to access the storagebox to retrieve backup configuration |
| STORAGEBOX\_URL | - | Backup storagebox option - url to access the storagebox to retrieve backup configuration |
| STORAGEBOX\_USER | - | Backup storagebox option - user to access the storagebox to retrieve backup configuration |
| STORAGEBOX\_PASSWORD | - | Backup storagebox option - password to access the storagebox to retrieve backup configuration |
