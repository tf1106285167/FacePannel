//
//  FacePannel.m
//  Weibo
//
//  Created by 玉女峰峰主 on 15-12-11.
//  Copyright (c) 2015年 玉女峰峰主. All rights reserved.
//

#import "FacePannel.h"
#import "FaceView.h"

#define KScreenHeight [UIScreen mainScreen].bounds.size.height
#define KScreenWidth [UIScreen mainScreen].bounds.size.width

@interface FacePannel(){
    
    UIScrollView *scrollV;//滚动视图
    UIPageControl *pageC;//分页控制器
}
@end

@implementation FacePannel

/**
 1.faceView
 2.UIScrollView
 3.pageConroll
 */

- (instancetype)initWithFrame:(CGRect)frame{
    
    if(self = [super initWithFrame:frame]){
        
        [self loadSubView];
    }
    return self;
}

- (void)loadSubView{
    
    FaceView *faceView = [[FaceView alloc]initWithFrame:CGRectZero];

    faceView.tag = 1002;
    faceView.backgroundColor = [UIColor clearColor];
    scrollV = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, faceView.height)];
    //滚动范围：faceView.width=375*4
    scrollV.contentSize = CGSizeMake(faceView.width, faceView.height);
    scrollV.pagingEnabled = YES; //开启分页
    scrollV.clipsToBounds = NO; //超出视图部分不裁剪
    scrollV.showsHorizontalScrollIndicator = NO;//是否显示水平方向的滚动条
    [scrollV addSubview:faceView];
    scrollV.delegate = self;
    [self addSubview:scrollV];
    
    //设置分页
    pageC = [[UIPageControl alloc]initWithFrame:CGRectMake(0, faceView.bottom, KScreenWidth, 20)];
    pageC.numberOfPages = faceView.itemsDic.count;
    pageC.tag = 1001;
    
    [pageC addTarget:self action:@selector(pageScrollAction) forControlEvents:UIControlEventValueChanged];

//    self.autoresizesSubviews = NO;
//    [self addSubview:pageC];
    self.width = KScreenWidth;
    self.height = faceView.height + pageC.height;
    [self addSubview:pageC];
    
    //（self）FacePannel的高度 = FaceView(UIScrollView) + UIPageControl 的高度
}

-(void)drawRect:(CGRect)rect{
    
    UIImage *image = [UIImage imageNamed:@"emoticon_keyboard_background.png"];
    
    [image drawInRect:rect];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    //获取当前页索引
    NSInteger index = scrollView.contentOffset.x/KScreenWidth;
    pageC.currentPage = index;
}

-(void)pageScrollAction{
    
    //获得当前页码
    NSInteger pages = pageC.currentPage;
    
    CGFloat contentOfSize = pages * KScreenWidth;
    
    [scrollV scrollRectToVisible:CGRectMake(contentOfSize, 0, scrollV.width, scrollV.height) animated:YES];
}

@end
