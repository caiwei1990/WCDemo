//
//  AppDelegate.m
//  Demo演练
//
//  Created by caiwei02 on 2023/3/23.
//

#import "AppDelegate.h"
#import <LLDebugTool/LLDebugTool.h>


@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [[LLDebugTool sharedTool] startWorkingWithConfigBlock:^(LLConfig * _Nonnull config) {
        config.colorStyle = LLConfigColorStyleNovel;
    }];
    
    return YES;
}




@end
