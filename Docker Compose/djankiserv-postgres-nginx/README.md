# djankiserv with PostgreSQL and NGINX

A self-contained configuration, ready for deployment.

## Components

| Component                                 | Version                                       |
|-------------------------------------------|-----------------------------------------------|
| PostgreSQL                                | 9.6:20                                        |
| Nginx (proxy and static files)            | 1.19.5                                        |
| djankiserv                                | `ankicommunity/anki-sync-server:djankiserv`   |

## Usage

1. Modify and source `"$REPOSITORY_ROOT"/Configuration/djankiserv.vars` according to your needs. Don't forget to alter the passwords!
2. Optionally, build the `djankiserv` by hand, image following `"$REPOSITORY_ROOT"/Docker/djankiserv/README`.
3. Run `generate_docker_compose_yml.sh`*
4. Run `generate_django_config.sh`*
    
    <sup>You can run the `*_oneclick.sh` versions of these scripts, which are
    going to use the variables defined in
    `"$REPOSITORY_ROOT"/Configuration/djankiserv.vars` and
    `"$REPOSITORY_ROOT"/Configuration/djankiserv_compose.vars`
    automatically.</sup>

5. Start the compose instance:

    ```
    docker-compose up -d
    ```
