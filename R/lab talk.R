# Code used in a talk introducing Durga # 06.10.22

library(Durga)

data("damselfly")
head(damselfly)
d1 <- DurgaDiff(damselfly, data.col = 1, group.col = 3, effect.type = "mean")


d2 <- DurgaDiff(damselfly, data.col = 1, group.col = 3, effect.type = "cohens", na.rm = TRUE)
d3 <- DurgaDiff(damselfly, data.col = 1, group.col = 3, effect.type = "hedges") 

d2

## plot effect size right
DurgaPlot(d1)
DurgaPlot(d1, box = TRUE)
DurgaPlot(d1, box = TRUE, ef.size.violin = FALSE)
DurgaPlot(d1, box = TRUE,ef.size.violin = FALSE, ef.size.pch = 15)
DurgaPlot(d1, box = TRUE,ef.size.violin = TRUE, ef.size.pch = 15)
DurgaPlot(d1, box = TRUE, ef.size.pch = 15, ef.size.violin = "red")
DurgaPlot(d1, box = TRUE, ef.size.pch = 15, 
          ef.size.violin = "red", ef.size.violin.shape = "full")

## plot effect size below 
DurgaPlot(d1, ef.size.position = "below")
DurgaPlot(d1, box = TRUE, ef.size.position = "below")
DurgaPlot(d1, box = TRUE, ef.size.violin = FALSE, ef.size.position = "below")
DurgaPlot(d1, box = TRUE,ef.size.violin = FALSE, ef.size.pch = 15, ef.size.position = "below")
DurgaPlot(d1, box = TRUE,ef.size.violin = TRUE, ef.size.pch = 15, ef.size.position = "below")
DurgaPlot(d1, box = TRUE, ef.size.pch = 15, ef.size.violin = "red", ef.size.position = "below")
DurgaPlot(d1, box = TRUE, ef.size.pch = 15, 
          ef.size.violin = "red", ef.size.violin.shape = "full", ef.size.position = "below")
DurgaPlot(d1, box = TRUE, ef.size.pch = 15, 
          ef.size.violin = "red", 
          ef.size.violin.shape = "full", 
          ef.size.position = "below",
          ef.size.dx = -0.5)


## effect size up
p <- DurgaPlot(d1, box = TRUE, ef.size = F, ylim = c(29, 36), box.outline = F)
DurgaBrackets(p)
## effect size for paired data 

data("insulin")
head(insulin)
d4 <- DurgaDiff(insulin, data.col = 1, group.col = 2, id.col = 3, effect.type = "unstandardised")
d5 <- DurgaDiff(insulin, data.col = 1, group.col = 2, id.col = 3, effect.type = "cohens")
d6 <- DurgaDiff(insulin, data.col = 1, group.col = 2, id.col = 3, effect.type = "hedges") 

DurgaPlot(d4)
DurgaPlot(d4, violin.shape = c("left-half", "right-half"))
DurgaPlot(d4, 
          box = TRUE,
          #violin = FALSE, 
          #central.tendency = FALSE, 
          #points = FALSE
)


### more than two group data 

data("petunia")
head(petunia)

d7 <- DurgaDiff(petunia, data.col = 1, group.col = 2)
DurgaPlot(d7)

## Durgaplot is a flexible and powerful package 

DurgaPlot(d1, 
          #violin = FALSE,
          #central.tendency = F,
          
          
          points = c("red", "blue"),
          points.method = "quasirandom", 
          points.params = list(cex = 1.8, pch = 16),
          #points = DurgaTransparent(c("red", "blue"),0.4),
          
          
          #violin = T,
          #violin = c("red", "blue"), 
          # violin.fill = TRUE,
          #violin.fill = c("red", "blue"), 
          #violin.shape = c("left-half", "right-half", "full"),
          #violin.adj = 1.5,
          # violin.width = 0.35,
          # violin.trunc = T,
          #violin.dx = 0.0,
          
          # box = T,
          #box.fill = F,
          #box.outline = F,
          #box.notch = F,
          #box.pars = list(boxwex = 0.8, staplewex = 0.5, outwex = 0.5),
          #box.dx = 0.3,
          
          
          
          # bar = T,
          # bar.fill = TRUE,
          # bar.width = 0.5,
          # bar.dx = 0.4,
          
          
          # box = F,
          #violin = F,
          #central.tendency = T,
          #central.tendency.type = "mean",
          #central.tendency.symbol = "point", # "segment"
          # central.tendency.width = violin.width,
          # central.tendency.params = list(cex = 1.5, col = "red", pch = 15),
          # central.tendency.dx = 0.2,
          
          
          #  error.bars = T,
          #  error.bars.type = "SD",
          # error.bars.cross.width = 0,
          
)

