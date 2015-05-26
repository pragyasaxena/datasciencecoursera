##Step wise breakdown of run_Analysis.R

1. Reads the feature list
2. Reads the activity labels list
3. Reads the test_subject, x_test, y_test using read.table() 
4. Column bind the above sets to form the test data set
5. Reads the train_subject, x_train, y_train using read.table() 
6. Column bind the above sets to form the train data set
7. Rowbind testdata and traindata to form a single set of data (tidydataset)
8. Assign the column names for tidydataset as the SubjectID, ActivityID and featurelist imported in Step 1.
9. Create a new column for ActivityDescription using match() from the activity labels read in Step 2.
10. Select the column names with 'mean()' or 'std()' using grep() function which gives the index of these columns.
11. Subset tidydataset using the column indexes found in Step 10 to create dataset 'final'
12. Use dplyr package to group and summarise the average of each column over each combination of activity and subject.

