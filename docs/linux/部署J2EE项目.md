### 下载jdk
```
wget --no-cookies --no-check-certificate --header "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie" "http://download.oracle.com/otn-pub/java/jdk/8u141-b15/336fa29ff2bb4ef291e347e091f7f4a7/jdk-8u141-linux-i586.tar.gz"
```

### centos需要安装glibc
```
yum -y install glibc.i686
```

### 配置环境变量(注意路径)
```
vi /etc/profile

JAVA_HOME=/usr/local/java/jdk1.8
JRE_HOME=/usr/local/java/jdk1.8/jre
CLASS_PATH=.:$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar:$JRE_HOME/lib
PATH=$PATH:$JAVA_HOME/bin:$JRE_HOME/bin
export JAVA_HOME JRE_HOME CLASS_PATH PATH

source /etc/profile
```
### 下载tomcat
```
wget http://mirrors.hust.edu.cn/apache/tomcat/tomcat-8/v8.5.56/bin/apache-tomcat-8.5.56.tar.gz
```
### 启动并输出日志
```
./startup.sh && tail -f ../logs/catalina.out
```
