//
//  DatabaseManager.h
//  CoreDataDemo
//
//  Created by Lymn on 6/13/16.
//  Copyright © 2016 Andy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
@interface DatabaseManager : NSObject
@property(strong,nonatomic,readonly)NSManagedObjectModel* managedObjectModel;//管理数据模型
@property(strong,nonatomic,readonly)NSManagedObjectContext* managedObjectContext;//管理数据内容
@property(strong,nonatomic,readonly)NSPersistentStoreCoordinator* persistentStoreCoordinator;//持久化数据存储协调器
//创建数据库管理者单例
+(instancetype)shareManager;

//插入数据
-(void)insertData:(NSString*)tempName studentId:(NSNumber *)tempId studentAddress:(NSString *)tempAddress studentScore:(NSNumber *)tempScore;

//更新数据
-(void)updateData:(NSNumber*)tempID;

//删除数据
-(void)deleteData;

//删除数据
-(void)deleteData:(NSNumber*)tempID;

//查询数据
-(void)queryData;

//根据条件查询
-(void)queryData:(NSNumber*)tempID;

@end
