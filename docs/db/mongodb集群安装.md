# 环境
CentOS7 + MongoDB4.2.10

# 说明
mongodb的集群搭建方式主要有三种：
1. Replica set模式 案例
2. sharding模式
3. 主从模式 不推荐  

本次安装采用replica set模式  
Replica Set是mongod的实例集合，它们有着同样的数据内容。包含三类角色：  
1. 主节点（Primary） 接收所有的写请求，只能有一个Primary节点
2. 副本节点(slaver)
3. 仲裁者（Arbiter） 不保有数据，不参与选主，只进行选主投票

# 节点规划
1. node31 IP地址172.16.1.31  
主节点master 172.16.1.31:27017
仲裁点arbiter 172.16.1.31:27018
2. node32 IP地址172.16.1.32  
备节点slaver 172.16.1.32:27017
3. node33 IP地址172.16.1.33   
备节点slaver 172.16.1.32:27017

# 安装步骤
### 安装master节点和arbiter节点到node31
```
# 安装文件准备
mkdir /usr/local/mongodb
cd /usr/local/mongodb
# 下载安装包
wget mongodb-linux-x86_64-rhel70-4.2.10.tgz
tar zxvf mongodb-linux-x86_64-rhel70-4.2.10.tgz
mv mongodb-linux-x86_64-rhel70-4.2.10 mongodb

# 创建master配置文件
vi master.conf
dbpath=/usr/local/mongodb/master/db
logpath=/usr/local/mongodb/master/log/master.log
replSet=rs0 # 集群名称
bind_ip=0.0.0.0
port=27017
# auth=true
fork=true  # 后台运行
maxConns=100
noauth=true
journal=true
storageEngine=wiredTiger

# 创建仲裁点配置文件 注意端口不同
vi arbiter.conf 
dbpath=/usr/local/mongodb/arbiter/db
logpath=/usr/local/mongodb/arbiter/log/arbiter.log
replSet=rs0 # 集群名称
bind_ip=0.0.0.0
port=27018
# auth=true
fork=true
maxConns=100
noauth=true
journal=true
storageEngine=wiredTiger

# 创建配置中需要的文件夹
mkdir /usr/local/mongodb/master/db
mkdir /usr/local/mongodb/master/log
mkdir /usr/local/mongodb/arbiter/db
mkdir /usr/local/mongodb/arbiter/log

# 建立MongoDB软连接，不然每次都需要调用/usr/local/mongodb/mongodb/bin下命令执行
ln -s /usr/local/mongodb/mongodb/bin/mongod /usr/bin/mongod
ln -s /usr/local/mongodb/mongodb/bin/mongo /usr/bin/mongo

# 启动服务
mongod -f /usr/local/mongodb/master.conf
mongod -f /usr/local/mongodb/arbiter.conf
```

### 配置文件说明
dbpath：存放数据目录  
logpath：日志数据目录  
keyFile：节点之间用于验证文件，内容必须保持一致，权限600，仅Replica Set 模式有效  
directoryperdb：数据库是否分目录存放  
logappend：日志追加方式存放  
replSet：Replica Set的名字  
bind_ip：mongodb绑定的ip地址  
port：端口  
auth：是否开启验证  
oplogSize：设置oplog的大小（MB）  
fork：守护进程运行，创建进程  
moprealloc：是否禁用数据文件预分配（往往影响性能）  
maxConns：最大连接数，默认2000  

### 安装slaver节点到32服务器
```
# 创建配置文件
vi /usr/local/mongodb/slaver.conf
dbpath=/usr/local/mongodb/slaver/db
logpath=/usr/local/mongodb/slaver/log/slaver.log
replSet=rs0
bind_ip=0.0.0.0
port=27017
# auth=true
fork=true
maxConns=100
noauth=true
journal=true
storageEngine=wiredTiger

# 创建配置中需要的文件夹
mkdir /usr/local/mongodb/slaver/db
mkdir /usr/local/mongodb/slaver/log

# 启动服务
mongod -f /usr/local/mongodb/slaver.conf
```

### 安装slaver节点到33服务器
步骤同32节点一致

# 在node31节点上进行集群配置
### 配置步骤
```
# 关闭防火墙或者接口放行
# 关闭防火墙，每个服务器节点都要执行
systemctl stop firewalld.service
# 禁止防火墙开机启动
systemctl disable firewalld.service
# 初始化集群
cfg={ _id:"rs0", members:[ 
{_id:0,host:'172.16.1.31:27017',priority:2}, {_id:1,host:'172.16.1.32:27017',priority:1}, 
{_id:2,host:'172.16.1.33:27017',priority:1}, 
{_id:3,host:'172.16.1.31:27018',arbiterOnly:true}] };

rs.initiate(cfg)
# 返回 ok :1 代表成功，失败可根据错误信息调试

# 查看集群状态
rs.status()

```
### 参数说明
1. cfg名字可选，只要跟mongodb参数不冲突，
2. _id为Replica Set名字，members里面的优先级priority值高的为主节点，对于仲裁点一定要加上arbiterOnly:true，否则主备模式不生效
3. priority表示优先级别，数值越大，表示是主节点
4. arbiterOnly:true表示仲裁节点
5. 使集群cfg配置生效rs.initiate(cfg)
6. 查看是否生效rs.status()
7. “stateStr” : "PRIMARY"表示主节点, “stateStr” : "SECONDARY"表示从节点，“stateStr” : “ARBITER”,表示仲裁节点
8. 添加节点命令
添加secondary：rs.add({host: "192.168.30.111:27017", priority: 1 })  
添加仲裁点：rs.addArb("192.168.30.113:27019")  
移除节点：rs.remove({host: "192.168.30.111:27017"})  

# 为集群配置密码
### 为主节点设置密码
```
# 登录mongo
mongo
# 切换到admin
use admin
# 创建管理员用户
db.createUser({user:"root",pwd:"eplugger",roles:[{role:"root",db:"admin"}]});
# 管理员登录
db.auth("root","eplugger");
# 切换到V8库中 
use RDSYSEDUV8
# 创建V8访问的普通用户
db.createUser({user:"root",pwd:"eplugger",roles:[{role:"readWrite",db:"RDSYSEDUV8"}]});
```
### 关闭mongodb服务
```
# 所有服务执行关闭
mongod --shutdown --dbpath /usr/local/mongodb/master/db
```
### 调整配置文件
```
# 生成filekey
openssl rand -base64 741 > keyfile
chmod 600 keyfile
# 复制key到每个服务器上
# 调整配置文件，以master节点为例
# 增加keyFile配置，注释noauth
vi /usr/local/mongodb/master.conf
dbpath=/usr/local/mongodb/master/db
logpath=/usr/local/mongodb/master/log/master.log
replSet=rs0
bind_ip=0.0.0.0
port=27017
# auth=true
fork=true
maxConns=100
# noauth=true
journal=true
storageEngine=wiredTiger
keyFile=/usr/local/mongodb/keyfile

```

### 启动每个节点测试
```
mongo
use admin
db.auth('root', 'eplugger')
db.testdb.insert(x:10)
db.testdb.find();
```

# 参考
[https://blog.csdn.net/hsg77/article/details/90645251](https://blog.csdn.net/hsg77/article/details/90645251)  
[https://blog.csdn.net/tksnail/article/details/86682558](https://blog.csdn.net/tksnail/article/details/86682558)  
[https://blog.csdn.net/weixin_33806300/article/details/92196599](https://blog.csdn.net/weixin_33806300/article/details/92196599)