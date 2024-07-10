//
//  MKMULogDatabaseManager.m
//  MKLoRaWAN-MTE_Example
//
//  Created by aa on 2024/7/2.
//  Copyright © 2024 aadyx2007@163.com. All rights reserved.
//

#import "MKMULogDatabaseManager.h"

#import <FMDB/FMDB.h>

#import "MKMacroDefines.h"

@implementation MKMULogDatabaseManager

+ (void)insertLogDatas:(NSArray <NSDictionary *>*)logList
            macAddress:(NSString *)macAddress
              sucBlock:(void (^)(void))sucBlock
           failedBlock:(void (^)(NSError *error))failedBlock {
    if (!logList) {
        [self operationInsertFailedBlock:failedBlock];
        return ;
    }
    FMDatabase* db = [FMDatabase databaseWithPath:kFilePath(@"MKMULogDB")];
    if (![db open]) {
        [self operationInsertFailedBlock:failedBlock];
        return;
    }
    NSString *sqlCreateTable = [NSString stringWithFormat:@"create table if not exists MKMULogDataTable (macAddress text,date text,logDetails text)"];
    BOOL resCreate = [db executeUpdate:sqlCreateTable];
    if (!resCreate) {
        [db close];
        [self operationInsertFailedBlock:failedBlock];
        return;
    }
    [[FMDatabaseQueue databaseQueueWithPath:kFilePath(@"MKMULogDB")] inDatabase:^(FMDatabase *db) {
        
        for (NSDictionary *logDic in logList) {
            BOOL exist = NO;
            FMResultSet * result = [db executeQuery:@"select * from MKMULogDataTable where macAddress = ? and date = ?",macAddress,SafeStr(logDic[@"date"])];
            while (result.next) {
                exist = YES;
            }
            if (exist) {
                //存在该设备，更新设备
                [db executeUpdate:@"UPDATE MKMULogDataTable SET logDetails = ? where macAddress = ?",SafeStr(logDic[@"logDetails"]),macAddress];
            }else{
                //不存在，插入设备
                [db executeUpdate:@"INSERT INTO MKMULogDataTable (macAddress,date,logDetails) VALUES (?,?,?)",macAddress,SafeStr(logDic[@"date"]),SafeStr(logDic[@"logDetails"])];
            }
        }
        
        if (sucBlock) {
            moko_dispatch_main_safe(^{
                sucBlock();
            });
        }
        [db close];
    }];
}

+ (void)readLocalLogsWithMacAddress:(NSString *)macAddress
                           sucBlock:(void (^)(NSArray <NSDictionary *>*logList))sucBlock
                        failedBlock:(void (^)(NSError *error))failedBlock {
    FMDatabase* db = [FMDatabase databaseWithPath:kFilePath(@"MKMULogDB")];
    if (![db open]) {
        [self operationGetDataFailedBlock:failedBlock];
        return;
    }
    [[FMDatabaseQueue databaseQueueWithPath:kFilePath(@"MKMULogDB")] inDatabase:^(FMDatabase *db) {
        NSMutableArray *tempDataList = [NSMutableArray array];
        FMResultSet * result = [db executeQuery:@"SELECT * FROM MKMULogDataTable where macAddress = ?",macAddress];
        while ([result next]) {
            NSDictionary *dic = @{
                @"macAddress":SafeStr([result stringForColumn:@"macAddress"]),
                @"logDetails":SafeStr([result stringForColumn:@"logDetails"]),
                @"date":SafeStr([result stringForColumn:@"date"]),
            };
        
            [tempDataList addObject:dic];
        }
        if (sucBlock) {
            moko_dispatch_main_safe(^{
                sucBlock(tempDataList);
            });
        }
        [db close];
    }];
}

+ (void)deleteDatasWithMacAddress:(NSString *)macAddress
                         sucBlock:(void (^)(void))sucBlock
                      failedBlock:(void (^)(NSError *error))failedBlock {
    [[FMDatabaseQueue databaseQueueWithPath:kFilePath(@"MKMULogDB")] inDatabase:^(FMDatabase *db) {
        BOOL result = [db executeUpdate:@"DELETE FROM MKMULogDataTable where macAddress = ?",macAddress];
        if (!result) {
            [self operationDeleteFailedBlock:failedBlock];
            return;
        }
        if (sucBlock) {
            moko_dispatch_main_safe(^{
                sucBlock();
            });
        }
        [db close];
    }];
}

+ (void)operationFailedBlock:(void (^)(NSError *error))block msg:(NSString *)msg{
    if (block) {
        NSError *error = [[NSError alloc] initWithDomain:@"com.moko.databaseOperation"
                                                    code:-111111
                                                userInfo:@{@"errorInfo":msg}];
        moko_dispatch_main_safe(^{
            block(error);
        });
    }
}

+ (void)operationInsertFailedBlock:(void (^)(NSError *error))block{
    [self operationFailedBlock:block msg:@"insert data error"];
}

+ (void)operationUpdateFailedBlock:(void (^)(NSError *error))block{
    [self operationFailedBlock:block msg:@"update data error"];
}

+ (void)operationDeleteFailedBlock:(void (^)(NSError *error))block{
    [self operationFailedBlock:block msg:@"fail to delete"];
}

+ (void)operationGetDataFailedBlock:(void (^)(NSError *error))block{
    [self operationFailedBlock:block msg:@"get data error"];
}

@end
