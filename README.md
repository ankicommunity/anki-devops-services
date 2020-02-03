# Anki Sync Server with Docker - and it works!

A quick and ergonomic way to setup an up-to-date instance of Anki Sync Server, without the hassle.

## Tested and works on:

|    Date    | AnkiDesktop version | AnkiDroid version | ankisyncd version | Tester       |
| :--------: | :-----------------: | :---------------: | :---------------: | ------------ |
| 2020-02-03 |       2.1.19        |       2.9.1       |       2.1.0       | kuklinistvan |

[Learn more about what "tested" means here.](Testing.md)

### News

* 2020-02-03:

  AnkiDesktop 2.1.19, AnkiDroid 2.9.1 is tested and works with `ankisyncd` 2.1.0.

* 2019-07-08:

  https://github.com/tsudoko/anki-sync-server/issues/41

## Usage

### One-time setup

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

### Deploying on a server

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

#### HTTPS Encryption with Apache Proxy

Here is an example:

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
        SSLCertificateFile /path/to/the/cert/fullchain.pem
        SSLCertificateKeyFile /path/to/the/key/privkey.pem
        ProxyRequests off
        ProxyPreserveHost on
    </VirtualHost>

Of course, nginx can work out too, but I haven't tried it yet.

**Attention**: of course, you should change the port if you've put anki-sync-server to a non-standard one.

## Creating users

For this you need to access your container instance in order to use the server's ctl:

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

## Setting up your Anki client devices

### Desktop computer (new, easier!)

1. Launch Anki
2. Go to Tools > Add-ons
3. Click Get Add-ons...
4. Reference the SyncRedirector plugin with the code **2124817646**
5. If you use docker-anki-sync-server on an external server or custom port:
   1. Select SyncRedirector and click Config
   2. Configure your sync urls
6. Restart Anki - optionally check your console output.

> For those who have been using this solution and had to deal with "proxy url confusion", note that this plugin hides the strange behaviour of `/msync` and `/sync` urls, thus you can specify the same two urls on the desktop client and on your Android device.

Plugin site: https://ankiweb.net/shared/info/2124817646

### Android Device

Open the app, then slide off the menu from the left side. Go Settings > Advanced > Custom sync server and specify the same two urls you've specified on the desktop client.

## Does not work? Submit an issue!

I highly encourage you contacting me if you feel it is "broken again" - it frustrates me too and I'd like to take the effort to fix the bugs on my side.

Even if it is not a bug but rather something to be clarified, I'm happy to answer questions (if I can), so if you have one, just submit an issue.
