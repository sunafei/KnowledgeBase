### 导入导出
```
-- 导入(注意表空间名称) 
Imp RDSYSEDUV8/eplugger@localhost:1521/orcl file=c:\work\20191009.dmp full=y log=c:\work\log.txt
-- 导出(注意空表是否能导出)
exp RDSYSEDUV8/eplugger@orcl file=c:\work\20190808.dmp grants=no consistent=y
```

cmd登陆sys用户
sqlplus
sys
eplugger as sysdba

### 创建表空间
create tablespace RDSYSEDUV82310002
logging
datafile 'C:\ORADBDATA\RDSYSEDUV82310002.ora'
size 50m
autoextend on
next 50m maxsize 20480m
extent management local;

创建用户
create user RDSYSEDUV82310002 profile default identified by eplugger default tablespace RDSYSEDUV82310002;

给用户授权
grant connect,resource,dba to RDSYSEDUV82310002;

删除表空间
Drop tablespace RDSYSEDUV8 INCLUDING CONTENTS AND DATAFILES CASCADE CONSTRAINTS;

删除用户
drop user RDSYSEDUV806 cascade;

```sql
-- 查询数据库状态
SELECT * FROM dba_users a where a.username='RDSYSEDUV8_DEV';
-- 查询数据库密码过期策略
SELECT * FROM dba_profiles s WHERE s.profile='DEFAULT' AND resource_name='PASSWORD_LIFE_TIME';
-- 修改数据库密码过期策略为永不过期
ALTER PROFILE DEFAULT LIMIT PASSWORD_LIFE_TIME UNLIMITED;
-- 重新初始化密码
alter user RDSYSEDUV8_DEV identified by eplugger;
```