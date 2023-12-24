#!/bin/bash
set -euo pipefail

# this adds the ip addresses of the leader cluster nodes as seed nodes on the follower
# https://stackoverflow.com/questions/26808855/how-to-format-a-bash-array-as-a-json-array
json_array() {
  echo -n '['
  while [ $# -gt 0 ]; do
    x=${1//\\/\\\\}
    echo -n \"${x//\"/\\\"}\"
    [ $# -gt 1 ] && echo -n ', '
    shift
  done
  echo ']'
}

seeds=()
follower_address='https://localhost:9201'

docker ps --format "{{.ID}} {{.Names}}" --filter "name=opensearch-cl1-node." --filter "status=running" |
{
    while read -r container_id container_name; do

        echo "$container_name: checking the ip addresses..."
        ip_address=$(docker inspect --format='{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' $container_id)
        echo "$container_name has ip address $ip_address"

        seed="${ip_address}:9300"
        echo "Adding $seed as a seed node..."
        
        seeds+=("${seed}")

    done

    echo "Converting ${seeds[@]} to json_array..."

    json_seeds=$(json_array "${seeds[@]}")

    echo "Adding the seeds, $json_seeds, to the follower cluster..."
    curl -XPUT -k -H 'Content-Type: application/json' -u 'admin:admin' "$follower_address/_cluster/settings?pretty" -d "
    {
        \"persistent\": {
            \"cluster\": {
                \"remote\": {
                    \"leader-cluster-connection-alias\": {
                        \"seeds\": $json_seeds
                    }
                }
            }
        }
    }"
}