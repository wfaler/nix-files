cd /run/current-system/sw/bin
JAVA_PATH=`echo $(ls -ltr java) | cut -d' ' -f11,11-`
PATH_LENGTH=${#JAVA_PATH}
LENGTH=`expr $PATH_LENGTH - 9`
J_HOME=${JAVA_PATH:0:$LENGTH}

echo $J_HOME/lib/openjdk
