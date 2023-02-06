# Set of functions to aid in creating pleasing animations
#
# An animation is constructed by building a list of scenes.  A scene
# is a parameterised plotting function, together with set of
# transitions. A transition defines how the values of a parameter
# change over time during the scene.
#
# Transitions make use of bezier curves for flexible smooth
# transitions.  Transitions are largely inspired by CSS animations.


# See https://cubic-bezier.com/
library(bezier)

# ================================================================================
#### Private functions ####

# Interpolates a single segment of points
interpValues <- function(from, to, nPoints, timing) {
  # Start with timing values
  f <- timing(nPoints)
  # Interpolate
  from + (to - from) * f
}

interpTrans <- function(trans, nFrames) {
  # Convert times to frame numbers
  keyFrames <- round(trans$times * (nFrames - 1) + 1)

  # Intialise with from values
  vals <- rep.int(trans$from, nFrames)

  # Fill in transition
  change <- interpValues(trans$from, trans$to, keyFrames[2] - keyFrames[1] + 1, trans$timing)

  vals[seq(keyFrames[1], keyFrames[2], 1)] <- change

  # Extend last value
  if (keyFrames[2] != nFrames) {
    vals[seq(keyFrames[2], nFrames, 1)] <- rep.int(trans$to, nFrames - keyFrames[2] + 1)
  }

  vals
}

timingFunctionBezier <- function(p0, p1, p2, p3, nPoints) {
  # Cubic bezier curve
  t <- seq(0, 1, length.out = 40)
  p <- matrix(c(0, 0,  p0, p1,  p2, p3,  1, 1), ncol = 2, byrow = TRUE)
  b <- bezier::bezier(t, p)
  # Linearly interpolate to get points equally spaced along the x-axis
  xout <- seq(0, 1, length.out = nPoints)
  y <- approx(b, xout = xout)

  if (F) {
    plot(b)
    lines(y)
  }

  y$y
}

timingFunctionStep <- function(stepTime, nPoints) {
  # Convert time to frame number
  stepFrame <- round(stepTime * nPoints)
  # Get value for each frame
  ifelse(seq_len(nPoints) < stepFrame, 0, 1)
}

# ================================================================================
#### Public functions ####

# Timing functions
# Invoked by name only (no additional parameters are required)
ease <- function(nPoints) timingFunctionBezier(0.25, 0.1, 0.25, 1, nPoints)
linear <- function(nPoints) timingFunctionBezier(0, 0, 1, 1, nPoints)
easeIn <- function(nPoints) timingFunctionBezier(0.42, 0, 1, 1, nPoints)
easeOut <- function(nPoints) timingFunctionBezier(0, 0, 0.58, 1, nPoints)
easeInOut <- function(nPoints) timingFunctionBezier(0.42, 0, 0.58, 1, nPoints)
bounce <- function(nPoints) timingFunctionBezier(0.175, 0.885, 0.32, 1.275, nPoints)
# Invoked by function call (additional parameters required)
bezier <- function(p0, p1, p2, p3) function(nPoints) timingFunctionBezier(p0, p1, p2, p3, nPoints)
step <- function(time) function(nPoints) timingFunctionStep(time, nPoints)

# Construct a transition. A transition defines how a single parameter
# values changes throughout a scene.
#
# @param from Initial parameter value.
# @param to Final parameter value.
# @param timing Animation timing function, such as `easeIn`, `bounce`.
# @param times Time period (start, stop) over which the transition
#        occurs, as a proportion of the scene time. A time of 0
#        indicates the first frame in the scene, while 1 is the last
#        frame. If the transition does not start at the beginning of
#        the frame, for all earlier frames the parameter will have
#        values `from`. Similarly, the parameter will have value `to`
#        for any gframes after the last transition frame.
transition <- function(from, to, timing = ease, times = c(0, 1)) {
  list(from = from, to = to, times = times, timing = timing)
}

# Construct a scene. A scene consists of some metadata (duration, frame rate), a
# set of animation transitions and a plotting function.
#
# @param duration Scene duration in seconds.
# @param fps Frame rate (frames per second).
# @param ... Ordered set of transitions. Transitions may be named for
#   documentation purposes, but the names are not used.
# @param plotFn The parameterised plotting function. Called with one positional
#   argument for each transition.
#
scene <- function(duration, fps, ..., plotFn) {
  nFrames <- round(duration * fps)
  transitions <- list(...)
  args <- lapply(transitions, interpTrans, nFrames)
  # Convert to data frame
  args <- do.call(cbind, args)

  # Return a function that draws 1 frame
  list(nFrames = nFrames,
       fun = function(frame) {
         do.call(plotFn, as.list(args[frame, ]))
       })
}

# Function to combine a list of scenes, and return a function that plots a
# single frame from the appropriate scene
#
# @param scenes A list of scene objects, each one created by calling the
#   \code{\link{scene}} constructor.
#
# @return A function that accepts a single argument, a frame number, and plots
#   the appropriate frame from the animation. The function is intended to be
#   used as the \code{plotFn} argument to \code{\link{JAnimateGIF}}.
plotScenes <- function(scenes) {

  function(frame) {
    # Which scene is this frame part of?
    startFrame <- 1
    for (s in scenes) {
      if (frame >= startFrame && frame < startFrame + s$nFrames) {
        # Plot this frame
        s$fun(frame - startFrame + 1)
        return(NULL)
      }

      if (frame < startFrame)
        stop(sprintf("Internal error: couldn't find scene that starts at frame %d", frame))

      startFrame <- startFrame + s$nFrames
    }
  }
}

