## Investingating Node Logs:

I have been running between 3 and 6 nodes for about 2 days, and I have generated a significant number of log entires for each node. Now that this data is acquired, we can investigate how the nodes are peforming. Using some simple estimates, we attempt to answer the following questions.



### What kind of Informational Log entries are there?

Excluding traces, errors and warnings, we see the following from inspection:




### Q: How can we estimate how much time each node is mining?

There currently isn't advanced tools to check with, with the nockchain codebase. I use a simple estimate method to assess this: For each `node.log` file, I count the number of lines that have `[%mining ....` entry, vs every other type of entry found in the file. This yields a percentage of the time we spend mining per node.

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

What about disconnection SE Events ("friendship ended")? "friendship ended"

| Node   | Log Length | "friendship ended" Lines | Percentage |
| ------ | ---------- | ------------------------ | ---------- |
| Node 1 | 29,441     | 3,005                    | 10.2%      |
| Node 2 | 57,008     | 6,535                    | 11.5%      |
| Node 3 | 40,542     | 12,176                   | 30.0%      |
| Node 4 | 109,116    | 1,568                    | 1.44%      |
| Node 5 | 266,290    | 5,259                    | 1.97%      |
| Node 6 | 34,460     | 270                      | 0.783%     |

There isn't any particlarly strong trend we can see in these tables. But they lead to the following Testable Hypothesis (TH1):  **Running fewer nodes (just 2) will yield better metrics (higher mining %, and less block querying. Disconnections are independent).

## Testible Hypothesis 1:

To perform our test, a 126GB machine with 16 vCPUs was launched. Two nodes were activated, and run for about 8 hour straight.  The three summary tables are below.



We don't have enough data to suggst 

