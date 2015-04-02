require(testthat)

test_that("withFormalClass/explicit assign", {

  expect_is(
    Test <- withFormalClass(
      R6Class(
        classname = "Test",
        portable = TRUE,
        public = list(
          foo = function() "hello world!"
        )
      )
    ), "R6ClassGenerator"
  )

  expect_true(exists("Test"))
  expect_true("Test" %in% ls(getOption(".classes")))
  expect_identical(getOption(".classes")$Test, c("Test", "R6"))

})

test_that("withFormalClass/no r6", {

  Test <- withFormalClass(
    R6Class(
      classname = "Test",
      portable = TRUE,
      public = list(
        foo = function() "hello world!"
      )
    ),
    r6 = FALSE
  )

  expect_identical(getOption(".classes")$Test, "Test")

})

test_that("withFormalClass/auto assign", {

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

  expect_true(exists("Test"))
  expect_true("Test" %in% ls(getOption(".classes")))
  expect_identical(getOption(".classes")$Test, c("Test", "R6"))

})

test_that("withFormalClass/inheritance", {

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

  expect_true(exists("Test2"))
  expect_true("Test2" %in% ls(getOption(".classes")))
  expect_identical(getOption(".classes")$Test2, c("Test2", "Test", "R6"))

})
