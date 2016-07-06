//
//  FaceView.h
//  Weibo
//
//  Created by 玉女峰峰主 on 15-12-11.
//  Copyright (c) 2015年 玉女峰峰主. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIViewExt.h"
//#define KScreenHeight [UIScreen mainScreen].bounds.size.height
//#define KScreenWidth [UIScreen mainScreen].bounds.size.width


@interface FaceView : UIView

@property (nonatomic, strong)NSMutableArray *itemsDic; //存放四组表情
@property (nonatomic, strong)UIImageView *imgView; //放大镜
@property (nonatomic, copy)NSString *selectImgName;//点击选中的表情

@end
