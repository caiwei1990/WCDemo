//
//  ChangeViewController.h
//  IMDB
//
//  Created by caiwei02 on 2023/3/21.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "StudentFMDBModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol ChangeValueDelegate <NSObject>

- (void)changeValue:(StudentFMDBModel *)model;

@end

@interface ChangeViewController : BaseViewController

@property (nonatomic, weak) id<ChangeValueDelegate> delegate;

@property (nonatomic, strong) StudentFMDBModel *model;

@end

NS_ASSUME_NONNULL_END
