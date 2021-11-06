#
#    Test the table functions: displayTables, displayTabInfo, checkTable, checkDataFields
#
#    Author: Rehan Nagoor
#
#    Date of last update: November 05, 2021
#
source("private_details.R")
source("rds_functions.R")

testTableFunctions <- function(){
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
# Test displayTables and checkTable 
# 
    print("The tables in the GBADs Public Database:")
    tables <- displayTables(con)
    for (table in tables[[2]]) {
        ret <- checkTable(con, table)
        print(paste("For the table name \'", table, "\' the return from checkTable() is ", ret, sep = ""))
    }
    ret <- checkTable(con, "empty")
    print(paste("For the table named 'empty' the return from checkTable() is", ret))

#
# Test checkDataFields and displayTabInfo
# 
    table_name <- "eth_csa_camels_category"
    fieldstring <- "id,year,camels_total"
    ret <- checkDataFields(con, table_name, fieldstring)
    print(paste("In", table_name, "testing if", fieldstring, "are fields and the return value from checkDataFields() is", ret))
    fieldstring <- "id,year,camels_total"
    ret <- checkDataFields(con, table_name, fieldstring)
    print(paste("In",table_name,"testing if",fieldstring,"are fields and return value from checkDataFields() is", ret))

    table_name <- "eth_csa_horses_category"
    fields <- displayTabInfo(con, table_name)
    print("The fields in horses_category are: ")
    for (field in fields[[1]]) {
        print(field)
    }
    print("The datatypes of the fields in horses_category are: ")
    for (field in fields[[2]]) {
        print(field)
    }

#
# Close connection
#
    dbDisconnect(con)
}
#
#   End of testTableFunctions.py
#