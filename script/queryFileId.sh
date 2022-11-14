MONGO_HOST=$1;
MONGO_PORT=$2;
MONGO_USER=$3;
MONGO_PASSWD=$4;

MONGO_DB_NAME=$5;
MONGO_COLLECTIONS=$6;
LIMIT=$7;
SKIP=$8
UPLOAD_DATE=$9

function queryFile(){
# 第一个参数 limit,第二个参数skip


/opt/mongodb-linux-x86_64-3.6.3/bin/mongo --host ${MONGO_HOST} --port ${MONGO_PORT} -u ${MONGO_USER} -p ${MONGO_PASSWD} --authenticationDatabase admin <<EOF |grep -P "ObjectId\(\"\w+\"\)" -o |grep -P "\"\w+\"" -o |grep -P "\w+" -o
use ${MONGO_DB_NAME};
DBQuery.shellBatchSize=${LIMIT};
db.${MONGO_COLLECTIONS}.find({"uploadDate":{\$lt:ISODate("${UPLOAD_DATE}T00:00:00.000Z")}},{"_id":1}).limit($1).skip($2);
EOF


}

queryFile $LIMIT $SKIP