MONGO_HOST=$1;
MONGO_PORT=$2;
MONGO_USER=$3;
MONGO_PASSWD=$4;

MONGO_DB_NAME=$5;
MONGO_COLLECTIONS=$6;
UPLOAD_DATE=$7;
PAGE_SIZE=3;
LIMIT=0;
PAGE=0;
res_i="1";
res="";
while true
do
    LIMIT=$((PAGE_SIZE * PAGE))
    res_i=`./queryFileIdSubFunc.sh  $1 $2 $3 $4 $5 $6 ${PAGE_SIZE} ${LIMIT} ${UPLOAD_DATE}`;
#echo ${PAGE}
#echo ${LIMIT}    
#echo ${res_i}
    PAGE=$((PAGE + 1));
    if [[ -z ${res_i} ]]
    then
        break;
    fi
    res=`echo -e "${res}\n${res_i}\n"`;
done
echo -e "${res}" > fileId_${MONGO_DB_NAME}_${MONGO_COLLECTIONS}.txt
sed 's/ /\n/g' fileId_${MONGO_DB_NAME}_${MONGO_COLLECTIONS}.txt