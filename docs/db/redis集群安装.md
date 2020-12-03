# 环境
CentOS7 + redis3.2.8

# 节点规划
1. node31 IP地址172.16.1.31  
2. node32 IP地址172.16.1.32  
3. node33 IP地址172.16.1.33   

# 安装步骤
### node31、node32、node33节点安装redis
```
# 准备安装路径
mkdir /usr/local/redis
cd /usr/local/redis
yum -y install gcc
# 下载并安装
wget http://download.redis.io/releases/redis-3.2.8.tar.gz
tar zxf redis-3.2.8.tar.gz 
cd redis-3.2.8
make && make install
# 配置节点
cp /usr/local/redis/redis-3.2.8/redis.conf /usr/local/redis/redis.conf
vi /usr/local/redis/redis.conf
# 修改以下几项
bind 192.168.0.7 # 本机ip
daemonize yes # 后台运行
cluster-enabled yes # 启用集群
# 启动
redis-server /usr/local/redis/redis.conf
```

### node31节点安装集群
```
# 创建Redis集群需要借助安装包里的一个Ruby脚本，先安装Ruby
yum -y install ruby rubygems
# 安装Redis客户端for Ruby 这一步可能会报错，报错解决
gem install redis 
创建Redis集群
redis-trib.rb create --replicas 172.16.1.31:6379 172.16.1.32:6379 172.16.1.33:6379 -a eplugger
```

### 设置密码
```
# 三个节点操作一致
redis-cli -h 172.16.1.31 -p 6379 
config set masterauth eplugger
config set requirepass eplugger
auth eplugger
config rewrite
```

### gem install redis 安装报错
报错内容为redis requires ruby version >= 2.3.0,原因是CentOS7 yum库中ruby的版本支持到2.0.0，但是gem安装redis需要最低是2.3.0，采用rvm来更新ruby
```
# 安装curl
yum -y install curl
# 安装rvm
gpg2 --keyserver hkp://keys.gnupg.net --recv-keys D39DC0E3  
curl -L get.rvm.io | bash -s stable 
# 安装过程中如果报错，需要执行错误提示信息中 gpg2 --keyserver......命令

# 修改 rvm下载 ruby的源，到 Ruby China 的镜像
gem sources --add https://gems.ruby-china.com/ --remove https://rubygems.org/

# 添加rvm软连接
source /usr/local/rvm/scripts/rvm

# 安装ruby
rvm install 2.3.3
rvm use 2.3.3
rvm use 2.3.3 --default
# 验证
ruby --version

```

# 常用命令
```
# 启动redis
redis-server redis.conf
# 连接redis,没有密码不需要-a
redis-cli -h 172.16.1.31 -p 6379 -a eplugger
# 连接redis到集群环境,没有密码不需要-a
redis-cli -h 172.16.1.31 -p 6379 -a eplugger -c
# 连接到集群环境
# 停止redis 
redis-cli -h 172.16.1.31 shutdown
# 停止redis带密码
redis-cli -h 172.16.1.31 -a eplugger shutdown
```

# 参考
[https://www.jianshu.com/p/0023970f122e](https://www.jianshu.com/p/0023970f122e)  
[https://www.codeleading.com/article/77931020806/](https://www.codeleading.com/article/77931020806/)  
[https://blog.csdn.net/xufei512/article/details/82758676](https://blog.csdn.net/xufei512/article/details/82758676)  
[https://www.cnblogs.com/ivictor/p/9768010.html](https://www.cnblogs.com/ivictor/p/9768010.html)  
[https://www.cnblogs.com/huxinga/p/6644226.html](https://www.cnblogs.com/huxinga/p/6644226.html)