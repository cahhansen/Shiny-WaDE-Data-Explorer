context("Parsing Tests")

test_that("Example Works", {
  
  expect_error(get_wade_data("borcked"),
               "Does not appear to be a URL and matching file not found.")
  
  test_df <- get_wade_data("data/UT_sample.xml")
  
  expect_named(test_df, c("Sector", "SourceType", "Amount"))
  
  expect_type(test_df$Amount, "double")
  expect_type(test_df$Sector, "character")
  
})

test_that("usgs_data", {
  
  expect_equal_to_reference(get_wade_data("data/USGS_sample.xml"),
                            "data/test_usgs_get_wade_data.rds")

})