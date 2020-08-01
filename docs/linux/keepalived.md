### 通过keepalived+nginx做web应用高可用

### ubuntu安装keepalived
```
cd home
# 下载keepalived
wget https://keepalived.org/software/keepalived-2.0.20.tar.gz
# 创建工作路径
mkdir /usr/local/keepalived
# 解压
tar -zxvf keepalived-2.0.20.tar.gz
cd keepalived-2.0.20
# 安装依赖
apt-get install gcc
apt-get install openssl
apt-get install libssl-dev
# 安装
./configure --prefix=/usr/local/keepalived
apt-get install make
make && make install
# 修改配置文件路径
mkdir /etc/keepalived
cp /usr/local/keepalived/etc/keepalived/keepalived.conf   /etc/keepalived/keepalived.conf
mkdir /etc/sysconfig
cp /usr/local/keepalived/etc/sysconfig/keepalived  /etc/sysconfig/keepalived
cp /usr/local/keepalived/sbin/keepalived /usr/sbin/keepalived
cp /root/keepalived-2.0.20/keepalived/etc/init.d/keepalived  /etc/init.d/keepalived
# 修改配置内容 由于 ubuntu下没有 /etc/rc.d/init.d/functions需要为其建立软链
mkdir -p  /etc/rc.d/init.d
ln -s /lib/lsb/init-functions /etc/rc.d/init.d/functions
# 修改/etc/init.d/keepalived文件
# 修改为daemon -- keepalived ${KEEPALIVED_OPTIONS}  # 加了一个“--”
# 加载配置,启动keepalived
service keepalived start
# 查看运行状态
service keepalived status
```

### 配置主从节点
```
vrrp_script check { # 检查nginx没有启动则停止keepalived
   script "/etc/keepalived/check_nginx.sh"
   interval 2
}
global_defs {
   router_id 192.168.174.51 # 主机IP
}
vrrp_instance VI_1 {
    state MASTER     # 主节点
    interface ens33  # 主机网卡名称
    virtual_router_id 51 # 统一
    priority 100  # 权重 从节点要比主节点小
    advert_int 1 
    authentication { # 不同节点一致
        auth_type PASS
        auth_pass 1111
    }
    virtual_ipaddress {
        192.168.174.50/24 # 对外提供虚拟IP
    }
    track_script {
        check   
    }
}

```

### check_nigx.sh文件 注意授权chomod
```
#! /bin/bash
A=`ps -C nginx --no-header |wc -l`      ## 查看是否有 nginx进程 把值赋给变量A 
if [ $A -eq 0 ];then                    ## 如果没有进程值得为 零
   service keepalived stop          ## 则结束 keepalived 进程
fi
```

参考博客
https://www.jianshu.com/p/4e405ca6f60b
https://blog.csdn.net/Qinejie1314520/article/details/103132762
https://www.cnblogs.com/jiafushunaixiaomeng/p/11061916.html
https://www.cnblogs.com/roy-blog/p/7196054.html