# djankiserv

Based on Anki Community's [djankiserv](https://github.com/ankicommunity/djankiserv).

## Usage

Probably the easiest way to get started is to use one of our Docker Compose
configurations. If you just want a working server as quick as possible, you
should probably continue following the instructions there. If you wish to use
your own database and/or proxy along with the images (instead of the ones
preconfigured in docker-compose), then read along. 

* Copy the Django configuration from
  `"$REPOSITORY_ROOT"/Configuration/djankiserv_example_config` and alter them to
  fit your setup. Mount them under `/persistence` in the container. 

  * Be sure to change the database and the Django password in `mysecrets.py`. The
    server is going to raise an exception otherwise. ;)

* At startup, the cointainer is going to generate the static content for you under
  `/home/app/static`. This content is not served by the image - however, it is
  needed, in order to the webpage be able to load the images, stylesheets, etc.

  By default in the Django configuration (`settings.py`), static content is
  expected to be available on the same host, under `/static/`. 

* According to the [`djankiserv`](https://github.com/ankicommunity/djankiserv)
  documentation, a reverse proxy is *needed* in front of the Django web server.

### Management interface

At the `/admin/` resource a web interface is available. You can access it with a
superuser account, that can be created from the container shell using the Django
CLI management utilities:

    $ docker exec -it <CONTAINER_ID> sh

    # manage.py createsuperuser
    Username (leave blank to use 'root'): 
    Email address: 
    Password: 
    Password (again): 
    The password is too similar to the username.
    This password is too short. It must contain at least 8 characters.
    This password is too common.
    Bypass password validation and create user anyway? [y/N]: y
    Superuser created successfully.

  
### Anki API endpoints

Anki synchronization endpoints are available at `/djs/` and `/djs/mysnc/`
resources. 

## Building

1. Optional: if you wish to rebuild the image with your own version of
   `djankiserv`, then head to the
   [`djankiserv`](https://github.com/ankicommunity/djankiserv) project first.

    1. Build it with `poetry`:

        ```
        poetry install
        poetry build

        # Only if you encounter a SolveProblemError, you may try first:
        poetry update
        ```

    2. We will need the artifacts under the `dist/` folder and their dependencies. An easy way to automatize their installation is to start a `pypi-server` instance that we will use when building the Docker image.

        ```
        cd dist
        pypi-server -p 8080 .
        # leave it running while building the Docker image
        ```

2. Welcome back to this repository! Time to build the Docker image.
   Modify `/Configuration/djankiserv.vars` according to your needs, then 
   
    * If you wish to use your own build of `djankiserv`, then set `INDEX_URL` to the IP address at which the image being built can access the `pypi-server`. Usually it is the IP address of the first Docker interface `docker0`, for example, `172.17.0.1`.
    * If not, remove that option from the template.


3. Source it:

   ```
    cd Configuration
    source ./djankiserv.vars
   ```

3. Now you are ready to build the image with `build.sh`.
