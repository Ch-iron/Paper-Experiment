#!/bin/bash

# Region에 대하여 각 인자 값을 위한 변수 정의

## Type : pc performance
TEST="t2.micro"
C4L="c4.large"
C4XL="c4.xlarge"
C42XL="c4.2xlarge"
C5L="c5.large"
C5XL="c5.xlarge"
C5NXL="c5n.xlarge"
C52XL="c5.2xlarge"
C54XL="c5.4xlarge"

## Image ID : OS to use
VIRGINIA_UBUNTU22="ami-0a0e5d9c7acc336f1"
OHIO_UBUNTU22="ami-003932de22c285676"
CALIFORNIA_UBUNTU22="ami-0ecaad63ed3668fca"
OREGON_UBUNTU22="ami-0075013580f6322a1"
HONGKONG_UBUNTU22="ami-01412724cbc6252ef"
MUMBAI_UBUNTU22="ami-0c2af51e265bd5e0e"
OSAKA_UBUNTU22="ami-0a70c5266db4a6202"
SEOUL_UBUNTU22="ami-056a29f2eddc40520"
SINGAPORE_UBUNTU22="ami-0497a974f8d5dcef8"
SYDNEY_UBUNTU22="ami-0375ab65ee943a2a6"
TOKYO_UBUNTU22="ami-0162fe8bfebb6ea16"
CANADA_UBUNTU22="ami-048ddca51ab3229ab"
FRANKFURT_UBUNTU22="ami-07652eda1fbad7432"
IRELAND_UBUNTU22="ami-0932dacac40965a65"
LONDON_UBUNTU22="ami-07d20571c32ba6cdc"
PARIS_UBUNTU22="ami-0062b622072515714"
STOCKHOLM_UBUNTU22="ami-07a0715df72e58928"
SAOPAULO_UBUNTU22="ami-01a38093d387a7497"

## Region : Location of server
VIRGINIA_REGION="us-east-1"
OHIO_REGION="us-east-2"
CALIFORNIA_REGION="us-west-1"
OREGON_REGION="us-west-2"
HONGKONG_REGION="ap-east-1"
MUMBAI_REGION="ap-south-1"
OSAKA_REGION="ap-northeast-3"
SEOUL_REGION="ap-northeast-2"
SINGAPORE_REGION="ap-southeast-1"
SYDNEY_REGION="ap-southeast-2"
TOKYO_REGION="ap-northeast-1"
CANADA_REGION="ca-central-1"
FRANKFURT_REGION="eu-central-1"
IRELAND_REGION="eu-west-1"
LONDON_REGION="eu-west-2"
PARIS_REGION="eu-west-3"
STOCKHOLM_REGION="eu-north-1"
SAOPAULO_REGION="sa-east-1"

## Subnet : Network Group in server's location
VIRGINIA_SUBNET="subnet-0f1992270cf260d9f"
OHIO_SUBNET="subnet-013fa442bb61c29ef"
CALIFORNIA_SUBNET="subnet-0be803b17cde4a880"
OREGON_SUBNET="subnet-043736806c46ee483"
HONGKONG_SUBNET="subnet-71ddf53b"
MUMBAI_SUBNET="subnet-05af2884939b1cac8"
OSAKA_SUBNET="subnet-8ffe16e6"
SEOUL_SUBNET="subnet-097447f37316f5329"
SINGAPORE_SUBNET="subnet-0ffbaf97260f82b4f"
SYDNEY_SUBNET="subnet-0840bab8944b072ec"
TOKYO_SUBNET="subnet-0ab3343a00d64f75b"
CANADA_SUBNET="subnet-02aadd8edb94d9e36"
FRANKFURT_SUBNET="subnet-076ae74d7d63dc934"
IRELAND_SUBNET="subnet-016ee3a170813ebc6"
LONDON_SUBNET="subnet-03a79ab595f052c24"
PARIS_SUBNET="subnet-019bf2c41712ade57"
STOCKHOLM_SUBNET="subnet-092a9a2d654504123"
SAOPAULO_SUBNET="subnet-0b219f70bc106eb99"

CONFIG=../bin/deploy/config.conf
K=1
while read line
do
    if [ ${K} -eq 2 ]; then
        COMMITTEE=$(echo $line | cut -d ":" -f 2)
        COMMITTEE=$(echo $COMMITTEE | cut -d " " -f 2)
    fi
    K=$((K+1))
done < $CONFIG
echo "Committee: ${COMMITTEE}"

## Count : The number of Instances for each location
VIRGINIA_COUNT=${COMMITTEE}
OHIO_COUNT=${COMMITTEE}
CALIFORNIA_COUNT=${COMMITTEE}
OREGON_COUNT=${COMMITTEE}
HONGKONG_COUNT=${COMMITTEE}
MUMBAI_COUNT=${COMMITTEE}
OSAKA_COUNT=${COMMITTEE}
SEOUL_COUNT=${COMMITTEE}
SINGAPORE_COUNT=${COMMITTEE}
SYDNEY_COUNT=${COMMITTEE}
TOKYO_COUNT=${COMMITTEE}
CANADA_COUNT=${COMMITTEE}
FRANKFURT_COUNT=${COMMITTEE}
IRELAND_COUNT=${COMMITTEE}
LONDON_COUNT=${COMMITTEE}
PARIS_COUNT=${COMMITTEE}
STOCKHOLM_COUNT=${COMMITTEE}
SAOPAULO_COUNT=${COMMITTEE}


