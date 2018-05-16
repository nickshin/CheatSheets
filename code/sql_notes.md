# SQL Notes

<span class="note1">written by Nick Shin - nick.shin@gmail.com<br>
this code found in this file is licensed under: [Unlicense - http://unlicense.org/](http://unlicense.org/)<br>
and, is from - <https://www.nickshin.com/CheatSheets/></span>

* * *

The following notes are based primarily on using MySQL directly.

* * *

### when you forget the MySQL root password

```sh
root_prompt> /usr/local/mysql/bin/safe_mysqld --skip-grant-tables &
root_prompt> /usr/local/mysql
mysql_root> USE mysql;
mysql_root> UPDATE user SET password=PASSWORD('.......') WHERE user='root' AND host='localhost';
mysql_root> FLUSH PRIVILEGES;
# stop and restart MySQL server.
```

* * *

### user maintenance

- <http://dev.mysql.com/doc/mysql/en/grant.html>
- <http://www.mysql.com/documentation/mysql/bychapter/manual_Privilege_system.html>

```sh
# list all current users found in this mysql database
mysql_prompt> SELECT Host, User FROM mysql.user;

# to get rid of anonymous access (not necessary)
mysql_root> DELETE FROM user WHERE user = "";
# or
mysql_root> DELETE FROM mysql.user WHERE Host='localhost' AND User='';

# nuke existing user
mysql_root> DELETE FROM user WHERE user = "username_to_delete";

# replace root info to grant complete access
mysql_root> REPLACE INTO user ( Host, User, Password,
				Select_priv, Insert_priv, Update_priv,
				Delete_priv, Create_priv, Drop_priv,
				Reload_priv, Shutdown_priv, Process_priv, File_priv,
				Grant_priv, References_priv, Index_priv, Alter_priv )
			VALUES ( 'localhost', 'root', password( '.......' ),
				'Y', 'Y', 'Y',
				'Y', 'Y', 'Y',
				'Y', 'Y', 'Y', 'Y',
				'Y', 'Y', 'Y', 'Y' );

mysql_root> REPLACE INTO user ( Host, User, Password,
				Select_priv, Insert_priv, Update_priv,
				Delete_priv, Create_priv, Drop_priv,
				Reload_priv, Shutdown_priv, Process_priv, File_priv,
				Grant_priv, References_priv, Index_priv, Alter_priv )
			VALUES ( 'localhost.localdomain', 'root', password( '.......' ),
				'Y', 'Y', 'Y',
				'Y', 'Y', 'Y',
				'Y', 'Y', 'Y', 'Y',
				'Y', 'Y', 'Y', 'Y' );
```

* * *

### to quickly fill in the database

```sh
root_prompt> mysqladmin [options] create sampleDBname
root_prompt> mysql mysql < createusers.sql

root_prompt> mysql sampleDBname < createtable.sql
prompt> mysql -u sampleDBuser -p sampleDBname < create_another_table.sql
Enter password:
prompt> mysql -u sampleDBuser -p sampleDBname < fill_in_table.sql
Enter password:
root_prompt> mysql sampleDBname < etc_etc_etc.sql
```

where `createusers.sql` might contain:
```sql
REPLACE INTO user ( host, user, password )
VALUES (
	'localhost',
	'sampleDBuser',
	password( 'sampleDBuserPassword' )
);

REPLACE INTO db ( host, db, user,
		select_priv, insert_priv, update_priv,
		delete_priv, create_priv, drop_priv )
VALUES (
	'localhost',
	'sampleDBname',
	'sampleDBuser',
	'Y', 'Y', 'Y',
	'Y', 'Y', 'Y'
);
```
- <span class="indent">note: REPLACE will INSERT if no entry matches</span>


where `createtable.sql` might contain:
```sql
CONNECT sampleDBname;

# nuke existing table
DROP TABLE sampleDBtable;

CREATE TABLE sampleDBtable (
# database id
	id    int(11) not null auto_increment,

# sample db items
	title varchar(20),
	name  varchar(25) not null,
	yrs1  int(4), # begining term year
	yrs2  int(4), # ending yerm year
	notes text,

# database control stuff
	primary key (id)
);
```
- <span class="indent">note: there is no "REPLACE" equivalent with "CREATE" TABLE</span>

* * *

### to do this manually:

```sh
mysql_root> CREATE DATABASE sampleDBname;
mysql_root> REPLACE INTO user ( host, user, password )
		VALUES (
			'localhost',
			'sampleDBuser',
			password( 'sampleDBuserPassword' )
		);
mysql_root> REPLACE INTO db ( host, db, user,
				select_priv, insert_priv, update_priv,
				delete_priv, create_priv, drop_priv )
		VALUES (
			'localhost',
			'sampleDBname',
			'sampleDBuser',
			'Y', 'Y', 'Y',
			'Y', 'Y', 'Y'
		);
mysql_root> FLUSH PRIVILEGES;

mysql_prompt> DROP sampleDBname sampleDBtable;
# -- or --
mysql_prompt> USE sampleDBname;
mysql_prompt> DROP TABLE sampleDBtable;

mysql_prompt> USE sampleDBname;
mysql_prompt> CREATE TABLE sampleDBtable ( ... see createtable.sql above ... );
```

* * *

### remote access examples:

- Set up the `host` table (assuming it has not yet been set up)
```sh
mysql_root> INSERT INTO host ( host, db,
				Select_priv, Insert_priv, Update_priv,
				Delete_priv, Create_priv, Drop_priv)
# with these example entries:
			VALUES ('localhost','mydb','Y', 'Y', 'Y', 'Y', 'Y', 'Y');
			VALUES ('devshed','mydb','Y', 'Y', 'Y', 'Y', 'Y', 'Y');
			VALUES ('localhost','%','Y', 'Y', 'Y', 'Y', 'Y', 'Y');
			VALUES ('somedomain','%','Y', 'Y', 'Y', 'Y', 'Y', 'Y');
```

- Update the `user` table, granting access to a new **host+user** combination.
```sh
mysql_root> INSERT INTO user (host,user,password)
# with these example entries:
			VALUES('localhost','dario',password('mamamia'));
			VALUES('www.devshed.com','dario',password('mamamia'));
```

- Update the `db` table.
```sh
mysql_root> INSERT INTO db ( host, db, user,
			Select_priv, Insert_priv, Update_priv,
			Delete_priv, Create_priv, Drop_priv)
# with these example entries:
			VALUES ('localhost','pasta','dario','Y','Y','Y','Y','Y','Y');
			VALUES ('%','chicken','dario','Y','Y','Y','Y','Y','Y');
```

* * *

### <http://www.devshed.com/Server_Side/MySQL/Administration/print>

```sh
root_prompt> mysqlshow
	+--------------+
	| Databases    |
	+--------------+
	| mysql        |
	+--------------+

root_promt> mysqlshow mysql
	Database: mysql
	+----------+
	| Tables   |
	+----------+
	| db       |
	| host     |
	| user     |
	+----------+

root_promt> mysql -e "SELECT host,db,user FROM db" mysql
	+------+----------+------+
	| host | db       | user |
	+------+----------+------+
	| %    | test     |      |
	| %    | test_%   |      |
	+------+----------+------+
```

* * *

### <http://www.devshed.com/Server_Side/MySQL/Speak/Speak1/print>

```sh
mysql_prompt> SHOW DATABASES;
	+----------+
	| Database |
	+----------+
	| library  |
	| mysql    |
	| test     |
	+----------+

mysql_prompt> USE mysql;
	Database changed

mysql_prompt> SHOW TABLES;
	+----------+
	| Tables   |
	+----------+
	| db       |
	| host     |
	| user     |
	+----------+

mysql_prompt> SELECT host,db,user FROM db;
	+------+----------+------+
	| host | db       | user |
	+------+----------+------+
	| %    | test     |      |
	| %    | test_%   |      |
	+------+----------+------+
```

* * *

### Basic Security tips:

1. Above all, take a moment to update the root privileges, and give it a password!
	- Someone managing to get on the localhost can enter simply by typing:
	- `mysql -u root mysql`, if a password is not established
1. Assign passwords for every user
1. If the user doesn't have a specific need for it, don't assign permission to use `File_priv`
	- This gives the user the ability to write files to the MySQL server
	- In addition, don't give permission to the `process_priv`, unless there is a good reason for doing so
1. Don't use '%' within the host names
	- It allows a user to enter that server from any outside host
	- In addition, don't use wildcards (i.e. devshed%)
	- It would theoretically allow someone to use http://devshed.badcracker.com to aid them in entering the server

* * *

### misc tips

- to list all the table index information
```sh
# the following two are the same
mysql_prompt> SHOW KEYS FROM tableItem;
mysql_prompt> SHOW INDEX FROM sampleDBtable FROM sampleDBname;
```

- to list all the entries from the table
```sh
# the following two are the same
mysql_prompt> SHOW COLUMNS FROM sampleDBtable;
mysql_prompt> SHOW FIELDS FROM sampleDBtable;
```

- narrow a search
```sh
mysql_prompt> SHOW FIELDS FROM sampleDBtable LIKE '%yyy';
```

- SEARCH
```sh
mysql_prompt> SELECT * FROM sampleDBtable WHERE tableItem LIKE '%zzz';
```

- multiple columns
```sh
mysql_prompt> SELECT tableItem,tableItem2 FROM sampleDBtable;
```

- list unique entries
```sh
mysql_prompt> SELECT DISTINCT tableItem FROM sampleDBtable;
```

* * *




<style>
.note1                    { font-size: 11px; }
.indent, pre              { margin-left: 2em; }
.markdown-body pre code   { font-size: 80%; }
</style>

