The iOS application project files are in the HistoricalQuizzes folder.

The iOS Spike solutions are in the Spikes folder.

The database file LocalServer/database_setup.sql can be loaded into a PostgreSQL database from the command line using the \i command. 

The file LocalServer/database_php/get_db_handle.php contains the credentials for the PostgreSQL database.

The LocalServer/database_php/sync folder contains the php files to perform the synchronisation between the iOS application and the database.

The iOS application uses the local loopback address to access the server. This can be found in the DatabaseHandler class => let urlStringPath:String = "http://127.0.0.1:8888/database_php/MainServerSidePDO.php"

The LocalServer/database_setup.sql file adds 4 test users to the database.
The login information for an administrator is:

Username: testUserName1

Password: password

The login information for an authorised user is:

Username: testUserName2

Password: password2  

When the PHP server and PostgreSQL database are running. These login credentials can be used on the iOS application. It is also possible to register as an authorised user from the iOS application.  
