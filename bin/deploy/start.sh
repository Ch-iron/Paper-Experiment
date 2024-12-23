#!/usr/bin/env bash
start=`date +%s.%N`

VARIABLE=config.conf

K=1
while read line
do
    if [ ${K} -eq 1 ]; then
        SHARD=$(echo $line | cut -d ":" -f 2)
        SHARD=$(echo $SHARD | cut -d " " -f 2)
    elif [ ${K} -eq 2 ]; then
        COMMITTEE=$(echo $line | cut -d ":" -f 2)
        COMMITTEE=$(echo $COMMITTEE | cut -d " " -f 2)
    fi
    K=$((K+1))
done < $VARIABLE
echo "Shard: ${SHARD}, Committee: ${COMMITTEE}"
TOTALCOMMITTEE=$((SHARD*COMMITTEE))

start(){
    SERVER_ADDR=(`cat ../../common/base_ips.txt`)
    for (( i=0; i<=${SHARD}; i++))
    do
      echo "Communicator Shard: ${i}"
      ./_start_cmd.sh ubuntu ${SERVER_ADDR[i]} 0 ${i} 0 1>>../../log/start.log 2>>../../log/start_err.log &
      sleep 0.1s
    done
    sleep 3
    NODE_ADDR=(`cat ../../common/ips.txt`)
    K=0
    for (( i=1; i<=${COMMITTEE}; i++)) # Node ID
    do
      for (( j=1; j<=${SHARD}; j++ )) # Shard
      do
        echo "Shard: ${j}, ID: ${i}, K: ${K} IP: ${NODE_ADDR[K]}"
        ./_start_cmd.sh ubuntu ${NODE_ADDR[K]} 1 ${j} ${i} 1>>../../log/start.log 2>>../../log/start_err.log &
        K=$((K+1))
        sleep 0.1s
      done
    done
}

rm -rf log/start*
# update config.json to replicas
start

finish=`date +%s.%N`
diff=$( echo "$finish - $start" | bc -l )
echo 'start:' $start
echo 'finish:' $finish
echo 'diff:' $diff