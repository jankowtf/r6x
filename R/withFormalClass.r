#' @title
#' Define R6 class and buffer formal S4 equivalent
#'
#' @description
#' Takes a regular R6 class definition and does the following things with it:
#' \enumerate{
#'  \item{Evaluate the class definition (main effect)}
#'  \item{Extract and store S3 class graph (i.e. including inheritance structure) in
#'    a special \code{\link[base]{options}} environment. This information can in
#'    turn be processed by \code{\link[r6x]{formalizeClasses}} inside your
#'    package's call to \code{\link[base]{.onLoad}} in order to produce S4
#'    equivalents of your R6 classes}
#' }
#'
#' @param def Actual R6 class definition, i.e. a call to \code{\link[R6]{R6Class}}.
#' @param envir \code{\link{environment}}.
#'    Parent environment for the assignment of the class generator object.
#'    Only relevant if \code{auto_assign = TRUE}.
#' @param auto_assign \code{\link{logical}}.
#'    \code{TRUE}: assign class generator object to an object whose name
#'    corresponds to the class name in \code{envir};
#'    \code{FALSE}: you must make sure that you assign the output of the function
#'    to the desired name.
#' @param r6 \code{\link{logical}}.
#'    \code{TRUE}: include  \code{"R6"} in the S3 class graph in order to
#'      denote that any R6 class inherits from class \code{R6};
#'    \code{FALSE}: only buffer the actual class name.
#'    Setting this to \code{TRUE} makes sense when you plan on defining
#'    S4 methods that should work for \emph{any} R6 method (as opposed to
#'    methods for \emph{specific} R6 classes only).
#' @return Return value of \code{\link[R6]{R6Class}}.
#' @example inst/examples/withFormalClass.r
#' @seealso \code{\link[r6x]{formalizeClasses}}
#' @template author
#' @template references
#' @export
#' @import R6

withFormalClass = function(
  def,
  envir = parent.frame(),
  auto_assign = FALSE,
  r6 = TRUE
) {
  name <- def$classname

  ## Assign //
  if (auto_assign) {
    assign(name, value = def, envir = envir)
  }

  ## Optionize //
  r6x:::optionize(".classes")
  clss <- getOption(".classes")

  ## Formal class //
  # print(def$inherit)
  # print(deparse(def$inherit))
  # print(as.character(def$inherit))
  inherit <- as.character(def$inherit)
  inherit <- inherit[length(inherit)]

  info <- if (!is.null(inherit)) {
    if (!r6) {
      c(name, inherit)
    } else {
      c(name, inherit, "R6")
    }
  } else {
    if (!r6) {
      name
    } else {
      c(name, "R6")
    }
  }
  clss[[name]] <- info
  invisible(def)
}
