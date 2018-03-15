# Crail tier on object storage system
Crail-S3 is an extension of the Crail project to enable storing data in an object storage system. 
The Crail S3 object tier can be used either on its own or can be used in combination with other faster Crail storage tiers (e.g., the RAM-based TcpStorageTier) for splilling data that is too largeto fit in RAM or in NVM storage.
The object store is accessed using the Amazon AWS S3 API. Crail-S3 can work in theory with any object store that supports the S3 API.

## Building
Clone and build [`crail-s3`]() using:

```bash
mvn -DskipTests install
```

Copy the jar file crail-storage-object-<version>.jar and its dependencies to `$CRAIL_HOME/jars/` and set the Yarn, Hadoop, Spark classpaths to include this directory or the jars in this directory.
The Spark environment needs to have access to the Crail jar files to allow accessing the Crail filesystem.

Also make sure that there are no conflicting jar files in the Hadoop, Spark, and Crail deployments.
Conflicting jar files indicate that different dependecy versions were used when compiling (e.g. Spark was compiled against hadoop-2.6, Crail against hadoop-2.8) and can cause unpredictable behavior.
The script "script/validate\_deployment.sh" can be used to verify that the deployments do not contain conflicting jar files. 


## Configuration parameters
All parameters accepted by the Object Tier are defined in ObjectStoreDataNode.java together with their defaut values. 
You can override these values in `$CRAIL_HOME/conf/crail-site.conf`.

The minimum configuration parameters required are the S3 credentials (s3accesskey, s3secretkey), endpoint(s) (s3endpoint), and object store datanode IP address (datanode).
Other parameters that should be set in most cases include the storagelimit (how much data can be stored in the Object Tier), the S3\_REGION and S3\_BUCKET.

## Starting a crail-objectstore datanode 
To create a Crail-S3 storage Tier, start a datanode as
```bash 
$CRAIL_HOME/bin/crail datanode -t org.apache.crail.datanode.object.ObjectStoreTier
```
In order for a client to automatically connect to a new ObjectStore datanode
type, you have to add the following class to your list of datanode types in the
`$CRAIL_HOME/conf/crail-site.conf` file. An example of such entry is :

```bash
crail.storage.types                 org.apache.crail.storage.object.ObjectStorageTier
crail.storage.object.datanode       <ip address>
```

Please note that crail.storage.types is a comma separated list of datanode **types** which defines the priority order in which the blocks of the datanodes are consumed. 

## Setting up automatic deployment
To enable deployment via `$CRAIL_HOME/bin/start-crail.sh` use the following extension 
in the crail slave file (`$CRAIL_HOME/conf/slave`.): 

```bash
hostname1 -t org.apache.crail.datanode.objectstore.ObjectStoreDataNode
...
```
Note: A crail-objectstore datanode does not serve data requests from clients, but
only registers the block device storage information to the namenode and translates
block IDs to object IDs. Clients access directly the object store through one of 
the configured endpoints and no data traffic traverses the datanode.

## Persistency and concurency considerations
Although data is stored persistently in the S3 object store, the Cral object tier does not current support recovering existing data upon restart. 

## Contributions
PRs are always welcome. Please fork, and make necessary modifications you propose, and let us know.

## Contact

If you have questions or suggestions, feel free to post at:

https://groups.google.com/forum/#!forum/zrlio-users

or email: zrlio-users@googlegroups.com  
