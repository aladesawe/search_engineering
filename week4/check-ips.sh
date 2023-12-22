set -euo pipefail


docker ps --format "{{.ID}} {{.Names}}" --filter "name=replication-node." | while read -r container_id container_name; do

    echo "$container_name: checking the ip addresses"
    docker inspect --format='{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' $container_id

done