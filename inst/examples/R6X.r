## Define example class that inherits from `R6X` //
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

## Instantiate //
inst <- Test$new()

## Inherited methods //
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
