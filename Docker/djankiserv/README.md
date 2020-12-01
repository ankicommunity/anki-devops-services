# djankiserv

Based on Anki Community's [djankiserv](https://github.com/ankicommunity/djankiserv).

## Usage

Pending...

## Building

1. Head to the [`djankiserv`](https://github.com/ankicommunity/djankiserv) project first.

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
   Modify `/Configuration/djankiserv.vars` according to your needs, then source it. Set `INDEX_URL` to the IP address at which the image being built can access the `pypi-server`. Usually it is the IP address of the first Docker interface `docker0`, for example, `172.17.0.1`.

   ```
    cd Configuration
    source ./djankiserv.vars
   ```

3. Now you are ready to build the image with `build.sh`.
