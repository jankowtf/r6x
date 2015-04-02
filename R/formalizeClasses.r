#' @title
#' Create formal S4 equivalents of R6 classes
#'
#' @description
#' Takes the S3 class information buffered in \code{getOption(".classes")} and
#' uses it accordingly for calls to \code{\link[methods]{setOldClass}}.
#'
#' @details
#' The S4 equivalents are assigned to the package's namespace if it is available
#' (i.e. \code{as.environment("package:<package-name>")}). This is definitely
#' the case at the stage when \code{\link[base]{.onLoad}} is calles, hence the
#' call to this function should happen there.
#'
#' @section Recommendation:
#' It seems to be a good advice to set \code{overwrite = TRUE} as this ensures
#' that previously defined S4 equivalents are removed prior to the respective
#' calls to \code{\link[methods]{setOldClass}}. Not doing so seems to have the
#' undesired side effect that
#' \code{getClasses(where = as.environment("package:<package-name>"))} returns
#' \code{character()} for subsequent package loads via
#' \code{\link[devtools]{load_all}} (and thus subsequent calls of
#' \code{\link[base]{.onLoad}}).
#'
#' @param where \code{\link{environment}} or \code{\link{NULL}}.
#'    Environment in which tne S4 equivalents should be defined. If it exists,
#'    this defaults to your packagte's namespace environment. If that does not
#'    exist, it is set to \code{\link[base]{.GlobalEnv}}.
#' @param overwrite \code{\link{logical}}.
#'    \code{TRUE}: ensure previously assigned S4 equivalents are removed from
#'      \code{where} before subsequent calls to
#'      \code{\link[methods]{setOldClass}};
#'    \code{FALSE}: state of classes in \code{where} is not modified before
#'      subsequent calls to \code{\link[methods]{setOldClass}}. See section
#'      \emph{Recommendation}.
#' @param clean_up \code{\link{logical}}.
#'    \code{TRUE}: remove buffered S3 class information in options;
#'    \code{FALSE}: keep buffered S3 class information in options.
#' @return Return value of \code{\link[R6]{R6Class}}.
#' @example inst/examples/formalizeClasses.r
#' @seealso \code{\link[r6x]{withFormalClass}}
#' @template author
#' @template references
#' @export
#' @import R6

formalizeClasses = function(
  where = eval(substitute(as.environment(NAME),
    list(NAME = sprintf("package:%s",
      as.list(read.dcf("DESCRIPTION")[1,])[["Package"]])))),
  overwrite = TRUE,
  clean_up = TRUE
) {
  if (is.null(where)) {
    where <- .GlobalEnv
  }
  id <- ".classes"
  opts <- getOption(id)
  if (!is.null(opts)) {
    clss <- ls(opts, all.names = TRUE)
    if (overwrite) {
      sapply(clss, function(cls) {
        idx <- sapply(cls, isClass, where = where)
        suppressWarnings(try(sapply(cls[idx], removeClass, where = where),
          silent = TRUE))
      })
    }
    sapply(clss, function(cls) {
      suppressWarnings(try(setOldClass(opts[[cls]], where = where),
        silent = TRUE))
    })
    if (clean_up) {
      eval(parse(text = sprintf("options(%s = NULL)", id)))
    }
    TRUE
  } else {
    FALSE
  }
}
