#! /bin/bash
cmd=$1
param2=$2
param3=$3
param4=$4
param5=$5

# 获取当前分支
cur_branch=`git branch |grep "*" | awk -F " " '{print $2}'`;
# 提示输出
tipResult="Success !";
# 最终tag名称
finallyTag="";

# push操作
gpush(){
    gpull
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
    if [  -z $param2 ]  ;then
        (git add .)
    else
        (git add $param2)
    fi
}

# commit 操作
gcm(){
    (git commit -m  "$param2")
}

# 展示近期的10个tag
gtag(){
    (git tag --sort=-v:refname | head -n 10)
}


# 获取修改状态
gst(){
     (git status)
}

# 自动打pre-master上面的tag并且提交
gpt() {
   if [[ "$cur_branch" != "pre-master" ]]  ;then
      tipResult="Branch is no support !!!";
      echo  $tipResult;
      exit;
   fi
   gp=`git pull`;
   gtag=`git tag --sort=-v:refname | head -n 1`;
   versionArray=()
   preVersion=(${gtag//\-/ })
   for i in "${!preVersion[@]}"; do
      if [[ $i == 0 ]] ; then
          versionArray=(${preVersion[i]//\./ })
      fi
   done
   # 获取不到tag,现场退出
   if [ "${#versionArray[@]}" -eq 0 ] ; then
      tipResult="Tag is not found !!!";
      echo  $tipResult;
      exit;
   fi

   last=`expr ${versionArray[2]} + 1 `;
   mid=${versionArray[1]};
   first=${versionArray[0]}
   if [ $last -ge "99" ] ; then
       mid=`expr $mid + 1 `;
       last=0;
   fi

   # 中间数字超过99第一位数据相加
   if [ $mid -ge "99" ] ; then
      mid=0;
      fv=`expr ${first:1:1} + 1`;
      first="${first:0:1}${fv}";
   fi
   tagName="$first.$mid.$last-$cur_branch";
   finallyTag=$tagName;
   # 执行确认工作
   f=`confirm`
   if [ $? -ne 1 ] ; then
      tipResult="Tag is not need confirm !!!";
      echo  $tipResult;
      exit;
   fi

   (git tag $tagName -m "$param2")
   (git push origin $finallyTag)
   echo  $tipResult;
   exit;
}


# 基础星号输出
printBasic(){
  for (( j = 0; j <= $1; j++ )) ; do
      str="${str}*";
  done
  printf "${str}\n";
}

# 补充空格输出
printInfo(){
  out=$(random 31 37);
  prefix="****"
  suffix="****"
  strNum="${prefix}${2}${3}";
  echoStr="${prefix}${2}\033[${out}m${3}\033[0m";
  supplement=`expr ${1} - ${#strNum} - ${#suffix}`;
   
  k=" ";
  for (( i = 0; i <= $supplement; i++ )); do
    echoStr="${echoStr}${k}";
  done
  echo "${echoStr}${suffix}";
}

# 确定是否提交
confirm(){
  while true
  do
	  read -r -p "Push tag to origin? [Y/n] " input
  	case $input in
	    [yY][eE][sS]|[yY])
			echo "Yes"
			return 1;
			;;

	    [nN][oO]|[nN])
			echo "No"
			return 2;
			;;

	    *)
			echo "Invalid input..."
			return 3;
			;;
	  esac
  done
}

# 获取随机数
function random()
{
    min=$1;
    max=$2-$1;
    num=$(date +%s+%N);
    ((retnum=num%max+min));
    #进行求余数运算即可
    echo $retnum;
    #这里通过echo 打印出来值，然后获得函数的，stdout就可以获得值
    #还有一种返回，定义全价变量，然后函数改下内容，外面读取
}

# 接受命令行参数
# currTime=$(date "+%Y-%m-%d %H:%M:%S")
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

row=8
line=56;
for((i=1;i<=$row;i++)); do
  str=""
  case $i in
  1)
    (printBasic ${line})
    ;;
  2)
    (printBasic ${line})
    ;;
  3)
    (printInfo ${line} "  @Show Same Information !" "")
    ;;
  4)
    (printInfo ${line} "  @Date " "$currTime")
    ;;
  5)
    (printInfo ${line} "  @Branch " "( ${cur_branch} )")
    ;;
  6)
    #(printInfo ${line} "  @Result " "${tipResult}")
    ;;
  7)
    (printBasic ${line})
    ;;
  8)
    (printBasic ${line})
    ;;
  esac
done

($cmd)



