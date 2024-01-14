# Bitwarden_Export
Bash docker image that exports your Bitwarden vault contents

## Features
This simple bash docker image uses the Bitwarden CLI to perform three backup tasks:

* export personal vault
* export organization vault (if applicable)
* export file attachments (if applicable)

The docker image provides the choice of creating unencrypted export files or password-encrypted export files. Attachments are not encrypted.

### Compatibility

This docker image is compatible with Linux, MacOs or Windows. Please adapt docker-compose file to each OS.

## Requirements\

This docker image requires the following:

-Docker

## How to Use the docker image


Before you use the docker image for the first time, you must edit the variables in lines 14 - 25 of the docker image to provide the folder locations to save your export files and attachments, as well as your organization ID (if you want to export your organization vault; just leave it blank otherwise). Ensure that you **end each folder name with a forward-slash** or the docker image may fail or produce unanticipated results.

The docker image will prompt you for your password each time so that you don't have to save that within the docker image.

### Execution:
From a terminal window, simply type: `bash bw_export.sh` and follow the prompts. 

## Outputs
The following are created by the docker image:
* JSON file containing your exported personal vault contents (password-encryption is recommended)
* JSON file containing your exported organization vault contents (optional)
* folder containing copies of your file attachments, labelled by subfolder names that match the name given to each vault item

## Special Notes
Before you use this docker image, please consider the following:
* the docker image is meant to be run interactively, so it is not suitable for automation (e.g., execution as a scheduled docker image, such as a cron job)
* sensitive information, such as your password and session keys, are not saved locally or to persistent environment variables for security reasons
* if you choose to use password-encryption to store your export files (recommended) be sure that you use a strong and memorable password! (don't just store it inside Bitwarden, because if you get locked out of your account you won't be able to restore your exports)
* the docker image is currently limited to export just one organization vault, so if you have two or more organization vaults in your account, only the first will be exported (I may extend the docker image in the future to accommodate multiple organization vaults)
* if you don't know your `organization id` value, just open a terminal window and type: `bw login; bw list organizations | jq -r '.[0] | .id'`
* note: the docker image will **not** export vault items in your Trash, nor will it export your password history -- this is a limitation of the Bitwarden CLI tools
* if you spot an issue with the docker image and/or want to suggest a change, feel free to reach out

# How to build image

## Prerequisites

 -Docker

## Define docker secret files

``` bash
mkdir ./.secrets
echo BW_CLIENTID > ./.secrets/.bwclientid
echo BW_CLIENTSECRET  > ./.secrets/.bwsecret
echo BW_PASSWORD  > ./.secrets/.bwpassword
```


### Disclaimer

I wrote this bash docker image pretty quickly and have not thoroughly tested it, so use at your own peril!

Since the purpse of this docker image is to create a copy of all your passwords and secrets stored in Bitwarden, you should carefully inspect this docker image to ensure it meets your needs and that it will execute as you would expect. I provide no guarantees that it will work for you!
