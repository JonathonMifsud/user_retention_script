require(tidyverse)
require(lubridate)

file <- "retentionreport32.csv" #put file name here if not put in git folder specify path
report_unclean <- read.csv(file, header = FALSE, na.strings=c("","NA"), stringsAsFactors=FALSE) #reading in csv, turning all empty cells to NA 
report_unclean <- report_unclean[-1,] #if the first row isnt column names put a # on the start line above
colnames(report_unclean)[1] <- "user_id" # changing first column to be called "user_id"

# This block is used to add dates to file names
currentdate <- Sys.Date()
clean_retention_report_name <- paste("~/Desktop/clean_retention_report_",currentdate,".csv",sep="")
days_with_charts_per_user_name <- paste("~/Desktop/days_with_charts_per_user_",currentdate,".csv",sep="")
days_with_charts_made_name <- paste("~/Desktop/days_with_charts_made_",currentdate,".csv",sep="")

clean_retention_report <- report_unclean %>%
  gather(key = column, value = date, -user_id) %>%
  select(-column) %>%
  drop_na("date") %>% 
  distinct(user_id, date, .keep_all = TRUE)

################################################################################
#                                 Non-Filtered                                 #              
################################################################################

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

################################################################################
#                                 Date Filtered                                #              
################################################################################


report_filtered  <- clean_retention_report %>%
  mutate(date = lubridate::mdy(date)) %>%
  filter(date >= "2019-9-10" & date <= "2019-9-20")
#YYYY/MM/DD
# first date is the start and second is the end, filter will keep all dates within this

clean_retention_report_name_filtered <- paste("~/Desktop/clean_retention_report_filtered_",currentdate,".csv",sep="")
days_with_charts_per_user_name_filtered <- paste("~/Desktop/days_with_charts_per_user_filtered_",currentdate,".csv",sep="")
days_with_charts_made_name_filtered <- paste("~/Desktop/days_with_charts_made_filtered_",currentdate,".csv",sep="")


report_filtered %>%
  write.csv(clean_retention_report_name_filtered, row.names=FALSE) #if you get errors here check that you dont a file with the same name open

days_with_charts_per_user_filtered <- report_filtered %>%
  count(user_id, sort = TRUE, name = "count")

days_with_charts_per_user_filtered %>% 
  write.csv(days_with_charts_per_user_name_filtered, row.names=FALSE)

days_with_charts_made_filtered <- days_with_charts_per_user_filtered %>% 
  count(count, name = "frequency")

days_with_charts_made_filtered %>% 
  write.csv(days_with_charts_made_name_filtered, row.names=FALSE)

  
  
