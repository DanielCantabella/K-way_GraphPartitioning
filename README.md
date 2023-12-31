# K-way Graph Partitioning Using JaBeJa

## Task 1:
Ja-Be-Ja algorithm is implemented in [Jabeja.java](src%2Fmain%2Fjava%2Fse%2Fkth%2Fjabeja%2FJabeja.java) file.
Below each TODO task you can find the code.

Here we show the different results we get when using the following default configuration of the algorithm:
- Simulated annealing delta = 0.003
- Simulated annealing temperature = 2.0
- Number of partitions (colors) = 4
- Alpha = 2.0

And here we show a short description of how the different graphs we are going to investigate look like and 
the plots after the JaBeJa implementation:

* 3elt: 
  * Nodes: 4720, Edges: 13722
  * Color Distribution: [ Color: 0, Count: 1180 ] [ Color: 1, Count: 1180 ] [ Color: 2, Count: 1180 ] [ Color: 3, Count: 1180 ]
![3elt.png](images%2Ftask2%2Fdefault%2F3elt.png)

* add20:
  * Nodes: 2395, Edges: 7462
  * Color Distribution: [ Color: 0, Count: 598 ] [ Color: 1, Count: 599 ] [ Color: 2, Count: 599 ] [ Color: 3, Count: 599]
![add20.png](images%2Ftask2%2Fdefault%2Fadd20.png)

* Twitter:
  * Nodes: 2731, Edges: 164629
  * Color Distribution: [ Color: 0, Count: 682 ] [ Color: 1, Count: 683 ] [ Color: 2, Count: 683 ] [ Color: 3, Count: 683 ]
![twitter.png](images%2Ftask2%2Fdefault%2Ftwitter.png)

In the following table we summarize the results we got after the JaBeJa algorithm:


|   Graph   |  Number of swaps  | Time to converge |  Minimum edge cut observed  |  Time to execute (seconds)  |
|:---------:|:-----------------:|:----------------:|:---------------------------:|:---------------------------:|
|   3elt    |      1307755      |       417        |            1163             |            17.65            |
|   add20   |      673453       |       894        |            1460             |            8.34             |
|  Twitter  |      765501       |       759        |            41160            |            31.70            |


## Task 2:
In this section we analyze the effects of the parameters of the algorithm as well as the implementation of a 
new simulated annealing function.

The different parameters we are going to investigate are:
* Simulated annealing delta (default: 0.003)
* Simulated annealing temperature (default: 2.0)
* Number of partitions (default: 4)
* Alpha (default: 2.0)

We are going to analyze the effect of different parameters on our sample graphs:
First of all, we are going to investigate the effect of the different simulated annealing parameters on both the 
original and a new simulated annealing function, and later on we are going to investigate the effect of alpha an number
of partitions parameters.

### Task 2.1:
We start by exploring the different simulated annealing parameters (i.e., delta and
initial temperature)

