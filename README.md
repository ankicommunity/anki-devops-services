# Anki Sync Server with Docker - and it works!

A quick and ergonomic way to setup a (reasonably) up-to-date instance of Anki Sync Server, without the hassle.

> Based on tsudoko's [`ankisyncd`](https://github.com/tsudoko/anki-sync-server)

## News

* 2020-09-21:

  Follow us on Gitter to learn the current progress of supporting newer versions of Anki!
  
  https://gitter.im/ankicommunity/community
 
  Special thanks for the work of the server contributors, among them to [AntonOfTheWoods](https://github.com/AntonOfTheWoods) and [VikashKothary](https://github.com/VikashKothary)!

  Learn more about the common problem here:
  * [SyncRedirector can support earlier versions of anki](https://github.com/kuklinistvan/docker-anki-sync-server/issues/16#issuecomment-626304807)
  * [Will it work on newest version on of Anki desktop? (unlikely for now)](https://github.com/ankicommunity/docker-anki-sync-server/issues/5)
  * [Unable to login on Anki 2.1.23-1](https://github.com/kuklinistvan/docker-anki-sync-server/issues/15)
  * ["Your client is using unsupported sync protocol (10, supported version: 9) ](https://github.com/kuklinistvan/docker-anki-sync-server/issues/14)
  * [Dont work on ARM CPU (Raspberry pi)](https://github.com/ankicommunity/docker-anki-sync-server/issues/9)
  

* 2020-02-06:

  AnkiDesktop 2.1.19, AnkiDroid 2.9.1 is tested and works with `ankisyncd` 2.1.0 with commit [2bfccf7f](<https://github.com/tsudoko/anki-sync-server/commit/2bfccf7fa4af87545f009729ff6e84934c6fde0b>) applied on the top of that.

* 2019-07-08:

  https://github.com/tsudoko/anki-sync-server/issues/41

## Tested and works on:

|    Date    | AnkiDesktop version | AnkiDroid version |                      ankisyncd version                       | Tester       |
| :--------: | :-----------------: | :---------------: | :----------------------------------------------------------: | ------------ |
| 2020-02-06 |       2.1.19        |       2.9.1       | [2.1.0 + 2bfccf7f](<https://github.com/kuklinistvan/anki-sync-server/tree/docker-release>) | kuklinistvan |

[Learn more about what "tested" means here.](Testing.md)

### Tested client downloads

|                            | Main                                                         | Mirror                                                       | Size     | SHA256                                                       |
| -------------------------- | ------------------------------------------------------------ | ------------------------------------------------------------ | -------- | ------------------------------------------------------------ |
| AnkiDesktop  for GNU/Linux | [2.1.19](https://apps.ankiweb.net/downloads/current/anki-2.1.19-linux-amd64.tar.bz2) | [2.1.19](https://mega.nz/file/lVxRgRwI#Oqohl1M0Ju9RrYa7D6uV5SOtwgqVxkxPKqNYxcOh858) | 127.7 MB | `ada59237b8b3774712d6309821db4b6cb1d2c625284302aa09bc7313ada76fc0` |
| AnkiDroid APK for Android  | [2.9.1](https://fdroid.tetaneutral.net/fdroid/archive/com.ichi2.anki_20901300.apk) | [2.9.1](https://mega.nz/file/YFoFER5S#BiMMDxyhdl_u9I1TC-v_bBYakM5DTTM5CybJb4pu4oY) | 10.7 MB  | `511ef65b8dcb65a7f99f9942c4fcee5134f137ce23c677cf1ea3b26c7c3f34c5` |
| AnkiDesktop for Windows  | [2.1.19](https://apps.ankiweb.net/downloads/current/anki-2.1.19-windows.exe) | [2.1.19](https://mega.nz/file/5MwhxLjT#TLGA03KMbnRmDiHO3A-Yfm-y6xNgW3eiDUgEk-TXYyU) | 97,3 MB  | `90be6a3e5a6f4373ba3342bd3dfbe61e9013bb2a4acced2fcdd594b4c651a665` |
| AnkiDesktop for Mac OS X | [2.1.19](https://apps.ankiweb.net/downloads/current/anki-2.1.19-mac.dmg) | [2.1.19](https://mega.nz/file/dc4HXbKZ#m17YAdB5-SZ_rET23g8VT12Y-ECMB6rd1UIUfmKMEHg) | 127,5 MB | `9be3e3bdf884f865e15f308e72b1ed0213c061d27102f80d01897d5355eef8e7` |

## Usage

You need to setup different part to make use of this project
-> A Client
  |
  --> A plugins depending of which client
-> A network (may seems obvious but firewalls may cause problems)
-> A server (a normal one or a raspberry pi)
  |
  --> docker-anki-sync-server (with of withouth HTTPS)
  |
  --> anki-sync-server (installed from source) (with of withouth HTTPS)

### One-time setup
Do this if you dont plan to keep your anki server running for a time. if you want to run it permanently useone of the followings method
If you've managed put your Anki devices on the same (typically LAN) network, you may use one of your computers to host the synchronization server with this command:

    export ANKI_SYNC_DATA_DIR=~/anki-sync-server-docker-data
    
    mkdir -p "$ANKI_SYNC_DATA_DIR"
    docker run -it \
       --mount type=bind,source="$ANKI_SYNC_DATA_DIR",target=/app/data \
       -p 27701:27701 \
       --name anki-container \
       --rm \
       kuklinistvan/anki-sync-server:latest

You can interrupt this instance anytime by hitting Ctrl+C. You can restart the server with the same command. Its data is going to be preserved in `$ANKI_SYNC_DATA_DIR`.

Also, **be warned** that if you don't use any additional proxies, your connection will be unencrypted! That means if you use Anki to memorize your passwords they will be leaked :)

See below how you can point your desktop application to the server you've just created.

### Deploying on a normal server

Docker will take care of starting the service on boot so you don't have to worry about that. You can setup the server with these commands:

    export DOCKER_USER=root
    export ANKI_SYNC_DATA_DIR=/etc/anki-sync-server
    export HOST_PORT=27701
    
    mkdir -p "$ANKI_SYNC_DATA_DIR"
    chown "$DOCKER_USER" "$ANKI_SYNC_DATA_DIR"
    chmod 700 "$ANKI_SYNC_DATA_DIR"
    
    docker run -itd \
       --mount type=bind,source="$ANKI_SYNC_DATA_DIR",target=/app/data \
       -p "$HOST_PORT":27701 \
       --name anki-container \
       --restart always \
       kuklinistvan/anki-sync-server:latest

or using `docker-compose`:

    version: "3"
    
    services:
        anki-sync-server:
            image: kuklinistvan/anki-sync-server:latest
            restart: always
            ports:
            - "27701:27701"
            volumes:
            - ./data:/app/data

### Deploying on a raspberry pi

This is really close to the installation on a normal server expect that another docker image is used (may work on other ARM CPU but not tested)
Docker will take care of starting the service on boot so you don't have to worry about that. You can setup the server with these commands:

    export DOCKER_USER=root
    export ANKI_SYNC_DATA_DIR=/etc/anki-sync-server
    export HOST_PORT=27701
    
    mkdir -p "$ANKI_SYNC_DATA_DIR"
    chown "$DOCKER_USER" "$ANKI_SYNC_DATA_DIR"
    chmod 700 "$ANKI_SYNC_DATA_DIR"
    
    docker run -itd \
       --mount type=bind,source="$ANKI_SYNC_DATA_DIR",target=/app/data \
       -p "$HOST_PORT":27701 \
       --name anki-container \
       --restart always \
       nathmo/anki-sync-server:initial

or using `docker-compose`:

    version: "3"
    
    services:
        anki-sync-server:
            image: nathmo/anki-sync-server:initial
            restart: always
            ports:
            - "27701:27701"
            volumes:
            - ./data:/app/data
            
### creating a docker image on a new device
  This explanation is based on [this ticket](https://github.com/ankicommunity/docker-anki-sync-server/issues/9)
  
`git clone https://github.com/ankicommunity/docker-anki-sync-server`
`cd docker-anki-sync-server/Docker`
`./build.sh`
You've now made a docker image
You may want to create a container from the docker image (a container is kinda like an object instance of it's class)
to do so : `docker run --publish=27701:27701 --restart=always --name=anki-container --mount=type=bind,source=/mnt/anki/data,target=/app/data anki-sync-server:tsudoko-ankisyncd-2.1.0-plus-2bfccf7f` (add any docker options that may server you and set the path where you need it)
You shoud have something like that that appeared
`Creating new configuration file: ankisyncd.conf. Creating new authentication database: auth.db. Creating collections directory: collections. Updating database schema Successfully updated table 'auth' No session DB found at the configured 'session_db_path' path. Starting tsudoko's anki-sync-server [2020-10-06 10:43:50,853]:INFO:ankisyncd:ankisyncd [unknown version] (https://github.com/tsudoko/anki-sync-ser ver) [2020-10-06 10:43:51,110]:INFO:ankisyncd:Loaded config from /app/anki-sync-server/ankisyncd.conf [2020-10-06 10:43:51,113]:INFO:ankisyncd.users:Found auth_db_path in config, using SqliteUserManager for auth [2020-10-06 10:43:51,119]:INFO:ankisyncd.sessions:Found session_db_path in config, using SqliteSessionManager for auth [2020-10-06 10:43:51,126]:INFO:ankisyncd:Serving HTTP on 0.0.0.0 port 27701... [2020-10-06 10:43:51,613]:INFO:ankisyncd.http:127.0.0.1 "GET / HTTP/1.1" 200 16`

`docker ps` give you the id of the running container
`docker exec -it dde248e9bc6e /bin/sh` give you a shell inside a given docker dde248e9bc6e being the container id.
run `./ankisyncctl.py adduser yourusername` to create an user on your docker instance
You need to create a free dockerhub account (you just need a valid email) to publish your container such that other dont have to redo it

`docker commit --author="you@you.com" --message=" the platform and a comment" --pause anki-container yourdockerid/yourreponame:latest`  this is analogue to a git commit
`docker login` # login to dockerhub such that you can push it to the platform
`docker push yourdockerid/yourreponame:latest` # this is analogue to a git push, it send the docker image to  dockerhub
Dont forget to make a pull request of this README to add the instruction for your platform

### Creating users
Your server is running, the client try to connect to it and you're greeted with  "the password is not correct or the user dont exist" -> you need to create an user first
For this you need to access your container instance in order to use the server's ctl:

The first command give you a shell inside the docker container, once you are inside you run the second one (./ankisyncctl.py) and this tool allow you to create/delete/list/change password for an user.

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

Done!

### HTTPS Encryption with Apache Proxy
You are using ankidroid and you were greeted with an error or you want just want to use https because you dant want the data of your flashcard to appear in clear over the network then you should follow the followings instructions.

You need an apache2 or ngninx server running somewhere.
Here is the detailed procedure for apache2

    sudo apt-get install apache2
    sudo a2enmod proxy
    sudo a2enmod proxy_http
    sudo a2enmod ssl
    sudo systemctl restart apache2

now you need to generate a self signed certificate. you can do so with the following command

openssl req -newkey rsa:2048 -new -nodes -x509 -days 3650 -keyout key.pem -out cert.pem

it generate two file. move them somewhere safe and add the path to thoses two file in the following config
(DISCLAIMER, the forementionned command may not be best practice but hey, it work)
transfer the cert.pem file to phone where you run AnkiDroid as you need to import is (save it on youre phone and go under settings and look for biometrics and security -> other securty settings -> intall from local storage

then you can edit this file ( if you know what this is or have other site running on the same server, you can do it in another one (beware the port))
    sudo nano /etc/apache2/sites-available/000-default.conf

Here is an example what you should paste inside:

    <VirtualHost *:443>
        ServerName anki.my.fancy.server.net
    
        <Location /sync>
            ProxyPass http://127.0.0.1:27701/sync
            ProxyPassReverse http://127.0.0.1:27701/sync
        </Location>
        <Location /msync>
            ProxyPass http://127.0.0.1:27701/msync
            ProxyPassReverse http://127.0.0.1:27701/msync
        </Location>
    
        UseCanonicalName off
        SSLEngine on
        SSLProtocol +TLSv1.2
        SSLCertificateFile /path/to/the/cert/cert.pem
        SSLCertificateKeyFile /path/to/the/key/key.pem
        ProxyRequests off
        ProxyPreserveHost on
    </VirtualHost>

Of course, nginx can work out too, but I haven't tried it yet.

**Attention**: of course, you should change the port if you've put anki-sync-server to a non-standard one.


### Setting up your Anki client devices

| What you need to publish     | Specify in AnkiDesktop       | Specify in AnkiDroid         |
| ---------------------------- | ---------------------------- | ---------------------------- |
| http://127.0.0.1:27701/sync  | http://127.0.0.1:27701/sync  | http://127.0.0.1:27701/      |
| http://127.0.0.1:27701/msync | http://127.0.0.1:27701/msync | http://127.0.0.1:27701/msync |

>  Do not put trailing slashes!

#### AnkiDesktop

1. Launch Anki
2. Go to Tools > Add-ons
3. Click Get Add-ons...
4. Reference the SyncRedirector plugin with the code [**2124817646**](https://ankiweb.net/shared/info/2124817646)
5. If you use docker-anki-sync-server on an external server or custom port:
   1. Select SyncRedirector and click Config
   2. Configure your sync urls
6. Restart Anki - optionally check your console output.

From now on, you can synchronize your collection the same way you would if you were using AnkiWeb - look for the Sync button in the main window. Although Anki will ask for your AnkiWeb ID the first time, you need to enter the server credentials you've set up previously instead.

#### AnkiDroid

Open the app, then slide off the menu from the left side. Go Settings > Advanced > Custom sync server and specify the same two urls you've specified on the desktop client.

From now on, you can synchronize your collection the same way you would if you were using AnkiWeb. Head to the main screen of the application (the list of decks) and slide down to synchronize (or use the icon next to the menu in the top right corner). Although Anki will ask for your AnkiWeb ID the first time, you need to enter the server credentials you've set up previously instead.
if you get an issue like "Authentication not allowed over insecure http" you may need to setup https

## Does not work? Submit an issue!

I highly encourage you contacting me if you feel it is "broken again" - it frustrates me too and I'd like to take the effort to fix the bugs on my side.

Even if it is not a bug but rather something to be clarified, I'm happy to answer questions (if I can), so if you have one, just submit an issue.

### Contact us at Gitter

An even quicker way to ask questions is to join the community chat at the link below:

https://gitter.im/ankicommunity/community