### interactive plotting 

DurgaPlot(d1)


## ways to present groups 
layout(matrix(c(1,2,3,4,5,6), nrow=2,ncol=3,byrow =  TRUE))

DurgaPlot(d1, box = TRUE, points = FALSE,ef.size = FALSE)
DurgaPlot(d1, box = FALSE, violin = FALSE, 
          central.tendency.type = "mean",
          central.tendency.symbol = "point",
          central.tendency = TRUE, 
          error.bars.type = "SD", 
          central.tendency.params = list(cex = 1.5),
          points = FALSE,
          ef.size = FALSE)
DurgaPlot(d1, bar = TRUE, points = FALSE, error.bars.type = "SD", ef.size = FALSE)
DurgaPlot(d1, violin = TRUE, violin.shape = "full", points =FALSE, ef.size = FALSE)
DurgaPlot(d1, violin = TRUE, ef.size = FALSE, points = FALSE)
DurgaPlot(d1, violin = TRUE, violin.shape = "right-half", points =FALSE, ef.size = FALSE)

## ways to present groups better 
layout(matrix(c(1,2,3,4,5,6), nrow=2,ncol=3,byrow =  TRUE))

DurgaPlot(d1, box = TRUE, ef.size = FALSE)
DurgaPlot(d1, box = FALSE, violin = FALSE, 
          central.tendency.type = "mean",
          central.tendency.symbol = "segment",
          central.tendency = TRUE, 
          error.bars.type = "SD", 
          ef.size = FALSE)
DurgaPlot(d1, bar = TRUE,  error.bars.type = "SD", ef.size = FALSE)
DurgaPlot(d1, violin = TRUE, violin.shape = "full", ef.size = FALSE)
DurgaPlot(d1, violin = TRUE, violin.shape = "right-half", ef.size = FALSE)
DurgaPlot(d1, violin = TRUE, ef.size = FALSE)

##Some recent form of advanced data plotting 


layout(matrix(c(1,2,3,4), nrow=2,ncol=2,byrow =  TRUE))

DurgaPlot(d2, box = DurgaTransparent(Khona,0.0), 
          box.fill = DurgaTransparent(Khona,0.4), 
          box.outline = FALSE,
          box.pars = list(boxwex = 0.2), 
          violin = DurgaTransparent(Khona,0),
          violin.fill = DurgaTransparent(Khona,0.4),
          violin.width = 0.30,
          violin.dx = -0.1,
          #box.dx = 0.25, 
          points = DurgaTransparent(Khona,0.4), 
          points.dx = 0.20,
          points.method = "jitter",
          points.params = list(cex = 1.2),
          ef.size = FALSE,
          ef.size.pch = 15, 
          ef.size.violin = DurgaTransparent(Khona[8], 0.0),
          las = 1,
          ef.size.las = 1)

DurgaPlot(d2, box = DurgaTransparent(Khona,0.0), 
          box.fill = DurgaTransparent(Khona,0.6), 
          box.outline = FALSE,
          box.pars = list(boxwex = 0.2), 
          violin = DurgaTransparent(Khona,0),
          violin.fill = DurgaTransparent(Khona,0.6),
          violin.width = 0.30,
          violin.dx = -0.1,
          box.dx = 0.05, 
          points = DurgaTransparent(Khona,0.4), 
          points.dx = 0.10,
          points.method = "jitter",
          points.params = list(cex = 1.2),
          ef.size = FALSE,
          ef.size.pch = 15, 
          ef.size.violin = DurgaTransparent(Khona[8], 0.0),
          las = 1,
          ef.size.las = 1)

DurgaPlot(d2, box = DurgaTransparent(Khona,0.0), 
          box.fill = DurgaTransparent(Khona,0.6), 
          box.outline = FALSE,
          box.pars = list(boxwex = 0.2), 
          violin = DurgaTransparent(Khona,0),
          violin.fill = DurgaTransparent(Khona,0.6),
          violin.width = 0.30,
          violin.dx = -0.1,
          box.dx = 0.25, 
          points = DurgaTransparent(Khona,0.4), 
          points.dx = 0.02,
          points.method = "jitter",
          points.params = list(cex = 1.2),
          ef.size = FALSE,
          ef.size.pch = 15, 
          ef.size.violin = DurgaTransparent(Khona[8], 0.0),
          las = 1,
          ef.size.las = 1)


