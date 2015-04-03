r6x (0.1)
======

Extensions to the R6 package

## Installation

```
require("devtools")
devtools::install_github("rappster/r6x")
require("r6x")
```

## Formal S4 equivalents of R6 classes

Whenever you define an R6 class, you can also provide the necessary information in order to easily register formal S4 equivalents with a later call to `formalizeClasses()`. Formal S4 equivalents are useful whenever you would like to define/use formal S4 methods that take your R6 classes as signature arguments.

### Class without inheritance

```
## Ensure clean initial state //
if (exists("Test")) {
  rm("Test")
}
exists("Test")
getOption(".classes")

## Define R6 class //
Test <- withFormalClass(
  R6Class(
    classname = "Test",
    portable = TRUE,
    public = list(
      foo = function() "hello world!"
    )
  )
)

## Investigate state after definition //
exists("Test")
Test
ls(getOption(".classes"))
getOption(".classes")$Test
## --> buffered S3 class information that is later used by `formalizeClasses()`
```

### Class with inheritance

```
Test2 <- withFormalClass(
  R6Class(
    classname = "Test2",
    portable = TRUE,
    inherit = Test,
    public = list(
      bar = function() "hello world!"
    )
  )
)

## Inspect buffered S3 class information //
ls(getOption(".classes"))
getOption(".classes")$Test2
## --> S3 inheritance graph
```

## Actually registering formal S4 equivalents

### Stand-alone call

Note:
This example only serves the purpose of illustrating what's going on.
In order for this function to be actually useful when developing own packages, it should be called inside `.onLoad()` (see example below).

```
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
```

### Call inside of `.onLoad()`

Note:
This function should be called in `.onLoad()` as at this stage the package has already been attached and thus a namespace environment has been created.
This environment is the recommended value for the function's `envir` argument (automatically set, you don't need to provide it explicitly)

So this is a template of how your `.onLoad()` function should look like when using this function. Just copy it to a file inside your `R` directory so it is picked up by `devtools::load_all()` or the like:

```
.onAttach <- function(libname, pkgname) {
  formalizeClasses()
}
```


