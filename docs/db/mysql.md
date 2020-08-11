
## 一条SQL语句在MySQL中如何执行的
* MySQL 主要分为 Server 层和引擎层，Server 层主要包括连接器、查询缓存、分析器、优化器、执行器，同时还有一个日志模块（binlog），这个日志模块所有执行引擎都可以共用,redolog 只有 InnoDB 有。
*引擎层是插件式的，目前主要包括，MyISAM,InnoDB,Memory 等。
* SQL 等执行过程分为两类，一类对于查询等过程如下：权限校验--->查询缓存--->分析器--->优化器--->权限校验--->执行器--->引擎
* 对于更新等语句执行流程如下：分析器---->权限校验---->执行器--->引擎---redo log prepare--->binlog--->redo log commit

## SQL执行顺序
写的顺序：select ... from... where.... group by... having... order by.. limit  
执行顺序：from...join...on... where...group by...avg/sum... having.... select ... order by... limit

## 数据库字段设计规范
1. 优先选择符合存储需要的最小的数据类型  
a. 将字符串转换成数字类型存储,如:将 IP 地址转换成整形数据,MySQL 提供了两个方法来处理 ip 地址  
• inet_aton 把 ip 转为无符号整型 (4-8 位)  
• inet_ntoa 把整型的 ip 转为地址  
b. 对于非负型的数据 (如自增 ID,整型 IP) 来说,要优先使用无符号整型来存储 
SIGNED INT  UNSIGNED INT  
2. 避免使用 TEXT,BLOB 数据类型，最常见的 TEXT 类型可以存储 64k 的数据
a. 建议把 BLOB 或是 TEXT 列分离到单独的扩展表中  
b. TEXT 或 BLOB 类型只能使用前缀索引  
3. 避免使用 ENUM 类型
修改 ENUM 值需要使用 ALTER 语句
ENUM 类型的 ORDER BY 操作效率低，需要额外操作
4. 尽可能把所有列定义为 NOT NULL
5. 使用 TIMESTAMP(4 个字节) 或 DATETIME 类型 (8 个字节) 存储时间
6. 同财务相关的金额类数据必须使用 decimal 类型

## mysql性能优化
1. 避免数据类型的隐式转换 字符串和日期 字符串和数字查询
2. 前置百分号会破坏索引
3. 联合索引查询时，一般遵循最左匹配原则
4. 避免子查询，使用join操作
5. 使用in代替or，or语句不会使用索引
6. 应尽量避免在 where 子句中对字段进行表达式操作，这将导致系统放弃使用索引而进行全表扫
7. 尽量避免在索引列上使用mysql的内置函数
8. 在明显不会有重复值时使用 UNION ALL 而不是 UNION
• UNION 会把两个结果集的所有数据放到临时表中后再进行去重操作
• UNION ALL 不会再对结果集进行去重操作
8. 如果知道查询结果只有一条或者只要最大/最小一条记录，建议用limit 1
9. Inner join 、left join、right join，优先使用Inner join，如果是left join，左边表结果尽量小  
• Inner join 内连接，在两张表进行连接查询时，只保留两张表中完全匹配的结果集   
• left join 在两张表进行连接查询时，会返回左表所有的行，即使在右表中没有匹配的记录。  
• right join 在两张表进行连接查询时，会返回右表所有的行，即使在左表中没有匹配的记录。  
10. 应尽量避免在 where 子句中使用!=或<>操作符，否则将引擎放弃使用索引而进行全表扫描。
```
-- 反例
select age,name  from user where age <>18;
-- 正例 使用UNION ALL
select age,name  from user where age <18;
select age,name  from user where age >18;
```
11. distinct 关键字一般用来过滤重复记录，以返回不重复的记录。在查询一个字段或者很少字段的情况下使用时，给查询带来优化效果。但是在字段很多的时候使用，却会大大降低查询效率。
12. 删除冗余和重复索引
13. where子句中考虑使用默认值代替null
14. 索引不适合建在有大量重复数据的字段上，如性别这类型数据库字段
15. 使用explain 分析你SQL的计划
