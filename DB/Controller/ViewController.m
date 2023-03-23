//
//  ViewController.m
//  IMDB
//
//  Created by caiwei02 on 2023/3/21.
//

#import "ViewController.h"
#import "DataForFMDB.h"
#import "StudentFMDBModel.h"
#import "AddStudentViewController.h"
#import "ChangeViewController.h"
#import "ClassViewController.h"

#define SeguID @"tableViewSelected"
#define ChangeSeguID @"showChange"
#define AddStudent @"addStudent"

@interface ViewController () <UITableViewDataSource,UITableViewDelegate,ChangeValueDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _dataArray = [NSMutableArray array];
    
    _tableView.tableFooterView = [UIView new];
    
    [[DataForFMDB sharedDataBase] initDataBase];
    
//    _dataArray = [[DataForFMDB sharedDataBase] getAllStudent];
    [self reloadTableView];
    
}

- (void)reloadTableView {
    _dataArray = [[DataForFMDB sharedDataBase] getAllStudent];
    [self.tableView reloadData];
}

#pragma mark - ChangeValueDelegate
- (void)changeValue:(StudentFMDBModel *)model {
    [[DataForFMDB sharedDataBase] updateStudent:model];
    [self reloadTableView];
}

#pragma mark - UITableViewDataSource,UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return  _dataArray.count;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TableViewCell"];
    
    StudentFMDBModel *model = _dataArray[indexPath.row];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%ld---%@---%ld",(long)model.sId,model.sName,(long)model.sAge];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    
    StudentFMDBModel *model = _dataArray[indexPath.row];
    
    [self performSegueWithIdentifier:SeguID sender:model];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSMutableArray *rowActions = [NSMutableArray array];
    
    __weak typeof(self) weakSelf = self;

    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
       
        StudentFMDBModel *model = weakSelf.dataArray[indexPath.row];
        
        [DataForFMDB.sharedDataBase deleteStudent:model];
        
        [weakSelf.dataArray removeObject:model];
        
        [weakSelf.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        
    }];
    deleteAction.backgroundColor = [UIColor redColor];

  
    UITableViewRowAction *changeAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"修改" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        
        StudentFMDBModel *model = weakSelf.dataArray[indexPath.row];
        
        [weakSelf performSegueWithIdentifier:ChangeSeguID sender:model];
        
    }];
    changeAction.backgroundColor = [UIColor greenColor];
    
    
    [rowActions addObject:deleteAction];
    [rowActions addObject:changeAction];
    
    return rowActions;
}


- (UISwipeActionsConfiguration *)tableView:(UITableView *)tableView trailingSwipeActionsConfigurationForRowAtIndexPath:(NSIndexPath *)indexPath API_AVAILABLE(ios(11.0)) {
    __weak typeof(self) weakSelf = self;
    NSMutableArray *arrayM = [NSMutableArray array];
    
    UIContextualAction *deleteAction = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleDestructive title:@"删除" handler:^(UIContextualAction * _Nonnull action, __kindof UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
        completionHandler(YES);
        weakSelf.tableView.editing = NO;
        
        StudentFMDBModel *model = weakSelf.dataArray[indexPath.row];
        
        [DataForFMDB.sharedDataBase deleteStudent:model];
        
        [weakSelf.dataArray removeObject:model];
        
        [weakSelf.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        
    }];
    deleteAction.backgroundColor = [UIColor redColor];
        
    UIContextualAction *changeAction = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleNormal title:@"修改" handler:^(UIContextualAction * _Nonnull action, __kindof UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
        completionHandler(YES);
        weakSelf.tableView.editing = NO;
        StudentFMDBModel *model = weakSelf.dataArray[indexPath.row];
        
        [weakSelf performSegueWithIdentifier:ChangeSeguID sender:model];
    }];
    changeAction.backgroundColor = [UIColor greenColor];
    
    [arrayM addObject:deleteAction];
    [arrayM addObject:changeAction];

    UISwipeActionsConfiguration *configuration = [UISwipeActionsConfiguration configurationWithActions:[NSArray arrayWithArray:arrayM]];
    configuration.performsFirstActionWithFullSwipe = NO;
    return configuration;
}

- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}


#pragma mark -

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue identifier] isEqualToString:SeguID]) {
        
        ClassViewController *vc = segue.destinationViewController;
        vc.model = sender;
        
    } else if ([[segue identifier] isEqualToString:AddStudent]) {
        AddStudentViewController *vc = segue.destinationViewController;
        
        vc.saveBlock = ^(StudentFMDBModel * _Nonnull model) {
            [[DataForFMDB sharedDataBase] addStudent:model];
            
            [self reloadTableView];
        };
    } else if ([[segue identifier] isEqualToString:ChangeSeguID]) {
        UIViewController* vc = segue.destinationViewController;
        [vc setValue:sender forKey:@"model"];
        [vc setValue:self forKey:@"delegate"];
    }
    
}

#pragma mark - Event
- (IBAction)searchAction:(UIBarButtonItem *)sender {
    NSLog(@"🌈%s🌈",__FUNCTION__);
}


- (IBAction)deleteAll:(id)sender {
    [DataForFMDB.sharedDataBase deleteAllStudent];
    [self reloadTableView];
}

@end
