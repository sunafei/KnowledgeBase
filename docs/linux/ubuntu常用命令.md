### 修改root密码
```
sudo passwd root
```

### 查看端口占用
```
lsof -i:port
kill -9 pid
```

### 修改主机名
```
vim /etc/hostname
reboot
```

### 防火墙
```
sudo ufw status  
# 如果开启防火墙了，添加允许规则如下
sudo ufw allow 3306/tcp
# 关闭防火墙命令
sudo ufw disable
# 开启防火墙
sudo ufw enable
```

