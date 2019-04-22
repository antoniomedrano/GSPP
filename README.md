# GSPP
A Processing implementation of the Gateway Shortest Path Problem (GSPP) on raster data as described in *Lombard & Church* (1993). Processing is a Java-based language with additional graphical functions and an IDE for simple code development suitable for graphics and animations. This also uses the *Gleyzer et al.* (2004) recursive algorithm to add Strahler stream ordering hierarchy to the shortest path trees to see if this approach would be a good way to automate the selection of "good" gateway points that result in paths that are spatially diverse from the shortest path yet minimally longer.  
* Once you have both the forward and reverse shortest path trees, you can click on any point to display the 1-gateway shortest path and the area difference to the shortest path.  
* The default raster is the HC2020.asc dataset, but other rasters are included here and can be changed by changing the appropriate comments in Data.pde.  
* The default raster connectivity is R=2, but you can change to R=1 or R=0 by changing the code at the top of Data.pde  
  
Perhaps a future update will incorporate multi-gateway paths as described in *Scaparra et al.* (2014)  

**Requirements**  
Requires [Processing](https://processing.org/) (last tested with v3.5.3)  
  
## References  
1. Lombard, K., & Church, R. L. (1993). The gateway shortest path problem: generating alternative routes for a corridor location problem. *Geographical Systems, 1*(1), 25-45.
2. Gleyzer, A., Denisyuk, M., Rimmer, A., & Salingar, Y. (2004). A fast recursive GIS algorithm for computing Strahler stream order in braided and nonbraided networks. *Journal of the American Water Resources Association, 40*(4), 937-946.
3. Scaparra, M. P., Church, R. L., & Medrano, F. A. (2014). Corridor location: the multi-gateway shortest path model. *Journal of Geographical Systems, 16*(3), 287-309.
