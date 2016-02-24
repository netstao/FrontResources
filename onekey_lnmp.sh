#!/bin/bash
BEGINTIME=`date +"%Y-%m-%d %H:%M:%S"`

echo $1 
#exit;
ret=$(ps aux | grep -E "php|nginx|mysql" | grep -v grep)
if [ $1 = "killall" ] && [ -n $ret  ] ;then
#kill 掉 nmp进程
ps aux | grep -E "php|nginx|mysql|memcached" | grep -v grep   | gawk '{print $2}' | tr "\n" " " | xargs kill
echo "killall ok"
fi  

current_path=$(pwd)   #脚本当前目录
#检查softs目录	   
if [ ! -d $current_path/softs ]; then
	mkdir -p $current_path/softs
fi
cd $current_path/softs
echo  "当前脚本执行目录: $(pwd)"
echo  "当前系统PATH: $PATH"
/usr/sbin/setenforce 0  #立刻关闭 SELINUX，1为开启
ulimit -SHu 65535
ulimit -SHn 65535  #注ulimit -SHn 65535 等效 ulimit -n 65535 ，-S 指soft #，-H 指hard)
sleep 3
echo "添加yum源"
# 帮助网页在 http://mirrors.163.com/.help/centos.html
if [ ! -f /etc/yum.repos.d/CentOS-Base.repo.bak ];then
 mv /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.bak
fi
v_num=$(cat /etc/redhat-release | grep -o  "[0-9]" | head -1)
yum_url="http://mirrors.163.com/.help/CentOS$v_num-Base-163.repo"
wget $yum_url -O /etc/yum.repos.d/CentOS-Base.repo


#编译环境安装
yum makecache  # 重建cache
yum -y install gcc gcc-c++ autoconf libjpeg libjpeg-devel libpng libpng-devel freetype freetype-devel libxml2 libxml2-devel zlib zlib-devel glibc glibc-devel glib2 glib2-devel bzip2 bzip2-devel ncurses ncurses-devel curl curl-devel e2fsprogs e2fsprogs-devel krb5 krb5-devel libidn libidn-devel openssl openssl-devel openldap openldap-devel nss_ldap openldap-clients openldap-servers libtool libtool-ltdl libtool-ltdl-devel libevent libevent-devel  libmcrypt  libmcrypt-devel libaio-devel cmake ImageMagick-devel  vim-enhanced glibc-common automake expat-devel wget ncurses-devel.x86_64 bison-devel.x86_64 libaio-devel.x86_64 gcc-c++.x86_64 bison readline-devel
#各下载软件url

#全文检索 
coreseek_url="http://www.wapm.cn/uploads/csft/4.0/coreseek-4.1-beta.tar.gz"
#官方版本
#http://sphinxsearch.com/files/sphinx-2.0.6-release.tar.gz

libmemcached = "https://launchpad.net/libmemcached/1.0/1.0.17/+download/libmemcached-1.0.17.tar.gz"

#php 
php_url="http://cn2.php.net/get/php-5.5.4.tar.gz/from/this/mirror"

    ############php扩展系列##################
	
	php_mcrypt_url="http://downloads.sourceforge.net/mcrypt/mcrypt-2.6.8.tar.gz?modtime=1194463373&big_mirror=0"    
	#wget http://nchc.dl.sourceforge.net/project/mcrypt/MCrypt/2.6.8/mcrypt-2.6.8.tar.gz
	
	#一个可以供PHP调用ImageMagick功能的PHP扩展。\
	#使用这个扩展可以使PHP具备和ImageMagick相同的功能。
	php_imagick_url="http://pecl.php.net/get/imagick-3.0.1.tgz"
	
	#Alternative PHP Cache (APC)是一种对PHP有效的开放源高速缓冲储存器工具，\
	#它能够缓存opcode的php中间码。\
    #PHP APC提供两种缓存功能，即缓存Opcode(目标文件)，\
    #我们称之为apc_compiler_cache。\
	#同时它还提供一些接口用于PHP开发人员将用户数据驻留在内存中，\
	#我们称之为apc_user_cache。
	#php_apc_url="http://pecl.php.net/get/APC-3.1.14.tgz"
	
	#php pdo长连接
	php_pdo_mysql_url="http://pecl.php.net/get/PDO_MYSQL-1.0.2.tgz"
	
	#一个可以供PHP调用ImageMagick功能的PHP扩展。使用这个扩展可以使PHP具备和ImageMagick相同的功能。
    php_imagick_url="http://pecl.php.net/get/imagick-3.1.0RC2.tgz"
	#Memcache是一个高性能的分布式的内存对象缓存系统 以下两个都是 php的扩展 
	memcache_url="http://pecl.php.net/get/memcache-3.0.7.tgz"
	memcached_url="http://pecl.php.net/get/memcached-2.1.0.tgz"
	############php扩展系列end#################################################
	
#nginx
#nginx_url="http://nginx.org/download/nginx-1.2.6.tar.gz"

#tengine
tengine_url="http://tengine.taobao.org/download/tengine-1.5.1.tar.gz"

#memcached   守护进程源码 这个是服务端 php扩展也有个memcached 不要搞混
memcached_url="http://memcached.googlecode.com/files/memcached-1.4.15.tar.gz"

#libiconv库为需要做转换的应用提供了一个iconv()的函数，\
#以实现一个字符编码到另一个字符编码的转换 07-Aug-2011 13:59 last update
libiconv_url="http://ftp.gnu.org/pub/gnu/libiconv/libiconv-1.14.tar.gz"