DurgaPlot(d2, box = DurgaTransparent(Khona,0.0), 
          box.fill = DurgaTransparent(Khona,0.4), 
          box.outline = FALSE,
          box.pars = list(boxwex = 0.2), 
          box.dx = -0.1,
          violin.shape = "full",
          violin = DurgaTransparent(Khona,0),
          violin.fill = DurgaTransparent(Khona,0.8),
          violin.width = 0.30,
          violin.dx = -0.1,
          #box.dx = 0.25, 
          points = DurgaTransparent(Khona,0.6), 
          #points.dx = 0.20,
          #points.method = "jitter",
          points.params = list(cex = 1.5),
          ef.size = FALSE,
          ef.size.pch = 15, 
          ef.size.violin = DurgaTransparent(Khona[8], 0.0),
          las = 1,
          ef.size.las = 1)


####  combine all plots 

pageWidthLarge<- 14.08661
pageHeightLarge <- pageWidthLarge * 1.5
pagePaper <- 'special'
fontFamily <- 'Times'
png("../output/Figure_3.1.png", width=pageWidthLarge, height= pageHeightLarge,
    units= "in",type= "cairo", res = 600)

layout(matrix(c(1,2,3,4,5,6,7,8,9,10,11,12,13,14,15), nrow=5,ncol=3,byrow =  TRUE))

DurgaPlot(d1, box = DurgaTransparent(Khona,0.0), 
          box.fill = DurgaTransparent(Khona,0.4),
          points = FALSE,ef.size = FALSE)

DurgaPlot(d1, box = FALSE, violin = FALSE, 
          central.tendency.type = "mean",
          central.tendency.symbol = "point",
          central.tendency = TRUE, 
          error.bars.type = "SD", 
          central.tendency.params = list(cex = 1.5),
          points = FALSE,
          ef.size = FALSE)

DurgaPlot(d1, bar = TRUE, points = FALSE, error.bars.type = "SD", ef.size = FALSE)
DurgaPlot(d1, violin = TRUE, violin.shape = "full", points =FALSE, ef.size = FALSE)
DurgaPlot(d1, violin = TRUE, ef.size = FALSE, points = FALSE)
DurgaPlot(d1, violin = TRUE, violin.shape = "right-half", points =FALSE, ef.size = FALSE)

DurgaPlot(d1, box = TRUE, ef.size = FALSE)
DurgaPlot(d1, box = FALSE, violin = FALSE, 
          central.tendency.type = "mean",
          central.tendency.symbol = "segment",
          central.tendency = TRUE, 
          error.bars.type = "SD", 
          ef.size = FALSE)
DurgaPlot(d1, bar = TRUE,  error.bars.type = "SD", ef.size = FALSE)
DurgaPlot(d1, violin = TRUE, violin.shape = "full", ef.size = FALSE)
DurgaPlot(d1, violin = TRUE, violin.shape = "right-half", ef.size = FALSE)
DurgaPlot(d1, violin = TRUE, ef.size = FALSE)

DurgaPlot(d2, box = DurgaTransparent(Khona,0.0), 
          box.fill = DurgaTransparent(Khona,0.4), 
          box.outline = FALSE,
          box.pars = list(boxwex = 0.2), 
          violin = DurgaTransparent(Khona,0),
          violin.fill = DurgaTransparent(Khona,0.4),
          violin.width = 0.30,
          violin.dx = -0.1,
          #box.dx = 0.25, 
          points = DurgaTransparent(Khona,0.4), 
          points.dx = 0.20,
          points.method = "jitter",
          points.params = list(cex = 1.2),
          ef.size = FALSE,
          ef.size.pch = 15, 
          ef.size.violin = DurgaTransparent(Khona[8], 0.0),
          las = 1,
          ef.size.las = 1)

DurgaPlot(d2, box = DurgaTransparent(Khona,0.0), 
          box.fill = DurgaTransparent(Khona,0.6), 
          box.outline = FALSE,
          box.pars = list(boxwex = 0.2), 
          violin = DurgaTransparent(Khona,0),
          violin.fill = DurgaTransparent(Khona,0.6),
          violin.width = 0.30,
          violin.dx = -0.1,
          box.dx = 0.05, 
          points = DurgaTransparent(Khona,0.4), 
          points.dx = 0.10,
          points.method = "jitter",
          points.params = list(cex = 1.2),
          ef.size = FALSE,
          ef.size.pch = 15, 
          ef.size.violin = DurgaTransparent(Khona[8], 0.0),
          las = 1,
          ef.size.las = 1)


