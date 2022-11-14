EXPORTER_TAR_PATH=$1;
EXPORTER_TAR_EXT_NAME=$2
INSTALL_CONFIG=$3;

ip=$(ip addr | awk '/^[0-9]+: / {}; /inet.*global/ {print gensub(/(.*)\/(.*)/, "\\1", "g", $2)}')


while read mongodbConfig
do
 echo "config:"$mongodbConfig
 array=(${mongodbConfig//,/ })
 RUN_USER=${array[0]}
 RUN_USER_GROUP=${array[1]}
 RUN_PATH=${array[2]}
 MONOGO_PORT=${array[3]}
 EXPORTER_PORT=${array[4]}
 MONOGO_MONITOR_USER=${array[5]}
 MONOGO_MONITOR_USER_PWD=${array[6]}

 cd $RUN_PATH
 if [ -d ./$EXPORTER_TAR_EXT_NAME ];then
    echo $EXPORTER_TAR_EXT_NAME'已经存在，无需解压'
 else
    sudo tar -zxvf $EXPORTER_TAR_PATH > /dev/null
    sudo chown -R $RUN_USER:$RUN_USER_GROUP ./$EXPORTER_TAR_EXT_NAME
 fi

 sudo -u $RUN_USER nohup ./$EXPORTER_TAR_EXT_NAME/mongodb_exporter --mongodb.uri=mongodb://$MONOGO_MONITOR_USER:$MONOGO_MONITOR_USER_PWD@localhost:$MONOGO_PORT --web.listen-address=:$EXPORTER_PORT --collector.dbstats --collector.topmetrics --collector.diagnosticdata --collector.replicasetstatus --collector.indexstats --collector.collstats --collect-all --compatible-mode &
  echo 'mongodb端口'$MONOGO_PORT'监控exporter部署完毕，exporter对外地址为'$ip':'$EXPORTER_PORT

done < $INSTALL_CONFIG



while read mongodbConfig
do
 array=(${mongodbConfig//,/ })
 RUN_USER=${array[0]}
 RUN_USER_GROUP=${array[1]}
 RUN_PATH=${array[2]}
 MONOGO_PORT=${array[3]}
 EXPORTER_PORT=${array[4]}
 MONOGO_MONITOR_USER=${array[5]}
 MONOGO_MONITOR_USER_PWD=${array[6]}

 curl 'localhost:'$EXPORTER_PORT > /dev/null

  if [ $? -eq 0 ];then
#    succe
    echo 'mongodb端口'$MONOGO_PORT'监控正常'
  else
    echo 'mongodb端口'$MONOGO_PORT'监控异常，无法访问'$ip':'$EXPORTER_PORT
  fi

done < $INSTALL_CONFIG
