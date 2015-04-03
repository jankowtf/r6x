#' @title
#' Class: R6X
#'
#' @description
#' Base layer class for inheritance providing a number of methods that
#' are often required in the context of using R6 classes.
#'
#' @section Methods:
#' \describe{
#'  \item{\code{.getComponentNames()}: } {
#'    List the names of all components (regardless if field or method)
#'  }
#'  \item{\code{.getComponentClasses()}: } {
#'    List the classes of all components (regardless if field or method)
#'  }
#'  \item{\code{.getFieldNames()}} {
#'    Returns the names of all fields that are not functions (i.e. methods)
#'  }
#'  \item{\code{.getMethodNames()}} {
#'    Returns the names of all methods
#'  }
#'  \item{\code{.getField(name, check, strict)}} {
#'    Internal getter method with validation (field name) with different
#'    strictness levels (argument \code{strict}).
#'  }
#'  \item{\code{.setField(name, value, check, strict)}} {
#'    Internal getter method with validation (field name and value class)
#'    with different strictness levels (argument \code{strict}).
#'  }
#'  \item{\code{.message(msg, id)}} {
#'    Signals the information in \code{msg} as a \code{\link[base]{message}}.
#'    Argument \code{id} can be used to include more precise information
#'    in the message prefix
#'  }
#'  \item{\code{.warning(msg, id)}} {
#'    Signals the information in \code{msg} as a \code{\link[base]{warning}}.
#'    Argument \code{id} can be used to include more precise information
#'    in the message prefix
#'  }
#'  \item{\code{.error(msg, id)}} {
#'    Signals the information in \code{msg} as an error as produced by
#'    \code{\link[base]{stop}}.
#'    Argument \code{id} can be used to include more precise information
#'    in the message prefix
#'  }
#' }
#'
#' @format An \code{\link{R6Class}} generator object
#' @docType class
#' @example inst/examples/R6X.r
#' @export
#' @import R6

R6X <- R6Class(
  classname = "R6X",
  portable = TRUE,
  public = list(
    .error = function(
      msg = character(),
      id = character()
    ) {
      msg <- private$.composeMessage(msg = msg, id = id)
      stop(msg$msg, call. = FALSE)
    },
    .getComponentNames = function(hidden = TRUE) {
      ls(self, all.names = TRUE)
    },
    .getComponentClasses = function(
      comps = self$.getComponentNames()
    ) {
      sapply(comps, function(ii) class(self[[ii]]))
    },
    .getMethodNames = function(
      clss = self$.getComponentClasses()
    ) {
      names(clss)[clss == "function"]
    },
    .getFieldNames = function(
      clss = self$.getComponentClasses()
    ) {
      names(clss)[clss != "function"]
    },
    .message = function(
      msg = character(),
      id = character()
    ) {
      msg <- private$.composeMessage(msg = msg, id = id)
      message(msg$msg)
    },
    .warning = function(
      msg = character(),
      id = character()
    ) {
      msg <- private$.composeMessage(msg = msg, id = id)
      warning(msg$msg, call. = FALSE)
    },
    .getField = function(name, check = TRUE, strict = 0:3,
      call. = ".getField()") {
      if (check) {
        private$.validateFieldName(name = name, strict = strict, call. = call.)
      }
      self[[name]]
    },
    .setField = function(name, value, check = TRUE, strict = 0:3,
      call. = ".setField()") {
      if (check) {
        call. <- deparse(sys.call())
        # call. <- gsub(".*\\$", "$", call.)
        call. <- gsub(".*\\$", "", call.)
        private$.validateFieldName(name = name, strict = strict, call. = call.)
        private$.validateFielClass(name = name, value = value,
          strict = strict, call. = call.)
      }
      self[[name]] <- value
    }
  ),
  private = list(
    .composeMessage = function(msg, id) {
      if (length(msg) > 1) {
        msg <- paste(msg, collapse = "\n")
      }
      id <- if (length(id)) {
        call. <- FALSE
        sprintf(":%s", id)
      } else {
        call. <- FALSE
        ""
      }
      list(
        msg = paste0(Sys.time(), ":", Sys.getpid(), id, "> ", msg),
        call. = call.
      )
    },
    .validateFielClass = function(name, value, strict = 0:3, call. = NULL) {
      strict <- as.numeric(match.arg(as.character(strict), as.character(0:3)))
      field_class <- class(self$.getField(name, check = FALSE))
      value_class <- class(value)
      idx <- inherits(value, field_class)
      class <- class(self)[1]
      id <- if (is.null(call.)) class else sprintf("%s:%s", class, call.)
      # print(idx)
      # print(field_class)
      # print(value_class)
      if (!idx) {
        if (strict == 0) {
        } else if (strict == 1) {
          self$.message(msg = sprintf("Invalid class: '%s' (expected: '%s')",
            paste(value_class, collapse = ", "), field_class), id = id)
        } else if (strict == 2) {
          self$.warning(msg = sprintf("Invalid class: '%s' (expected: '%s')",
            paste(value_class, collapse = ", "), field_class), id = id)
          TRUE
        } else if (strict == 3) {
          self$.error(msg = sprintf("Invalid class: '%s' (expected: '%s')",
            paste(value_class, collapse = ", "), field_class), id = id)
        } else {
          self$.error(msg = sprintf("Invalid value for `strict`: '%s'", strict),
            id = id)
        }
      }
      idx
    },
    .validateFieldName = function(name, strict = 0:3, call. = NULL) {
      strict <- as.numeric(match.arg(as.character(strict), as.character(0:3)))
      idx <- name %in% self$.getFieldNames()
      class <- class(self)[1]
      id <- if (is.null(call.)) class else sprintf("%s:%s", class, call.)
      if (!idx) {
        if (strict == 0) {
        } else if (strict == 1) {
          self$.message(msg = sprintf("No such field: '%s'", name), id = id)
        } else if (strict == 2) {
          self$.warning(msg = sprintf("No such field: '%s'", name), id = id)
          TRUE
        } else if (strict == 3) {
          self$.error(msg = sprintf("No such field: '%s'", name), id = id)
        } else {
          self$.error(msg = sprintf("Invalid value for `strict`: '%s'", strict),
            id = id)
        }
      }
      idx
    }
  )
)
