# Anki Sync Server with Docker - and it works!

Finally! A self-contained solution AND tutorial on how to survive setting up this mess.

Tested and has worked on: 

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
       --rm \
       anki-sync-server:tsudoku-2.1.4
       
You can interrupt this instance anytime by hitting Ctrl+C. You can restart the server with the same command. Its data will be preserved in `$ANKI_SYNC_DATA_DIR`.

Also, **be warned** that if you don't use any additional proxies, your connection will be unencrypted! That means if you use Anki to memorize your passwords they will be leaked :)

See below how you can point your desktop application to the server you've just created.
### Deploying on a server

    # TODO
    
#### HTTPS Encryption with Apache Proxy

## Setting up your Anki client devices

### Desktop computer

Find Anki's folder in your home directory and create a new addon in it. On my computer the final destination of this addon is:

    ~/.local/share/Anki2/addons21/MySyncServer
    
Create the directory above and place an `__init__.py` file in it, which contains this:

    import anki.sync
    anki.sync.SYNC_BASE = 'http://127.0.0.1:27701/' + '%s'
    anki.sync.SYNC_MEDIA_BASE = 'http://127.0.0.1:27701/msync/' + '%s'

Substitute your IP address or hostname to `127.0.0.1`. With the default settings, these urls will work.

#### URL Confusion!

**Attention**: although the server configuration `ankisyncd.conf` contains by default these two lines:

    base_url = /sync/
    base_media_url = /msync/
    
for some reason, **neither on the desktop nor on the mobile client should you append `/sync/` to the sync base url BUT you should append `/msync/` to the media sync url**. Finding this out took me 30-60 minutes, hope I've saved you this time.

## Android Device

Open the app, then slide off the menu from the left side. Go Settings > Advanced > Custom sync server and specify the same two urls you've specified on the desktop client.

**Attention**: please see the **URL Confusion** part.

## Does not work? Submit an issue!

I highly encourage you contacting me if you feel it is "broken again" - it frustrates me too and I'd like to take the effort to fix the bugs on my side.

## Additional credits

* https://github.com/tsudoko/anki-sync-server

## Final words - Motivation

Whenever I had to take off Anki Sync Server from the shelf, it was always broken for some reason, and it was also hard to reinstall from a clean state. These maintenances usually took from 1-2 to 5-6 hours, including finding the fork on GitHub which worked.

According to the stars and the number of forks of the anki-sync-server or ankisyncd project, I'm sure I'm not the only one fighting this problem.

I've decided to maintain a Docker image and a tutorial that is easy enough to follow for installation - even for a one time use on a laptop.

