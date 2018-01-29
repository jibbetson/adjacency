# adjacency
A Shiny app for presenting and manipulating data in an adjacency matrix. Mostly exploratory for the purpose of learning how to use Shiny.  

By adjacency matrix I mean a set of pairwise relationships for multiple endpoints. As a simple example, a set of travel times from point A to B, A to C, B to C, etc. Such data can be visualized as a heatmap, where each cell corresponds to a specific pair.

In general, once you have a raw dataset it needs to be processed. For example: does it satisfy a threshold and what does that look like?  

##Shiny app elements
- Read in data from a file.  
- Choose and plot a variable as a heatmap. Include color scheme options.  
- Do something to the data. E.g. symmetrize.
- Replot.  
- Do something with the processed data. E.g. does it meet a user-defined threshold?  
- Replot.  

For additional value use `plotly` for the heatmaps so they are interactive.
