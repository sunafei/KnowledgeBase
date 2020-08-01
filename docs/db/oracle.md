### 导入导出
```
-- 导入(注意表空间名称) 
Imp username/password@localhost:1521/orcl file=c:\xxx.dmp full=y log=c:\xxx.txt
-- 导出(注意空表是否能导出)
exp username/password@orcl file=c:\xxx.dmp grants=no consistent=y
```

### cmd登陆sys用户
```
sqlplus
sys
password as sysdba
```

### 创建数据库
```
# 创建表空间
create tablespace xxx
logging
datafile 'C:\ORADBDATA\xxx.ora'
size 50m
autoextend on
next 50m maxsize 20480m
extent management local;

# 创建用户
create user username profile default identified by password default tablespace xxx;

# 给用户授权
grant connect,resource,dba to username;

# 删除表空间
Drop tablespace username INCLUDING CONTENTS AND DATAFILES CASCADE CONSTRAINTS;

# 删除用户
drop user username cascade;
```
