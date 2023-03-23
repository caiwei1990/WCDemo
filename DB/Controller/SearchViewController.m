//
//  SearchViewController.m
//  IMDB
//
//  Created by caiwei02 on 2023/3/21.
//

#import "SearchViewController.h"
#import "DataForFMDB.h"
#import "StudentFMDBModel.h"

@interface SearchViewController () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextField *searchTextField;

@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _dataArray = [NSMutableArray array];
    
    
    _tableView.tableFooterView = [UIView new];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"searchCell"];
    StudentFMDBModel *model = _dataArray[indexPath.row];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%ld--%ld",(long)model.sId,(long)model.sAge];
    return cell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.view endEditing:true];
}

- (IBAction)searchEvent:(UIButton *)sender {
    if (!_searchTextField.text.length) return;
    
    _dataArray = [DataForFMDB.sharedDataBase seachAllInfoWith:_searchTextField.text];
    
    [self.tableView reloadData];
}

@end