#libmcrypt是加密算法扩展库。支持DES, 3DES, RIJNDAEL, Twofish,\
#IDEA, GOST, CAST-256, ARCFOUR, SERPENT, SAFER+等算法。系统库
libmcrypt_url="ftp://mcrypt.hellug.gr/pub/crypto/mcrypt/libmcrypt/libmcrypt-2.5.7.tar.gz" 

#Mhash扩展库支持12种混编算法
mhash_url="http://nchc.dl.sourceforge.net/project/mhash/mhash/0.9.9.9/mhash-0.9.9.9.tar.bz2"
#wget "http://downloads.sourceforge.net/mhash/mhash-0.9.9.9.tar.gz?modtime=1175740843&big_mirror=0"

#PCRE(Perl Compatible Regular Expressions)是一个Perl库，\
#包括 perl 兼容的正规表达式库。
perl_url="ftp://ftp.csx.cam.ac.uk/pub/software/programming/pcre/pcre-8.34.tar.gz"

#imageMagick是一套功能强大、稳定而且免费的工具集和开发包，\
#可以用来读、写和处理超过89种基本格式的图片文件，\
#包括流行的TIFF、JPEG、GIF、 PNG、PDF以及PhotoCD等格式
imagemagick_url="http://blog.s135.com/soft/linux/nginx_php/imagick/ImageMagick.tar.gz"

#下载CMAKE
cmake_url="http://www.cmake.org/files/v2.8/cmake-2.8.11.tar.gz"

#安装Percona DB  mysql 一个分支 下载Percona DB
mysql_url="http://www.percona.com/redir/downloads/Percona-Server-5.6/Percona-Server-5.6.13-rc60.6/source/Percona-Server-5.6.13-rc60.6.tar.gz"

#Bison is a general-purpose parser generator that converts an annotated context-free grammar into a deterministic LR or generalized LR (GLR) parser employing LALR(1) parser tables. As an experimental feature, Bison can also generate IELR(1) or canonical LR(1) parser tables. Once you are proficient with Bison, you can use it to develop a wide range of language parsers, from those used in simple desk calculators to complex programming languages.
bison_url="http://ftp.gnu.org/gnu/bison/bison-3.0.tar.gz"    
#3.0装Percona-Server-5.6.12-rc60.4 以上的版本失败 改成 2.7 安装成功 错误信息如下
#/sql/sql_yacc.yy: In function ‘int MYSQLparse()’:
#/root/softs/Percona-Server-5.6.14-rel62.0/sql/sql_yacc.yy:81: 错误：给予 function‘int MYSQLlex(void*, void*)’的实参太少
#/root/softs/Percona-Server-5.6.14-rel62.0/sql/sql_yacc.cc:17587: 错误：在文件的这个地方


#gperftools 依赖库
#http://download.savannah.gnu.org/releases/libunwind/libunwind-1.1.tar.gz
#libunwind_url="ftp://mirror.switch.ch/pool/2/mirror/fedora/linux/development/rawhide/x86_64/os/Packages/l/libunwind-1.0.1-4.fc18.x86_64.rpm"
libunwind_url="http://download.savannah.gnu.org/releases/libunwind/libunwind-1.1.tar.gz"
#gperftools
gperftools_url="https://gperftools.googlecode.com/files/gperftools-2.0.tar.gz"

install_log="install.log"
#######开始循环下载##########
urls=($php_url $php_mcrypt_url $php_imagick_url $php_apc_url $php_pdo_mysql_url \
      $php_imagick_url $nginx_url $libiconv_url $libmcrypt_url $memcache_url \
	   $mhash_url $perl_url $imagemagick_url $cmake_url $mysql_url $bison_url \
	   $tengine_url $libunwind_url $gperftools_url $memcached_url $coreseek_url)

color="\033[41;32;5m"
color_end="\033[41;32;0m"

if [ ! -d $current_path/softs ]; then
	mkdir -p $current_path/softs
fi
for url in ${urls[@]}
do
	wget -nc -c "$url" 
    echo "$url" >> $install_log
done	
echo "软件包下载完成" >> $install_log
files=$(pwd)/* #$(ls -la | awk '/^-/{print $NF}')
for file_name in  $files; do
	 #dir_name=${file_name%-*}
	 ext=${file_name##*.}
	if [[ $ext = "tgz" || $ext = "bz2" || $ext = "gz" ]]; then
		tar xvf  $file_name
		echo "$file_name解压完成" >> $install_log
	fi
done
echo "批量解压完成" >> $install_log
default=("libiconv" "libmcrypt" "mhash" "bison" "pcre" "ImageMagick" "libunwind" "cmake" "memcached-1.4.15")

echo $(pwd)

for file_name in ${default[@]} ; do 
   cd ./$file_name*/
   
   if [ "$file_name" = "libmcrypt" ]; then
		/sbin/ldconfig
		cd libltdl/
		./configure --enable-ltdl-install && make && make install
		cd ../
        ./configure && make && make install
         echo "$file_name安装完成" >> $install_log
    elif [ "$file_name" = "libunwind" ];then
		CFLAGS=-fPIC ./configure
		make CFLAGS=-fPIC  && \
		make CFLAGS=-fPIC install
         echo "$file_name安装完成" >> $install_log
	elif [ $file_name = "memcached-1.4.15" ];then
	     ./configure --prefix=/usr/local/webserver/memcached  --enable-64bit 
		 make && make install 
         echo "$file_name安装完成" >> $install_log
    else 
		./configure && make && make install
        echo "$file_name安装完成" >> $install_log
   fi
   cd ../
done

