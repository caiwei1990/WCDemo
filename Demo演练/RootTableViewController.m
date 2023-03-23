//
//  RootTableViewController.m
//  Demo演练
//
//  Created by caiwei02 on 2023/3/23.
//

#import "RootTableViewController.h"

typedef NS_ENUM(NSInteger,KKEventType) {
    KKEvent_Segue = 0,
    KKEvent_Block = 1,
    KKEvent_Action = 2,
    KKEvent_Class = 3,
};

@interface EventModel : NSObject

@property (nonatomic, copy) NSString *title;

@property (nonatomic, assign) KKEventType eventType;

@property (nonatomic, copy) NSString *segue;

@property SEL method;

@end

@implementation EventModel



@end

@interface RootTableViewController ()

@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation RootTableViewController

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
        
        EventModel *model1 = [EventModel new];
        model1.title = @"数据库测试";
        model1.eventType = KKEvent_Segue;
        model1.segue = @"DBTest";
        [_dataArray addObject:model1];
        
        EventModel *model2 = [EventModel new];
        model2.title = @"点击测试";
        model2.eventType = KKEvent_Action;
        model2.segue = @"DBTest";
        model2.method = @selector(clickTestEvent);
        [_dataArray addObject:model2];
    }
    return _dataArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RootCell" forIndexPath:indexPath];
    
    EventModel *model = _dataArray[indexPath.row];
    
    cell.textLabel.text = model.title;

    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    
    EventModel *model = _dataArray[indexPath.row];
    switch(model.eventType) {
        case KKEvent_Action:
        {
            SEL selector = model.method;
            ((void (*)(id, SEL))[self methodForSelector:selector])(self, selector);
//            [self performSelector:model.method];
        }
            break;
        case KKEvent_Segue:
        {
            [self performSegueWithIdentifier:model.segue sender:nil];
        }
            break;
        default:
            break;
    }
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)clickTestEvent {
    NSLog(@"🌈%s🌈",__FUNCTION__);
//    NSLog(@"1111");
}

@end
