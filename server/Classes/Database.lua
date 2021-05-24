--|**********************************************************************
--|* Project           : Visual Life Selfmade
--|* Author            : n0pe
--|* Date              : 22.11.2019
--|**********************************************************************

Database = inherit(Singleton)

function Database:constructor()
    connection = dbConnect("mysql", "dbname=vl_new;host=127.0.0.1;port=3306;charset=utf8", "root", "****************", "share-1")
    self.m_DBHandler = connection

    if not self.m_DBHandler then
        outputDebugString("Can't connect to database.")
        stopResource(getThisResource())
    else
        outputDebugString("Database-connection succesful.")
    end
end

function Database:getPrefix()
    return self.Prefix
end

function Database:query(query, callBackFunction, callBackArguments, ...)
    return dbQuery(self.m_DBHandler, query, callBackFunction, callBackArguments, ...)
end

function Database:poll(query, timeout)
    return dbPoll(query, timeout)
end

function Database:exec(query, ...)
    return dbExec(self.m_DBHandler, query, ...)
end
