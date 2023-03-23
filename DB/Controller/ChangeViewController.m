//
//  ChangeViewController.m
//  IMDB
//
//  Created by caiwei02 on 2023/3/21.
//

#import "ChangeViewController.h"

@interface ChangeViewController () 

@property (weak, nonatomic) IBOutlet UITextField *sidTextField;
@property (weak, nonatomic) IBOutlet UITextField *sNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *saAgeTextField;

@end

@implementation ChangeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _sidTextField.text = [NSString stringWithFormat:@"%ld",(long)_model.sId];
    _sNameTextField.text = _model.sName;
    _saAgeTextField.text = [NSString stringWithFormat:@"%ld",(long)_model.sAge];
}

- (void)setModel:(StudentFMDBModel *)model {
    _model = model;
}

- (IBAction)changeEvent:(UIButton *)sender {
    
    if (!_sidTextField.text.length || !_sNameTextField.text.length || !_saAgeTextField.text.length) return;
    
    StudentFMDBModel *model = [[StudentFMDBModel alloc] init];
    model.sId = _sidTextField.text.integerValue;
    model.sName = _sNameTextField.text;
    model.sAge = _saAgeTextField.text.integerValue;
    
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(changeValue:)]) {
        [self.delegate changeValue:model];
    }
    
    [self.navigationController popViewControllerAnimated:true];
    
}

@end
