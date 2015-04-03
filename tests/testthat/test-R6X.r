require(testthat)

test_that("R6X", {

  ## Define example class that inherits from `R6X` //
  Test <- R6::R6Class(
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
  target <- c(
    ".error", ".getComponentClasses", ".getComponentNames",
    ".getField", ".getFieldNames", ".getMethodNames",
    ".message", ".setField", ".warning",
    "bar", "field_1", "field_2",
    "field_3", "field_4", "field_5",
    "field_6", "field_7", "field_8",
    "foo"
  )
  expect_true(all(target %in% inst$.getComponentNames()))

  target <- c(
    "function", "function", "function", "function",
    "function", "function", "function", "function",
    "function", "function", "character", "logical",
    "list", "data.frame", "numeric", "integer",
    "NULL", "logical", "function"
  )
  expect_true(all(target %in% inst$.getComponentClasses()))

  target <- c(
    "field_1", "field_2", "field_3", "field_4", "field_5", "field_6",
    "field_7", "field_8"
  )
  expect_true(all(target %in% inst$.getFieldNames()))

  target <- c(
    ".error", ".getComponentClasses", ".getComponentNames",
    ".getField", ".getFieldNames", ".getMethodNames",
    ".message", ".setField", ".warning",
    "bar", "foo"
  )
  expect_true(all(target %in% inst$.getMethodNames()))

  expect_message(inst$.message("Hello world!"))
  expect_message(inst$.message("Hello world!", id = "abc"))
  expect_warning(inst$.warning("Hello world!"))
  expect_warning(inst$.warning("Hello world!", id = "abc"))
  expect_error(inst$.error("Hello world!"))
  expect_error(inst$.error("Hello world!", id = "abc"))

  expect_identical(inst$.getField("field_1"), inst$field_1)
  expect_null(inst$.getField("field_xyz"))
  expect_message(inst$.getField("field_xyz", strict = 1))
  expect_warning(inst$.getField("field_xyz", strict = 2))
  expect_error(inst$.getField("field_xyz", strict = 3))

  expect_error(inst$.setField("field_1", value = NA, strict = 3))
  expect_warning(inst$.setField("field_1", value = NA, strict = 2))
  ## --> setting NOT blocked, so it went through with a warning:
  expect_identical(inst$.getField("field_1"), NA)
  expect_message(inst$.setField("field_1", value = letters, strict = 1))

})
