# This script takes the UCI HAR Dataset and
# (1) Merges the training and the test sets to create one data set.
# (2) Extracts only the measurements on the mean and standard deviation for each
#     measurement.
# (3) Uses descriptive activity names to name the activities in the data set
# (4) Appropriately labels the data set with descriptive variable names.
# (5) From the data set in step 4, creates a second, independent tidy data set 
#     with the average of each variable for each activity and each subject.

# ASSUMPTIONS:
# (1) the data has been downloaded and extracted under "UCIHARDataset" folder

require(dplyr); require(tidyr); require(readr); require(stringr)

# Read data -------
# read training measurements (flat table, delimiter = space)
traindata.measurements <- read_table2(file = "UCIHARDataset/train/X_train.txt", 
                                      col_names = FALSE)

# read test measurements (flat table, delimiter = space)
testdata.measurements <- read_table2(file = "UCIHARDataset/test/X_test.txt", 
                                     col_names = FALSE)

# read training subjects (single column)
traindata.subjects <- read_table2(file = "UCIHARDataset/train/subject_train.txt", 
                                  col_names = FALSE)

# read test subjects (single column)
testdata.subjects <- read_table2(file = "UCIHARDataset/test/subject_test.txt", 
                                 col_names = FALSE)

# read training activities (single column)
traindata.activities <- read_table2(file = "UCIHARDataset/train/y_train.txt", 
                                    col_names = FALSE)

# read test activities (single column)
testdata.activities <- read_table2(file = "UCIHARDataset/test/y_test.txt", 
                                   col_names = FALSE)

# assign proper naming for activities
activitylabels <- read_table2(file = "UCIHARDataset/activity_labels.txt", 
                              col_names = FALSE)
testdata.activities <- inner_join(x = testdata.activities, 
                                  y = activitylabels, by = "X1") %>% 
        select(X2)

traindata.activities <- inner_join(x = traindata.activities, 
                                   y = activitylabels, by = "X1") %>% 
        select(X2)
rm(activitylabels)

# read column names (table with delimiter = space, no fixed width)
col.names <- read_table2(file = "UCIHARDataset/features.txt", 
                         col_names = FALSE)

# Modify tables --------
# bind columns on both datasets
traindata <- bind_cols(traindata.subjects, 
                       traindata.activities, 
                       traindata.measurements)
testdata <- bind_cols(testdata.subjects, 
                      testdata.activities, 
                      testdata.measurements)
rm(traindata.measurements, 
   traindata.activities, 
   traindata.subjects, 
   testdata.measurements, 
   testdata.activities, 
   testdata.subjects)

# merge dataframes (train data first)
measurements <- bind_rows(traindata, testdata)
rm(traindata, testdata)

# assign the column labels to the dataframe
names(measurements) <- c("subjects", "activities", col.names %>% pull(X2))
rm(col.names)

# select required columns
measurements.mean.std <- measurements %>% 
        select(subjects, 
               activities, 
               contains("mean()"), 
               contains("std()"))
rm(measurements)

# adjust variable names 
names(measurements.mean.std) <- names(measurements.mean.std) %>% 
   str_replace_all(pattern = "-", replacement = ".") %>% 
   str_remove(pattern = "\\(\\)") %>%
   str_replace_all(pattern = "^t", replacement = "time") %>%
   str_replace_all(pattern = "^f", replacement = "frequency") %>%
   str_replace_all(pattern = "Acc", replacement = "Acceleration")

# reconstruct the labels that include "Magnitude"
for(i in names(measurements.mean.std)){
   if (str_detect(i,"Mag")){
      names(measurements.mean.std)[names(measurements.mean.std) == i] <- i %>%
         str_remove(pattern = "Mag") %>%
         str_c(".Magnitude")
   }
}
rm(i)

# Create second independent data set -------
# grouping data set by subjects and activities and then taking average
tidydataset <- measurements.mean.std %>% 
   group_by(subjects, activities) %>% 
   summarise(across(.fns = mean))