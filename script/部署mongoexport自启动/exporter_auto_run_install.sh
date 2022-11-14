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


  echo '[Unit]
Description=v2 Mongodb Exporter
After=local-fs.target network-online.target network.target
Wants=local-fs.target network-online.target network.target

[Service]
User='${RUN_USER}'
Group='${RUN_USER_GROUP}'
Type=simple
ExecStart='${RUN_PATH}'/'$EXPORTER_TAR_EXT_NAME'/mongodb_exporter --mongodb.uri=mongodb://'$MONOGO_MONITOR_USER':'$MONOGO_MONITOR_USER_PWD'@localhost:'$MONOGO_PORT' --web.listen-address=:'$EXPORTER_PORT' --collector.dbstats --collector.topmetrics --collector.diagnosticdata --collector.replicasetstatus --collector.indexstats --collector.collstats --collect-all --compatible-mode
Restart=on-failure
RestartSec=30

[Install]
WantedBy=multi-user.target' > /etc/systemd/system/v2_mongodb_export_${MONOGO_PORT}.service

systemctl daemon-reload
systemctl enable v2_mongodb_export_${MONOGO_PORT}

systemctl start v2_mongodb_export_${MONOGO_PORT}

done < $INSTALL_CONFIG

