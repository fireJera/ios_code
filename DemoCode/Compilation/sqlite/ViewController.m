//
//  ViewController.m
//  sqlite
//
//  Created by Jeremy on 2020/3/16.
//  Copyright © 2020 Jeremy. All rights reserved.
//

#import "ViewController.h"
#import "sqlite3.h"
#import "CTMSGDataBaseManager.h"
@interface ViewController () {
    sqlite3 * _db;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
//    [[CTMSGDataBaseManager shareInstance] insertBlackTargetId:@"10000"];
//    [[CTMSGDataBaseManager shareInstance] isBlackInTable:@"10000"];
    
    [self openDB];
    BOOL hasTable = [self p_judgeTable];
    if (hasTable) {
        
    }
    else {
        [self createTable];
    }
    [self insetsql];
    [self querysql];
    [self closesql];
}

- (void)openDB {
    NSString * dP = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    NSString * path = [dP stringByAppendingPathComponent:@"sqlite"];
    NSString *dbPath = [path stringByAppendingPathComponent:@"testdb"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    const char * filePath = [dbPath fileSystemRepresentation];
    int openResult = sqlite3_open(filePath, &_db);
    if (openResult == SQLITE_OK) {
        NSLog(@"open db success");
    }
    else {
        NSLog(@"open db fail");
        return;
    }
}

- (BOOL)p_judgeTable {
    sqlite3_stmt *pStmt = 0x00;
    int rc = 0x00;
    NSString * tableName = @"TestUser";
    NSString * sql = @"select count(*) as 'count' from sqlite_master where "
    @"type = 'table' And name = ?";
    
    // 如果第三个参数是负数，那么读到第一个\0 结束符，如果为正数，就是u要从zsql读取的字节数，w如果为0，应该就不执行了。
    // 最后一个参数，如果第二个参数和第三个参数生效后，从第二个参数读取到了终止符或者nbyte指定的字节后，第二个参数还有剩余的话，那么剩余的就会放在最后一个参数中。
    rc = sqlite3_prepare_v2(_db, [sql UTF8String], -1, &pStmt, 0);
    
    if (rc != SQLITE_OK) {
        sqlite3_finalize(pStmt);
        return NO;
    }
    //sql语句的参数个数
    int queryCount = sqlite3_bind_parameter_count(pStmt);
    // 这里的第四个参数和上面的一样。8
    sqlite3_bind_text(pStmt, 1, [[tableName description] UTF8String], -1, SQLITE_STATIC);
    
    NSInteger count = 0;
    do {
        rc = sqlite3_step(pStmt);
        if (rc == SQLITE_BUSY || rc == SQLITE_LOCKED) {
            NSLog(@"database busy");
        }
        else if (rc == SQLITE_DONE || rc == SQLITE_ROW) {
            NSLog(@"end");
        }
        else if (rc == SQLITE_ERROR) {
            NSLog(@"error");
        }
        else if (rc == SQLITE_MISUSE) {
        }
        else {
            
        }
        if (rc != SQLITE_ROW) {
            sqlite3_reset(pStmt);
        }
        else {
            int columnCount = sqlite3_column_count(pStmt);
            for (int i = 0; i < columnCount; i++) {
                NSString * name = [NSString stringWithUTF8String:sqlite3_column_name(pStmt, i)];
                if ([name isEqualToString:@"count"]) {
                    count = sqlite3_column_int(pStmt, i);
                }
            }
        }
        
    } while (rc == SQLITE_ROW);
    sqlite3_reset(pStmt);
    if (count == 0) {
        // 去创建表
        return NO;
    }
    else {
        return YES;
    }
}

- (void)createTable {
    NSString * tableName = @"TestUser";
    NSString * creatSql = @"create table TestUser"
    @"(userid text not null,"
    @"name text not null,"
    @"age integer DEFAULT 0,"
    @"sex integer DEFAULT 0)";
    
    int rc = 0x00;
    sqlite3_stmt * pStmt = 0x00;
    rc = sqlite3_prepare_v2(_db, [creatSql UTF8String], -1, &pStmt, 0);
    if (rc != SQLITE_OK) {
        sqlite3_finalize(pStmt);
        return;
    }
    int queryCount = sqlite3_bind_parameter_count(pStmt);
    if (queryCount == 0) {
        
    }
    else {
        
    }
    rc = sqlite3_step(pStmt);
    if (rc == SQLITE_DONE) {
        
    }
    else if (rc == SQLITE_INTERRUPT) {
        
    }
    else if (rc == SQLITE_ROW) {
        
    }
    else {
        if (rc == SQLITE_ERROR) {
            
        }
        else if (rc == SQLITE_MISUSE) {
            
        }
        else {
            
        }
    }
    sqlite3_reset(pStmt);
}

- (void)insetsql {
    int rc = 0x00;
    sqlite3_stmt * pstmt = 0x00;
    NSString * insetSql = @"insert into TestUser (userid, name, age, sex) values (?, ?, ?, ?)";
    sqlite3_prepare_v2(_db, [insetSql UTF8String], -1, &pstmt, 0);
    NSString * names = @"abcdefghijklmnopqrstuvwxyz";
    int length = arc4random_uniform(7) + 6;
    NSMutableString * name = [NSMutableString string];
    for (int i = 0; i < length; i++) {
        NSUInteger r = arc4random_uniform(26);
        NSString * str = [names substringWithRange:NSMakeRange(r, 1)];
        [name appendString:str];
    }
    NSString * uid = [NSString stringWithFormat:@"%d", arc4random_uniform(10) + 100000];
    sqlite3_bind_text(pstmt, 1, [uid UTF8String], -1, SQLITE_STATIC);
    sqlite3_bind_text(pstmt, 2, [name UTF8String], -1, SQLITE_STATIC);
    sqlite3_bind_int(pstmt, 3, 29);
    sqlite3_bind_int(pstmt, 4, 1);
    
    int queryCount = sqlite3_bind_parameter_count(pstmt);
    if (queryCount == 0) {
        sqlite3_reset(pstmt);
        return;
    }
//    do {
        rc = sqlite3_step(pstmt);
        if (rc == SQLITE_DONE) {
            
        }
        else if (rc == SQLITE_INTERRUPT) {
            
        }
        else if (rc == SQLITE_ROW) {
            
        }
        else {
            if (rc == SQLITE_ERROR) {
                
            }
            else if (rc == SQLITE_MISUSE) {
                
            }
            else {
                NSLog(@"insert error : %s", sqlite3_errmsg(_db));
                NSLog(@"DB query : %@", insetSql);
            }
        }
//    } while (rc != SQLITE_DONE && rc != SQLITE_OK);
}

- (void)querysql {
    int rc = 0x00;
    sqlite3_stmt *pstmt;
    NSString * querysql = @"select * from TestUser where age = ?";
    sqlite3_prepare_v2(_db, [querysql UTF8String], -1, &pstmt, 0);
    int queryCount = sqlite3_bind_parameter_count(pstmt);
    sqlite3_bind_int(pstmt, 1, 29);
    do {
        rc = sqlite3_step(pstmt);
        if (rc == SQLITE_BUSY || rc == SQLITE_LOCKED) {
            
        }
        else if (rc == SQLITE_DONE || rc == SQLITE_ROW) {
            NSLog(@"end");
            break;
        }
        else if (rc == SQLITE_ERROR) {
            
        }
        else if (rc == SQLITE_MISUSE) {
            
        }
    } while (rc == SQLITE_ROW);

    int columnCount = sqlite3_column_count(pstmt);
    for (int i = 0; i < columnCount; i++) {
        NSString * name = [[NSString stringWithUTF8String:sqlite3_column_name(pstmt, i)] lowercaseString];
        if ([name isEqualToString:@"userid"]) {
            NSString *uid;
            if (sqlite3_column_type(pstmt, i) == SQLITE_NULL ||
                i < 0 ||
                i >= sqlite3_column_count(pstmt)) {
                uid = nil;
            }
            else {
                const char *c = (const char *)sqlite3_column_text(pstmt, i);
                if (!c) {
                    uid = nil;
                }
                else {
                    uid = [NSString stringWithUTF8String:c];
                }
            }
        }
        else if ([name isEqualToString:@"name"]) {
            NSString *name;
            if (sqlite3_column_type(pstmt, i) == SQLITE_NULL ||
                i < 0 ||
                i >= sqlite3_column_count(pstmt)) {
                name = nil;
            }
            else {
                const char *c = (const char *)sqlite3_column_text(pstmt, i);
                if (!c) {
                    name = nil;
                }
                else {
                    name = [NSString stringWithUTF8String:c];
                }
            }
        }
        else if ([name isEqualToString:@"age"]) {
            int age = (int)sqlite3_column_int(pstmt, i);
        }
        else if ([name isEqualToString:@"sex"]) {
            int sex = (int)sqlite3_column_int(pstmt, i);
        }
    }
    sqlite3_reset(pstmt);
}

- (void)deletesql {
    
}

- (void)closesql {
    sqlite3_close(_db);
}

@end
