//
//  DataForFMDB.m
//  IMDB
//
//  Created by caiwei02 on 2023/3/22.
//

#import "DataForFMDB.h"
#import <FMDB/FMDB.h>
#import "StudentFMDBModel.h"

@interface DataForFMDB()
{
    
    FMDatabase *fmdb;
    
}
@end

@implementation DataForFMDB

- (instancetype)init
{
    self = [super init];
    if (self) {
//        [self initDataBase];
    }
    return self;
}


static DataForFMDB *theData = nil;
static dispatch_once_t onceToken;

+(instancetype)sharedDataBase {
    
    dispatch_once(&onceToken, ^{
        theData = [[DataForFMDB alloc] init];
    });
    return theData;
}


-(void)initDataBase{
    
    //获得Documents目录路径
    
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    
    //文件路径
    
    NSString *filePath = [documentPath stringByAppendingPathComponent:@"student.db"];
    
    //实例化FMDataBase对象
        
    fmdb = [FMDatabase databaseWithPath:filePath];
    
    if([fmdb open]) {
        
        //初始化数据表
        
        [self addStudentTable];
        
        [self addClassTable];
        
        [fmdb close];
        
    }else{
        
        NSLog(@"数据库打开失败---%@", fmdb.lastErrorMessage);
        
    }
    
}

-(void)addStudentTable{
    
    NSString*studentSQL =@"create table if not exists student (id integer Primary Key Autoincrement, sId integer, sName text, sAge integer)";
    
    BOOL studentSuccess = [fmdb executeUpdate:studentSQL];
    
    if(!studentSuccess) {
        
        NSLog(@"studentTable创建失败---%@",fmdb.lastErrorMessage);
        
    }
    
}

-(void)addClassTable{
    
    NSString*classSQL =@"create table if not exists class (id integer Primary Key Autoincrement,scId integer, cName text)";
    
    BOOL classSuccess = [fmdb executeUpdate:classSQL];
    
    if(!classSuccess) {
        
        NSLog(@"classTable创建失败---%@",fmdb.lastErrorMessage);
        
    }
    
}


/// 获取student表全部内容
-(NSMutableArray*)getAllStudent{
    
    [fmdb open];
    
    NSMutableArray *array = [NSMutableArray new];
    
    FMResultSet *result = [fmdb executeQuery:@"select * from student"];
    
    while([result next]) {
        
        StudentFMDBModel *student = [[StudentFMDBModel alloc] init];
        
        student.sId = [[result stringForColumn:@"sId"] integerValue];
        
        student.sName= [result stringForColumn:@"sName"];
        
        student.sAge= [[result stringForColumn:@"sAge"] integerValue];
        
        [array addObject:student];
        
    }
    
    [fmdb close];
    
    return array;
    
}

/// student表添加内容
/// - Parameter student: <#student description#>
-(void)addStudent:(StudentFMDBModel*)student{
    
    [fmdb open];
    
    NSString *SQL =@"insert into student(sId,sName,sAge) values(?,?,?)";
    
    BOOL isAddSuccess = [fmdb executeUpdate:SQL,@(student.sId),student.sName,@(student.sAge)];
    
    if(!isAddSuccess) {
        
        NSLog(@"studentTable插入信息失败--%@",fmdb.lastErrorMessage);
        
    }
    
    [fmdb close];
    
}

/// student表删除内容
-(void)deleteStudent:(StudentFMDBModel*)student{
    
    [fmdb open];
    
    NSString *SQL =@"delete from student where sId = ?";
    
    BOOL isDeleteSuccess = [fmdb executeUpdate:SQL,@(student.sId)];
    
    if(!isDeleteSuccess) {
        
        NSLog(@"studentTable删除某一信息失败--%@",fmdb.lastErrorMessage);
        
    }
    
    [fmdb close];
    
}

/// student表修改内容
/// - Parameter student: <#student description#>
-(void)updateStudent:(StudentFMDBModel*)student{
    
    [fmdb open];
    
    NSString *SQL1 =@"update student set sName = ? where sId = ?";
    
    NSString *SQL2 =@"update student set sAge = ? where sId = ?";
    
    BOOL isSuccess1 = [fmdb executeUpdate: SQL1, student.sName,@(student.sId)];
    
    BOOL isSuccess2 = [fmdb executeUpdate: SQL2,@(student.sAge),@(student.sId)];
    
    if(!isSuccess1) {
        
        NSLog(@"student.sName修改失败--%@",fmdb.lastErrorMessage);
        
    }
    
    if(!isSuccess2) {
        
        NSLog(@"student.sAge修改失败--%@",fmdb.lastErrorMessage);
        
    }
    
    [fmdb close];
    
}

