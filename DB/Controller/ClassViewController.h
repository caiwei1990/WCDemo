//
//  ClassViewController.h
//  IMDB
//
//  Created by caiwei02 on 2023/3/21.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "StudentFMDBModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ClassViewController : BaseViewController

@property (nonatomic, strong) StudentFMDBModel *model;

@end

NS_ASSUME_NONNULL_END
