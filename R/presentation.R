# Code to generate an animated presentation

library(Durga)
library(JUtils)
library(png)

source("anim-tools.R")

#----------------------------------------------------------------------


d <- DurgaDiff(damselfly, 2, 3, groups = c(Juvenile = "juvenile", Adult = "adult"), na.rm = TRUE)
p <- DurgaDiff(petunia, 1, 2, groups = c(`Self fertilised` = "self_fertilised", `Westerham cross` = "westerham_cross", `Inter cross` = "inter_cross"), na.rm = TRUE)


# hardwire y limits for damselfly data set
ymin0 <- -1.19398260869565 # barplot only
ymin1 <- 16.28             # Boxplot only
ymax0 <- 31.043547826087   # barplot only
ymax1 <- 31.898924471995   # Bar plot + error bars
ymax2 <- 38.5632           # Bar plot + boxplot
ymax3 <- 37.88             # Boxplot only

xmin0 <- 0.42              # 2 groups, no effect size
xmax0 <- 2.58              # 2 groups, no effect size
xmin1 <- 0.392             # 2 groups, effect size
xmax1 <- 3.308             # 2 groups, effect size

efMai <- 2.02472222222222  # Bottom margin with effect size
nefMai <- 1.02             # Bottom margin without effect size
pymin0 <- 9.77994856717634 # ylim of petunias without effect size
pymax0 <- 67.5496276040083
pymin1 <- 10               # ylim of petunias with brackets
pymax1 <- 83

cols2 <- RColorBrewer::brewer.pal(3, "Set2")

if (!file.exists("../data/Durga.png")) {
  warning("Logo file Durga.png not found")
  logo <- NULL
} else {
  logo <- readPNG("../data/Durga.png", native = TRUE)
}

# -----------------------------------------------------------------------------

# Frame rate
fps <- 20
# Output file (extension defines format)
outFile <- "../output/pres.gif"


