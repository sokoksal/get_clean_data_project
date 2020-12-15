# get_clean_data_project
Week 4 course project: getting and cleaning data

### Assumptions

* The data has been downloaded and extracted under "UCIHARDataset" folder within the project folder.

### Steps to prpepare data
This script takes the UCI HAR Dataset and

1. Merges the training and the test sets to create one data set.
    i) read training and testing raw data
    ii) read the subjects the activities and the activity labels
    iii) replace the codes with the readable names
    iv) read the column names
    v) bind tables - first columns then rows
    vi) apply column names 
    vii) remove the unnecessary objects to free the memory
2. Extracts only the measurements on the mean and standard deviation for each measurement.
3. Uses descriptive activity names to name the activities in the data set
4. Appropriately labels the data set with descriptive variable names.
    i) structure the column names as three blocks -> (variable name without abbreviations).(std|mean).(X|Y|Z|Magnitude)
5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

### The tidy data set

The output at step 4 is already a tidy data set:

1. each column is a variable.
2. each row is an observation.
3. the columns are easily understandable.

Therefore, at step 5, the script just gets the averages of the variables per the groups at subject and activity levels.

*Please refer to the code book for further information on the variables.*