The entire UCI HAR Dataset may not fit on to GitHub.  The full dataset can be found <a href=https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip>here</a>.

run_analysis.R does the following to the UCI HAR Dataset<br>
<ol>
  <li>Merges the training and the test sets to create one data set.</li>
  <li>Extracts only the measurements on the mean and standard deviation for each measurement.</li>
  <li>Uses descriptive activity names to name the activities in the data set</li>
  <li>Appropriately labels the data set with descriptive variable names.</li>
  <li>From the data set in step 4, creates a second, 
  independent tidy data set with the average of each variable for each activity and each subject.</li>
</ol>
Run the script from the same directory as the location of the 'UCI HAR Dataset' directory.
The script requires the <code>dplyr</code> package.<br>

The subject ID's and activities are prepended to the training and test sets, 
which are then merged together in the <code>merged</code> variable.

Means and standard deviations are extracted using a <code>grep</code> on the features vector.<br>

I am not a fan of using only lower case letters in the column names, as it makes distinguishing words more difficult.
As such, PascalCase is used instead.  Hyphens, commas, and empty parentheses are removed, but parentheses with arguments
are left alone, as rewriting them with plain text would be awkward (commas are already replaced by the word 'And').<br>

The final dataset is contained in <code>ans</code>, which is displayed at the end of the script.
