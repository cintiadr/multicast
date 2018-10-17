## Running multicast by docker


We have multiple docker compose files inside `docker` folder:

  - `db.yaml`: mongodb (not exposed on host)
  - `db-dev.yaml`: exposing mongodb on port 27017 and mongo-express on 8081. Requires `db.yaml`.
  - `multicast.yaml`: run multicast in port `3944`. Requires `db.yaml`

Make sure to always call the commands from repository root folder.

Multicast image was based on <https://github.com/Jack12816/docker-mdns>.


### Requirements

Install docker (and docker-compose if you are on Linux).

Copy `docker/multicast.env.template` to `docker/multicast.env` and modify to have the values you need. 


### Mongodb and mongoexpress

For example, to use mongo (and mongoexpress) from host:

```
# Start mongodb and mongoexpress
docker-compose -f docker/db.yaml -f docker/db-dev.yaml up -d

# Open your browser: http://localhost:8081

# To follow the logs
docker-compose -f docker/db.yaml -f docker/db-dev.yaml logs -f
# ctrl+c to stop following the logs

# Stop services and destroy all data
docker-compose -f docker/db.yaml -f docker/db-dev.yaml down -v
```

## Mongodb and multicast

To use multicast in docker as well:

```
# Rebuild local docker image for multicast
docker build -t multicast:local -f docker/multicast/Dockerfile .

# To run services
docker-compose -f docker/db.yaml -f docker/multicast.yaml up -d


```
