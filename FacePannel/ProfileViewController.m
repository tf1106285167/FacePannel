//
//  ProfileViewController.m
//  Weibo
//
//  Created by 玉女峰峰主 on 15-12-1.
//  Copyright (c) 2015年 玉女峰峰主. All rights reserved.
//

#import "ProfileViewController.h"
#import "FacePannel.h"

#define KScreenWidth [UIScreen mainScreen].bounds.size.width

@interface ProfileViewController ()
{
    UITextView *textView;
}
@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor brownColor];
    
    textView = [[UITextView alloc]initWithFrame:CGRectMake(0, 20, KScreenWidth, 130)];
    [self.view addSubview:textView];
    
    
    FacePannel *pan =[[FacePannel alloc]initWithFrame:CGRectMake(0, 170, 0, 0)];
    
    [self.view addSubview:pan];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(faceNameChange:) name:@"faceName" object:nil];
}

-(void)faceNameChange:(NSNotification *)info{

    textView.text = [NSString stringWithFormat:@"%@%@",textView.text,[info.userInfo objectForKey:@"faceName"]];
}


@end
