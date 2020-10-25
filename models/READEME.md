# About SQLite Database

+ I will be updating this file with all the little quirks that made working with SQLite a little bit of a nightmare +


+ SQLite doesn't recognite the SQL file as the proper file: +
Sometimes the shell seems to forget it's reading SQL (or something along those lines), and you'll need to try the following command:
"cat bookmarksdb.sql | sqlite3 database.db"

+ 'cat' is not recognized as an internal or external command +
Apparently the normal Windows 8 & 10 command prompt just doesn't know what cat is, try running the Windows Powershell instead.
Just search for "Powershell" in the search bar in the bottom left of your screen.

## Updated on preview

Database file(e.g. `*.db`,`*.sqlite`) we work with is a binary file rather than text file, therefore it is necessary that we
interact with the file using `sqlie3` command. Below is an example.

```
$ sqlite3 database.db  # Open the database file using sqlite3 command
sqlite> SELECT * FROM whatever; # Input the SQL command interactively
```

More info could be found on the [official documentation](https://www.sqlite.org/cli.html).
