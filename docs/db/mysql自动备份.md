```bash
# 创建sh
vim bak.sh
chmod 777 bak.sh
# 示例一 
backupdir=/usr/local/xsh/db-bak/data
time=` date +%Y_%m_%d_%H_%M_%S `
db_user=root
db_pass=sunafei.110
mysqldump --all-databases -u $db_user -p$db_pass | gzip > $backupdir/$time.sql.gz
find $backupdir -name "*.sql.gz" -type f -mtime +5 -exec rm -rf {} \; > /dev/null 2>&1
```


```
# 示例二
#!/bin/sh
DUMP=/usr/bin/mysqldump 
OUT_DIR=/usr/local/xsh/db-bak/data
LINUX_USER=root
DB_NAME=xsh
DB_USER=root
DB_PASS=sunafei.110
DAYS=7
cd $OUT_DIR
DATE=`date +%Y-%m-%d`
OUT_SQL=$DATE.sql
TAR_SQL="energy_bak_$DATE.tar.gz"
$DUMP -u$DB_USER -p$DB_PASS $DB_NAME --default-character-set=gbk --opt -Q -R --skip-lock-tables>$OUT_SQL
tar -czf $TAR_SQL ./$OUT_SQL
rm $OUT_SQL
chown $LINUX_USER:$LINUX_USER $OUT_DIR/$TAR_SQL
find $OUT_DIR -name "energy_bak*" -type f -mtime +$DAYS -exec rm { } \;
# 测试
./bak.sh
# 编辑crontab
# vi /etc/crontab
crontab -e
0 6 * * * root /usr/local/../bak.sh
# 查看任务
crontab -l
# cron日志
vim /etc/rsyslog.d/50-default.conf
cron.*              /var/log/cron.log #将cron前面的注释符去掉 
service rsyslog  restart  重启rsyslog
cat /var/log/cron.log
#重启cron服务
service cron reload
/etc/init.d/cron restart
```