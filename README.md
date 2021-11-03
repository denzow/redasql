# RedaSQL
![redasql](https://user-images.githubusercontent.com/4572217/138800787-b9525acd-8ab1-4f35-a762-948244b9caee.png)


RedaSQL is querying tool for redash.
I like `psql`(PostgreSQL CLI). so redasql resemble psql in some respects.

## Install

```bash
pip install redasql
```

## supported readsh version

RedaSQL supports Redash v8, v9 and v10.RedaSQL supports Redash v8, v9 and v10.

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
metadata=# \?
\?: HELP META COMMANDS.
\q: EXIT.
\d: DESCRIBE TABLE
\c: SELECT DATASOURCE.
\x: QUERY RESULT TOGGLE PIVOT.
\f: CHANGE RESULT FORMATTER ['table', 'markdown', 'markdown_with_sql', 'csv'].
\l: LOAD QUERY FROM REDASH.
```

### execute query

see below

#### start
```
$ redasql

 ____          _       ____   ___  _     
|  _ \ ___  __| | __ _/ ___| / _ \| |    
| |_) / _ \/ _` |/ _` \___ \| | | | |    
|  _ <  __/ (_| | (_| |___) | |_| | |___ 
|_| \_\___|\__,_|\__,_|____/ \__\_\_____|

    - redash query cli tool -

SUCCESS CONNECT
- server version 8.0.0+b32245
- client version 0.1.0

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
set pivoted [True]

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

### formats

redasql support many formats. `\f <format_name>` and `\x`



#### table format(default)

```
metadata=# select id, object_id, org_id, created_at from favorites limit 3;

+------+-------------+----------+--------------------------+
|   id |   object_id |   org_id | created_at               |
|------+-------------+----------+--------------------------|
|    2 |         513 |        1 | 2019-05-22T05:30:17.185Z |
|    3 |         514 |        1 | 2019-05-22T05:30:19.031Z |
|    4 |         230 |        1 | 2019-05-22T08:17:12.693Z |
+------+-------------+----------+--------------------------+

3 rows returned.
Time: 0.0219s
```

#### table format(pivoted)

```
metadata=# select id, object_id, org_id, created_at from favorites limit 3;

-[RECORD 1]----------
        id| 2
 object_id| 513
    org_id| 1
created_at| 2019-05-22T05:30:17.185Z
-[RECORD 2]----------
        id| 3
 object_id| 514
    org_id| 1
created_at| 2019-05-22T05:30:19.031Z
-[RECORD 3]----------
        id| 4
 object_id| 230
    org_id| 1
created_at| 2019-05-22T08:17:12.693Z


3 rows returned.
Time: 0.0223s

```

#### markdown

```
metadata=# \f markdown
set formatter [markdown]
metadata=# select id, object_id, org_id, created_at from favorites limit 3;

|   id |   object_id |   org_id | created_at               |
|------|-------------|----------|--------------------------|
|    2 |         513 |        1 | 2019-05-22T05:30:17.185Z |
|    3 |         514 |        1 | 2019-05-22T05:30:19.031Z |
|    4 |         230 |        1 | 2019-05-22T08:17:12.693Z |

3 rows returned.
Time: 0.0207s

```

#### markdown(pivoted)


```
metadata=# select id, object_id, org_id, created_at from favorites limit 3;

| colum_name   | value                    |
|--------------|--------------------------|
| created_at   | 2019-05-22T05:30:17.185Z |
| org_id       | 1                        |
| id           | 2                        |
| object_id    | 513                      |
| created_at   | 2019-05-22T05:30:19.031Z |
| org_id       | 1                        |
| id           | 3                        |
| object_id    | 514                      |
| created_at   | 2019-05-22T08:17:12.693Z |
| org_id       | 1                        |
| id           | 4                        |
| object_id    | 230                      |

3 rows returned.
Time: 0.0106s
```

#### markdown_with_sql

```
```sql
select id, object_id, org_id, created_at from favorites limit 3;
``` .

|   id |   object_id |   org_id | created_at               |
|------|-------------|----------|--------------------------|
|    2 |         513 |        1 | 2019-05-22T05:30:17.185Z |
|    3 |         514 |        1 | 2019-05-22T05:30:19.031Z |
|    4 |         230 |        1 | 2019-05-22T08:17:12.693Z |

3 rows returned.
Time: 0.0253s


```

#### csv

```
metadata=# \f csv
set formatter [csv]
metadata=# select id, object_id, org_id, created_at from favorites limit 3;

id,object_id,org_id,created_at
2,513,1,2019-05-22T05:30:17.185Z
3,514,1,2019-05-22T05:30:19.031Z
4,230,1,2019-05-22T08:17:12.693Z

```

### quit

`ctrl + D` or `\q` quit redasql.

```
metadata=# \q                                                                                                                                                                        
Sayonara!
```


## Contribution

### run test

#### start up containers (redash, MySQL, postgresql)

unittest necessary redash test server. use docker-compose.
choose `REDASH_VERSION`.

 - 8.0.2.b37747
 - 9.0.0-beta.b49509
 - 10.0.0.b50363

```bash
$ export REDASH_VERSION=8.0.2.b37747
$ docker-compose -f ci/docker-compose.${REDASH_VERSION}.yml up -d
```

#### run test

```bash
$ python -m unittest discover -s ci/
```
