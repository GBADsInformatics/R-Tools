#
#    Testing the query functions: setJoin, setQuery, execute
#
#    Author: Rehan Nagoor
#
#    Date of last update: November 05, 2021
#
source("private_details.R")
source("rds_functions.R")

testQueryFunctions <- function(){
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
# Test query functions: get a few fields from the cattle_health table where year=2000
#
    table_name <- "eth_csa_cattle_health"
    fieldstring <- "id,year,cattle_death_disease,cattle_death_other"
    joinstring <- ""
    querystring <- "year=2020"
    querystr <- setQuery(table_name, fieldstring, querystring, joinstring)
    print(paste("Query =", querystr))
    retQ <- execute(con, querystr)
    print("Answer: ")
    # for (i in 1:(nrow(retQ))) {
    #     print (retQ[i,][[1]],",",retQ[i,][[2]],",",retQ[i,][[3]],",",retQ[i,][[4]])
    # }
    print(retQ[,1:4])

# Test query with join: get some death stats about cattle and join this with the idtable so that we can see where the information
# came from and restricting this to national statistics (i.e. country and zone are equal as they will both be Ethiopia.

    idTab <- "idtable"
    cattleTab <- "eth_csa_cattle_health"
    jfield_1 <- "id"
    jfield_2 <- "id"
    joinstring <- setJoin(cattleTab, idTab, jfield_1, jfield_2)
    fieldstring <- "idtable.country,idtable.zone,eth_csa_cattle_health.year,eth_csa_cattle_health.cattle_death_disease,eth_csa_cattle_health.cattle_death_other"
    querystring <- "idtable.zone=idtable.country"
    querystr <- setQuery(table_name, fieldstring, querystring, joinstring)
    print(paste("Query =", querystr))
    retQ <- execute(con, querystr)
    print("Answer: ")
    # for (i in 1:(nrow(retQ))) {
    #     print(retQ[i,][[1]],",",retQ[i,][[2]],",",retQ[i,][[3]],",",retQ[i,][[4]],",",retQ[i,][[5]])
    # }
    print(retQ[,1:5])
    
    fieldstring <- "eth_csa_cattle_health.year,eth_csa_cattle_health.cattle_death_disease,eth_csa_cattle_health.cattle_death_other"
    querystring <- "idtable.zone=idtable.country"
    querystr <- setQuery(table_name, fieldstring, querystring, joinstring)
    print(paste("Query =", querystr))
    retQ <- execute(con, querystr)
    print("Answer: ")
    # for (i in 1:(nrow(retQ))) {
    #     print(retQ[i,][[1]],",",retQ[i,][[2]],",",retQ[i,][[3]])
    # }
    print(retQ[,1:3])

#
# Close connection
#
    dbDisconnect(con)
}
#
#   End of testQueryFunctions.py
#