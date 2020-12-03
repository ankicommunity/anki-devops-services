# djankiserv with PostgreSQL and NGINX

A self-contained configuration, ready for deployment.

## Components

| Component                                 | Version                                       |
|-------------------------------------------|-----------------------------------------------|
| PostgreSQL                                | 9.6:20                                        |
| Nginx (proxy and static files)            | 1.19.5                                        |
| djankiserv                                | `ankicommunity/anki-sync-server:djankiserv`   |

## Usage

1. Modify and source `"$REPOSITORY_ROOT"/Configuration/djankiserv.vars` according to your needs.
2. Optionally, build the `djankiserv` by hand, image following `"$REPOSITORY_ROOT"/Docker/djankiserv/README`.
3. Run `generate_docker_compose_yml.sh`*

    <sup>You can run `generate_docker_compose_yml_oneclick.sh`, which is going to use the variables defined
    in `"$REPOSITORY_ROOT"/Configuration/djankiserv.vars` automatically.</sup>

4. **Important!** Alter the passwords in these files:

    * `settings.py`
    * `docker-compose.yml` (generated one)

5. Start the compose instance:

    ```
    docker-compose up -d
    ```
