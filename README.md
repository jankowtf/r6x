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

Defining your R6 classes with this function instead of `R6Class()` ensures the buffering of information that is required in order to register formal S4 equivalents. This information is picked up and processed by `formalizeClasses()` which carries out the actual class registration. 

Having formal S4 equivalents for your R6 classes is useful whenever you would like to use instances of those R6 classes as signature arguments of S4 methods.

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

## R6X - a baselayer class for your R6 classes

Class `R6X` can be seen as a baselayer class that offers some basic methods that - at least I - seem to often need when working with R6 classes.

Define example class that inherits from `R6X`:

```
require(R6)
Test <- R6Class(
  classname = "Test",
  inherit = R6X,
  public = list(
    field_1 = letters,
    field_2 = TRUE,
    field_3 = list(a = 1, b = 2),
    field_4 = data.frame(a = 1:3, b = 1:3),
    field_5 = 1.5,
    field_6 = as.integer(1),
    field_7 = NULL,
    field_8 = NA,
    foo = function() {
      super$.message("My message", id = "foo")
      "hello"
    },
    bar = function() {
      super$.warning("My warning", id = "bar")
      "world!"
    }
  )
)
```

Instantiate:

```
inst <- Test$new()
```

Investigate class methods:

```
inst$.getComponentNames()
inst$.getComponentClasses()

inst$.getFieldNames()
inst$.getMethodNames()

inst$.message("Hello world!")
inst$.message("Hello world!", id = "abc")
inst$.warning("Hello world!")
inst$.warning("Hello world!", id = "abc")
inst$.error("Hello world!")
inst$.error("Hello world!", id = "abc")

inst$.getField("field_1")
inst$.getField("field_xyz")
inst$.getField("field_xyz", strict = 1)
inst$.getField("field_xyz", strict = 2)
inst$.getField("field_xyz", strict = 3)

inst$.setField("field_1", value = NA, strict = 3)
inst$.setField("field_1", value = NA, strict = 2)
## --> setting NOT blocked, so it went through with a warning:
inst$.getField("field_1")
inst$.setField("field_1", value = letters, strict = 1)
```

