# Q: How long did it take to index the 1.2M product data set?  What docs/sec indexing rate did you see?
INFO:Done. 1275077 were indexed in 42.1751602166667 minutes.  Total accumulated time spent in `bulk` indexing: 520.4573684849955 minutes
Indexing rate was a saw-tooth, with max of 763 and avg of 353 docs/sec

# Q: Notice that the Index size rose (roughly doubled) while the content was being indexed, peaked, then ~ 5 minutes after indexing stopped, the index size dropped down substantially.  Why did it drop back down?  (What did OpenSearch do here?)
Merge operations kicked in and consolidated the segments that had duplicated documents.

# Q: Looking at the metrics dashboard, what queries/sec rate are you getting?
I am getting a sawtooth graph, that nestled around 40 queries/sec on average

# Q: What resource(s) appear to be the constraining factor?
CPU. CPU usage spiked and hit 100% utilization all through the search duration. There was also a size up on threadpool for the search queries.

# Q: What is the impact on your query throughput (QPS) and indexing throughput (docs/sec)?
Queries stayed around 40 qps and indexing at 212 docs/sec