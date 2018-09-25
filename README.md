# Anki Sync Server with Docker - and it works!

Finally! A self-contained solution AND tutorial on how to survive setting up this mess.

Has been tested and has worked on: 

| Anki version  | AnkiDroid version |
| :----------:  | :---------------: |
| 2.1.4         | 2.8.3             |

## Usage

### One-time setup

If you've managed put your Anki devices on the same (typically LAN) network, you may use one of your computers to host the synchronisation server with this command:

    export ANKI_SYNC_DATA_DIR=~/anki-sync-server-docker-data

    mkdir -p "$ANKI_SYNC_DATA_DIR"
    docker run -it \
       --mount type=bind,source="$ANKI_SYNC_DATA_DIR",target=/app/data \
       -p 27701:27701 \
       --name anki-container \
       --rm \
       kuklinistvan/anki-sync-server:tsudoku-2.1.4
       
You can interrupt this instance anytime by hitting Ctrl+C. You can restart the server with the same command. Its data will be preserved in `$ANKI_SYNC_DATA_DIR`.

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
       kuklinistvan/anki-sync-server:tsudoku-2.1.4
    
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
    
Of course, nginx can work out too, but I didn't try it yet.

**Attention**: of course, you should change the port if you've put anki-sync-server to a non-standard one.

##### Proxy URL Confusion!

Apparently the server does serve the urls `/sync/` and `/msync/` as it is expected from its configuration. The client, however, expects `http(s)://anki.my.fancy.server.net/` as sync url and `http(s)://anki.my.fancy.server.net/msync/` as media url. 

What happens is that the client treats the media url you've is specified it **and appends `/sync/` to the base synchronisation url**.

It is even enough therefore (yes, I've tested it) to proxy the `/sync/` and `/msync/` urls in case of serving other urls for other purposes on that particular virtualhost.

In summary, you're specifying the urls on your devices this way:

| URL Type | Server              | Client                  |
| -------- | ------------------- | ------------------------|
| Base     | `/sync/`            | `http:/..../`           |
| Media    | `/msync/`           | `http:/..../msync`      |
  
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

### Desktop computer

Find Anki's folder in your home directory and create a new addon in it. On my computer the final destination of this addon is:

    ~/.local/share/Anki2/addons21/MySyncServer
    
Create the directory above and place an `__init__.py` file in it, which contains this:

    import anki.sync
    anki.sync.SYNC_BASE = 'http://127.0.0.1:27701/' + '%s'
    anki.sync.SYNC_MEDIA_BASE = 'http://127.0.0.1:27701/msync/' + '%s'

Substitute your IP address or hostname to `127.0.0.1` and optionally change the port too if you are hosting `anki-sync-server` on a non-standard one. With the default settings, these urls will work.

If you're using a proxy (for HTTPS encryption usually) you should specify these addresses accordingly.

**Warning**: without the ` + '%s'` the plugin will crash. Was not easy to figure it out.

#### Client URL Confusion!

**Attention**: although the server configuration `ankisyncd.conf` contains by default these two lines:

    base_url = /sync/
    base_media_url = /msync/
    
for some reason, **neither on the desktop nor on the mobile client should you append `/sync/` to the sync base url BUT you should append `/msync/` to the media sync url**. Finding this out took me 30-60 minutes, hope I've saved you this time.

For more information on this strange phenomenon and on what url to specify when, see the proxy configuration above.

## Android Device

Open the app, then slide off the menu from the left side. Go Settings > Advanced > Custom sync server and specify the same two urls you've specified on the desktop client.

**Attention**: please see the **URL Confusion** part.

## Does not work? Submit an issue!

I highly encourage you contacting me if you feel it is "broken again" - it frustrates me too and I'd like to take the effort to fix the bugs on my side.

Even if it is not a bug but rather something to be clarified, I'm happy to answer questions (if I can), so if you have one, just submit an issue.

## Additional credits

* https://github.com/tsudoko/anki-sync-server

## Final words and motivation

Whenever I had to take off Anki Sync Server from the shelf, it was always broken for some reason, and it was also hard to reinstall from a clean state. These maintenances usually took from one to five or six hours, including finding the fork on GitHub which worked.

According to the stars and the number of forks of the anki-sync-server or ankisyncd project, I'm sure I'm not the only one fighting this problem.

I've decided to maintain a Docker image and a tutorial that is easy enough to follow for installation - for private servers or even for a one time use on a laptop.