#### Task 2.1.1: Original simulated annealing
In this section we used our first simulated annealing configuration with our original acceptance probability function.
All the other parameters kept their original default values described in [Task 2.1](#task-21).

Here we split our results based on the different graphs we used:

##### **Deltas**:
We started by analyzing the effect delta has in the algorithm. Delta works as parameter that determines the speed of the
cooling process, meaning a higher delta results in a faster reduction of temperature over every round. 
The higher the delta the faster T reaches 1. 

  * 3elt:
  
    | Delta  | Number of swaps | Time to converge |Minimum edge cut observed |Time to execute (seconds) |
    |:------:|:---------------:|:----------------:|:------------------------:|:------------------------:|
    | 0.003  |     1307755     |       417        |           1163           |          17.65           |
    |  0.5   |      11311      |       185        |           1936           |          24.30           |
    |  0.8   |      11026      |        95        |           1984           |          24.51           |

  * add20: 
        
    |  Delta  | Number of swaps  |  Time to converge  |  Minimum edge cut observed  |  Time to execute (seconds)  |
    |:-------:|:----------------:|:------------------:|:---------------------------:|:---------------------------:|
    |  0.003  |      673453      |        894         |            1460             |            8.34             |
    |   0.5   |       5220       |        848         |            1754             |            12.03            |
    |   0.8   |       5134       |        130         |            1791             |            12.48            |     

  * Twitter: 
    
    |  Delta  |  Number of swaps  |  Time to converge  |  Minimum edge cut observed  |  Time to execute (seconds)  |
    |:-------:|:-----------------:|:------------------:|:---------------------------:|:---------------------------:|
    |  0.003  |      765501       |        759         |            41160            |            31.70            |
    |   0.5   |       7553        |        429         |            42045            |           165.51            |
    |   0.8   |       7453        |      501 (*)       |            42025            |           186.95            |

**_Results_**: 
* Increasing delta results in a decrease in the number of swaps counted by the algorithm. 
* It also results in a minor time of convergence, meaning the algorthm takes less time to converge to a result (*)
except for the Twitter graph, where a higher delta resulted in higher time to converge, probably due to the size 
difference among the other two graphs.
* A higher delta resulted in a higher minimum edge cut observed among all the rounds of the algorithm.

**_Discussion_**: 
- In other words, delta represents a trade-off between the number of swaps and the quality of the partitioning (edge-cut).
  - Note that a higher number of swaps means both a longer convergence time and more communication overhead.
- Interestingly, the Twitter graph was very robust to delta in terms of the edge-cut value,
so in the case of highly clustered graphs the best choice seems to be a relatively fast cooling schedule.



##### **Temperature**:
Later, we studied the effect the initial temperature has in the algorithm. Initial temperature works as parameter that
biases the comparison towards selecting new states (in the initial rounds), meaning a higher temperature results in a 
longer time to achieve a temperature of 1 (i.e., the more biased rounds we will have).
The higher the temperature the longer it will take to T reach 1. 

  * 3elt:
    
    |  Temperature  |  Number of swaps  |  Time to converge  |  Minimum edge cut observed  |  Time to execute (seconds)  |
    |:-------------:|:-----------------:|:------------------:|:---------------------------:|:---------------------------:|
    |      1.5      |      653054       |        216         |            1503             |            24.59            |
    |      2.0      |      1307755      |        417         |            1163             |            24.79            |
    |    5.0 (*)    |      5223884      |        1387        |             610             |           153.90            |

  * add20:
  
    |  Temperature  |  Number of swaps  |  Time to converge  |  Minimum edge cut observed  |  Time to execute (seconds)  |
    |:-------------:|:-----------------:|:------------------:|:---------------------------:|:---------------------------:|
    |      1.5      |      336359       |        844         |            1602             |            12.53            |
    |      2.0      |      673453       |        894         |            1460             |            8.34             |
    |    5.0 (*)    |      2820697      |        1906        |            1436             |            79.83            |

  * Twitter:
  
    |  Temperature  |   Number of swaps    |  Time to converge  |  Minimum edge cut observed  |  Time to execute (seconds)  |
    |:-------------:|:--------------------:|:------------------:|:---------------------------:|:---------------------------:|
    |      1.5      |        379607        |        515         |            41930            |           185.73            |
    |      2.0      |        765501        |        759         |            41160            |            31.70            |
    |    5.0 (*)    |       3302007        |        1619        |            41146            |           316.55            |
  
**_Results_**: 
* Increasing initial temperature results in an increase in the number of swaps counted by the algorithm. 
* It also results in a larger time of convergence, meaning the algorthm takes more time to converge to a result, (*)
even in some cases it does not even seem to converge with 1000 rounds.
* A higher initial temperature resulted in a higher minimum edge cut observed among all the rounds of the algorithm.

(*) As the algorithm didn't converge with an initial temperature of 5.0 in any case for 1000 rounds, we decided to
increase the number of rounds to 2000 to check its effect.

**_Discussion_**: 
- In other words, initial temperature represents a trade-off between the time to converge (hence more communication overhead)
and the possibility to get stacked in a local optima result (i.e., less temperature allows less bad swaps).

  
#### Task 2.1.1: New simulated annealing
In this section we used the new simulated annealing configuration described in [this paper](http://katrinaeg.com/simulated-annealing.html).
You can see the implemented code commented in [Jabeja.java](src%2Fmain%2Fjava%2Fse%2Fkth%2Fjabeja%2FJabeja.java) under "TODO for Task 2" sections.
All the other parameters kept their original default values described in [Task 2](#task-2) except for temperature,
which in that case its maximum value is 1, so we assume it is now our default value.

Here we show the same plots as before while implementing the new simulated annealing function:
* 3elt:
![3elt3000.png](images%2Ftask2%2Fdeltas%2FnewAnnealing%2F3elt3000.png)
* add20:
![add203000.png](images%2Ftask2%2Fdeltas%2FnewAnnealing%2Fadd203000.png)
* Twitter:
![twitter3000.png](images%2Ftask2%2Fdeltas%2FnewAnnealing%2Ftwitter3000.png)


##### **Deltas**:
We again, started by analyzing the effect delta has in the algorithm.

  * 3elt:
  
    | Delta (alfa) |  Number of swaps  | Time to converge |  Minimum edge cut observed   | Time to execute (seconds) |
    |:------------:|:-----------------:|:----------------:|:----------------------------:|:-------------------------:|
    |  0.003 (*)   | 3884825/11645721  |     999/2999     |           930/730            |       130.88/123.47       |
    |  0.5   (*)   | 3885387/11645341  |     999/2980     |           889/766            |       139.03/88.07        |
    |  0.8   (*)   | 3886617/11646922  |     999/2987     |           843/781            |       134.42/88.48        |
(*) not even converged with 2000 rounds

  * add20: 
      
    |  Delta  |  Number of swaps   |          Time to converge           |  Minimum edge cut observed  |  Time to execute (seconds)  |
    |:-------:|:------------------:|:-----------------------------------:|:---------------------------:|:---------------------------:|
    |  0.003  |  1972708/3942139   |              878/1582               |          1779/1783          |        65.39/131.55         |
    |   0.5   |  1972261/3943393   |              886/1707               |          1785/1796          |        65.60/129.44         |
    |   0.8   |  1972494/3942041   |  998/1938 (probably not converged)  |          1783/1742          |        67.87/130.68         |

  * Twitter: 
    
    |  Delta  |  Number of swaps   |  Time to converge  |  Minimum edge cut observed  |  Time to execute (seconds)  |
    |:-------:|:------------------:|:------------------:|:---------------------------:|:---------------------------:|
    |  0.003  |  2247437/4498187   |      835/1942      |         41615/41652         |       294.34/1002.58        |
    |   0.5   |  2248966/4497603   |      569/1281      |         41627/42230         |        277.36/731.49        |
    |   0.8   |  2250259/4498067   |      782/1911      |         42372/42270         |        332.97/611.95        |

**_Results_**: 
In the case of 3elt graph:
* Increasing deltas increases the number of swaps
* Increasing deltas achieves a lower minimum edge cut observed

None of the trials has shown a clear conversion but seem to converge similar results if we look at their plots
(not included here)

In the case of add20 and twitter:
* Increasing delta does not seem to achieve a lower minimum edge observed, not even increase the number of swaps.

Based on the plots, they all follow a similar pattern where number of swaps increase with every round and edge cut and 
migrations seem to converge to a stable point (which we cannot demonstrate with our previous results in the table). 

**_Discussion_**: 
n 3elt minimum edge cuts are much lower than those observed with the original simulated annealing function.

In add20 and twitter graphs there is no evidence that results are better in one configuration or another.



##### **Temperature**:
Later again, we studied the effect the initial temperature has in the algorithm.

  * 3elt:
    
    |  Temperature  |  Number of swaps   |  Time to converge  |  Minimum edge cut observed  |  Time to execute (seconds)  |
    |:-------------:|:------------------:|:------------------:|:---------------------------:|:---------------------------:|
    |      0.8      |  3885356/7765897   |      998/1997      |          1015/894           |        133.43/285.11        |
    |      0.5      |  3884923/7764298   |      998/1993      |           952/880           |        85.41/138.40         |
    |      0.3      |  3883838/7766680   |      998/1997      |          1011/800           |        82.15/153.83         |

  * add20:

    |  Temperature  |  Number of swaps   |  Time to converge  |  Minimum edge cut observed  |  Time to execute (seconds)  |
    |:-------------:|:------------------:|:------------------:|:---------------------------:|:---------------------------:|
    |      0.8      |  1971865/3942059   |      965/1993      |          1824/1790          |         37.27/71.59         |
    |      0.5      |  1971718/3942193   |      974/1981      |          1802/1786          |         36.25/73.52         |
    |      0.3      |  1972379/3942878   |      968/1987      |          1776/1798          |         36.05/68.58         |

  * Twitter:

    |  Temperature  |  Number of swaps  |    Time to converge     |  Minimum edge cut observed  |  Time to execute (seconds)  |
    |:-------------:|:-----------------:|:-----------------------:|:---------------------------:|:---------------------------:|
    |      0.8      |  2249248/4494843  |  656/403 (interesting)  |         41686/41622         |        168.69/336.59        |
    |      0.5      |  2249536/4496908  |        901/1576         |         41591/42123         |        173.00/341.28        |
    |      0.3      |  2248825/449047   |         782/901         |         41662/41604         |        172.15/339.30        |

**_Results_**: 
Changes in the initial temperature doesn’t seem to have any impact on the minimum edge cut observed nor in the number of swaps.

**_Discussion_**: 
Based on the observed results both when exploring the initial temperature and the delta parameter, we can say randomness
takes an important role and has been difficult to explore all different parameters to find a correlation. Grid search or
other optimization techniques can help in identifying suitable parameter values.






### Task 2.2:
In this section we are going to experiment with different parameters and configurations to find lower edge cuts.

### Other analysis:

* Number of partitions
  * 3elt:
    
    |  Nr Partitions  |  Number of swaps  |  Time to converge  |  Minimum edge cut observed  |  Time to execute (seconds)  |
    |:---------------:|:-----------------:|:------------------:|:---------------------------:|:---------------------------:|
    |        2        |      1553468      |        365         |             915             |            27.12            |
    |        4        |      1307755      |        417         |            1163             |            17.65            |
    |        8        |      890072       |        476         |            1471             |            27.04            |

  * add20:
    
    |  Nr Partitions  |  Number of swaps  |  Time to converge  |  Minimum edge cut observed  |  Time to execute (seconds)  |
    |:---------------:|:-----------------:|:------------------:|:---------------------------:|:---------------------------:|
    |        2        |      789049       |        886         |             863             |            13.45            |
    |        4        |      673453       |        894         |            1460             |            8.34             |
    |        8        |      468891       |        793         |            2170             |            14.31            |

  * Twitter:
    
    | Nr Partitions | Number of swaps |      Time to converge      | Minimum edge cut observed | Time to execute (seconds) |
    |:-------------:|:---------------:|:--------------------------:|:-------------------------:|:-------------------------:|
    |       2       |     899733      |            838             |           11632           |          163.71           |
    |       4       |     765501      |            759             |           41160           |           31.70           |
    |       8       |     590143      | 987 (maybe not converged)  |           90344           |          190.53           |

  * Increasing number of partitions results in a lower number of swaps in every case.
  * Increasing number of partitions also results in a higher minimum edge cut observed

3elt graphs:
* 2 partitions:
![3elt2.png](images%2Ftask2%2Fpartitions%2F3elt2.png)
* 8 partitions:
![3elt8.png](images%2Ftask2%2Fpartitions%2F3elt8.png)

add20 graphs:
* 2 partitions:
![add202.png](images%2Ftask2%2Fpartitions%2Fadd202.png)
* 8 partitions:
![add208.png](images%2Ftask2%2Fpartitions%2Fadd208.png)

Twitter graphs:
* 2 partitions:
![twitter2.png](images%2Ftask2%2Fpartitions%2Ftwitter2.png)
* 8 partitions:
![twitter8.png](images%2Ftask2%2Fpartitions%2Ftwitter8.png)

* Alpha:
  * 3elt:
    
    | Alpha | Number of swaps | Time to converge | Minimum edge cut observed | Time to execute (seconds) |
    |:-----:|:---------------:|:----------------:|:-------------------------:|:-------------------------:|
    |  0.5  |     1367348     |       412        |           1003            |           36.67           |
    |   2   |     1307755     |       417        |           1163            |           17.65           |
    |   4   |     1303969     |       396        |           1247            |           74.31           |

  * add20:
  
    | Alpha | Number of swaps |       Time to converge       | Minimum edge cut observed | Time to execute (seconds) |
    |:-----:|:---------------:|:----------------------------:|:-------------------------:|:-------------------------:|
    |  0.5  |     727933      | 994 (probably not converged) |           1221            |           19.66           |
    |   2   |     673453      |             894              |           1460            |           8.34            |
    |   4   |     675828      | 984 (probably not converged) |           1519            |           38.33           |

  * Twitter:
  
    | Alpha | Number of swaps | Time to converge | Minimum edge cut observed | Time to execute (seconds) |
    |:-----:|:---------------:|:----------------:|:-------------------------:|:-------------------------:|
    |  0.5  |     886644      |       685        |           42342           |          170.15           |
    |   2   |     765501      |       759        |           41160           |           31.70           |
    |   4   |     756612      |       510        |           42043           |          170.71           |

  * Increasing alpha results in a higher minimum edge cut observed except in the case of Twitter
  * If alpha is set too high, nodes might overestimate the value of a swap and end up in an inferior state.

3elt graphs:
* Alpha 0.5:
![3elt05.png](images%2Ftask2%2Falphas%2F3elt05.png)
* Alpha 4:
![3elt4.png](images%2Ftask2%2Falphas%2F3elt4.png)

add20 graphs:
* Alpha 0.5:
![add2005.png](images%2Ftask2%2Falphas%2Fadd2005.png)
* Alpha 4:
![add204.png](images%2Ftask2%2Falphas%2Fadd204.png)

Twitter graphs:
* Alpha 0.5:
![twitter05.png](images%2Ftask2%2Falphas%2Ftwitter05.png)
* Alpha 4:
![twitter4.png](images%2Ftask2%2Falphas%2Ftwitter4.png)