
# O -----------------------------------------------------------------------

optionize = function(id) {
  opts <- getOption(id)
  if (is.null(opts)) {
    opts <- new.env(parent = emptyenv())
    eval(parse(text = sprintf("options(%s = opts)", id)))
  }
  TRUE
}

