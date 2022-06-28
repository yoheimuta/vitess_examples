# Local Vitess cluster using docker-compose 

This directory has a docker-compose sample application based on [the official example](https://github.com/vitessio/vitess/tree/08dfc4eb7e844f15b35086e37692391061a194f5/examples/compose).
To understand it better, you can run it.

First you will need to [install docker-compose](https://docs.docker.com/compose/install/).

### Start the cluster
To start Consul(which saves the topology config), vtctld, vtgate, orchestrator and a few vttablets with MySQL running on them.
```
vitess/examples/compose$ docker-compose up -d
```

### Check cluster status
Check the status of the cluster.
```
(base) compose❯ docker-compose ps
                Name                              Command                  State                                                  Ports
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
compose_consul1_1                      docker-entrypoint.sh agent ...   Up             8300/tcp, 8301/tcp, 8301/udp, 8302/tcp, 8302/udp, 0.0.0.0:8400->8400/tcp,:::8400->8400/tcp,
                                                                                       0.0.0.0:8500->8500/tcp,:::8500->8500/tcp, 0.0.0.0:8600->8600/tcp,:::8600->8600/tcp,
                                                                                       8600/udp
compose_consul2_1                      docker-entrypoint.sh agent ...   Up             8300/tcp, 8301/tcp, 8301/udp, 8302/tcp, 8302/udp, 8400/tcp, 8500/tcp, 8600/tcp, 8600/udp
compose_consul3_1                      docker-entrypoint.sh agent ...   Up             8300/tcp, 8301/tcp, 8301/udp, 8302/tcp, 8302/udp, 8400/tcp, 8500/tcp, 8600/tcp, 8600/udp
compose_external_db_host_1             docker-entrypoint.sh --ser ...   Up (healthy)   0.0.0.0:56444->3306/tcp, 33060/tcp
compose_schemaload_lookup_keyspace_1   sh -c /script/schemaload.sh      Exit 0
compose_schemaload_test_keyspace_1     sh -c /script/schemaload.sh      Exit 0
compose_vreplication_1                 sh -c [ $EXTERNAL_DB -eq 1 ...   Exit 0
compose_vtctld_1                       sh -c  /vt/bin/vtctld -top ...   Up             0.0.0.0:56518->15999/tcp, 0.0.0.0:15000->8080/tcp,:::15000->8080/tcp
compose_vtgate_1                       sh -c /script/run-forever. ...   Up             0.0.0.0:15306->15306/tcp,:::15306->15306/tcp, 0.0.0.0:56534->15999/tcp,
                                                                                       0.0.0.0:15099->8080/tcp,:::15099->8080/tcp
compose_vtorc_1                        sh -c /script/vtorc-up.sh        Up             0.0.0.0:13000->3000/tcp,:::13000->3000/tcp
compose_vttablet101_1                  sh -c /script/vttablet-up. ...   Up (healthy)   0.0.0.0:56549->15999/tcp, 0.0.0.0:56550->3306/tcp,
                                                                                       0.0.0.0:15101->8080/tcp,:::15101->8080/tcp
compose_vttablet102_1                  sh -c /script/vttablet-up. ...   Up (healthy)   0.0.0.0:56553->15999/tcp, 0.0.0.0:56554->3306/tcp,
                                                                                       0.0.0.0:15102->8080/tcp,:::15102->8080/tcp
compose_vttablet201_1                  sh -c /script/vttablet-up. ...   Up (healthy)   0.0.0.0:56547->15999/tcp, 0.0.0.0:56548->3306/tcp,
                                                                                       0.0.0.0:15201->8080/tcp,:::15201->8080/tcp
compose_vttablet202_1                  sh -c /script/vttablet-up. ...   Up (healthy)   0.0.0.0:56528->15999/tcp, 0.0.0.0:56529->3306/tcp,
                                                                                       0.0.0.0:15202->8080/tcp,:::15202->8080/tcp
compose_vttablet301_1                  sh -c /script/vttablet-up. ...   Up (healthy)   0.0.0.0:56551->15999/tcp, 0.0.0.0:56552->3306/tcp,
                                                                                       0.0.0.0:15301->8080/tcp,:::15301->8080/tcp
compose_vttablet302_1                  sh -c /script/vttablet-up. ...   Up (healthy)   0.0.0.0:56545->15999/tcp, 0.0.0.0:56546->3306/tcp,
                                                                                       0.0.0.0:15302->8080/tcp,:::15302->8080/tcp
compose_vtwork_1                       sh -c /vt/bin/vtworker -to ...   Up             0.0.0.0:56539->15999/tcp, 0.0.0.0:56540->8080/tcp
```

### Check the status of the containers
You can check the logs of the containers (vtgate, vttablet101, vttablet102, vttablet103) at any time.
For example to check vtgate logs, run the following;
```
vitess/examples/compose$ docker-compose logs -f vtgate
```

### Connect to vgate and run queries
vtgate responds to the MySQL protocol, so we can connect to it using the default MySQL client command line.
```
vitess/examples/compose$ mysql --port=15306 --host=127.0.0.1
```
**Note that you may need to replace `127.0.0.1` with `docker ip` or `docker-machine ip`** 

You can also use the `./lmysql.sh` helper script.
```
vitess/examples/compose$ ./lmysql.sh --port=15306 --host=<DOCKER_HOST_IP>
```

where `<DOCKER_HOST_IP>` is `docker-machine ip` or external docker host ip addr

### Play around with vtctl commands

```
vitess/examples/compose$ ./lvtctl.sh Help
```

## Exploring

- vtctld web ui:
  http://localhost:15000

- vttablets web ui:
  http://localhost:15101/debug/status
  http://localhost:15102/debug/status
  http://localhost:15103/debug/status

- vtgate web ui:
  http://localhost:15099/debug/status

- orchestrator web ui:
  http://localhost:13000
  
- Stream querylog
  `curl -S localhost:15099/debug/querylog`
  
**Note that you may need to replace `localhost` with `docker ip` or `docker-machine ip`**  
 
## Troubleshooting
If the cluster gets in a bad state, you most likely will have to stop and kill the containers. Note: you will lose all the data.
```
vitess/examples/compose$ docker-compose kill
vitess/examples/compose$ docker-compose rm
```

### Connect to vgate and run queries
vtgate responds to the MySQL protocol, so we can connect to it using the default MySQL client command line.
Verify that data was copied and is replicating successfully.
```sh
(base) compose❯ docker run -it --rm mysql:5.7 mysql --port=15306 -hhost.docker.internal

mysql> show databases;
+--------------------+
| Database           |
+--------------------+
| lookup_keyspace    |
| test_keyspace      |
| information_schema |
| mysql              |
| sys                |
| performance_schema |
+--------------------+
6 rows in set (0.02 sec)

mysql> use test_keyspace;
Reading table information for completion of table and column names
You can turn off this feature to get a quicker startup with -A

Database changed
mysql> show tables;
+-------------------------+
| Tables_in_test_keyspace |
+-------------------------+
| messages                |
| tokens                  |
+-------------------------+
2 rows in set (0.00 sec)

mysql> use lookup_keyspace;
Database changed

mysql> show tables;
+---------------------------+
| Tables_in_lookup_keyspace |
+---------------------------+
| messages_message_lookup   |
| tokens_token_lookup       |
+---------------------------+
2 rows in set (0.01 sec)

mysql> use test_keyspace;
Reading table information for completion of table and column names
You can turn off this feature to get a quicker startup with -A

Database changed
mysql> insert into messages(page,time_created_ns,message) values(1,10,"alice");
Query OK, 1 row affected (0.03 sec)

mysql> select * from messages;
+------+-----------------+---------+
| page | time_created_ns | message |
+------+-----------------+---------+
|    1 |              10 | alice   |
+------+-----------------+---------+
1 row in set (0.02 sec)

mysql> select * from lookup_keyspace.messages_message_lookup;
+---------+------+
| message | page |
+---------+------+
| alice   |    1 |
+---------+------+
1 row in set (0.01 sec)

mysql> insert into tokens(page,time_created_ns,token) values(1,10,"ask");
Query OK, 1 row affected (0.03 sec)

mysql> select * from tokens;
+------+-----------------+-------+
| page | time_created_ns | token |
+------+-----------------+-------+
|    1 |              10 | ask   |
+------+-----------------+-------+
1 row in set (0.01 sec)

mysql> select * from lookup_keyspace.tokens_token_lookup;
+------+-------+
| page | token |
+------+-------+
|    1 | ask   |
+------+-------+
1 row in set (0.01 sec)
```

## Helper Scripts
The following helper scripts are included to help you perform various actions easily
* vitess/examples/compose/lvtctl.sh
* vitess/examples/compose/lmysql.sh

You may run them as below
```
vitess/examples/compose$ ./lvtctl.sh <args>
```

To run against a specific compose service/container, use the environment variable **$CS**

```
vitess/examples/compose$ (export CS=vttablet101; ./lvtctl.sh <args> )
```

## Custom Image Tags
You  may specify a custom `vitess:lite` image tag by setting the evnironment variable `VITESS_TAG`.  
This is optional and defaults to the `latest` tag. Example;
* Set `VITESS_TAG=8.0.0` in your `.env` before running `docker-compose up -d`
* Run `VITESS_TAG=8.0.0; docker-compose up -d`

## Reference
Checkout this excellent post about [The Life of a Vitess Cluster](https://vitess.io/blog/2020-04-27-life-of-a-cluster/)