ln -s /usr/local/lib/libmcrypt.la /usr/lib/libmcrypt.la  \
ln -s /usr/local/lib/libmcrypt.so /usr/lib/libmcrypt.so  \
ln -s /usr/local/lib/libmcrypt.so.4 /usr/lib/libmcrypt.so.4    \
ln -s /usr/local/lib/libmcrypt.so.4.4.8 /usr/lib/libmcrypt.so.4.4.8  \
ln -s /usr/local/lib/libmhash.a /usr/lib/libmhash.a   \
ln -s /usr/local/lib/libmhash.la /usr/lib/libmhash.la   \
ln -s /usr/local/lib/libmhash.so /usr/lib/libmhash.so   \
ln -s /usr/local/lib/libmhash.so.2 /usr/lib/libmhash.so.2   \
ln -s /usr/local/lib/libmhash.so.2.0.1 /usr/lib/libmhash.so.2.0.1    \
ln -s /usr/local/bin/libmcrypt-config /usr/bin/libmcrypt-config  

cd mcrypt*/
/sbin/ldconfig
 export LD_LIBRARY_PATH=/usr/lib64:/usr/lib:/usr/local/lib64:/usr/local/lib:$LD_LIBRARY_PATH   && ./configure \
 && make && make install
cd ../
echo "mcrypt安装完成" >> $install_log

#mysql安装
#
/usr/sbin/groupadd mysql  && 
/usr/sbin/useradd -g mysql mysql

  ####copy sphinxse 到mysql 存储引擎目录 准备安装
cd coreseek*/
if [ ! -d  ../Percona-Server-5.6.12-rc60.4/storage/sphinx ];then
		mkdir -p ../Percona-Server-5.6.12-rc60.4/storage/sphinx
