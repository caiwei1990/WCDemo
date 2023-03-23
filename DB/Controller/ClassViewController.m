//
//  ClassViewController.m
//  IMDB
//
//  Created by caiwei02 on 2023/3/21.
//

#import "ClassViewController.h"
#import "DataForFMDB.h"

@interface ClassViewController () <UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITextField *sIdTextField;
@property (weak, nonatomic) IBOutlet UITextField *cNameTextField;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation ClassViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _dataArray = [NSMutableArray arrayWithArray:[DataForFMDB.sharedDataBase getAllClassFromStudent:self.model]];
    
    self.tableView.tableFooterView = [UIView new];
    
    [self.tableView reloadData];
    
    self.sIdTextField.text = [NSString stringWithFormat:@"%ld",(long)_model.sId];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ClassTableCell"];
    StudentClassModel *model = _dataArray[indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@",model.cName];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:true];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSMutableArray *rowActions = [NSMutableArray array];
    
    __weak typeof(self) weakSelf = self;

    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
       
        StudentClassModel *model = weakSelf.dataArray[indexPath.row];
        
        [DataForFMDB.sharedDataBase deleteClass:model toStudent:weakSelf.model];
        
        [weakSelf.dataArray removeObjectAtIndex:indexPath.row];
        
        [weakSelf.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        
    }];
    deleteAction.backgroundColor = [UIColor redColor];
    
    [rowActions addObject:deleteAction];
    
    return rowActions;
}


- (UISwipeActionsConfiguration *)tableView:(UITableView *)tableView trailingSwipeActionsConfigurationForRowAtIndexPath:(NSIndexPath *)indexPath API_AVAILABLE(ios(11.0)) {
    __weak typeof(self) weakSelf = self;
    NSMutableArray *arrayM = [NSMutableArray array];
    
    UIContextualAction *deleteAction = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleDestructive title:@"删除" handler:^(UIContextualAction * _Nonnull action, __kindof UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
        completionHandler(YES);
        weakSelf.tableView.editing = NO;
        
        StudentClassModel *model = weakSelf.dataArray[indexPath.row];
        
        [DataForFMDB.sharedDataBase deleteClass:model toStudent:weakSelf.model];
        
        [weakSelf.dataArray removeObjectAtIndex:indexPath.row];
        
        [weakSelf.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        
    }];
    deleteAction.backgroundColor = [UIColor redColor];
    
    [arrayM addObject:deleteAction];

    UISwipeActionsConfiguration *configuration = [UISwipeActionsConfiguration configurationWithActions:[NSArray arrayWithArray:arrayM]];
    configuration.performsFirstActionWithFullSwipe = NO;
    return configuration;
}

- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}


#pragma mark - Event
- (IBAction)addClassEvent:(UIButton *)sender {
    
    if (!_cNameTextField.text.length) return;
    
    StudentClassModel *model = [[StudentClassModel alloc] init];
    model.scId = _model.sId;
    model.cName = _cNameTextField.text;
    
    [DataForFMDB.sharedDataBase addClass:model toStudent:_model];
    
    [_dataArray addObject:model];
    
    [_tableView reloadData];
    
    _cNameTextField.text = nil;
}

- (IBAction)deleteAllClass:(UIButton *)sender {
    
    [DataForFMDB.sharedDataBase deleteAllCarsFromStudent:_model];
    [_dataArray removeAllObjects];
    [_tableView reloadData];
}


#pragma mark - Setter
- (void)setModel:(StudentFMDBModel *)model {
    _model = model;
}

@end
