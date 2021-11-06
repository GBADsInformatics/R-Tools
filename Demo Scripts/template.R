source("private_details.R")
source("rds_functions.R")

template <- function(){
#
# Create connection and cursor
#
    dbname <- "publicData_1"
    host <- "gbadske-database-public-data.cp73fx22weet.ca-central-1.rds.amazonaws.com"
    port <- 5432
    user <- getuser()
    password <- getpass()
    con <- dbConnect(RPostgres::Postgres(), dbname=dbname, host=host, port=port, user=user, password=password)

    tables <- displayTables(con)
    return(tables)
#
# Close connection
#
    dbDisconnect(con)
}