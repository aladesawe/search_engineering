# Indexing the data and supporting replication to the follower cluster
- Designating opensearch-cl1 as the leader cluster.

## Add the connection to the leader cluster seed nodes on the follower. Run ./add-leader-seed-nodes.sh
```
curl -XPUT -k -H 'Content-Type: application/json' -u 'admin:admin' 'https://localhost:9200/_cluster/settings?pretty' -d '
{
  "persistent": {
    "cluster": {
      "remote": {
        "replication-leader-connection": {
          "seeds": [<addresses>]
        }
      }
    }
  }
}'
```

## Create the bbuy_products index in the leader cluster, with 1 primary and 2 shards
```
curl -XPUT -k -H 'Content-Type: application/json' -u 'admin:admin' 'https://localhost:9200/bbuy_products?pretty' -d '@week4/bbuy_products.json'
```

## Start the replication on the follower cluster
```
curl -XPUT -k -H 'Content-Type: application/json' -u 'admin:admin' 'https://localhost:9201/_plugins/_replication/bbuy_products/_start?pretty' -d '
{
   "leader_alias": "leader-cluster-connection-alias",
   "leader_index": "bbuy_products",
   "use_roles":{
      "leader_cluster_role": "all_access",
      "follower_cluster_role": "all_access"
   }
}'
```

## 5a. Start indexing data
```
python week3/index.py -s ./datasets/product_data/products -w 8 -b
 500
```

## 5b. Query both clusters
```
python week3/query.py -q ./datasets/train.csv -w 2 -m 500 # leader-cluster query
python week2/query.py -q ./datasets/train.csv -w 2 -m 500 # follower-cluster query
```