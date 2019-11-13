require(tidyverse)

file <- "retentionreport32.csv" #put file name here if not put in git folder specify path
report_unclean <- read.csv(file, header = FALSE, na.strings=c("","NA"), stringsAsFactors=FALSE) #reading in csv, turning all empty cells to NA 
report_unclean <- report_unclean[-1,] #if the first row isnt column names put a # on the start line above
colnames(report_unclean)[1] <- "user_id" # changing first column to be called "user_id"

# This block is used to add dates to file names
currentdate <- Sys.Date()
clean_retention_report_name <- paste("$HOME/Desktop/clean_retention_report_",currentdate,".csv",sep="")
days_with_charts_per_user_name <- paste("$HOME/Desktop/days_with_charts_per_user_",currentdate,".csv",sep="")
days_with_charts_made_name <- paste("$HOME/Desktop/days_with_charts_made_",currentdate,".csv",sep="")


clean_retention_report <- report_unclean %>%
  gather(key = column, value = date, -user_id) %>%
  select(-column) %>%
  drop_na("date") %>% 
  distinct(user_id, date, .keep_all = TRUE)

clean_retention_report %>%
  write.csv(clean_retention_report_name, row.names=FALSE) #if you get errors here check that you dont a file with the same name open

days_with_charts_per_user <- clean_retention_report %>%
  count(user_id, sort = TRUE, name = "count")

days_with_charts_per_user %>% 
  write.csv(days_with_charts_per_user_name, row.names=FALSE)

days_with_charts_made <- days_with_charts_per_user %>% 
  count(count, name = "frequency")

days_with_charts_made %>% 
  write.csv(days_with_charts_made_name, row.names=FALSE)
