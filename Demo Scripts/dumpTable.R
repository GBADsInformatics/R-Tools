#
#    Dump the contents of a table 
#
#    Author: Rehan Nagoor
#
#    Date of last update: October 24, 2021
#
source("private_details.R")
source("rds_functions.R")

dumpTable <- function(table_name){
#
# Create connection and cursor
#
    dbname <- "publicData_1"
    host <- "gbadske-database-public-data.cp73fx22weet.ca-central-1.rds.amazonaws.com"
    port <- 5432
    user <- getuser()
    password <- getpass()
    con <- dbConnect(RPostgres::Postgres(), dbname=dbname, host=host, port=port, user=user, password=password)

    if (checkTable(con, table_name) == 0) {
        return(sprintf("%s does not exist as a table in GBADs public database", table_name))
    } else {
        joinstring <- ""
        fieldstring <- "*"
        querystring <- ""
        querystr <- setQuery(table_name, fieldstring, querystring, joinstring)
        retQ <- execute(con, querystr)
        return(retQ)
    }
#
# Close connection
#
    dbDisconnect(con)
}
#
#   End of dumpETH_CSAtables.R
#