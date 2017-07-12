//
//  ViewController.m
//  SearchBarDemo
//
//  Created by subo on 16/1/10.
//  Copyright © 2016年 FengFeiYang. All rights reserved.
//

#import "ViewController.h"
#import "UISearchBar+FMAdd.h"

@interface ViewController ()<UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UISearchBar *customSearchBar;
@property (weak, nonatomic) IBOutlet UISearchBar *minimalSearchBar;
@property (strong, nonatomic) UIButton *voiceButton;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.customSearchBar.delegate = self;
    self.customSearchBar.placeholder = @"请输入查询信息";
    
    //1. 设置背景颜色
    //设置背景图是为了去掉上下黑线
    self.customSearchBar.backgroundImage = [[UIImage alloc] init];
    // 设置SearchBar的颜色主题为白色
    self.customSearchBar.barTintColor = [UIColor whiteColor];
    
    //2. 设置圆角和边框颜色
    UITextField *searchField = [self.customSearchBar valueForKey:@"searchField"];
    if (searchField) {
        [searchField setBackgroundColor:[UIColor whiteColor]];
        searchField.layer.cornerRadius = 14.0f;
        searchField.layer.borderColor = [UIColor colorWithRed:247/255.0 green:75/255.0 blue:31/255.0 alpha:1].CGColor;
        searchField.layer.borderWidth = 1;
        searchField.layer.masksToBounds = YES;
    }
    
    //3. 设置按钮文字和颜色
    [self.customSearchBar fm_setCancelButtonTitle:@"取消"];
    self.customSearchBar.tintColor = [UIColor colorWithRed:86/255.0 green:179/255.0 blue:11/255.0 alpha:1];
    //设置取消按钮字体
    [self.customSearchBar fm_setCancelButtonFont:[UIFont systemFontOfSize:22]];
    //修正光标颜色
    [searchField setTintColor:[UIColor blackColor]];
    
    //4. 设置输入框文字颜色和字体
    [self.customSearchBar fm_setTextColor:[UIColor blackColor]];
    [self.customSearchBar fm_setTextFont:[UIFont systemFontOfSize:14]];
    
    //5. 设置搜索Icon
    [self.customSearchBar setImage:[UIImage imageNamed:@"Search_Icon"]
                  forSearchBarIcon:UISearchBarIconSearch
                             state:UIControlStateNormal];
    
    //6. 实现类似微信的搜索框
    UIButton *voiceButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [voiceButton setImage:[UIImage imageNamed:@"Voice_button_icon"] forState:UIControlStateNormal];
    [voiceButton addTarget:self action:@selector(tapVoiceButton:) forControlEvents:UIControlEventTouchUpInside];
    [searchField addSubview:voiceButton];
    self.voiceButton = voiceButton;
    
    //Autolayout
    voiceButton.translatesAutoresizingMaskIntoConstraints = NO;
    NSDictionary *views = NSDictionaryOfVariableBindings(voiceButton);
    //设置水平方向约束
    [searchField addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"[voiceButton(21)]-|" options:NSLayoutFormatAlignAllRight | NSLayoutFormatAlignAllLeft metrics:nil views:views]];
    //设置高度约束
    [searchField addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[voiceButton(21)]" options:NSLayoutFormatAlignAllTop | NSLayoutFormatAlignAllBottom metrics:nil views:views]];
    //设置垂直方向居中约束
    [searchField addConstraint:[NSLayoutConstraint constraintWithItem:voiceButton attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:searchField attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    //设置类似QQ搜索框
    self.minimalSearchBar.searchBarStyle = UISearchBarStyleMinimal;
}

//按钮触摸事件
- (IBAction)tapVoiceButton:(id)sender {
    NSLog(@"Tap voiceButton");
}

#pragma mark -
#pragma mark .....:::::: UISearchBarDelegate ::::::.....


- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    [searchBar setShowsCancelButton:YES animated:YES];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    searchBar.text = @"";
    [searchBar setShowsCancelButton:NO animated:YES];
    [searchBar endEditing:YES];
}

//监控文本变化
- (BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    self.voiceButton.hidden = searchBar.text.length + (text.length - range.length) > 0;
    return YES;
}

@end
