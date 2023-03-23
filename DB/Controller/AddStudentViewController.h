//
//  AddStudentViewController.h
//  IMDB
//
//  Created by caiwei02 on 2023/3/21.
//

#import <UIKit/UIKit.h>
#import "StudentFMDBModel.h"
#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface AddStudentViewController : BaseViewController

@property (nonatomic, copy) void(^saveBlock)(StudentFMDBModel *model);

@end

NS_ASSUME_NONNULL_END
