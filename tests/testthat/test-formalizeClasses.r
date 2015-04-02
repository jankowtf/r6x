require(testthat)

test_that("formalizeClasses/stand-alone", {

  Test <- withFormalClass(
    R6Class(
      classname = "Test",
      portable = TRUE,
      public = list(
        foo = function() "hello world!"
      )
    )
  )
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

  expect_false(isClass("Test"))
  expect_false(isClass("Test2"))
  expect_error(getClass("Test"))
  expect_error(getClass("Test2"))

  expect_true(formalizeClasses())

  expect_true(isClass("Test"))
  expect_true(isClass("Test2"))
  expect_is(getClass("Test"), "classRepresentation")
  expect_is(getClass("Test2"), "classRepresentation")

  expect_null(getOption(".classes"))

  expect_true(removeClass("Test"))
  expect_true(removeClass("Test2"))
  expect_false(isClass("Test"))
  expect_false(isClass("Test2"))

})
