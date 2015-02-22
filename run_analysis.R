#loading data
f <- read.table("./features.txt") #feature description

test <- read.table("./X_test.txt") #test data
test_s <- read.table("./subject_test.txt") #test subjects description
test_act <- read.table("./y_test.txt") #test activity description

train <- read.table("./X_train.txt") #train data
train_s <- read.table("./subject_train.txt") #train subjects description
train_act <- read.table("./y_train.txt") #train activity description

act_labels <- read.table("./activity_labels.txt") #activity labels

#merging data
test_comp <- cbind(test_s, test_act, test)
train_comp <- cbind(train_s, train_act, train)

db <- rbind(test_comp, train_comp)

#activity labels
db[,2]<-factor(db[,2],levels=act_labels$V1,labels=act_labels$V2)

# variable labels
names(db)<-c("subject","activity",as.character(f[,2]))

#extracting means and standard deviation
n<-grepl(".*mean..$|.*std..$|.*mean..-.*|.*std..-.*|subject|activity",names(db))
dbtidy<-db[,n]


#new data set with average of each variable
new_db_average<-data.frame(t(sapply(split(dbtidy,list(dbtidy$activity, dbtidy$subject)), function(x) colMeans(x[,3:68]))))

#adding row names as a new variable
new_db_average<-cbind(row.names(new_db_average),new_db_average)
names(new_db_average)<-c("activity_subject", names(new_db_average[2:67]))

#writing data set to a file
write.table(new_db_average, "./newdata.txt", row.names= FALSE)