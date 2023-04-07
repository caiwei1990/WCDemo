//
//  DataForFMDB.h
//  IMDB
//
//  Created by caiwei02 on 2023/3/22.
//

#import <Foundation/Foundation.h>
@class StudentFMDBModel;
@class StudentClassModel;

NS_ASSUME_NONNULL_BEGIN

@interface DataForFMDB : NSObject

+(instancetype)sharedDataBase;

-(void)initDataBase;
/// 获取student表全部内容
- (NSMutableArray*)getAllStudent;
/// student表添加内容
-(void)addStudent:(StudentFMDBModel*)student;

-(void)deleteStudent:(StudentFMDBModel*)student;

-(void)updateStudent:(StudentFMDBModel*)student;
/// 删除student表
-(void)deleteAllStudent;



-(NSMutableArray*)getAllClassFromStudent:(StudentFMDBModel*)student;


/// 给class表添加课程
-(void)addClass:(StudentClassModel*)clas toStudent:(StudentFMDBModel*)student;

-(void)deleteClass:(StudentClassModel*)clas toStudent:(StudentFMDBModel*)student;

-(void)deleteAllCarsFromStudent:(StudentFMDBModel*)student;

-(void)deleteAllClass;

-(NSMutableArray*)seachAllInfoWith:(NSString*)str;

@end

NS_ASSUME_NONNULL_END
