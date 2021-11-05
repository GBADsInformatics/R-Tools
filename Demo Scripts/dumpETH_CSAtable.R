#
#    Dump the contents of an Ethiopia CSA table displaying the id fields as well
#
#    Author: Rehan Nagoor
#
#    Date of last update: October 23, 2021
#
source("private_details.R")
source("rds_functions.R")

dumpETH_CSAtable <- function(table_name){
#
# Create connection and cursor
#
    dbname <- "publicData_1"
    host <- "gbadske-database-public-data.cp73fx22weet.ca-central-1.rds.amazonaws.com"
    port <- 5432
    user <- getuser()
    password <- getpass()
    con <- dbConnect(RPostgres::Postgres(), dbname=dbname, host=host, port=port, user=user, password=password)
#
# Check the table name
#
    if (checkTable(con, table_name) == 0) {
        print(sprintf("%s does not exist as a table in GBADs public database", table_name))
    } else {
       idTab <- "idtable"
        jfield_1 <- "id"
        jfield_2 <- "id"
        joinstring <- setJoin(table_name, idTab, jfield_1, jfield_2)
        idfieldstring <- "idtable.id,idtable.country,idtable.region,idtable.zone,idtable.datasource"
        fields <- displayTabInfo(con, table_name)
        selfieldstring <- ""
        for (field in fields[[1]]) {
           selfieldstring <- paste(selfieldstring,",",table_name,".",field, sep = "")
        }
        fieldstring <- paste(idfieldstring,selfieldstring, sep = "")
        querystring <- ""
        querystr <- setQuery(table_name, fieldstring, querystring, joinstring)
        retQ <- execute(con, querystr)
        # for (field in retQ) {
        #    i <- 0
        #    print("")
        #    While (i < (lengths(field, use.names=FALSE)[1] - 1)) {
        #        cat(field[i],",")
        #        i <- i+1
        #    }
        #    print(field[i],"\n")
        # }
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