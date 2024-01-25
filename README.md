# Bitwarden_Export

<img src="https://raw.githubusercontent.com/dani-garcia/vaultwarden/main/resources/vaultwarden-icon.svg" width="180">

**[Bitwarden_Export](https://github.com/0neTX/Bitwarden_Export)**: Docker to backup your Bitwarden vault contents


[![CD to Docker Hub to Release-Latest](https://github.com/0neTX/Bitwarden_Export/actions/workflows/docker-publishhub-latest.yml/badge.svg?branch=main&event=status)](https://github.com/0neTX/Bitwarden_Export/actions/workflows/docker-publishhub-latest.yml)


## Features

This simple bash docker image uses the Bitwarden CLI to perform three backup tasks:

- [x] Export personal vault
- [x] Export organization vault (if applicable)
- [x] Export file attachments (if applicable)

The docker image provides the choice of creating unencrypted export files or password-encrypted export files. Attachments are not encrypted.

## Compatibility

This docker image is compatible with Linux, MacOs or Windows. Please adapt docker-compose file to each OS.

### Requirements

This docker image requires the following:

- [Docker](https://docker.com) (Obviously)
- Personal API Keys for CLI Authentication <a href="https://bitwarden.com/help/personal-api-key/" target="_blank">https://bitwarden.com/help/personal-api-key/</a>

## How to Use the docker image

Before using the image for the first time, you must edit the variables and volumes to provide authentication credentials and folder locations to save export files and attachments, as well as your organisation ID (if you want to export your organisation's vault; otherwise, leave it blank).

The docker image will prompt you for your password each time so that you don't have to save that within the docker image.

### Execution:
From a terminal window, simply type: `bash bw_export.sh` and follow the prompts. 

## Outputs

The following are created by the docker image:
* JSON file containing your exported personal vault contents (password-encryption is recommended)
* JSON file containing your exported organization vault contents (optional)
* folder containing copies of your file attachments, labelled by subfolder names that match the name given to each vault item

## How to run the container

### Run container in any plattorm with docker

* To run this container you must copy the `docker-compose.yml` from the repository.

    ``` yaml
    services:
    bw-export:
        container_name: bw-export
        image: bw-export
        volumes:
        - ./export:/var
        environment:
        - BW_CLIENTID=<CLIENT ID FROM BITWARDEN API>
        - BW_CLIENTSECRET=<CLIENT SECRET FROM BITWARDEN API>
        - BW_PASSWORD=<BITWARDEN PASSWORD>
        # Optional: Own Vaultwarden/Bitarden selfhosted server
        #- BW_URL_SERVER=<YOUR VAULTWARDER URL SERVER>
        - OUTPUT_PATH=<Output path i.e. /var/data/ >
        - ATTACHMENTS_PATH=<attachment path i.e. /var/attachment/ >
        - EXPORT_PASSWORD=<Export password. Export will be encrypted with this password>
        - BW_ORGANIZATIONS_LIST=<Organization list id, comma separated>
        # Optional: Map the container's internal user to a user on the host machine
        # - PUID=1000
        # - PGID=1000
    ```

* Configure each required variable and volumes.
* Run the compose with `docker compose up`

### Safety

This container is based on an automation of the official [Bitwarden CLI client](https://bitwarden.com/help/cli/). **This script does not save, trace or store any information.** The session is closed after the backup has been performed.

If you wish you can configure each variable using [docker secrets](https://docs.docker.com/compose/use-secrets/) as in the example [docker-compose.secrets.sample.yml](https://github.com/0neTX/Bitwarden_Export/blob/main/docker-compose.secrets.sample.yml)

- Define docker secret files

``` bash
mkdir ./.secrets
echo BW_CLIENTID > ./.secrets/.bwclientid
echo BW_CLIENTSECRET  > ./.secrets/.bwsecret
echo BW_PASSWORD  > ./.secrets/.bwpassword
```

- Configure `docker-compose.secrets.sample.yml` with your variables and volumes
- Run it and enjoy it.

## Run in Unraid

Please see the following link [Bitwarden_Export Unraid Tempplate Readme](https://github.com/0neTX/UnRAID_Template/blob/main/bw-export/README.md)

---

## PUID and PGID

Docker runs all of its containers under the `root` user domain because it requires access to things like network configuration, process management, and your filesystem. This means that the processes running inside your containers also run as `root`. This kind of elevated access is not ideal for day-to-day use, and potentially gives applications the access to things they shouldn't \(although, a strong understanding of volume and port mapping will help with this\).

Another issue is file management within the container's mapped volumes. If the process is running under `root`, all files and directories created during the container's lifespan will be owned by `root`, thus becoming inaccessible by you.

Using the `PUID` and `PGID` allows our containers to map the container's internal user to a user on the host machine. All of our containers use this method of user mapping and should be applied accordingly.

### Using the variables

When creating a container from one of our images, ensure you use the `-e PUID` and `-e PGID` options in your docker command:

```shell
docker create .... -e PUID=1000 -e PGID=1000 ....
```

Or, if you use `docker-compose`, add them to the `environment:` section:

```yaml
environment:
  - PUID=1000
  - PGID=1000
```

It is most likely that you will use the `id` of yourself, which can be obtained by running the command below. The two values you will be interested in are the `uid` and `gid`.

```shell
id $user
```

# Developers only -  How to build the image

## Clone repo and build docker image

```bash
git clone https://github.com/0neTX/Bitwarden_Export.git
cd Bitwarden_Export
docker build --no-cache -t bw-export --progress=plain .
```

## SPECIAL THANKS

This docker image is based on the script of [@dh024/Bitwarden_Export](https://github.com/dh024/Bitwarden_Export) that I used as a base and inspiration. Thank you very much.

## Disclaimer

Since the purpse of this docker image is to create a copy of all your passwords and secrets stored in Bitwarden, you should carefully inspect this docker image to ensure it meets your needs and that it will execute as you would expect. I provide no guarantees that it will work for you!

* Note: the docker image will **not** export vault items in your Trash, nor will it export your password history -- this is a limitation of the Bitwarden CLI tools

## License

This project is licensed under the GPL 3.0 License. See the [LICENSE](.\LICENSE) file for details.
