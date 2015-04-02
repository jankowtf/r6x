##------------------------------------------------------------------------------
## Class without inheritance
##------------------------------------------------------------------------------

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

## Auto-assign //
rm(Test)
withFormalClass(
  R6Class(
    classname = "Test",
    portable = TRUE,
    public = list(
      foo = function() "hello world!"
    )
  ),
  auto_assign = TRUE
)
## --> note that the class generator object is automaticall assigned to `Test`
exists("Test")
Test

##------------------------------------------------------------------------------
## Class with inheritance
##------------------------------------------------------------------------------

Test2 <- withFormalClass(
  R6Class(
    classname = "Test2",
    portable = TRUE,
    inherit = r6x::Test,
    public = list(
      bar = function() "hello world!"
    )
  )
)

## Inspect buffered S3 class information //
ls(getOption(".classes"))
getOption(".classes")$Test2
## --> S3 inheritance graph
