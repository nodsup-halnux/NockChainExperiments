## Investingating Node Logs:

I have been running between 3 and 6 nodes for about 2 days, and I have generated a significant number of log entires for each node. Now that this data is acquired, we can investigate how the nodes are peforming. Using some simple estimates, we attempt to answer the following questions.


### Q: How can we estimate how much time each node is mining?

There currently isn't advanced tools to check with, with the nockchain codebase. I use a simple estimate method to assess this: For each `node.log` file, I count the number of lines that have `[%mining ....` entry, vs every other type of entry found in the file. This yields a percentage of the time we spend mining per node.

**Note that usage of log files to estimate mining time is crude, because the rate at which log messages appear can vary dramatically (form large bursts in 2 seconds, to nothing even after 1 minute). Also, out of the 20 threads that typically habit a process node, some may be doing work/mining, but not necessarily reporting it to console at all.**

Still, I was curious just to see what the results were. They are quite poor with a base setup. 

For the six nodes I was running my my machine, we observe the following:


| Node   | Log Length | [%mining] Lines | Mining Percentage |
|--------|------------|-----------------|--------------------|
| Node 1 | 29,441     | 91              | 0.309%             |
| Node 2 | 57,008     | 184             | 0.323%             |
| Node 3 | 40,542     | 192             | 0.473%             |
| Node 4 | 109,116    | 59              | 0.0541%            |
| Node 5 | 266,290    | 37              | 0.0139%            |
| Node 6 | 34,460     | 11              | 0.0319%            |


Which look pretty anemic. Next, lets look at some other stats.  How often are our nodes querying the network backbone for elder data?

| Node   | Log Length | "requesting elders" Lines | Percentage |
| ------ | ---------- | ------------------------- | ---------- |
| Node 1 | 29,441     | 16,617                    | 56.4%      |
| Node 2 | 57,008     | 10,959                    | 19.2%      |
| Node 3 | 40,542     | 4,419                     | 10.9%      |
| Node 4 | 109,116    | 47,698                    | 43.7%      |
| Node 5 | 266,290    | 146,314                   | 54.9%      |
| Node 6 | 34,460     | 30,673                    | 89.0%      |


We see a lot more variablility in the percentages here. 

What about disconnection SE Events ("friendship ended")?

| Node   | Log Length | "friendship ended" Lines | Percentage |
| ------ | ---------- | ------------------------ | ---------- |
| Node 1 | 29,441     | 3,005                    | 10.2%      |
| Node 2 | 57,008     | 6,535                    | 11.5%      |
| Node 3 | 40,542     | 12,176                   | 30.0%      |
| Node 4 | 109,116    | 1,568                    | 1.44%      |
| Node 5 | 266,290    | 5,259                    | 1.97%      |
| Node 6 | 34,460     | 270                      | 0.783%     |

There isn't any particlarly strong trend we can see in these tables. But they lead to the following Testable Hypothesis (TH1): 

## Testible Hypothesis 1:

 **Running fewer nodes (2 v.s 4-6) on a larger Droplet should result in better log file metrics (higher mining %, and less block querying).** 

To perform our test, a 128GB machine with 16 vCPUs was launched. Two nodes were activated, and run for about ~10 hour straight. Note that previously, 4-6 nodes were run to get the data that was seen above. The three summary tables are below.

**Results:**

| Node   | Log Length | "FE" Lines | FE %  | RE Lines | RE %  | %mining Lines | %mining % |
| ------ | ---------- | ---------- | ----- | -------- | ----- | ------------- | --------- |
| Node 1 | 39,375     | 2,901      | 7.37% | 8,281    | 21.0% | 17            | 0.0432%   |
| Node 2 | 4,938      | 1,935      | 39.2% | 959      | 19.4% | 94            | 1.90%     |


These numbers are still quite poor, although Node 2 has increased its mining percentage by about 2.5x. They also vary quite a bit between the two nodes, as well as with the previous 6 nodes that were run earlier.

Strangely, node2 also had a much different log length. Both ndoes have the same log leven (RUST_LOG=info), so this isn't a setting issue.

At ths point, I will abandon other test configurations (2 nodes on 64GB machine), as I don't expect the metrics to be any better.


**In short:** our goal is to have maximum mining, and minimum network querying and reconnection to the backbone. Despite the crudeness of counting log entries and calculating percentages, we appear to very far away from our goal, given the results we obtained.

The common gripe of not being able to mine anything without extensive optiimizations **will now be taken more seriously**. All server optimizaitond and tests are complete, and can give no more boosts in performance.

...Its time to deep dive into the code base.

## Experiment 2:

As per [this post](), there may have been a network attack while I was doing my testing (a DDOS node making too many requests, specifically for elder requests). Once again, I ran a VPS with 2 nodes and 128GB of RAM (for about 7 hours). Here are the reseults:

| Node   | Log Length | "FE" Lines | FE %  | RE Lines | RE %  | %mining Lines | %mining % |
| ------ | ---------- | ---------- | ----- | -------- | ----- | ------------- | --------- |
| Node 1 | 89200     |   42    | X | 88,840    | 21.0% | X            | 0.0432%   |
| Node 2 | 77877      |  50     | X | 77405      | 19.4% | X            | 1.90%     |

Which is still abysmal. Perhaps the node was catching up? We need to figure out what the different log messages mean, so we need to depe dive into the code, as stated before.