fi
cd csft-*/
cp -rf ./mysqlse/* ../../Percona-Server-5.6.12-rc60.4/storage/sphinx

cd ../../

chown -R root:root ./Percona-Server-5.6.14-rel62.0
cd  ./Percona-Server-5.6.14-rel62.0/


sh BUILD/autorun.sh
#配置 安装
cmake . -DCMAKE_INSTALL_PREFIX=/usr/local/webserver/mysql  \
    -DDEFAULT_CHARSET=utf8  -DWITH_EXTRA_CHARSETS=all \
    -DWITH_SSL=system \
    -DWITH_EMBEDDED_SERVER=1 \
    -DENABLED_LOCAL_INFILE=1 \
    -DDEFAULT_COLLATION=utf8_general_ci \
    -DWITH_MYISAM_STORAGE_ENGINE=1 \
    -DWITH_INNOBASE_STORAGE_ENGINE=1 \
     -DWITH_DEBUG=0 -DWITH_DTRACE=0     \
     -DWITH_SPHINX_STORAGE_ENGINE=1 \
	 
	 cmake -DCMAKE_INSTALL_PREFIX=/usr/local/webserver/mysq_5.7 \
-DWITH_INNOBASE_STORAGE_ENGINE=1 \
-DWITH_ARCHIVE_STORAGE_ENGINE=1 \
-DWITH_BLACKHOLE_STORAGE_ENGINE=1 \
-DWITH_FEDERATED_STORAGE_ENGINE=1 \
-DWITH_PARTITION_STORAGE_ENGINE=1 \
-DEXTRA_CHARSETS=all -DDEFAULT_CHARSET=utf8  -DDEFAULT_COLLATION=utf8_general_ci 
    
 && 
make && make install 
echo "mysql安装完成" >> $install_log
  

  
  
chmod +w /usr/local/webserver/mysql  && 
chown -R mysql:mysql /usr/local/webserver/mysql   &&
mkdir -p /data/mysql/3307/data/    &&
mkdir -p /data/mysql/3307/binlog/    &&
mkdir -p /data/mysql/3307/relaylog/   && 
chown -R mysql:mysql /data/mysql/  
echo "mysql目录配置完成" >> $install_log


cp support-files/my-default.cnf /data/mysql/3307/my.cnf 
echo echo "mysql my.cnf" >> $install_log
cat >/data/mysql/3307/my.cnf  <<EOF 
[client]
character-set-server = utf8
port    = 3307
socket  = /tmp/mysql.sock

[mysqld]
character-set-server = utf8
replicate-ignore-db = mysql
replicate-ignore-db = test
replicate-ignore-db = information_schema
user    = mysql
port    = 3307
socket  = /tmp/mysql.sock
basedir = /usr/local/webserver/mysql
datadir = /data/mysql/3307/data
log-error = /data/mysql/3307/mysql_error.log
pid-file = /data/mysql/3307/mysql.pid
open_files_limit    = 10240
back_log = 600
max_connections = 5000
max_connect_errors = 6000
external-locking = FALSE
max_allowed_packet = 32M
sort_buffer_size = 1M
join_buffer_size = 1M
thread_cache_size = 300
#thread_concurrency = 8
query_cache_size = 64M
query_cache_limit = 2M
query_cache_min_res_unit = 2k
default-storage-engine = MyISAM
thread_stack = 192K
transaction_isolation = READ-COMMITTED
tmp_table_size = 64M
max_heap_table_size = 64M
long_query_time = 3
log-slave-updates
log-bin = /data/mysql/3307/binlog/binlog
binlog_cache_size = 4M
binlog_format = MIXED
max_binlog_cache_size = 8M
max_binlog_size = 1G
relay-log-index = /data/mysql/3307/relaylog/relaylog
relay-log-info-file = /data/mysql/3307/relaylog/relaylog
relay-log = /data/mysql/3307/relaylog/relaylog
expire_logs_days = 30
key_buffer_size = 128M
read_buffer_size = 1M
read_rnd_buffer_size = 16M
bulk_insert_buffer_size = 64M
myisam_sort_buffer_size = 64M
myisam_max_sort_file_size = 10G
myisam_repair_threads = 1
myisam_recover

interactive_timeout = 120
wait_timeout = 120

skip-name-resolve
#master-connect-retry = 10
slave-skip-errors = 1032,1062,126,1114,1146,1048,1396

#master-host     =   192.168.1.2
#master-user     =   username
#master-password =   password
#master-port     =  3306

server-id = 1

innodb_additional_mem_pool_size = 16M
innodb_buffer_pool_size = 64M
innodb_data_file_path = ibdata1:256M:autoextend
innodb_file_io_threads = 4
innodb_thread_concurrency = 8
innodb_flush_log_at_trx_commit = 2
innodb_log_buffer_size = 16M
innodb_log_file_size = 128M
innodb_log_files_in_group = 3
innodb_max_dirty_pages_pct = 90
innodb_lock_wait_timeout = 120
innodb_file_per_table = 1
innodb_open_files=300

#log-slow-queries = /data/mysql/3307/slow.log
#long_query_time = 10

[mysqldump]
quick
max_allowed_packet = 32M
EOF


#较小内存配置
cat >/data/mysql/3307/my.cnf <<EOF
[client]
port    = 3307
socket  = /tmp/mysql.sock

[mysql]
prompt="\u@\h[\d]> " #mysql提示符
no-auto-rehash

[mysqld]
user    = mysql
port    = 3307
socket  = /tmp/mysql.sock
basedir = /usr/local/webserver/mysql
datadir = /data/mysql/3307/data
log-error = /data/mysql/3307/mysql_error.log
pid-file = /data/mysql/3307/mysql.pid
#log-slow-queries = /data/mysql/3307/slow.log
explicit_defaults_for_timestamp=true
open_files_limit    = 600
back_log = 20
max_connections = 1000
max_connect_errors = 200
external-locking = FALSE
max_allowed_packet = 16M
sort_buffer_size = 128K
join_buffer_size = 128K
thread_cache_size = 10
thread_concurrency = 8
query_cache_size = 0M
query_cache_limit = 2M
query_cache_min_res_unit = 2k
thread_stack = 192K
transaction_isolation = READ-UNCOMMITTED
tmp_table_size = 512K
max_heap_table_size = 32M
long_query_time = 1
server-id = 1
#log-bin = /usr/local/mysql/data/binlog
binlog_cache_size = 2M
max_binlog_cache_size = 4M
max_binlog_size = 512M
expire_logs_days = 7
key_buffer_size = 4M
read_buffer_size = 1M
read_rnd_buffer_size = 2M
bulk_insert_buffer_size = 2M
myisam_sort_buffer_size = 4M
myisam_max_sort_file_size = 10G
myisam_repair_threads = 1
myisam_recover

innodb_file_per_table = 1
innodb_open_files=300



[mysqldump]
quick
max_allowed_packet = 16M
EOF

#初始化数据库
/usr/local/webserver/mysql/scripts/mysql_install_db --defaults-file=/data/mysql/3307/my.cnf  --user=mysql  --basedir=/usr/local/webserver/mysql  --datadir=/data/mysql/3307/data 

#5.7 
mysqld --initialize-insecure --user=mysql --basedir=/usr/local/mysql_5.7 --datadir=/data/mysql/3306/data

#/usr/local/mysql_5.7/bin/mysqld_safe --defaults-file=/data/mysql/3306/my.cnf 2>&1 > /dev/null &

echo echo "mysql初始化数据库完成" >> $install_log

#创建管理脚本
if [ ! -d ~/sh ]; then
	mkdir -p ~/sh
fi
cat >~/sh/mysql.sh <<EOF
#!/bin/bash

mysql_port="3307"
mysql_username="root"
mysql_password="123456"

function_start_mysql()
{
    printf "Starting MySQL...\n"
     /usr/local/webserver/mysql/bin/mysqld_safe --defaults-file=/data/mysql/\$mysql_port/my.cnf 2>&1 > /dev/null &
	
}

function_stop_mysql()
{
    printf "Stoping MySQL...\n"
    /usr/local/webserver/mysql/bin/mysqladmin -u \${mysql_username} -p\${mysql_password} -S /tmp/mysql.sock shutdown 2>&1 > /dev/null &
	sleep 3
}

function_restart_mysql()
{
    printf "Restarting MySQL...\n"
    function_stop_mysql
    sleep 5
    function_start_mysql
}

function_kill_mysql()
{
    kill  \$(ps aux | grep mysql | grep -v grep | gawk '{print \$2}' | tr -s "\n" " ")
	#kill \$(ps ef | grep bin/mysqld_safe | grep -v /bin/grep | gawk '{print \$1}')
	echo 'kill done'
	
}

if [ "\$1" = "start" ]; then
    function_start_mysql
elif [ "\$1" = "stop" ]; then
    function_stop_mysql
elif [ "\$1" = "restart" ]; then
function_restart_mysql
elif [ "\$1" = "kill" ]; then
function_kill_mysql
else
    printf "Usage: /data/mysql/\$mysql_port/mysql {start|stop|restart|kill}\n"
fi
EOF

chmod +x ~/sh/mysql.sh
 
#启动数据库
#/data/sh/mysql.sh start

/usr/local/webserver/mysql/bin/mysql -u root  -S /tmp/mysql.sock -e "GRANT ALL PRIVILEGES ON *.* TO root@'localhost' IDENTIFIED BY '123456';GRANT ALL PRIVILEGES ON *.* TO root@'127.0.0.1' IDENTIFIED BY '123456';flush privileges;"
/usr/local/mysql_5.7/bin/mysql -u root  -S /var/run/mysql/mysql.sock -e "GRANT ALL PRIVILEGES ON *.* TO root@'localhost' IDENTIFIED BY '';GRANT ALL PRIVILEGES ON *.* TO root@'127.0.0.1' IDENTIFIED BY '123456';flush privileges;"

#/data/sh/mysql.sh stop && 
 cp -frp /usr/lib64/libldap* /usr/lib/ && 
  ln -s /usr/local/webserver/mysql/lib /usr/local/webserver/mysql/lib64  &&
 ln -s /usr/local/webserver/mysql/lib/libmysqlclient.so.18  /usr/lib64/  
/
 ln -s /usr/lib64/libperconaserverclient.so /usr/lib64/libmysqlclient.so
 ln -s /usr/lib64/libperconaserverclient.so.18 /usr/lib64/libmysqlclient.so.18
cd ../

###############安装 全文检索引擎##########
cd coreseek-4.1*/
  cd mmseg-3*/
   ./bootstrap
    ./configure --prefix=/usr/local/mmseg3
	 make && make install
	 cd  ./data/
	 /usr/local/mmseg3/bin/mmseg -u unigram.txt
	 cp -ua ./unigram.txt.uni /usr/local/coreseek/dict/uni.lib
	 cd ../../csft-*/
	 sh buildconf.sh
	 ./configure --prefix=/usr/local/coreseek  --without-unixodbc --with-mmseg --with-mmseg-includes=/usr/local/mmseg3/include/mmseg/ --with-mmseg-libs=/usr/local/mmseg3/lib/ --with-mysql --without-iconv
	 make && make install 
	 #cp -ua ../testpack/etc/csft_mysql.conf /usr/local/coreseek/etc/csft_mysql.conf
	 ####
	 
	 
	 ##############分词源配置#######################
	 prefix="/usr/local/coreseek"
     cat > /usr/local/coreseek/etc/csft_mysql.conf <<EOF
