```shell
# 查看已有集合
show tables;
show collections;

# 创建集合
use test;
db.createCollection("mycol");
# 插入数据直接创建集合
db.mycol1.insert({"name" : "张三"});
# 删除集合
db.mycol1.drop()
# 统计集合内数据量
db.exceptionLog.count();
# 排序
db.exceptionLog.find().sort({"exceptionTime":-1});
# 删除所有数据
db.exceptionLog.remove({});
# 时间查询
db.exceptionLog.find({"exceptionTime": {$gte:new Date(2016,11,1)}})
# 分组查询
db.exceptionLog.aggregate([
    {
        $match: {
            exceptionTime: {
                $gte: new Date(2020, 2, 13),
                                $lte: new Date(2020, 2, 14)
            }
        }
    },
    {
        $group: {
            _id: '$action',
            counter: {
                $sum: 1
            }
        }
    }
])

```

