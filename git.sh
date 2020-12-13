#! /bin/bash
cmd=$1
param2=$2
param3=$3
param4=$4
param5=$5

cur_branch=`git branch |grep "*" | awk -F " " '{print $2}'`;


# push操作
gpush(){
    if [ -z "$param2" ]  ;then 
        (git push origin $cur_branch)
    else 
        (git push origin $param2 $param3 $param4 $param5)
    fi
}

# pull操作
gpull(){
    if [[ -z $param2 ]]  ;then 
        (git pull origin $cur_branch)
    else 
        (git pull origin $param2 $param3 $param4 $param5)
    fi
}

# branch 操作
gb(){
    (git branch $param2 $param3 $param4 $param5)
}

# checkout 操作
gco(){
    (git checkout $param2 $param3 $param4 $param5)
}

# merge 操作
gm(){
    (git merge $param2 $param3 $param4 $param5)
}

# log 操作
glog(){
    (git log)

}

# add 操作
gadd(){
    if [[  -n $param2 ]]  ;then 
        (git add $param2)
    else 
        (git add .)
    fi
}

# commit 操作
gcm(){
    (git commit -m  "$param2")
}

gtag(){
    (git tag -l)
}

gst(){
     (git status)
}

# 接受命令行参数
currTime=$(date +"%Y-%m-%d %T")
if [[ "$cmd" == "" ]] ;then
    echo "********************************************"
    echo "********************************************"
    echo "****      Date $currTime      ****"
    echo "****      Command not found  !!!!       ****"
    echo "********************************************"
    echo "********************************************"
    exit;
fi

# 判断当前是否是git项目
if [ ! -d "${PWD}/.git" ]; then
    echo "********************************************"
    echo "********************************************"
    echo "****     Date $currTime       ****"
    echo "****     This is not git    !!!!        ****"
    echo "********************************************"
    echo "********************************************"
    exit;
fi

# 获取分支名称
printf '********************************************************\n';
printf '********************************************************\n';
printf '**** Show Branch And Date                           ****\n';

echo "**** Date $currTime                       ****"
prePrint="**** @Current Branch ";
midPrint="${cur_branch}   ";
printf "${prePrint}";
printf $midPrint
total=`expr 56 - ${#midPrint} - ${#prePrint}`
for((i=1;i<$total;i++))
do
    printf " ";
done
printf "****\n"
printf "********************************************************\n"
printf "********************************************************\n"
($cmd)