#MySQL数据源配置，详情请查看：http://www.coreseek.cn/products-install/mysql/
#请先将var/test/documents.sql导入数据库，并配置好以下的MySQL用户密码数据库

#源定义
source mysql
{
    type                    = mysql
    sql_host                = 127.0.0.1
    sql_user                = admin
    sql_pass                = 12345678
    sql_db                    = test
    sql_port                = 3306
    sql_query_pre            = SET NAMES utf8

    sql_query                = SELECT id, group_id, UNIX_TIMESTAMP(date_added) AS date_added, title, content FROM documents
                                                              #sql_query第一列id需为整数
                                                              #title、content作为字符串/文本字段，被全文索引
    sql_attr_uint            = group_id           #从SQL读取到的值必须为整数
    sql_attr_timestamp        = date_added #从SQL读取到的值必须为整数，作为时间属性

    sql_query_info_pre      = SET NAMES utf8                                        #命令行查询时，设置正确的字符集
    sql_query_info            = SELECT * FROM documents WHERE id=\$id #命令行查询时，从数据库读取原始数据信息
}

#index定义
index mysql
{
    source            = mysql             #对应的source名称
    path            = $prefix/var/data/mysql #请修改为实际使用的绝对路径，例如：/usr/local/coreseek/var/...
    docinfo            = extern
    mlock            = 0
    morphology        = none
    min_word_len        = 1
    html_strip                = 0

    #中文分词配置，详情请查看：http://www.coreseek.cn/products-install/coreseek_mmseg/
	#stopwords		= /path/to/stowords.txt #禁止搜索关键字的位置
    charset_dictpath = /usr/local/mmseg3/etc/ #BSD、Linux环境下设置，/符号结尾
    #charset_dictpath = etc/                             #Windows环境下设置，/符号结尾，最好给出绝对路径，例如：C:/usr/local/coreseek/etc/...
    charset_type        = utf-8
	charset_table      = 0..9, A..Z->a..z, _, a..z, U+410..U+42F->U+430..U+44F, U+430..U+44F 
	ngram_len        = 0
}

#全局index定义
indexer
{
    mem_limit            = 128M
}

#searchd服务定义
searchd
{
    listen                  =   9312
    read_timeout        = 5
    max_children        = 30
    max_matches            = 1000
    seamless_rotate        = 0
    preopen_indexes        = 0
    unlink_old            = 1
    pid_file = $prefix/var/log/searchd_mysql.pid  #请修改为实际使用的绝对路径，例如：/usr/local/coreseek/var/...
    log = $prefix/var/log/searchd_mysql.log        #请修改为实际使用的绝对路径，例如：/usr/local/coreseek/var/...
    query_log = $prefix/var/log/query_mysql.log #请修改为实际使用的绝对路径，例如：/usr/local/coreseek/var/...
    binlog_path =                                #关闭binlog日志
}
EOF
    cd ../../
    /usr/local/coreseek/bin/indexer -c /usr/local/coreseek/etc/csft_mysql.conf --all 
	/usr/local/coreseek/bin/searchd -c /usr/local/coreseek/etc/csft_mysql.conf
	/usr/local/coreseek/bin/indexer -c  /usr/local/coreseek/etc/csft_mysql.conf --all --rotate
#启动
#/usr/local/coreseek/bin/searchd -c /usr/local/coreseek/etc/csft_mysql.conf
#停止
#/usr/local/coreseek/bin/searchd -c /usr/local/coreseek/etc/csft_mysql.conf --stop  
#更新索引
#/usr/local/coreseek/bin/indexer -c  /usr/local/coreseek/etc/csft_mysql.conf --all --rotate
		 
		 
##########################安装php#############################
if [ ! -d  /usr/local/webserver/php/etc ] ;then 
	mkdir -p /usr/local/webserver/php/etc
fi

/usr/sbin/groupadd www
/usr/sbin/useradd -g www www

