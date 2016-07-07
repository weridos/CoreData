//
//  DatabaseManager.m
//  CoreDataDemo
//
//  Created by Lymn on 6/13/16.
//  Copyright © 2016 Andy. All rights reserved.
//

#import "DatabaseManager.h"
#import "Student.h"
@implementation DatabaseManager
static DatabaseManager *shareManager = nil;//将对象定义为全局变量 已备在本类其他方法中方便使用
@synthesize managedObjectContext =_managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (instancetype)init{
    if (self == [super init]) {
        
    }
    return self;
}
+(instancetype)shareManager
{
    //GCD的写法
    static dispatch_once_t onceToken;
    //采用加锁机制，防止多线程出错
    dispatch_once(&onceToken, ^{
        shareManager = [[DatabaseManager alloc]init];
    });
    return shareManager;
}
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel!=nil) {
        return _managedObjectModel;
    }
    //从应用程序中加载模型文件
    NSURL* modelURL=[[NSBundle mainBundle] URLForResource:@"CoreDataDemo" withExtension:@"momd"];
    _managedObjectModel=[[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext!=nil) {
        return _managedObjectContext;
    }
    NSPersistentStoreCoordinator* coordinator=[self persistentStoreCoordinator];
    //初始化上下文
    if (coordinator!=nil) {
        _managedObjectContext=[[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator!=nil) {
        return _persistentStoreCoordinator;
    }
    //SQLite数据库文件路径
    NSString* docs=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
    NSURL* fileURL=[NSURL fileURLWithPath:[docs stringByAppendingPathComponent:@"coreData.sqlite"]];
    NSError* error=nil;
    _persistentStoreCoordinator=[[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    //判断数据库是否添加成功
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:fileURL options:nil error:&error]) {
        NSLog(@"Error: %@,%@",error,[error userInfo]);
    }
    return _persistentStoreCoordinator;
}
//插入数据
- (void)insertData:(NSString *)tempName studentId:(NSNumber *)tempId studentAddress:(NSString *)tempAddress studentScore:(NSNumber *)tempScore
{
    //创建一个Student实体对象，传入上下文
    Student *student = [NSEntityDescription insertNewObjectForEntityForName:@"Student" inManagedObjectContext:self.managedObjectContext];
    //设置属性
    student.name = tempName;
    student.studentID = tempId;
    student.address = tempAddress;
    student.score = tempScore;
    NSError *error;
    BOOL res = [self.managedObjectContext save:&error];
    if (!res) {
        NSLog(@"访问数据库出错：%@",[error localizedDescription]);
    }
}
//更新数据
- (void)updateData:(NSNumber *)tempID
{
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Student" inManagedObjectContext:self.managedObjectContext];
    //创建连接
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    [request setEntity:entity];
    //检索条件
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"studentID = %@",tempID];
    [request setPredicate:predicate];
    NSError *error;
    NSArray *resultArray = [self.managedObjectContext executeFetchRequest:request error:&error];
    if (resultArray.count) {
        for (Student *student in resultArray) {
            student.score = [NSNumber numberWithInt:90];
        }
        //更新数据后进行保存，否则没更新
        [self.managedObjectContext save:&error];

    }else
    {
        NSLog(@"未查询到可以更新的数据：%@",[error localizedDescription]);
    }
}
//删除所有数据
- (void)deleteData
{
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Student" inManagedObjectContext:self.managedObjectContext];
    //创建连接
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    [request setEntity:entity];
    NSError *error;
    NSArray *resultArray = [self.managedObjectContext executeFetchRequest:request error:&error];
    if (resultArray.count) {
        for (Student *student in resultArray) {
            [self.managedObjectContext deleteObject:student];
        }
        //删除数据后进行保存，否则没更新
        [self.managedObjectContext save:&error];
    }else
    {
        NSLog(@"未查询到可以删除的数据：%@",[error localizedDescription]);
    }
   
}
//删除指定数据
- (void)deleteData:(NSNumber *)tempID
{
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Student" inManagedObjectContext:self.managedObjectContext];
    //创建连接
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    [request setEntity:entity];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"studentID = %@",tempID];
    request.predicate = predicate;
    NSError *error;
    NSArray *resultArray = [self.managedObjectContext executeFetchRequest:request error:&error];
    if (resultArray.count) {
        for (Student *student in resultArray) {
            [self.managedObjectContext deleteObject:student];
        }
        //删除数据后进行保存，否则没更新
        [self.managedObjectContext save:&error];
    }else
    {
        NSLog(@"未查询到可以删除的数据：%@",[error localizedDescription]);
    }

}
//查询所有数据
- (void)queryData
{
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Student" inManagedObjectContext:self.managedObjectContext];
    //创建连接
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    [request setEntity:entity];
    NSError *error;
    NSArray *resultArray = [self.managedObjectContext executeFetchRequest:request error:&error];
    if (resultArray.count) {
        for (Student *student in resultArray) {
            NSLog(@"name = %@,studentID  = %@,address = %@,score = %@",student.name,student.studentID,student.address,student.score);
        }
    }else
    {
        NSLog(@"未查询到数据：%@",[error localizedDescription]);
    }

}
- (void)queryData:(NSNumber *)tempID
{
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Student" inManagedObjectContext:self.managedObjectContext];
    //创建连接
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    [request setEntity:entity];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"studentID = %@",tempID];
    request.predicate = predicate;
    NSError *error;
    NSArray *resultArray = [self.managedObjectContext executeFetchRequest:request error:&error];
    if (resultArray.count) {
        for (Student *student in resultArray) {
            NSLog(@"name = %@,studentID  = %@,address = %@,score = %@",student.name,student.studentID,student.address,student.score);
        }
    }else
    {
        NSLog(@"未查询到指定数据：%@",[error localizedDescription]);
    }

}
@end

