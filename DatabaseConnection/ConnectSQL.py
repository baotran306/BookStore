import pyodbc

connect = pyodbc.connect(
    "Driver={ODBC Driver 17 for SQL Server};"
    "Server=DESKTOP-LJOB7S5;"
    "UID=sa;"
    "PWD=123456;"
    "Database=BookOnlineStore;"
    "MultipleActiveResultSets=true;"
    "Connection Timeout=300;"
)
