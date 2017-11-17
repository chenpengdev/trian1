#!/bin/bash
#autor shenyuanyu

#安装编译工具及库文件
yumware=(gcc gcc-c++ make autoconf libtool-ltdl-devel gd-devel freetype-devel libxml2-devel libjpeg-devel libpng-devel openssl-devel curl-devel bison patch unzip ncurses-devel sudo bzip2 flex libaio-devel wget
	)
for t in ${yumware[@]}
do
	echo "start to install ${t}"
	yum -y install ${t}
	if test $? -eq 0
	then 
		echo "${t} install success"
	else
		echo "${t} install fail"
		exit
	fi
done

#安装cmake编译器
echo "start install cmake tool"
#下载压缩包
wget http://www.cmake.org/files/v3.1/cmake-3.1.1.tar.gz
#解压压缩包
tar zxvf cmake-3.1.1.tar.gz
#进入安装目录 
cd cmake-3.1.1
#编译安装
./bootstrap
make && make install
#返回用户根目录
cd
echo "cmake tool install end"

#安装mysql
echo "start install mysql"
#下载安装包
wget http://dev.mysql.com/get/Downloads/MySQL-5.6/mysql-5.6.15.tar.gz
#解压安装包
tar zxvf mysql-5.6.15.tar.gz
#进入安装包目录
cd mysql-5.6.15
#编译安装
cmake -DCMAKE_INSTALL_PREFIX=/usr/local/webserver/mysql/ -DMYSQL_UNIX_ADDR=/tmp/mysql.sock -DDEFAULT_CHARSET=utf8 -DDEFAULT_COLLATION=utf8_general_ci -DWITH_EXTRA_CHARSETS=all -DWITH_MYISAM_STORAGE_ENGINE=1 -DWITH_INNOBASE_STORAGE_ENGINE=1 -DWITH_MEMORY_STORAGE_ENGINE=1 -DWITH_READLINE=1 -DWITH_INNODB_MEMCACHED=1 -DWITH_DEBUG=OFF -DWITH_ZLIB=bundled -DENABLED_LOCAL_INFILE=1 -DENABLED_PROFILING=ON -DMYSQL_MAINTAINER_MODE=OFF -DMYSQL_DATADIR=/usr/local/webserver/mysql/data -DMYSQL_TCP_PORT=3306
#make命令
make && make install
echo "mysql install end"

#mysql配置
echo "start set mysql config"
#创建mysql运行使用的用户组mysql
/usr/sbin/groupadd mysql
/usr/sbin/useradd -g mysql mysql
#创建binlog和库的存储路径并赋予mysql用户权限
mkdir -p /usr/local/webserver/mysql/binlog /www/data_mysql
chown mysql.mysql /usr/local/webserver/mysql/binlog/ /www/data_mysql/

#将配置文件/etc/my.cnf替换为下面内容
cnf="[client]
port = 3306
socket = /tmp/mysql.sock
[mysqld]
replicate-ignore-db = mysql
replicate-ignore-db = test
replicate-ignore-db = information_schema
user = mysql
port = 3306
socket = /tmp/mysql.sock
basedir = /usr/local/webserver/mysql
datadir = /www/data_mysql
log-error = /usr/local/webserver/mysql/mysql_error.log
pid-file = /usr/local/webserver/mysql/mysql.pid
open_files_limit = 65535
back_log = 600
max_connections = 5000
max_connect_errors = 1000
table_open_cache = 1024
external-locking = FALSE
max_allowed_packet = 32M
sort_buffer_size = 1M
join_buffer_size = 1M
thread_cache_size = 600
#thread_concurrency = 8
query_cache_size = 128M
query_cache_limit = 2M
query_cache_min_res_unit = 2k
default-storage-engine = MyISAM
default-tmp-storage-engine=MYISAM
thread_stack = 192K
transaction_isolation = READ-COMMITTED
tmp_table_size = 128M
max_heap_table_size = 128M
log-slave-updates
log-bin = /usr/local/webserver/mysql/binlog/binlog
binlog-do-db=oa_fb
binlog-ignore-db=mysql
binlog_cache_size = 4M
binlog_format = MIXED
max_binlog_cache_size = 8M
max_binlog_size = 1G
relay-log-index = /usr/local/webserver/mysql/relaylog/relaylog
relay-log-info-file = /usr/local/webserver/mysql/relaylog/relaylog
relay-log = /usr/local/webserver/mysql/relaylog/relaylog
expire_logs_days = 10
key_buffer_size = 256M
read_buffer_size = 1M
read_rnd_buffer_size = 16M
bulk_insert_buffer_size = 64M
myisam_sort_buffer_size = 128M
myisam_max_sort_file_size = 10G
myisam_repair_threads = 1
myisam_recover
interactive_timeout = 120
wait_timeout = 120
skip-name-resolve
#master-connect-retry = 10
slave-skip-errors = 1032,1062,126,1114,1146,1048,1396
#master-host = 192.168.1.2
#master-user = username
#master-password = password
#master-port = 3306
server-id = 1
loose-innodb-trx=0 
loose-innodb-locks=0 
loose-innodb-lock-waits=0 
loose-innodb-cmp=0 
loose-innodb-cmp-per-index=0
loose-innodb-cmp-per-index-reset=0
loose-innodb-cmp-reset=0 
loose-innodb-cmpmem=0 
loose-innodb-cmpmem-reset=0 
loose-innodb-buffer-page=0 
loose-innodb-buffer-page-lru=0 
loose-innodb-buffer-pool-stats=0 
loose-innodb-metrics=0 
loose-innodb-ft-default-stopword=0 
loose-innodb-ft-inserted=0 
loose-innodb-ft-deleted=0 
loose-innodb-ft-being-deleted=0 
loose-innodb-ft-config=0 
loose-innodb-ft-index-cache=0 
loose-innodb-ft-index-table=0 
loose-innodb-sys-tables=0 
loose-innodb-sys-tablestats=0 
loose-innodb-sys-indexes=0 
loose-innodb-sys-columns=0 
loose-innodb-sys-fields=0 
loose-innodb-sys-foreign=0 
loose-innodb-sys-foreign-cols=0

slow_query_log_file=/usr/local/webserver/mysql/mysql_slow.log
long_query_time = 1
[mysqldump]
quick
max_allowed_packet = 32M"

#将替换的内容写入/etc/my.cnf
echo "${cnf}" > /etc/my.cnf


#初始化数据库
/usr/local/webserver/mysql/scripts/mysql_install_db --defaults-file=/etc/my.cnf --basedir=/usr/local/webserver/mysql --user=mysql

#创建开机启动脚本
cd /usr/local/webserver/mysql/
#赋予目录权限
chown -R mysql:mysql ./
cp support-files/mysql.server /etc/rc.d/init.d/mysqld 
chkconfig --add mysqld 
chkconfig --level 35 mysqld on

#启动mysql服务器
service mysqld start

#将mysql设置入环境变量，方便使用
echo 'export PATH=${PATH}:/usr/local/webserver/mysql/bin' >> /etc/profile
#激活加入的环境变量
source /etc/profile
if test $? -eq 0
then
	echo "mysql环境变量设置成功"
else
	echo "mysql环境变量设置失败"
	exit
fi

#连接 MySQL，并创建myapp数据库
mysql << EOF
create database myapp
EOF

if test $? -eq 0
then
	echo "create myapp database success"
else
	echo "create myapp database fail"
	exit
fi
