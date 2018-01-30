# playing with heatmaps
# ----------------------------------------------------------------------

library(lattice)

plot_heatmap.lattice <- function(dt, z, title = NULL, 
                            incl.vals = TRUE, allticks = TRUE, ... ){
    
    # function to add text to heatmap
    myPanel <- function(x, y, z, ...) { 
        panel.levelplot(x, y, z, ...)
        if(incl.vals) panel.text(x, y, round(z, 2), cex = 0.75)
    }    
    
    grid <- as_tibble(list(X = dt[, 1], Y = dt[, 2], Z = dt[, z]))
    
    # default plot title and non-default tick locations
    if(is.null(title)) title <- z
    entity.list <- unique(grid$X)
    l <- if(allticks) list(at = entity.list) else list() 
    ticks <- l
    
    levelplot(Z ~ X*Y, grid, main = title, panel = myPanel, 
              col.regions = colorRampPalette(c("red", "yellow", "green")),
              xlab = "Start", ylab = "End", scales = ticks)
}
