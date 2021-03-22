# pNISE
A parallelized NISE algorithm applied toward biobjective shortest path analysis on raster grids used in Medrano & Church (2015). Serial NISE was originally published in Cohon *et al.* (1979)  
  
## Contents
Contains both a graphical implementation using Processing, and a non-graphical but faster implementation in Java. Data is included in both.
  
**Requirements**  
[Processing](https://processing.org/): last tested with v3.5.4  
Java SDK: last tested with Java SE 8 Update 66  
*update contributions are welcome*  

**Instructions**  
In the Processing IDE, simply click the "Run" button. All parameters such as which map data to use, R, OD pair, color, and parallelism can be modified in code.  
  
The Java version takes 3 arguments in order: *R OD parallelism*  
All other parameters such as which map data to use can be modified in code.  
  
## References  
1. Medrano, F. A., & Church, R. L. (2015). A Parallel Computing Framework for Finding the Supported Solutions to a Biobjective Network Optimization Problem. *Journal of Multi-Criteria Decision Analysis, 22*(5-6), 244-259. doi:10.1002/mcda.1541  
2. Cohon, J. L., Church, R. L., & Sheer, D. P. (1979). Generating multiobjective trade-offs: an algorithm for bicriterion problems. *Water Resources Research*, 15(5), 1001-1010. 
