## Dockerfile常用指令 
指令 | 描述 | 示例
-|-|-
FROM | 构造的新镜像是基于哪个镜像 | FROM centos:v1
MAINTAINER  | 维护者信息 | MAINTAINER sunafei\<924393541@qq.com\>
RUN | 构建镜像时运行的shell命令 | RUN ["yum", "install", "http"] <br/> RUN yum install httpd
CMD |  运行容器时执行的shell命令 | CMD ["-c", "/startup.sh"]  <br/>  CMD ["/usr/sbin/sshd", "-D"]  <br/>  CMD /usr/sbin/sshd -D
EXPOSE | 指定于外界交互的端口，即容器在运行时监听的端口 | EXPOSE 8081 8082
ENV  | 设置容器内环境变量 | ENV MYSQL_ROOT_PASSWORD 123456
ADD | 拷贝文件或者目录到镜像，如果是URL或者压缩包会自动下载或者自动解压 | ADD hom* /mydir/  <br/>  ADD test relativeDir/
COPY | 拷贝文件或者目录到镜像，用法同ADD | COPY ./startup.sh /startup.sh
ENTRYPOINT | 运行容器时执行的shell命令 | ENTRYPOINT ["/bin/bash","-c","/startup.sh"] <br/> ENTRYPOINT /bin/bash -c '/startup.sh'
VOLUME | 指定容器挂载点到宿主机自动生成的目录或者其他容器 | VOLUME ["/path/to/dir"]
USER | 为RUN,CMD,ENTRYPOINT执行命令指定运行用户 | USER www 镜像构建完成后，通过docker run运行容器时，可以通过-u参数来覆盖所指定的用户。
WORKDIR | 为RUN,CMD,ENTRYPOINT,COPY和ADD设置工作目录 | WORKDIR /data
HEALTHCHECK | 健康检查 | HEALTHCHECK --interval=5m --timeout=3s CMD curl -f http://localhost/ \|\|exit 1
ARG | 在构建镜像时指定一些参数 | FROM centos:6 ARG age=100

## 示例：构建java环境
```dockerfile
FROM java:8

RUN mkdir /app
COPY xsh-api-1.0.jar /app/app.jar
# 设置镜像的时区,避免出现8小时的误差
ENV TZ=Asia/Shanghai

ENTRYPOINT ["java", "-Djava.security.egd=file:/dev/./urandom", "-jar", "/app/app.jar", "--spring.profiles.active=prod"]

EXPOSE 8081
```

## 示例：在gitlab-runner基础上安装docker、jdk、maven
```dockerfile
FROM gitlab/gitlab-runner:v11.0.2
MAINTAINER sunafei <924393541@qq.com>

# 修改软件源
RUN echo 'deb http://mirrors.aliyun.com/ubuntu/ xenial main restricted universe multiverse' > /etc/apt/sources.list && \
    echo 'deb http://mirrors.aliyun.com/ubuntu/ xenial-security main restricted universe multiverse' >> /etc/apt/sources.list && \
    echo 'deb http://mirrors.aliyun.com/ubuntu/ xenial-updates main restricted universe multiverse' >> /etc/apt/sources.list && \
    echo 'deb http://mirrors.aliyun.com/ubuntu/ xenial-backports main restricted universe multiverse' >> /etc/apt/sources.list && \
    apt-get update -y && \
    apt-get clean

# 安装 Docker
RUN apt-get -y install apt-transport-https ca-certificates curl software-properties-common && \
    curl -fsSL http://mirrors.aliyun.com/docker-ce/linux/ubuntu/gpg | apt-key add - && \
    add-apt-repository "deb [arch=amd64] http://mirrors.aliyun.com/docker-ce/linux/ubuntu $(lsb_release -cs) stable" && \
    apt-get update -y && \
    apt-get install -y docker-ce
# 修改为阿里云镜像加速
COPY daemon.json /etc/docker/daemon.json

# 安装 Docker Compose 通过DaoCloud安装
WORKDIR /usr/local/bin
RUN curl -L https://get.daocloud.io/docker/compose/releases/download/1.25.0-rc2/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose
RUN chmod +x docker-compose

# 安装 Java
RUN mkdir -p /usr/local/java
WORKDIR /usr/local/java
COPY jdk-8u152-linux-x64.tar.gz /usr/local/java
RUN tar -zxvf jdk-8u152-linux-x64.tar.gz && \
    rm -fr jdk-8u152-linux-x64.tar.gz

# 安装 Maven
RUN mkdir -p /usr/local/maven
WORKDIR /usr/local/maven
COPY apache-maven-3.6.1-bin.tar.gz /usr/local/maven
RUN tar -zxvf apache-maven-3.6.1-bin.tar.gz && \
    rm -fr apache-maven-3.6.1-bin.tar.gz
# maven中已经包含最新的settings
# COPY settings.xml /usr/local/maven/apache-maven-3.6.1/conf/settings.xml

# 配置环境变量
ENV JAVA_HOME /usr/local/java/jdk1.8.0_152
ENV MAVEN_HOME /usr/local/maven/apache-maven-3.6.1
ENV PATH $PATH:$JAVA_HOME/bin:$MAVEN_HOME/bin

WORKDIR /
```
