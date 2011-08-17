node default{ 


}



node hdclient inherits default{ 


#HDFS global variables
       $hadoop_version = "0.20"
        $conf_name = "prod_conf"
        $conf_path = "/etc/hadoop-${hadoop_version}/${conf_name}"
        $lib_path = "/usr/lib/hadoop"
        $lzo_version = "0.4.9"
        $hdfs_basedir = "/dir1/data/server_hdfs"
        $namenode_name='namenode_server'
        $jobtracker_name='jobtracker server'
        $hadoop_tmp_dir='/dir1/tmp/${user.name}'
        $dfs_name_dir='/dir1/local/dfs/name'
        $fs_checkpoint_dir='/dir1/dfs/secondary'

        $hbase_tmp_dir='/dir1/server_hbase/tmp/hbase'

        $hddatadirs     = [
        "/dir1/server_hdfs/data/disk1/dfs/dn",
        "/dir1/server_hdfs/data/disk2/dfs/dn",
        "/dir1/server_hdfs/data/disk3/dfs/dn",
        ]

        $hdmapreddirs = [
        "/dir1/server_hdfs/data/disk1/mapred/local",
        "/dir1/server_hdfs/data/disk2/mapred/local",
        "/dir1/server_hdfs/data/disk3/mapred/local",
        "/dir1/server_hdfs/data/disk4/mapred/local",
        "/dir1/server_hdfs/data/disk5/mapred/local",
        "/dir1/server_hdfs/data/disk6/mapred/local",
        ]

        $hdzooservers = [
        "server1",
        "server2",
        "server3",
        ]

#HBASE global variables

        $hbase_conf_path = "/etc/hbase/conf"
        $hbase_version = "0.90.1-cdh3u0"
	$hbase_root_dir='/hbase'


#Ganglia variables, required for hadoop-metrics
        $mcast_ip="239.2.11.71"
        $cluster="Hadoop production cluster"

#deploying actually client
        include hdfs::common
        include hbase::common



}

node basenode {
#include sudo
}

node hdbasenode inherits hdclient {


#install Ganglia client
        include ganglia::client
        ganglia::config {'client':
                }


}



node 'master1' inherits hdbasenode {

	include hdfs::namenode
	include hdfs::jobtracker
	include hbase::common
	include hbase::masterserver

       $zookeeper_myid = '1'
	include zookeeper::server
	include hue::plugins

}

node 'master2' inherits hdbasenode {

#        include hdfs::namenode
#        include hdfs::jobtracker
        include hbase::common
	include hbase::masterserver

       $zookeeper_myid = '2'
        include zookeeper::server
        include hue::plugins
	include hdfs::secondarynamenode

}

node 'appserver1' inherits hdbasenode {

        include hdfs::common
        include hbase::common
	       $mysqlserver = 'mysqlserver1'

       $zookeeper_myid = '3'
        include zookeeper::server
	include hue::server
	include hive::client
	include pig::client
	include dbautils
}
node 'appserver2' inherits hdbasenode {

	$mysqlserver = 'mysqlserver1'
        include hdfs::common
        include hbase::common
        include hue::server
        include hive::client
        include pig::client
	include zookeeper::common
	include dbautils
}



node /^dataserver\d+$/ inherits hdbasenode {
	include hdfs::datanode
	include hue::plugins
	include hdfs::tasktracker
	include hbase::regionserver
	include hbase::thriftserver

}