/// 删除student表
-(void)deleteAllStudent{
    
    [fmdb open];
    
    NSString *SQL =@"delete from student";
    
    BOOL isSuccess = [fmdb executeUpdate:SQL];
    
    if(!isSuccess) {
        
        NSLog(@"studentTable全部删除失败--%@",fmdb.lastErrorMessage);
        
    }
    
    //student表删除以后，对应的class也要删除
    
    [self deleteAllClass];
    
    [fmdb close];
    
}

/// 获取某一student class表的全部课程
/// - Parameter student: <#student description#>
-(NSMutableArray*)getAllClassFromStudent:(StudentFMDBModel*)student{
    
    [fmdb open];
    
    NSMutableArray *array = [NSMutableArray new];
    
    FMResultSet *result = [fmdb executeQuery:[NSString stringWithFormat:@"select * from class where scId = %ld", student.sId]];
    
    while([result next]) {
        
        StudentClassModel*class = [[StudentClassModel alloc] init];
        
        class.cName= [result stringForColumn:@"cName"];
        
        [array addObject:class];
        
    }
    
    [fmdb close];
    
    return array;
    
}

/// 给class表添加课程
/// - Parameters:
///   - clas: <#clas description#>
///   - student: <#student description#>
-(void)addClass:(StudentClassModel*)clas toStudent:(StudentFMDBModel*)student{
    
    [fmdb open];
    
    //scId integer, cName text
    
    NSString*SQL = [NSString stringWithFormat:@"insert into class (scId, cName) values (%ld,?)", student.sId];
    
    BOOL isSuccess = [fmdb executeUpdate:SQL, clas.cName];
    
    if(!isSuccess) {
        
        NSLog(@"classTable插入信息失败--%@",fmdb.lastErrorMessage);
        
    }
    
    [fmdb close];
    
}


/// 给class表删除课程
/// - Parameters:
///   - clas: <#clas description#>
///   - student: <#student description#>
-(void)deleteClass:(StudentClassModel*)clas toStudent:(StudentFMDBModel*)student{
    
    [fmdb open];
    
    NSString *SQL = [NSString stringWithFormat:@"delete from class where scId = %ld and cName = ?", student.sId];
    
    BOOL isSuccess = [fmdb executeUpdate:SQL,clas.cName];
    
    if(!isSuccess) {
        
        NSLog(@"classTable删除某一信息失败--%@",fmdb.lastErrorMessage);
        
    }
    
    [fmdb close];
    
}

/// 删除student下某一的全部class
/// - Parameter student: <#student description#>
-(void)deleteAllCarsFromStudent:(StudentFMDBModel*)student{
    
    [fmdb open];
    
    NSString *SQL = [NSString stringWithFormat:@"delete from class where scId = %ld", student.sId];
    
    BOOL isSuccess = [fmdb executeUpdate:SQL];
    
    if(!isSuccess) {
        
        NSLog(@"student下某一的全部class删除失败--%@",fmdb.lastErrorMessage);
        
    }
    
    [fmdb close];
    
}

/// /删除class表
-(void)deleteAllClass{
    
    NSString *SQL =@"delete from class";
    
    BOOL isSuccess = [fmdb executeUpdate:SQL];
    
    if(!isSuccess) {
        
        NSLog(@"classt全部删除失败--%@",fmdb.lastErrorMessage);
        
    }
    
}

-(NSMutableArray*)seachAllInfoWith:(NSString*)str {
    
    [fmdb open];
    
    NSMutableArray*array = [NSMutableArray new];
    
    //通过名字查询学生信息
    
    NSString *SQL = [NSString stringWithFormat:@"select * from student where sName = '%@' ", str]; // '%@' 可以查询中文
    
    FMResultSet *result = [fmdb executeQuery:SQL];
    
    while([result next]) {
        
        StudentFMDBModel *student = [[StudentFMDBModel alloc] init];
        
        student.sId= [result intForColumn:@"sId"];
        
        student.sName= [result stringForColumn:@"sName"];
        
        [array addObject:student];
        
    }
    
    [fmdb close];
    
    return array;
    
}



@end