## Array of all above infos for each region
VIRGINIA=("$VIRGINIA_UBUNTU22" "$VIRGINIA_REGION" "$VIRGINIA_SUBNET" "$VIRGINIA_COUNT")
OHIO=("$OHIO_UBUNTU22" "$OHIO_REGION" "$OHIO_SUBNET" "$OHIO_COUNT")
CALIFORNIA=("$CALIFORNIA_UBUNTU22" "$CALIFORNIA_REGION" "$CALIFORNIA_SUBNET" "$CALIFORNIA_COUNT")
OREGON=("$OREGON_UBUNTU22" "$OREGON_REGION" "$OREGON_SUBNET" "$OREGON_COUNT")
HONGKONG=("$HONGKONG_UBUNTU22" "$HONGKONG_REGION" "$HONGKONG_SUBNET" "$HONGKONG_COUNT")
MUMBAI=("$MUMBAI_UBUNTU22" "$MUMBAI_REGION" "$MUMBAI_SUBNET" "$MUMBAI_COUNT")
OSAKA=("$OSAKA_UBUNTU22" "$OSAKA_REGION" "$OSAKA_SUBNET" "$OSAKA_COUNT")
SEOUL=("$SEOUL_UBUNTU22" "$SEOUL_REGION" "$SEOUL_SUBNET" "$SEOUL_COUNT")
SINGAPORE=("$SINGAPORE_UBUNTU22" "$SINGAPORE_REGION" "$SINGAPORE_SUBNET" "$SINGAPORE_COUNT")
SYDNEY=("$SYDNEY_UBUNTU22" "$SYDNEY_REGION" "$SYDNEY_SUBNET" "$SYDNEY_COUNT")
TOKYO=("$TOKYO_UBUNTU22" "$TOKYO_REGION" "$TOKYO_SUBNET" "$TOKYO_COUNT")
CANADA=("$CANADA_UBUNTU22" "$CANADA_REGION" "$CANADA_SUBNET" "$CANADA_COUNT")
FRANKFURT=("$FRANKFURT_UBUNTU22" "$FRANKFURT_REGION" "$FRANKFURT_SUBNET" "$FRANKFURT_COUNT")
IRELAND=("$IRELAND_UBUNTU22" "$IRELAND_REGION" "$IRELAND_SUBNET" "$IRELAND_COUNT")
LONDON=("$LONDON_UBUNTU22" "$LONDON_REGION" "$LONDON_SUBNET" "$LONDON_COUNT")
PARIS=("$PARIS_UBUNTU22" "$PARIS_REGION" "$PARIS_SUBNET" "$PARIS_COUNT")
STOCKHOLM=("$STOCKHOLM_UBUNTU22" "$STOCKHOLM_REGION" "$STOCKHOLM_SUBNET" "$STOCKHOLM_COUNT")
SAOPAULO=("$SAOPAULO_UBUNTU22" "$SAOPAULO_REGION" "$SAOPAULO_SUBNET" "$SAOPAULO_COUNT")

# Execute Command
INSTANCES_FILE=instances.node.file
# INSTANCES_FILE_FILE이 존재한다면, 실행하지 않음
if [ -f "${INSTANCES_FILE}" ]; then
    printf "Instances are already existing.\n" 
else
    # Run 할 Region을 결정
    # regions=(SEOUL)
    ## Shard 3
    # regions=(TOKYO CALIFORNIA FRANKFURT)

    for region in ${regions[@]}
    do
        region=${region}[*] # 배열을 가져올 문자열 생성 ex) SEOUL[*]

        # 실행 인풋에 따라 값 할당
        EXECUTE_REGION=(${!region}) # 실제 배열 가져옴 ex) ${SEOUL[*]}

        IMAGE_ID="${EXECUTE_REGION[0]}"
        TYPE="${C5NXL}"
        KEY_NAME="unishard"
        NAME="cheolhoon"
        REGION="${EXECUTE_REGION[1]}"
        SUBNET_ID="${EXECUTE_REGION[2]}"
        COUNT="${EXECUTE_REGION[3]}"

        printf "== ${REGION} INSTANCE INFO ==\n"
        printf "NAME: $NAME\n"
        printf "OS Image: $IMAGE_ID\n"
        printf "PERFORMANCE Type: $TYPE\n"
        printf "KEYFILE: $KEY_NAME\n"
        printf "REGION: $REGION\n"
        printf "SUBNET ID: $SUBNET_ID\n"
        printf "COUNT: $COUNT\n"

        # instance id 저장할 파일 - Region별 instance ID 저장
        # echo $REGION >> "$INSTANCES_FILE"
        # INSTANCES_ID_FILE="${REGION}.instances.id" 

        # execute command
        INSTANCE=$(aws ec2 run-instances \
        --image-id "$IMAGE_ID" \
        --count "$COUNT" \
        --instance-type "$TYPE" \
        --key-name "$KEY_NAME" \
        --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$NAME}]" \
        --region "$REGION" \
        --subnet-id "$SUBNET_ID" \
        --query Instances[].InstanceId)
        # --query Instances[].PublicAddress >> "$INSTANCES_FILE"

        echo ${REGION} ${INSTANCE} >> "$INSTANCES_FILE"
    done
fi





