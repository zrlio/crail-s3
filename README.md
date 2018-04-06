# Crail tier on object storage system
Crail-S3 is an extension of the Crail project to enable storing data in an object storage system. 
The Crail S3 object tier can be used either on its own or can be used in combination with other faster Crail storage tiers (e.g., the RAM-based TcpStorageTier) for splilling data that is too large to fit in RAM or in NVM storage.
The object store is accessed using the Amazon AWS S3 API. Crail-S3 can work in theory with any object store that supports the S3 API.

## Building
Clone and build [`crail-s3`]() using:

```bash
mvn -DskipTests install
```

Copy the jar file crail-storage-object-\<version\>.jar and its dependencies to `$CRAIL_HOME/jars/` and set the Yarn, Hadoop, Spark classpaths to include this directory or the jars in the directory.
At a minimum, the Spark execution environment needs the Crail jar files for accessing data in the Crail filesystem.

NOTE: Please make sure that there are no conflicting jar files in the Hadoop, Spark, and Crail deployments.
Conflicting jar files indicate that different dependecy versions were used when compiling (e.g. Spark was compiled against hadoop-2.6, Crail against hadoop-2.8) and can cause unpredictable behavior.
The script "script/validate\_deployment.sh" can be used to verify that the deployments do not contain conflicting jar files. 


## Configuration parameters
All parameters accepted by the Object Tier are defined in ObjectStoreDataNode.java together with their defaut values. 
You can override these values in `$CRAIL_HOME/conf/crail-site.conf`.

The minimum configuration parameters required are the S3 credentials (s3accesskey, s3secretkey), endpoint(s) (s3endpoint), and Crail-S3 datanode IP address (datanode). 
Other parameters that should be set in most cases include the storagelimit (how much data can be stored in the Crail Object Tier), the S3\_REGION and the S3\_BUCKET.


## Starting a Crail-S3 datanode
A Crail-S3 datanode does not serve data requests from clients, but only registers the virtual Crail blocks to the namenode and translates Crail block IDs to object names. Clients access directly the object store through one of 
the configured endpoints and no data traffic traverses the Crail-S3 datanode. For the majority of uses a single datanode process, that can run on the same machine as the Crail namenode, is sufficient. However, there can be several Crail-S3 datanodes if, for example, multiple object stores are used concurently.

  - **Manual startup.** You can start a new Crail-S3 storage tier by hand:
```bash 
$CRAIL_HOME/bin/crail datanode -t   com.ibm.crail.storage.object.ObjectStoreTier
```

  - **Automatic deployment.** Alternatively, the Crail-S3 datanode be started automatically as part of Crail. To enable deployment via `$CRAIL_HOME/bin/start-crail.sh` add the following line in the Crail slave file (`$CRAIL_HOME/conf/slaves`): 
```bash
datanode_hostname -t com.ibm.crail.storage.object.ObjectStoreTier
...
```

## Crail client configuration
In addition to other global Crail paremeters, the following parameters must be set in `$CRAIL_HOME/conf/crail-site.conf` to allow a Crail client to connect to the Crail S3 tier:

```bash
# The java class that defines the implementation of the Crail-S3 tier. Please note that crail.storage.types is a comma separated list of storage tier types which defines the priority order in which the storage tiers are filled.
crail.storage.types                     com.ibm.crail.storage.object.ObjectStorageTier
# The Crail-S3 datanode (see above) that will translate Crail blocks to object names
crail.storage.object.datanode           <ip address>
# S3 access / secret keys
crail.storage.object.s3accesskey        <key>
crail.storage.object.s3secretkey        <key>
# Comma separated S3 endpoints (either IP addresses or hostnames). For example s3.amazonaws.com. In case of multiple endpoints, each client transfers data through all endpoints.
crail.storage.object.s3endpoit          <ip address>
```
Alternatively, you can set a subset of the S3 paramenters using environment variables.


## Persistency and concurency considerations
Although data is stored persistently in the S3 object store, the Cral object tier does not current support recovering existing data upon restart. 


## Contributions
PRs are always welcome. Please fork, and make necessary modifications you propose, and let us know.


## Contact

If you have questions or suggestions, feel free to post at:

https://groups.google.com/forum/#!forum/zrlio-users

or email: zrlio-users@googlegroups.com  