DurgaPlot(d2, box = DurgaTransparent(Khona,0.0), 
          box.fill = DurgaTransparent(Khona,0.4), 
          box.outline = FALSE,
          box.pars = list(boxwex = 0.2), 
          #box.dx = -0.1,
          violin.shape = "full",
          violin = DurgaTransparent(Khona,0),
          violin.fill = DurgaTransparent(Khona,0.8),
          violin.width = 0.30,
          # violin.dx = -0.1,
          #box.dx = 0.25, 
          points = DurgaTransparent(Khona,0.6), 
          #points.dx = 0.20,
          #points.method = "jitter",
          points.params = list(cex = 1.5),
          ef.size = FALSE,
          ef.size.pch = 15, 
          ef.size.violin = DurgaTransparent(Khona[8], 0.0),
          las = 1,
          ef.size.las = 1)

dev.off()

### None of the graphs provide quantitive information about the difference aka effect size

library(DurgaPlot)

data("damselfly")
head(damselfly)
d1 <- DurgaDiff(damselfly, data.col = 1, group.col = 3, effect.type = "unstandardised")
d2 <- DurgaDiff(damselfly, data.col = 1, group.col = 3, effect.type = "cohens")
d3 <- DurgaDiff(damselfly, data.col = 1, group.col = 3, effect.type = "hedges") 

d1

## plot effect size right
DurgaPlot(d1)
DurgaPlot(d1, box = TRUE)
DurgaPlot(d1, box = TRUE, ef.size.violin = FALSE)
DurgaPlot(d1, box = TRUE,ef.size.violin = FALSE, ef.size.pch = 15)
DurgaPlot(d1, box = TRUE,ef.size.violin = TRUE, ef.size.pch = 15)
DurgaPlot(d1, box = TRUE, ef.size.pch = 15, ef.size.violin = "red")
DurgaPlot(d1, box = TRUE, ef.size.pch = 15, 
          ef.size.violin = "red", ef.size.violin.shape = "full")

## plot effect size below 
DurgaPlot(d1, ef.size.position = "below")
DurgaPlot(d1, box = TRUE, ef.size.position = "below")
DurgaPlot(d1, box = TRUE, ef.size.violin = FALSE, ef.size.position = "below")
DurgaPlot(d1, box = TRUE,ef.size.violin = FALSE, ef.size.pch = 15, ef.size.position = "below")
DurgaPlot(d1, box = TRUE,ef.size.violin = TRUE, ef.size.pch = 15, ef.size.position = "below")
DurgaPlot(d1, box = TRUE, ef.size.pch = 15, ef.size.violin = "red", ef.size.position = "below")
DurgaPlot(d1, box = TRUE, ef.size.pch = 15, 
          ef.size.violin = "red", ef.size.violin.shape = "full", ef.size.position = "below")

## effect size for paired data 

data("insulin")
head(insulin)
d4 <- DurgaDiff(insulin, data.col = 1, group.col = 2, id.col = 3, effect.type = "unstandardised")
d5 <- DurgaDiff(insulin, data.col = 1, group.col = 2, id.col = 3, effect.type = "cohens")
d6 <- DurgaDiff(insulin, data.col = 1, group.col = 2, id.col = 3, effect.type = "hedges") 

DurgaPlot(d4)
DurgaPlot(d4, violin.shape = c("left-half", "right-half"))
DurgaPlot(d4, 
          #box = TRUE
          #violin = FALSE, 
          #central.tendency = FALSE, 
          #points = FALSE
)


## Durgaplot is a flexible and powerful package 

DurgaPlot(d1, 
          #violin = FALSE,
          #central.tendency = F,
          
          
          points = c("red", "blue"),
          points.method = "quasirandom", 
          points.params = list(cex = 1.8, pch = 16),
          #points = DurgaTransparent(c("red", "blue"),0.4),
          
          
          #violin = T,
          #violin = c("red", "blue"), 
          # violin.fill = TRUE,
          #violin.fill = c("red", "blue"), 
          #violin.shape = c("left-half", "right-half", "full"),
          #violin.adj = 1.5,
          # violin.width = 0.35,
          # violin.trunc = T,
          #violin.dx = 0.0,
          
          # box = T,
          #box.fill = F,
          #box.outline = F,
          #box.notch = F,
          #box.pars = list(boxwex = 0.8, staplewex = 0.5, outwex = 0.5),
          #box.dx = 0.3,
          
          
          
          # bar = T,
          # bar.fill = TRUE,
          # bar.width = 0.5,
          # bar.dx = 0.4,
          
          
          # box = F,
          #violin = F,
          #central.tendency = T,
          #central.tendency.type = "mean",
          #central.tendency.symbol = "point", # "segment"
          # central.tendency.width = violin.width,
          # central.tendency.params = list(cex = 1.5, col = "red", pch = 15),
          # central.tendency.dx = 0.2,
          
          
          #  error.bars = T,
          #  error.bars.type = "SD",
          # error.bars.cross.width = 0,
          
)

### interactive plotting 

DurgaPlot(d1)


