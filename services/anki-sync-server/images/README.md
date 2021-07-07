# Legacy variant

> Based on tsudoko's [`ankisyncd`](https://github.com/tsudoko/anki-sync-server)

## Tested and works on

| Date       | AnkiDesktop version | AnkiDroid version | ankisyncd version                                                                          | Tester       |
|:----------:|:-------------------:|:-----------------:|:------------------------------------------------------------------------------------------:| ------------ |
| 2020-02-06 | 2.1.19              | 2.9.1             | [2.1.0 + 2bfccf7f](<https://github.com/kuklinistvan/anki-sync-server/tree/docker-release>) | kuklinistvan |

[Learn more about what "tested" means here.](Testing.md)

## About this Docker image

* As of yet, it lives on DockerHub at [kuklinistvan/anki-sync-server:latest](https://hub.docker.com/r/kuklinistvan/anki-sync-server).
* It was built for `x86_64` CPU architecture.

An example setup with `docker-compose`:

```
version: "3"

services:
    anki-container:
        image: kuklinistvan/anki-sync-server:latest
        container_name: anki-container

        restart: always
        ports:
        - "27701:27701"
        volumes:
        - data:/app/data

volumes:
    data:
```

#### Rebuilding

Enter the Docker directory and alter `build.sh` to suit your use case. Run it to build the image on the current platform.

## Administration

Management utility is reachable through the container shell:

```
# docker exec -it anki-container /bin/sh
/app/anki-sync-server # ./ankisyncctl.py --help
usage: ./ankisyncctl.py <command> [<args>]

Commands:
  adduser <username> - add a new user
  deluser <username> - delete a user
  lsuser             - list users
  passwd <username>  - change password of a user
/app/anki-sync-server # ./ankisyncctl.py adduser kuklinistvan
Enter password for kuklinistvan:
/app/anki-sync-server #
```

## Tested client downloads

|                            | Main                                                                                 | Mirror                                                                              | Size     | SHA256                                                             |
| -------------------------- | ------------------------------------------------------------------------------------ | ----------------------------------------------------------------------------------- | -------- | ------------------------------------------------------------------ |
| AnkiDesktop  for GNU/Linux | [2.1.19](https://apps.ankiweb.net/downloads/current/anki-2.1.19-linux-amd64.tar.bz2) | [2.1.19](https://mega.nz/file/lVxRgRwI#Oqohl1M0Ju9RrYa7D6uV5SOtwgqVxkxPKqNYxcOh858) | 127.7 MB | `ada59237b8b3774712d6309821db4b6cb1d2c625284302aa09bc7313ada76fc0` |
| AnkiDroid APK for Android  | [2.9.1](https://fdroid.tetaneutral.net/fdroid/archive/com.ichi2.anki_20901300.apk)   | [2.9.1](https://mega.nz/file/YFoFER5S#BiMMDxyhdl_u9I1TC-v_bBYakM5DTTM5CybJb4pu4oY)  | 10.7 MB  | `511ef65b8dcb65a7f99f9942c4fcee5134f137ce23c677cf1ea3b26c7c3f34c5` |
| AnkiDesktop for Windows    | [2.1.19](https://apps.ankiweb.net/downloads/current/anki-2.1.19-windows.exe)         | [2.1.19](https://mega.nz/file/5MwhxLjT#TLGA03KMbnRmDiHO3A-Yfm-y6xNgW3eiDUgEk-TXYyU) | 97,3 MB  | `90be6a3e5a6f4373ba3342bd3dfbe61e9013bb2a4acced2fcdd594b4c651a665` |
| AnkiDesktop for Mac OS X   | [2.1.19](https://apps.ankiweb.net/downloads/current/anki-2.1.19-mac.dmg)             | [2.1.19](https://mega.nz/file/dc4HXbKZ#m17YAdB5-SZ_rET23g8VT12Y-ECMB6rd1UIUfmKMEHg) | 127,5 MB | `9be3e3bdf884f865e15f308e72b1ed0213c061d27102f80d01897d5355eef8e7` |