mkdir -p /www
chmod +w /www
chown -R www:www /www

cd php* 
./configure --prefix=/usr/local/webserver/php \
--with-config-file-path=/usr/local/webserver/php/etc \
--with-mysql=mysqlnd \
--with-mysqli=mysqlnd \
--with-pdo-mysql=mysqlnd \
--with-iconv-dir=/usr/local \
--with-freetype-dir \
--with-jpeg-dir \
--with-png-dir\
 --with-zlib \
 --with-libxml-dir=/usr/local\
 --enable-xml\
 --disable-rpath \
 --enable-bcmath \
 --enable-shmop \
 --enable-sysvsem \
 --enable-inline-optimization \
 --with-curl --enable-mbregex  \
 --enable-fpm  \
 --enable-mbstring \
 --with-mcrypt \
 --with-gd \
--enable-gd-native-ttf \
--with-openssl \
--with-mhash \
--enable-pcntl \
--enable-sockets \
--with-ldap \
--with-ldap-sasl \
--with-xmlrpc \
--enable-zip \
--enable-soap \
--without-pear  \
--with-libdir=lib64  \
--enable-opcache=no
 make ZEND_EXTRA_LIBS='-liconv' -j4  &&   make install 


cp -u php.ini-production /usr/local/webserver/php/etc/php.ini
cd ../ 

cd memcache-3.0.7/

/usr/local/webserver/php/bin/phpize 
./configure --with-php-config=/usr/local/webserver/php/bin/php-config
make && make install
cd ../

#5.5以后不用apc
#cd APC*/
#/usr/local/webserver/php/bin/phpize && \
#./configure --with-php-config=/usr/local/webserver/php/bin/php-config  --enable-apc-mmap --enable-apc --enable-apc-filehits&& \
#make && make install
#cd ../

ln -s /usr/local/webserver/mysql/include/* /usr/local/include/

cd PDO_MYSQL*/
/usr/local/webserver/php/bin/phpize && \
./configure --with-php-config=/usr/local/webserver/php/bin/php-config --with-pdo-mysql=/usr/local/webserver/mysql && \
make && make install
cd ../

cd imagick*/
/usr/local/webserver/php/bin/phpize && \
./configure --with-php-config=/usr/local/webserver/php/bin/php-config   --with-libdir=lib64 && \
make && make install
cd ../

######php 各种优化 #######
php_ini="/usr/local/webserver/php/etc/php.ini"
sed -i 's#extension_dir = "./"#\nextension_dir = "/usr/local/webserver/php/lib/php/extensions/no-debug-non-zts-20121212/"\nextension = "memcache.so"\nextension = "pdo_mysql.so"\nextension = "imagick.so"\n#' $php_ini \
sed -i 's#output_buffering = Off#output_buffering = On#' $php_ini  \
sed -i "s#;always_populate_raw_post_data = On#always_populate_raw_post_data = On#g"  $php_ini \
sed -i "s#;cgi.fix_pathinfo=0#cgi.fix_pathinfo=0#g" $php_ini \
sed -i 's#expose_php = On#expose_php = Off#'  $php_ini  \
sed -i 's#disable_functions =#disable_functions =exec,passthru,shell_exec,system,proc_open,popen,curl_exec,curl_multi_exec,parse_ini_file,show_source;#' $php_ini  \
sed -i "s#session.save_handler =#session.save_handler = memcache;#" $php_ini  \
sed -i "s#session.save_path =#session.save_path ='tcp://127.0.0.1:11211?persistent=1&weight=1&timeout=1&retry_interval=15';##" $php_ini \

#swoole
#./configure   --enable-sockets  --enable-async-mysql  --with-php-config=/usr/local/webserver/php/bin/php-config

#php-fpm 优化
php_fpm_path="/usr/local/webserver/php/etc/php-fpm.conf"
cp -u /usr/local/webserver/php/etc/php-fpm.conf.default $php_fpm_path
sed -i "s#;rlimit_files = 1024#rlimit_files = 65535#" $php_fpm_path
children_num=50  #每个子进程消耗 20M左右 50*20=1G
sed -i "s#pm.max_children#pm.max_children = $children_num;#" $php_fpm_path
ret_num=8000
sed -i "s#;pm.max_requests#;pm.max_requests = $ret_num;#" $php_fpm_path
sed -i "s#user = nobody#user = www#" $php_fpm_path \
sed -i "s#group = nobody#group = www#" $php_fpm_path

#/usr/local/webserver/php/sbin/php-fpm -t && \
#/usr/local/webserver/php/sbin/php-fpm 
#linsten="/tmp/php-cgi.sock" 配置 sock通讯
#############nginx安装################
#rpm -ivh ./libunwind-1.0.1-4.fc18.x86_64.rpm

#安装替换标准c库的内存分配函数malloc 50ns完成一次内存分配 而标准c需要300ns
cd gperftools* 
./configure && \
make  -j2 && make install
#注释：64位系统必须添加:--enable-frame-pointers
echo "/usr/local/lib" >> /etc/ld.so.conf.d/usr_local_lib.conf 
echo "/usr/local/include" >> /etc/ld.so.conf 
/sbin/ldconfig
/sbin/ldconfig -N
#为 gperftools 添加线程目录:
mkdir -p /tmp/tcmalloc
chmod 0777 /tmp/tcmalloc
cd ../