scenes <- list(

  # 0. Black and white bar plot, fade to colour
  scene(2, fps,

        colIntensity = transition(0, 1, easeIn, c(0.1, 0.9)),

        plotFn = function(colIntensity) {
          fullCols <- RColorBrewer::brewer.pal(3, "Set2")
          colsRgb <- col2rgb(fullCols) * colIntensity
          cols <- rgb(colsRgb[1, ], colsRgb[2, ], colsRgb[3, ], maxColorValue = 255)
          DurgaPlot(d, group.colour = cols, yaxs = "i", ylim = c(ymin0, ymax0), error.bars = FALSE,
                    bar = TRUE, points = FALSE, ef.size = FALSE, main = "Bar chart, introducing colour")
        }),

  # 1. bar plot, introduce error bars
  scene(2, fps,

        ymax = transition(ymax0, ymax1, easeIn, c(0, 0.7)),
        error.bars = transition(0, 1, step(.8)),

        plotFn = function(ymax, error.bars) {
          DurgaPlot(d, yaxs = "i", ylim = c(ymin0, ymax), error.bars = error.bars,
                    bar = TRUE, points = FALSE, ef.size = FALSE,
                    main = "Bar chart with error bars")
        }),

  # 2. Fade out bars, in boxes
  scene(2, fps,

        alphaBar = transition(0, 1),
        alphaBox = transition(1, 0),
        ymin = transition(ymin0, ymin1, times = c(0.6, 1)),
        ymax = transition(ymax1, ymax3),
        errorBarAlpha = transition(0, 1),

        plotFn = function(alphaBar, alphaBox, ymin, ymax, errorBarAlpha) {

          barCol <- DurgaTransparent(cols2, alphaBar)
          barFillCol <- DurgaTransparent(barCol, 0.8, TRUE)
          boxCol <- DurgaTransparent(cols2, alphaBox)
          boxFillCol <- DurgaTransparent(boxCol, 0.8, TRUE)
          error.bars <- DurgaTransparent("black", errorBarAlpha)
          DurgaPlot(d,
                    yaxs = "i", ylim = c(ymin, ymax),
                    bar = barCol, bar.fill = barFillCol, box = boxCol, box.fill = boxFillCol,
                    error.bars = error.bars,
                    points = FALSE, ef.size = FALSE,
                    main = "Box plot")
        }),


  # 3. Fade out boxes, in violins
  scene(2, fps,

        alphaBox = transition(0, 1),
        alphaViolin = transition(1, 0),
        errorBarAlpha = transition(1, 0),

        plotFn = function(alphaBox, alphaViolin, errorBarAlpha) {

          boxCol <- DurgaTransparent(cols2, alphaBox, errorBarAlpha)
          boxFillCol <- DurgaTransparent(boxCol, 0.8, TRUE)
          violinCol <- DurgaTransparent(cols2, alphaViolin)
          violinFillCol <- DurgaTransparent(violinCol, 0.8, TRUE)
          error.bars <- DurgaTransparent("black", errorBarAlpha)
          DurgaPlot(d,
                    box = boxCol, box.fill = boxFillCol, violin = violinCol, violin.fill = violinFillCol,
                    central.tendency = error.bars, error.bars = error.bars,
                    points = FALSE, ef.size = FALSE,
                    main = "Violin plot")
        }),


  # 4. Show points with jitter
  scene(1, fps,

        pointsAlpha = transition(1, 0.4),
        pointsSpread = transition(0, .05),
        pointsDx = transition(0, 0.08),

        plotFn = function(pointsAlpha, pointsSpread, pointsDx) {
          points <- DurgaTransparent(cols2, pointsAlpha)
          set.seed(1)
          DurgaPlot(d,
                    points = points, points.spread = pointsSpread,
                    points.method = "jitter", points.dx = pointsDx,
                    ef.size = FALSE,
                    main = "Violin and jittered points")
        }),


  # 5. Quickly remove jitter
  scene(0.6, fps,

        pointsSpread = transition(0.05, 0.0001, easeIn),
        pointsDx = transition(0.08, 0),

        plotFn = function(pointsSpread, pointsDx) {
          set.seed(1)
          DurgaPlot(d,
                    points.spread = pointsSpread,
                    points.method = "jitter", points.dx = pointsDx,
                    ef.size = FALSE,
                    main = "Violin and jittered points")
        }),

  # 6. Quickly add nice scatter
  scene(1, fps,

        pointsSpread = transition(0, 0.3, easeOut),
        xmin = transition(xmin0, xmin1, easeInOut, times = c(0, 0.9)),
        xmax = transition(xmax0, xmax1, easeInOut, times = c(0, 0.9)),
        rmar = transition(2.1, 4.1, times = c(0, 0.9)),

        plotFn = function(pointsSpread, xmin, xmax, rmar) {
          m <- par()$mar
          m[4] <- rmar
          par(mar = m)
          DurgaPlot(d,
                    xaxs = "i", xlim = c(xmin, xmax),
                    points.spread = pointsSpread,
                    ef.size = FALSE,
                    main = "Violin and scattered points")
        }),

  # 7. All defaults, including effect size
  scene(1.4, fps,
        plotFn = function() {
          DurgaPlot(d, main = "Effect size!")
        }),

  # 8. Fade to black
  scene(0.8, fps,
        fade = transition(1, 0, easeIn),

        plotFn = function(fade) {
          DurgaPlot(d, main = "Effect size!")
          usr <- par()$usr
          w <- usr[2] - usr[1]
          h <- usr[4] - usr[3]
          rect(usr[1] - w, usr[3] - h, usr[2] + w, usr[4] + h, col = DurgaTransparent("black", fade), border = NA, xpd = NA)
        }),

  # 9. Fade from black to petunias
  scene(2, fps,
        fade = transition(0, 1, easeOut, times = c(0, 0.4)),

        plotFn = function(fade) {
          DurgaPlot(p, main = "Multiple effect sizes")
          usr <- par()$usr
          w <- usr[2] - usr[1]
          h <- usr[4] - usr[3]
          rect(usr[1] - w, usr[3] - h, usr[2] + w, usr[4] + h, col = DurgaTransparent("black", fade), border = NA, xpd = NA)
        }),

  # 10. Hide effect sizes, animate to make space for confidence brackets
  scene(2.5, fps,
        margin = transition(efMai, nefMai, times = c(0, 0.34)),
        ymin = transition(pymin0, pymin1, times = c(0, 0.34)),
        ymax = transition(pymax0, pymax1, times = c(0, 0.34)),
        brackets = transition(0, 1, step(0.3)),

        plotFn = function(margin, ymin, ymax, brackets) {
          m <- par()$mai
          m[1] <- margin
          par(mai = m)
          pl <- DurgaPlot(p, ef.size = FALSE,
                          yaxs = "i", ylim = c(ymin, ymax),
                          main = "Confidence brackets")
          if (brackets) {
            sign <- sapply(p$group.differences, function(diff) ifelse(diff$bca[5] < 0, -1,
                                                                      ifelse(diff$bca[4] > 0, 1, 0)))
            # Get the larger group from each difference
            largerIdx <- sapply(p$group.differences, function(diff) {
              # If the group difference > 0, the first group is taller
              ifelse(diff$t0 > 0, diff$groupIndices[1], diff$groupIndices[2])
            })
            br.col <- ifelse(sign == 0, "grey80", pl$palette[largerIdx])
            DurgaBrackets(pl, labels = "level CI", lb.cex = 0.8, br.col = br.col)
          }
        }),


  # 11. Logo
  scene(2, fps,

        cexl = transition(0.001, 5, easeIn, times = c(0, .2)),
        cex1 = transition(0.001, 2, easeIn, times = c(.2, .45)),
        cex2 = transition(0.001, 2, easeIn, times = c(.4, .65)),
        cex3 = transition(0.001, 2, easeIn, times = c(.6, .85)),
        cex4 = transition(0.001, 2, easeIn, times = c(.8, 1)),

        plotFn = function(cexl, cex1, cex2, cex3, cex4) {
          par(mar = c(0, 0, 0, 0))
          plot(NULL, xaxs = "i", yaxs = "i", xlim = c(-1, 1), ylim = c(-1, 1), axes = FALSE, xlab = "", ylab = "", asp = 1)
          if (!is.null(logo))
            JPlotRaster(logo, 0, 0, height = 2)
          x <- 0.9
          # Unfortunately fonts don't work with the cairo plotting device
          #windowsFonts(Baskerville = windowsFont("Baskerville Old Face"))
          #family <- "Baskerville"
          family <- "serif"
          text(-1, .75, "Durga", font = 2, cex = cexl, family = family)
          if (cex1 > 0.1) text(x, -0.65, "complex", adj = c(1, 0), font = 2, cex = cex1, family = family)
          if (cex2 > 0.1) text(x, -0.65, " plots", adj = c(0, 0), font = 2, cex = cex2, family = family)
          if (cex3 > 0.1) text(x, -0.8, "made ", adj = c(1, 0), font = 2, cex = cex3, family = family)
          if (cex4 > 0.1) text(x, -0.8, "simple", adj = c(0, 0), font = 2, cex = cex4, family = family)
        })

)

totalFrames <- sum(sapply(scenes, function(s) s$nFrames))
JAnimateGIF(outFile, totalFrames, plotFn = plotScenes(scenes), loop = 1, frameRate = fps)
secs <- totalFrames / fps
cat(sprintf("Video duration %g seconds\n", secs))

