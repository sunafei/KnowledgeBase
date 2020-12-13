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
-- 创建表空间
create tablespace *xxx*
logging
datafile 'C:\ORADBDATA\xxx.ora'
size 50m
autoextend on
next 50m maxsize 20480m
extent management local;

-- 创建用户
create user *username* profile default identified by *password* default tablespace *xxx*;

-- 给用户授权
grant connect,resource,dba to *username*;

-- 删除表空间
Drop tablespace username INCLUDING CONTENTS AND DATAFILES CASCADE CONSTRAINTS;

-- 删除用户
drop user username cascade;
```



exp RDSYSEDUV8_TSINGHUA/eplugger@orcl file=c:\xxxxxx.dmp grants=no consistent=y
Imp RDSYSEDUV8_TSINGHUA/eplugger@localhost:1521/orcl file=1012.dmp full=y log=1012.txt

select * from dba_constraints where constraint_name='xxx' and constraint_type = 'R';

SELECT DISTINCT (SELECT NAME FROM BIZ_FEE_SCHEME WHERE ID = t1.FEESCHEMEID) tttt,t1.CODE,t1.NAME FROM BIZ_FEE_SCHEME_SUBJECT t1, BIZ_FEE_SCHEME_SUBJECT t2 
WHERE t1.CODE = t2.CODE and t1.NAME = t2.NAME 
and t1.FEESCHEMEID = t2.FEESCHEMEID AND t1.COMPUTERULE <> t2.COMPUTERULE ORDER BY tttt;


SELECT code,COMPUTERULE, (SELECT NAME FROM BIZ_FEE_SCHEME WHERE ID = t.FEESCHEMEID) ss
FROM BIZ_FEE_SCHEME_SUBJECT t WHERE FEESCHEMEID IN (SELECT FEESCHEMEID FROM BIZ_FEE_SCHEME_SUBJECT WHERE CODE = '02') AND CODE = '07' ORDER BY ss;


UPDATE SYS_PARAM SET PMVAL = 'jdbc:oracle:thin:@(DESCRIPTION=(ADDRESS = (PROTOCOL = TCP)(HOST = 172.16.1.5)(PORT = 1521))(CONNECT_DATA =(SERVER = DEDICATED)(SERVICE_NAME = orcl)(failover_mode =(type = select)(method = basic))))' WHERE PMKEY = 'studentjcUrl';


XXNBYLKUTQLBCQSX