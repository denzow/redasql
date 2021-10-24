# RedaSQL
![redasql](https://user-images.githubusercontent.com/4572217/138585742-dc82c105-8f43-46f4-a611-27fe49577a5b.png)


RedaSQL is querying tool for redash.
I like `psql`(PostgreSQL CLI). so redasql resemble psql in some respects.

## Install

```bash
pip install redasql
```

## How To Use

redasql need some arguments or environment variables.
redasql prioritizes arguments over environment variables.


|argument|env|mean|required|
|---|---|---|---|
|-k/--api-key|REDASQL_REDASH_APIKEY|API KEY(user api key)|True|
|-s/--server-host|REDASQL_REDASH_ENDPOINT|Redash server hostname. ex) https://your.redash.server.host/|True|
|-p/--proxy|REDASQL_HTTP_PROXY|if your redash server restricted by Proxy, set url format. ex)http://user:pass@your.proxy.server:proxy-port|False|
|-d/--data-source||initial connect datasource name.|False|

if you want to use redasql with direnv, rename `.envrc.sample` to `.envrc` and set attributes.

### special commands

redasql has management commands.

```
\?: HELP META COMMANDS.
\d: DESCRIBE TABLE
\c: SELECT DATASOURCE.
\x: QUERY RESULT TOGGLE PIVOT.
\q: EXIT.
```

### execute query

see below

#### start
```
$ redasql

____          _                 _
|  _ \ ___  __| | __ _ ___  __ _| |
| |_) / _ \/ _` |/ _` / __|/ _` | |
|  _ <  __/ (_| | (_| \__ \ (_| | |
|_| \_\___|\__,_|\__,_|___/\__, |_|
                              |_|
    - redash query cli tool -

SUCCESS CONNECT
- server version 8.0.0+b32245
- client version 0.1.0.0

(No DataSource)=#
```

#### connect datasource

use `\c data_source_name`. if not provide data_source_name, show all available data sources. 

```
(No DataSource)=# \c metadata
metadata=#
```

#### describe table

use `\d table_name`. if not provide table_name, show all table names. if provide table_name with wildcard(\*), show describe matched tables.

```
metadata=# \d
access_permissions
alembic_version
:
queries
query_results
query_snippets
users
visualizations
widgets
metadata=# \d queries
## queries
- schedule
- updated_at
- api_key
- name
- id
- version
- is_draft
- query
- is_archived
- tags
- last_modified_by_id
- org_id
- options
- query_hash
- description
- latest_query_data_id
- search_vector
- data_source_id
- schedule_failures
- created_at
- user_id
metadata=# \d query_*
## query_results
- id
- data
- org_id
- query_hash
- data_source_id
- runtime
- query
- retrieved_at
## query_snippets
- updated_at
- id
- description
- created_at
- user_id
- trigger
- snippet
- org_id

```

#### execute query

enter your SQL and semicolon.

```bash
metadata=# select count(*) from queries;
+-------+
| count |
+-------+
|  3606 |
+-------+

1 row returned.
Time: 0.0159s

```

`\x` pivot result.



```
metadata=# \x
set pivot format

metadata=# select id, user_id from queries limit 3;
-[RECORD 1]-------
     id: 543
user_id: 40
-[RECORD 2]-------
     id: 717
user_id: 40
-[RECORD 3]-------
     id: 515
user_id: 38


3 rows returned.
Time: 0.0281s

```

### quit

`ctrl + D` or `\q` quit redasql.

```
metadata=# \q                                                                                                                                                                        
Sayonara!
```