#export LD_PRELOAD=/usr/local/lib/libtcmalloc_minimal.so
sed -i 's#executing mysqld_safe#executing mysqld_safe\nexport LD_PRELOAD=/usr/local/lib/libtcmalloc_minimal.so\n#' /usr/local/webserver/mysql/bin/mysqld_safe
#文件位置:nginx-1.3.4/auto/lib/google-perftools/conf。将文件中的/usr/local/lib替换成你安##装的位置,我的位置是/usr/local/googleopreftools,然后再次编译就不会出现上面的错误。我的编
ln -s   /usr/local/lib/libtcmalloc_minimal.so.4.1.0  /usr/local/lib/libtcmalloc.so
ln -s   /usr/local/lib/libtcmalloc_minimal.so.4.1.0  /usr/local/lib/libtcmalloc.so.4
ln -s /usr/local/lib/libprofiler.so /lib64/libprofiler.so.0

cd nginx*
#sed -i "s#/usr/local#/usr/local/gperftools#g" auto/lib/google-perftools/conf && \
#sed -i "s#/opt/local#/usr/local/gperftools#g" auto/lib/google-perftools/conf

./configure --user=www --group=www  --prefix=/usr/local/webserver/nginx \
--with-http_stub_status_module --with-http_ssl_module --with-http_flv_module \
--with-http_gzip_static_module --with-google_perftools_module  --http-fastcgi-temp-path=/tmp/fast_cache && \
make -j2 && make install
cd ../

if [ ! -d /usr/local/webserver/nginx/conf/sites ]; then
	mkdir -p  /usr/local/webserver/nginx/conf/sites
fi

woker_num=$(cat /proc/cpuinfo  | grep processor | wc -l)
#sysctl -a | grep fs.file 查看linux系统文件描述符的方法：
#getconf PAGESIZE 内存分页大小  4k
cat >/usr/local/webserver/nginx/conf/nginx.conf <<EOF
user  www www;

worker_processes $woker_num;
#为每个进程分配cpu，例中将8个进程分配到8 个cpu，当然可以写多个，或者将一
#个进程分配到多个cpu。
#worker_cpu_affinity 00000001 00000010 00000100 00001000 00010000 00100000 01000000 10000000;
error_log  /usr/local/webserver/nginx/logs/nginx_error.log  crit;

pid        /usr/local/webserver/nginx/nginx.pid;
google_perftools_profiles /tmp/tcmalloc;
#Specifies the value for maximum file descriptors that can be opened by #this process.
worker_rlimit_nofile 65535;

events
{
  use epoll;
  worker_connections 65535;
  #每个进程允许的最多连接数,理论上每台nginx #服务器的最大连接数为worker_processes*worker_connections。
}

