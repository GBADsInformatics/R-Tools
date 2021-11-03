source("private_details.R")

print_table <- function(){

 library(DBI)
 library(RPostgres)

 dbname <- "publicData_1"
 host <- "gbadske-database-public-data.cp73fx22weet.ca-central-1.rds.amazonaws.com"
 port <- 5432
 user <- getuser()
 password <- getpass()

 con <- dbConnect(RPostgres::Postgres(), dbname=dbname, host=host, port=port, user=user, password=password)
 list <- dbListTables(con)
 print(list)
 var <- readline(prompt = "Choose a table to print: ")
 print(var)
 var <- paste("SELECT * FROM ", var)
 table <- dbGetQuery(con, var)

 dbDisconnect(con)

 return(table)

}