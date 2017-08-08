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

test_that("wyoming_app_url", {
  url <- paste0("http://www.westernstateswater.org/Wyoming/WADE/v0.2/GetSummary/GetSummary.php?",
                "loctype=REPORTUNIT&loctxt=1&orgid=WYWDC&reportid=2014&datatype=USE")
  test_df <- get_wade_data(url)
  expect_equal(nrow(test_df), 5)
}) 

test_that("CA Sample Works", {
  
  # url <- paste0("http://wade.sdsc.edu/WADE/v0.2/GetSummary/GetSummary.php?",
  #               "loctype=REPORTUNIT&loctxt=DAU06435&orgid=CA-DWR&reportid=2010&datatype=SUPPLY")
  url <- "data/CA_sample.xml"  
  expect_equal_to_reference(get_wade_data(url),"data/test_CA_get_wade_data.rds")
  
})
