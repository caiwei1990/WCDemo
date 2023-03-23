//
//  AddStudentViewController.m
//  IMDB
//
//  Created by caiwei02 on 2023/3/21.
//

#import "AddStudentViewController.h"

@interface AddStudentViewController ()
@property (weak, nonatomic) IBOutlet UITextField *sidTextField;
@property (weak, nonatomic) IBOutlet UITextField *sNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *saAgeTextField;

@end

@implementation AddStudentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (IBAction)saveStudentAction:(UIButton *)sender {
    if (!_sidTextField.text.length || !_sNameTextField.text.length || !_saAgeTextField.text.length) return;
    
    StudentFMDBModel *model = [[StudentFMDBModel alloc] init];
    model.sId = _sidTextField.text.integerValue;
    model.sName = _sNameTextField.text;
    model.sAge = _saAgeTextField.text.integerValue;
    
    
    if (_saveBlock) {
        _saveBlock(model);
    }
    
    [self.navigationController popViewControllerAnimated:true];
}

- (void)willMoveToParentViewController:(UIViewController *)parent {
    if (parent == nil) {
        
    }
}

@end
