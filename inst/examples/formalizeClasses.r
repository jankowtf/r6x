##------------------------------------------------------------------------------
## Stand-alone call
##------------------------------------------------------------------------------

##########
## NOTE ##
##########

## This example only serves the purpose of illustrating what's going on.
## In order for this function to be actually useful when developing own
## packages, it should be called inside `.onLoad()` (see example below)

## Preliminaries //
## Run example of `?withFormalClass`

## Buffered S3 class information //
clss <- getOption(".classes")
ls(clss)
lapply(ls(clss), function(ii) clss[[ii]])

## Note //
## Currently, there are no formal S4 equivalents for our R6 classes yet:
isClass("Test")
isClass("Test2")
try(getClass("Test"))
try(getClass("Test2"))

## Formalize classes //
formalizeClasses()

## Note //
## 1) Formal S4 equivalents have been created:
isClass("Test")
isClass("Test2")
try(getClass("Test"))
try(getClass("Test2"))
## --> note how the S3 inheritance information has been preserved

## 2) The buffered information has been deleted due to `clean_up = TRUE`:
getOption(".classes")

##------------------------------------------------------------------------------
## Call inside of `.onLoad()`
##------------------------------------------------------------------------------

##########
## NOTE ##
##########

## This function should be called in `.onLoad()` as at this stage the package
## has already been attached and thus a namespace environment has been created.
## This environment is the recommended value for the function's `envir`
## argument (automatically set, you don't need to provide it explicitly)

## So this is a template of how your `.onLoad()` function should look like
## when using this function. Just copy it to a file inside your `R` directory
## so it is picked up by `devtools::load_all()` or the like:

.onAttach <- function(libname, pkgname) {
  formalizeClasses()
}



