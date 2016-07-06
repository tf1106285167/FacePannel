//
//  FaceView.m
//  Weibo
//
//  Created by 玉女峰峰主 on 15-12-11.
//  Copyright (c) 2015年 玉女峰峰主. All rights reserved.
//

#import "FaceView.h"


#define imgWidth 30
#define imgHeight 30
#define itemsWidth (KScreenWidth/7)
#define itemsHeight (KScreenWidth/7)

#define KScreenHeight [UIScreen mainScreen].bounds.size.height
#define KScreenWidth [UIScreen mainScreen].bounds.size.width

@implementation FaceView

-(instancetype)initWithFrame:(CGRect)frame{
    
    if(self = [super initWithFrame:frame]){
        
        [self loadFace];
    }
    return self;
}

-(void)loadFace{
    
    //1.获取表情文件数组
    NSArray *array = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"emoticons.plist" ofType:nil]];
    //2.定义一个可变的数组来装小数组,还需要创建小数组
    _itemsDic = [NSMutableArray array];
    NSMutableArray *items2Dic = nil;
    //3.循环数组
    for(int i=0; i<array.count; i++){
        
        //分4组：创建四个数组
        if(items2Dic == nil || items2Dic.count == 28){
            
            items2Dic = [NSMutableArray arrayWithCapacity:28];
            [_itemsDic addObject:items2Dic];
        }
        //取出字典依次存放在4个组中
        NSDictionary *faceDic = [array objectAtIndex:i];
        [items2Dic addObject:faceDic];
    }
    self.width = KScreenWidth * _itemsDic.count; //共四组
    self.height = itemsHeight * 4; //每组都是4行
}

////当前视图显示在屏幕的时候会调用这个方法; drawRect调是在Controller->loadView, Controller->viewDidLoad 两方法之后掉用的.drawRect方法一般情况下只会被掉用一次
-(void)drawRect:(CGRect)rect{
    
    CGFloat col = 0;
    CGFloat row = 0;
    for(int i=0; i<_itemsDic.count; i++){ //_itemsDic.count=4
        
        NSArray *item2Dict = _itemsDic[i];
        //从小数组中获取每个存储表情的字典
        for(int j=0; j<item2Dict.count; j++){ //item2Dict.count=28
            //从数组中取出字典
            NSDictionary *dic = item2Dict[j];
            //根据key从字典中取出图片
            NSString *imgName = [dic objectForKey:@"png"];
            UIImage *img = [UIImage imageNamed:imgName];
            
            //图片显示的位置
            CGFloat x = col*itemsWidth + (itemsWidth-imgWidth)/2 + KScreenWidth*i;
            CGFloat y = row*itemsHeight +(itemsHeight-imgHeight)/2;
            
            [img drawInRect:CGRectMake(x, y, imgWidth, imgHeight)];
            
            col++;
            if(col ==7){  //一行显示7个表情
                col = 0;
                row ++;
            }
            if(row == 4){
                row = 0;
            }
        }
    }
}


#pragma mark - 触摸事件
//开始触摸
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    self.imgView.hidden = NO;
     //解决手势冲突  在表情视图中触摸则不能滚动
    if([self.superview isKindOfClass:[UIScrollView class]]){
        UIScrollView *scrollView = (UIScrollView *)self.superview;
        scrollView.scrollEnabled = NO;
    }
    
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    [self touchFace:point];
}

//正在移动
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    [self touchFace:point];
    
}

//触摸结束
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    
    self.imgView.hidden = YES;
    if([self.superview isKindOfClass:[UIScrollView class]]){
        UIScrollView *scrollV = (UIScrollView *)self.superview;
        scrollV.scrollEnabled = YES;
    }
}

//获取表情
-(void)touchFace:(CGPoint)point{
    
    /**
     CGFloat x = col*itemsWidth + (itemsWidth-imgWidth)/2 + KScreenWidth*i;
     CGFloat y = row*itemsHeight +(itemsHeight-imgHeight)/2;
     */
    
    //1.确定页数
    NSInteger page = point.x / KScreenWidth;
    
    //判断是否越界

    if(page>_itemsDic.count || page<0){
        return;
    }
    
    //2.确定行和列
    NSInteger col = (point.x - ((itemsWidth-imgWidth)/2 +KScreenWidth*page)) / itemsWidth;
    NSInteger row = (point.y - (itemsHeight-imgHeight)/2) / itemsHeight;
    
    //容错处理
    //行 0-3  列 0-6
    if(col > 6) col=6;
    if(col < 0) col=0;
    if(row > 3) row=3;
    if(row < 0) row=0;
    
    //3.计算数组中的位置
    NSInteger index = row * 7 + col;
    if(page == _itemsDic.count-1){
        
        NSArray *item2 = _itemsDic[page];
        if(index > item2.count-1){
            return;
        }
    }
    
       //4.获取图片和名字
    NSArray *item2 =_itemsDic[page];//获取第几组
    NSDictionary *faceDic = item2[index];//获取点击图片的相关信息
    NSString *imgName = faceDic[@"png"];
    NSString *faceName = faceDic[@"chs"];
    
    NSLog(@"-----faceName:%@",faceName);
    NSDictionary *Diction = [NSDictionary dictionaryWithObjectsAndKeys:faceName,@"faceName", nil];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"faceName" object:self userInfo:Diction];
    
    //5.判断放大镜的位置
    if(![self.selectImgName isEqualToString:faceName]){
    
    CGFloat x = col * itemsWidth + itemsWidth/2 +page * KScreenWidth;
    CGFloat bottom = row * itemsHeight + itemsHeight / 2;
    //设置放大镜的位置
    self.imgView.center =CGPointMake(x, 0);
    self.imgView.bottom = bottom;
    
    UIImageView *faceImgV = (UIImageView *)[self.imgView viewWithTag:1000];
    faceImgV.image = [UIImage imageNamed:imgName];
    }
    //获取点击的表情视图的表情名
    self.selectImgName = faceName;
}

//放大镜图片
-(UIImageView *)imgView{
    
    if(_imgView == nil){
    
        _imgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"emoticon_keyboard_magnifier@2x.png"]];
        [_imgView sizeToFit];//得到最适合当前图片的尺寸
        _imgView.hidden = YES;
        [self addSubview:_imgView];//将放大镜添加到表情视图中
        //设置表情视图的位置
        UIImageView *faceImgView = [[UIImageView alloc]initWithFrame:CGRectMake((_imgView.width-imgWidth)/2, 15, imgWidth, imgHeight)];
        faceImgView.tag = 1000;
        [_imgView addSubview:faceImgView]; //将表情视图添加到放大镜上
    }
        return _imgView;
}


@end
