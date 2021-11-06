#
#    Display names of tables and their structure in the public data section of the GBADs database on AWS
#
#    Author: Rehan Nagoor
#
#    Date of last update: October 27, 2021
#
source("private_details.R")
source("rds_functions.R")

publicTable <- function(){
#
# Create connection and cursor
#
    dbname <- "publicData_1"
    host <- "gbadske-database-public-data.cp73fx22weet.ca-central-1.rds.amazonaws.com"
    port <- 5432
    user <- getuser()
    password <- getpass()
    con <- dbConnect(RPostgres::Postgres(), dbname=dbname, host=host, port=port, user=user, password=password)

    print ( "The tables in the GBADs Public Database:" )
    tables <- displayTables(con)
    for (table in tables[[2]]) {
       print(table)
    }

    tabname <- readline(prompt = "Select a table: ")
    while (tabname != "exit") {
        tabs <- strsplit(tabname, " ")
        if (tabs[[1]][1] == "tables") {
            if (length(tabs[[1]]) == 1) {
                for (table in tables[[2]]) {
       	        print(table)
    		    }
            } else {
                for (table in tables[[2]]) {
                   if (grepl(tabs[[1]][2], table)) {
                       print(table)
                   }
                }
            }
        } else {
            tinfo <- displayTabInfo(con, tabname)
            for (i in 1:(nrow(tinfo))) {
               print(sprintf("    %s - %s", tinfo[i,][[1]], tinfo[i,][[2]]))
            }
        }
        tabname <- readline(prompt = "Select a table: ")
    }
#
# Close connection
#
    dbDisconnect(con)
}
#
#   End of publicTable.R
#