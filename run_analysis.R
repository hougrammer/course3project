# Run script from the same directory where 'UCI HAR Dataset/' is located.

require(dplyr)

LOAD_DATA = TRUE # set to false to save time if data is alread loaded

if (LOAD_DATA) {
    rawfeatures = unlist(read.table('UCI HAR Dataset/features.txt', header = FALSE, stringsAsFactors = FALSE)[,2])
    labels = unlist(read.table('UCI HAR Dataset/activity_labels.txt', header = FALSE)[,2])
    
    xtrain = as_tibble(read.table('UCI HAR Dataset/train/X_train.txt', header = FALSE))
    ytrain = as_tibble(read.table('UCI HAR Dataset/train/Y_train.txt', header = FALSE))
    subtrain = as_tibble(read.table('UCI HAR Dataset/train/subject_train.txt', header = FALSE))
    xtest = as_tibble(read.table('UCI HAR Dataset/test/X_test.txt', header = FALSE))
    ytest = as_tibble(read.table('UCI HAR Dataset/test/Y_test.txt', header = FALSE))
    subtest = as_tibble(read.table('UCI HAR Dataset/test/subject_test.txt', header = FALSE))
}

# Appropriately labels the data set with descriptive variable names.
# I don't like the convention of using only lower case as specified in the video,
# as it makes it too hard to distinguish between words.
# Instead PascalCase is used.
# Hyphens and empty parenthesese are removed, as they do not offer any information.
# Parentheses with arguments are left unmodified for clarity.
features = sapply(strsplit(rawfeatures, '-'), function(x){
    for (i in 1:length(x)) 
        substr(x[i], 1, 1) = toupper(substr(x[i], 1, 1))
    x = gsub('\\()', '', x)
    x = gsub(',', 'And', x)
    paste(x, sep = '', collapse = '')
})

# The original author has an extra right parenthesis on feature 556.
features[556] = 'Angle(tBodyAccJerkMean,gravityMean)'

names(xtrain) = features
names(xtest) = features
names(ytrain) = 'Activity'
names(ytest) = 'Activity'
names(subtrain) = 'Subject'
names(subtest) = 'Subject'

# Extracts only the measurements on the mean and standard deviation for each measurement.
meanStdCols = grep('Mean|Std', features)
xtrain = xtrain[meanStdCols]
xtest = xtest[meanStdCols]

# Merges the training and the test sets to create one data set.
train = as_tibble(cbind(subtrain, ytrain, xtrain))
test = as_tibble(cbind(subtest, ytest, xtest))
merged = rbind(train, test)

# Uses descriptive activity names to name the activities in the data set.
merged = merged %>% 
    mutate(Activity = labels[Activity]) %>%
    group_by(Subject, Activity)

# From the data set in step 4, creates a second, independent tidy data set 
# with the average of each variable for each activity and each subject.
ans = summarise_all(merged, mean)
View(ans)