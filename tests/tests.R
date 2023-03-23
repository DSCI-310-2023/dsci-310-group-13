source("/home/rstudio/R/functions.R")

youtube_col_names <- c("Video ID", "uploader", "age", 'category','length',
                       'views','rate','ratings','comments','related IDs')
#Test read_raw_data() 
# Load in May 5th 2007 data
table0007 <- read_raw_data("/home/rstudio/data/0007.txt")
table0107 <- read_raw_data("/home/rstudio/data/0107.txt")
table0207 <- read_raw_data("/home/rstudio/data/0207.txt")
table0307 <- read_raw_data("/home/rstudio/data/0307.txt")

# Load in May 4th 2008 data
table0008 <- read_raw_data("/home/rstudio/data/0008.txt")
table0108 <- read_raw_data("/home/rstudio/data/0108.txt")
table0208 <- read_raw_data("/home/rstudio/data/0208.txt")
table0308 <- read_raw_data("/home/rstudio/data/0308.txt")

#expect the number of rows and columns to be consistent with original data
testthat::expect_equal(nrow(table0007), 227)
testthat::expect_equal(ncol(table0007), 29)

testthat::expect_error(read_raw_data(""),"Please look at the data folder and provide a valid input!")
testthat::expect_error(read_raw_data("333"),"Please look at the data folder and provide a valid input!")

testthat::expect_equal(nrow(table0308), 58187)
testthat::expect_equal(ncol(table0308), 29)


#Test bind_tables() 
data2007_test <- bind_tables(table0007,table0107,table0207, table0307)
colnames(data2007_test) <- youtube_col_names

data2008_test <- bind_tables(table0008,table0108,table0208, table0308)
colnames(data2008_test) <- youtube_col_names

#Expect the number of rows of the combined table is equal to the number of 
#rows of the tables added together
testthat::expect_equal(nrow(data2007_test), 
                       nrow(na.omit(table0007))+nrow(na.omit(table0107))+ 
                         nrow(na.omit(table0207)) + nrow(na.omit(table0307)))


testthat::expect_equal(nrow(data2008_test), 
                       nrow(na.omit(table0008))+ nrow(na.omit(table0108))+ 
                         nrow(na.omit(table0208)) + nrow(na.omit(table0308)))

rm("table0007","table0107", "table0207","table0307",
   "table0008","table0108", "table0208","table0308" )


#Testing wrangling_data()
data2007 = wrangling_data(data2007_test)
data2008 = wrangling_data(data2008_test)
#The first and second test expects that the age in the first and last row 
#of the wrangled data is the same 
testthat::expect_equal(select(data2007, c('age'))[1,], 
                       select(data2007_test, c('age'))[1,])

testthat::expect_equal(select(data2007, c('age'))[62101,], 
                       select(data2007_test, c('age'))[62101,])

#The third and fourth test expects that the comments in the first and last row 
#of the wrangled data is the same 
testthat::expect_equal(select(data2008, c('comments'))[1,], 
                       select(data2008_test, c('comments'))[1,])

testthat::expect_equal(select(data2008, c('comments'))[62101,], 
                       select(data2008_test, c('comments'))[62101,])

#The fifth and sixth test expects errors because the input is not a valid data frame
testthat::expect_error(wrangling_data("sad"),"Please have a valid dataframe as input!")
testthat::expect_error(wrangling_data(3),"Please have a valid dataframe as input!")

#The seventh and eighth test expects the number of columns is 7 which only contains
#the required features
testthat::expect_equal(ncol(data2007), 7)
testthat::expect_equal(ncol(data2008), 7)



#Testing fit_regression()
# Selecting variables for reduced model
datareduced <- data2007 |>  select(c(views,age,ratings,comments))

# Split data into training and testing set
split <- initial_split(datareduced, prop = 3/4, strata = views)
train <- training(split)
test <- testing(split)

# Fit the regression model
lm_spec <- linear_reg() |> set_engine('lm') |> set_mode('regression')

lm_recipe <- recipe(views~., data = train)

lm_fit <- workflow() |> add_recipe(lm_recipe) |> add_model(lm_spec) |> fit(data = train)

# The results our model performed
lm_test_results <- lm_fit |> predict(test) |> bind_cols(test) |> metrics(truth = views, estimate = .pred)

#test if parameter is a dataframe
testthat::expect_error(fit_regression(c(1:5)))
testthat::expect_error(fit_regression("hello"))

#test that the model is formed properly:
# coefficients
testthat::expect_equal(as.numeric(tidy(lm_fit)$estimate[1]), as.numeric(lm(views~.,train)$coefficients[1]))
# rmse
testthat::expect_equal(lm_test_results$.estimate[1],
                       sqrt(mean((test$views - predict(lm_fit, test)$.pred)^2)))


#remove all temporary variables 
rm("datareduced", "split", "train", "test", "lm_spec", "lm_recipe", "lm_fit",
   "lm_test_results")
rm("data2007", "data2008","data2007_test","data2008_test", "youtube_col_names")
