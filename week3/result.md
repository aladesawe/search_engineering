# Q1: Which node was elected as cluster manager?
opensearch-node3 (from running GET /_cat/nodes?v in dev tools)
172.24.0.3           21          98  11    0.94    4.12     4.83 dimr      cluster_manager,data,ingest,remote_cluster_client *               opensearch-node3

# Q2: After stopping the previous cluster manager, which node was elected the new cluster manager?
opensearch-node1

# Q what's one log message you found that relates to the cluster manager change?
[o.o.c.s.MasterService    ] [opensearch-node1] elected-as-cluster-manager ([2] nodes joined)[{opensearch-node2}{90hxPBAMTUeC6Xyge8vUEQ}{o2M3aWsSTs6qyiLR0_3VOw}{172.24.0.2}{172.24.0.2:9300}{dimr}{shard_indexing_pressure_enabled=true} elect leader, {opensearch-node1}{cNNS4q9wSCGFNLyb5VRVtw}{1HabwcifSZyYVfhzfNW0Xw}{172.24.0.5}{172.24.0.5:9300}{dimr}{shard_indexing_pressure_enabled=true} elect leader, _BECOME_CLUSTER_MANAGER_TASK_, _FINISH_ELECTION_], term: 16, version: 76, delta: cluster-manager node changed {previous [], current [{opensearch-node1}{cNNS4q9wSCGFNLyb5VRVtw}{1HabwcifSZyYVfhzfNW0Xw}{172.24.0.5}{172.24.0.5:9300}{dimr}{shard_indexing_pressure_enabled=true}]}

[o.o.c.s.ClusterApplierService] [opensearch-node1] cluster-manager node changed {previous [], current [{opensearch-node1}{cNNS4q9wSCGFNLyb5VRVtw}{1HabwcifSZyYVfhzfNW0Xw}{172.24.0.5}{172.24.0.5:9300}{dimr}{shard_indexing_pressure_enabled=true}]}, term: 16, version: 76, reason: Publication{term=16, version=76}

# Q3: Did the cluster manager node change again? (was a different node elected as cluster manager when you started the node back up?)
No, cluster manager remained node1

# Q4: How much faster was it to index the dataset with 0 replicas versus the previous time with 2 replica shards?
With replicas, it took about 75 minutes. It took 20.01 minutes without replicas.

# Q5: Why was it faster?
Indexing a doc no longer includes the time it takes to forward, and complete, the index operation on the other replicas.

# Q6: How long did it take to create the new replica shards?  This will be the difference in time between those two log messages.
It took about 1 minute.

# Q7: Those two messages were both logged by the cluster_manager.  Why do you think the cluster manager is the node that logs these actions (versus non-manager nodes)?
As the cluster leader node, eligibility is having the most up-to-date view of the cluster state and hence can make decision consistent with the cluster state.

# Q: Looking at the metrics dashboard, what queries/sec rate are you getting?
Sawtooth, between 68 - 112 qps

# Q: How does that compare to the max queries/sec rate you saw in week 2?
It's about double the rate
