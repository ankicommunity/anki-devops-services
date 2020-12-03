# djankiserv with PostgreSQL and NGINX

A self-contained configuration, ready for deployment.

## Components

| Component                                 | Version                                       |
|-------------------------------------------|-----------------------------------------------|
| PostgreSQL                                | 13.1 (Alpine)                                        |
| Nginx (proxy and static files)            | 1.19.5                                        |
| djankiserv                                | `ankicommunity/anki-sync-server:djankiserv`   |

## Usage

1. Modify and source the configuration according to your needs. Don't forget to alter the passwords!

    * `"$REPOSITORY_ROOT"/Configuration/djankiserv.vars`
    * `"$REPOSITORY_ROOT"/Configuration/djankiserv_compose.vars`

2. Optionally, build the `djankiserv` by hand, image following `"$REPOSITORY_ROOT"/Docker/djankiserv/README`.

3. Generate the Django and the Docker-compose configuration:

    * Run `generate_docker_compose_yml.sh`
    * Run `generate_django_config.sh`
    
    <sup>You can run the `*_oneclick.sh` versions of these scripts, which are
    going to use the variables defined in
    `"$REPOSITORY_ROOT"/Configuration/djankiserv.vars` and
    `"$REPOSITORY_ROOT"/Configuration/djankiserv_compose.vars`
    automatically.</sup>

5. Start the compose instance:

    ```
    docker-compose up -d
    ```

Now you should be able to access the management interface at the
`http://your_ip:8080/admin/` resource. To learn about creating a superuser
account, proceed to the `README` of the `djankiserv` Docker image.

## Anki API endpoints

To configure the clients, specify these urls:

* `http://your_ip:8080/djs/`
* `http://your_ip:8080/djs/msync/`