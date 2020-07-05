### 配置yum
### 配置IP地址
```
vi  /etc/sysconfig/network-scripts/ifcfg-ens33
BOOTPROTO=static #dhcp改为static（修改）
ONBOOT=yes #开机启用本配置，一般在最后一行（修改）
IPADDR=192.168.174.129 #静态IP（增加）
GATEWAY=192.168.174.2 #默认网关，虚拟机安装的话，通常是2，也就是VMnet8的网关设置（增加）
NETMASK=255.255.255.0 #子网掩码（增加）
DNS1=192.168.174.2 #DNS 配置，虚拟机安装的话，DNS就网关就行，多个DNS网址的话再增加（增加）
```
### 安装vim
### 安装netstat
```
yum -y install net-tools
```
### 安装wget
```
yum -y install wget
```
### 配置YUM源更换到阿里云软件仓库
```
mv /etc/yum.repos.d /etc/yum.repos.d-bak
mkdir /etc/yum.repos.d
cd /etc/yum.repos.d
wget http://mirrors.aliyun.com/repo/Centos-7.repo
yum clean all
yum repolist
```
### 安装docker
https://www.cnblogs.com/tjp40922/p/10747758.html
https://www.cnblogs.com/tjp40922/p/10747758.html
### 防火墙
```
# 开放关闭窗口
firewall-cmd --zone=public --add-port=5672/tcp --permanent   # 开放5672端口
firewall-cmd --zone=public --remove-port=5672/tcp --permanent  #关闭5672端口
firewall-cmd --reload   # 配置立即生效
# 查看防火墙所有开放的端口
firewall-cmd --zone=public --list-ports
# 关闭防火墙
systemctl stop firewalld.service
# 查看防火墙状态
firewall-cmd --state
# 查看监听的端口
yum install -y net-tools
netstat -lnpt
# 检查端口被哪个进程占用
netstat -lnpt |grep 5672
# 查看进程的详细信息
ps 6832
```