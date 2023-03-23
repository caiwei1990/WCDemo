//
//  StudentFMDBModel.h
//  IMDB
//
//  Created by caiwei02 on 2023/3/21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface StudentFMDBModel : NSObject

/// 学生id
@property (nonatomic, assign) NSInteger sId;

/// 学生姓名
@property (nonatomic, copy) NSString *sName;

/// 学生年龄
@property (nonatomic, assign) NSInteger sAge;

/// 学生所选可能
@property (nonatomic, strong) NSMutableArray *sClassArray;

@end


@interface StudentClassModel : NSObject

/// 所属学生Id
@property (nonatomic, assign) NSInteger scId;

/// 课程名字
@property (nonatomic, copy) NSString *cName;

@end

NS_ASSUME_NONNULL_END