http
{
  include       mime.types;
  default_type  application/octet-stream;

  charset  utf-8;

  server_names_hash_bucket_size 128;
  large_client_header_buffers 4 32k;
  client_max_body_size 8m;

  sendfile on;
  tcp_nopush     on;

  keepalive_timeout 60;
 
   fastcgi_cache_path   /tmp/fastcgi_cache  levels=1:2
                       keys_zone=TEST:10m
                       inactive=5m;
  client_header_buffer_size 4k;
  #客户端请求头部的缓冲区大小，这个可以根据你的系统分页大小来设置，一般一个请求头的大小不#会超过1k，不过由于一般系统分页都要大于1k，所以这里设置为分页大小。
  
  open_file_cache max=65535 inactive=20s;
  #这个将为打开文件指定缓存，默认是没有启用的，max #指定缓存数量，建议和打开文件数一致，inactive 是指经过多长时间文件没被请求后删除缓存。
  open_file_cache_valid 80s; #这个是指多长时间检查一次缓存的有效信息。
  open_file_cache_min_uses 1;
  #open_file_cache 指令中的inactive #参数时间内文件的最少使用次数，如果超过这个数字，文件描述符一直是在缓存中打开的，如上例#，如果有一个文件在inactive 时间内一次没被使用，它将被移除。
  tcp_nodelay on;

  fastcgi_connect_timeout 300;
  fastcgi_send_timeout 300;
  fastcgi_read_timeout 300;
  fastcgi_buffer_size 64k;
  fastcgi_buffers 4 64k;
  fastcgi_busy_buffers_size 128k;
  fastcgi_temp_file_write_size 128k;
  fastcgi_cache TEST;
  fastcgi_cache_valid 200 302 1h;
  fastcgi_cache_valid 301 1d;
  fastcgi_cache_valid any 1m;

#为指定的应答代码指定缓存时间，如上例中将200，302 应答缓存一小时，301 应答缓存1 
#天，其他为1 分钟。
  fastcgi_cache_min_uses 1;
  fastcgi_cache_use_stale error timeout invalid_header http_500;

   

#缓存在fastcgi_cache_path 指令inactive 参数值时间内的最少使用次数，如上例，如果在5 #分钟内某文件1 次也没有被使用，那么这个文件将被移除。
  gzip off;
  gzip_min_length  1k;
  gzip_buffers     4 16k;
  gzip_http_version 1.0;
  gzip_comp_level 2;
  gzip_types       text/plain application/x-javascript text/css application/xml;
  gzip_vary on;

  log_format  main  '\$remote_addr - \$remote_user [\$time_local] \$request '
                    '"\$status" \$body_bytes_sent' "\$http_referer"
                    '"\$http_user_agent" "\$http_x_forwarded_for"';

  server
  {
    listen          80;
    server_name     denyipaccess;
    index index.php index.html;
    root /dev/null;
	#location /ustats {

	 #ustats memsize=3m;

	 #ustats_refresh_interval 6000;

	 #ustats_html_table_width 95;

	 #ustats_html_table_height 95;

	#}  
  }
  
  include sites/*.conf;

}
EOF



#/usr/sbin/lsof -n | grep tcmalloc
mkdir -p /data/logs
chmod +w /data/logs
chown -R www:www /data/logs


#/usr/local/webserver/nginx/sbin/nginx -t && 
#/usr/local/webserver/nginx/sbin/nginx 

#/usr/local/webserver/nginx/sbin/nginx -s quit nginx 退出 
#ps aux | grep php | grep -v grep | gawk '{print $2}' | tr -s "\n" " " | #xargs kill
#开机自动启动
line_num=$(cat /etc/rc.local | grep -E "memcached|php-fpm|nginx|mysql|SHu|SHn" | wc -l)
if [ $line_num -le 0 ];then
cat >/etc/rc.local<<EOF
ulimit  -SHu 65535
ulimit -SHn 65535
/data/sh/mysql.sh start
/usr/local/webserver/php/sbin/php-fpm 
/usr/local/webserver/nginx/sbin/nginx
/usr/local/webserver/memcached/bin/memcached -l 127.0.0.1 -p 11211 -d -u www -m 128 -P /usr/local/webserver/memcached/pid/memcached.pid
EOF
fi
line_num=$(cat /etc/security/limits.conf | grep 65535 | wc -l)
if [ $line_num -le 0 ]; then
cat >>/etc/security/limits.conf<<EOF
* soft nofile 65535
* hard nofile 65535
* soft nproc 65535
* hard nproc 65535
EOF
fi

if [ ! -f /etc/sysctl.conf.bak ];then
	cp /etc/sysctl.conf /etc/sysctl.conf.bak
fi
line_num=$(cat /etc/sysctl.conf  | grep 65536 | wc -l)
if [ $line_num -le 0 ];then
cat >>/etc/sysctl.conf<<EOF
net.ipv4.ip_forward = 0
net.ipv4.conf.default.rp_filter = 1
net.ipv4.conf.default.accept_source_route = 0
kernel.sysrq = 0
kernel.core_uses_pid = 1
net.ipv4.tcp_syncookies = 1
kernel.msgmnb = 65536
kernel.msgmax = 65536
kernel.shmmax = 68719476736
kernel.shmall = 4294967296
net.ipv4.tcp_max_tw_buckets = 6000
net.ipv4.tcp_sack = 1
net.ipv4.tcp_window_scaling = 1
net.ipv4.tcp_rmem = 4096 87380 4194304
net.ipv4.tcp_wmem = 4096 16384 4194304
net.core.wmem_default = 8388608
net.core.rmem_default = 8388608
net.core.rmem_max = 16777216
net.core.wmem_max = 16777216
net.core.netdev_max_backlog = 262144
net.core.somaxconn = 262144
net.ipv4.tcp_max_orphans = 3276800
net.ipv4.tcp_max_syn_backlog = 262144
net.ipv4.tcp_timestamps = 0
net.ipv4.tcp_synack_retries = 1
net.ipv4.tcp_syn_retries = 1
net.ipv4.tcp_tw_recycle = 1
net.ipv4.tcp_tw_reuse = 1
net.ipv4.tcp_mem = 94500000 915000000 927000000
net.ipv4.tcp_fin_timeout = 1
net.ipv4.tcp_keepalive_time = 30
net.ipv4.ip_local_port_range = 1024 65000
EOF
fi

/sbin/sysctl -p
echo "内核优化结束"
echo "正在启动mysql....."
/data/sh/mysql.sh start
echo "正在检查php-fpm.conf配置文件....."
/usr/local/webserver/php/sbin/php-fpm -t 
echo "正在启动php-fpm...."
/usr/local/webserver/php/sbin/php-fpm 
echo "正在检查nginx.conf文件...."
/usr/local/webserver/nginx/sbin/nginx -t 
echo "正在启动nginx...."
/usr/local/webserver/nginx/sbin/nginx 
echo "正在启动memechahed....."
memsize=$(free -m | awk '{print $2}' | head -2 | grep -E "[0-9]")
if [ $memsize -le 1024 ];then
memsize=128
elif [ $memsize -ge 7863 ] ; then
memsize=512
elif [ $memsize -ge 32099 ] ; then
memsize=1024
fi
/usr/local/webserver/memcached/bin/memcached -l 127.0.0.1 -p 11211  -d -u www -m $memsize -P /usr/local/webserver/memcached/pid/memcached.pid
echo "lnmp&memcached启动完成."

CREATE TABLE documents_sphinxse
(
    id          INTEGER UNSIGNED NOT NULL,
    weight      INTEGER NOT NULL,
    query       VARCHAR(3072) NOT NULL,
    group_id    INTEGER,
    INDEX(query)
) ENGINE=SPHINX CONNECTION="sphinx://localhost:9312/mysql";



#linux 默认值 open files 和 max user processes 为 1024
#ulimit -n #open files
#1024
#ulimit -u  #max user processes
#1024
#问题描述： 说明 server 只允许同时打开 1024 个文件，处理 1024 个用户进程
#使用ulimit -a 可以查看当前系统的所有限制值
#ps aux | grep -E "php|mysql|nginx"  查看 lnmp  是否运行



####ngixn 脚本切割日志
#cat >>/data/sh/cut_nginx_log.sh<<EOF\
#!/bin/bash
# This script run at 00:00
# The Nginx logs path
#logs_path_kerry="/data/logs/www/"
#logs_path_kerry="/data/logs/www/"
#mv ${logs_path_kerry}kerry_nginx.log ${logs_path_kerry}$kerry_nginx_$(date -d #"yesterday" +"%Y%m%d").log
#mv ${logs_path_king}king_nginx.log ${logs_path_king}king_nginx_$(date -d "yesterday" #+"%Y%m%d").log
#kill -USR1 `cat /usr/local/nginx/nginx.pid`
#EOF

#pmap -x  pid  # 查看线程栈的大小
#ll /proc/pid/fd/  #查看那进程打开的文件描述符 
