source("private_details.R")

library(DBI)
library(RPostgres)

# displayTables returns the names of the tables that are in the GBADs AWS RDS Postgres database
#    Parameter(s): connection to database (An object from dbConnect that extends DBIConnection)
#    Returns: table names
displayTables <- function(con){

	query <- paste("SELECT table_schema,table_name FROM information_schema.tables WHERE table_schema='public' ORDER BY table_schema,table_name ;")
	tables <- dbGetQuery(con, query)

	return(tables)
}

# displayTabInfo returns the column names and datatypes of a given table that is in the GBADs AWS RDS Postgres database
#    Parameter(s): Connection to database (An object from dbConnect that extends DBIConnection), table name
#    Returns: column names and datatypes
displayTabInfo <- function(con, table_name){
	query <- paste("SELECT column_name,data_type FROM information_schema.columns WHERE table_name='",table_name,"' ;",sep="")
	table <- dbGetQuery(con, query)

	return(table)
}

# checkTable checks if the table is in the database
#    Parameter(s): Connection to database (An object from dbConnect that extends DBIConnection), table name
#    Returns: 1 if table is in the database and 0 if it is not
checkTable <- function(con, table_name){
	query <- paste("SELECT table_schema,table_name FROM information_schema.tables WHERE table_schema='public' ORDER BY table_schema,table_name ;")
	tabs <- dbGetQuery(con, query)

	for (i in tabs) {
	   ifelse(i == table_name, return(1), NA)
	}
	return(0)
}

# checkDataFields checks if the fields chosen to query on are valid
#    Parameter(s): Connection to database, table name, string with comma seperated field/column names
#    Returns: 1 if every field checks out and 0 otherwise
checkDataFields <- function(con, table_name, fieldstring){
	query <- paste("SELECT column_name FROM information_schema.columns WHERE table_name='",table_name,"' ;",sep="")
	fields_list <- as.list(unlist(dbGetQuery(con, query)))
	ret <- 0
	flist <- as.list(unlist(strsplit(fieldstring, ",")))
	num <- length(flist)

	for (fname in flist) {
		for (i in fields_list) {
			ifelse (fname == i,ret <- ret+1,NA)
		}
	}

	if (ret - num == 0) {
	   ret <- 1
	} else {
	   ret <- 0
	}
	
	return(ret)
}

# setJoin defines the tables that are to be joined and the fields that are in the join
#    Parameter(s): table1 name, table2 name, field1 name, field2 name
#    Returns: join string ( string to be sent to the query builder )
setJoin <- function(table_name1, table_name2, jfield_1, jfield_2){
	jstring <- paste("FROM ",table_name1," INNER JOIN ",table_name2," ON ",table_name1,".",jfield_1,"=",table_name2,".",jfield_2,sep="")
	return(jstring)
}

# setQuery builds a query to be sent to the database
#    Parameter(s): string of fields to be retrieved, query string, join string
#    Returns: completed query string
setQuery <- function(table_name, selectstring, wherestring, joinstring){
	if (wherestring == "") {
		if (joinstring == "") {
			querystring <- paste("SELECT",selectstring,"FROM",table_name)
		} else {
			querystring <- paste("SELECT",selectstring,joinstring)
		}
	} else {
		if (joinstring == "") {
			querystring <- paste("SELECT",selectstring,"FROM",table_name,"WHERE",wherestring)
		} else {
			querystring <- paste("SELECT",selectstring,joinstring,"WHERE",wherestring)
		}
	}
	return(querystring)
}

# execute runs the query against the database
#    Parameter(s): Connection to database, query string
#    Returns: answer to the query
execute <- function(con, querystring){
	answer <- dbGetQuery(con, querystring)
	return(answer)
}