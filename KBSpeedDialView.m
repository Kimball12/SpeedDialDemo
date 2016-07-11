//
//  KBSpeedDialView.m
//  SpeedDialDemo
//
//  Created by 韩金波 on 16/7/11.
//  Copyright © 2016年 Psylife. All rights reserved.
//

#import "KBSpeedDialView.h"

@interface KBSpeedDialView()

@property (nonatomic,strong) NSMutableArray <UIButton *> *selectedArray;

//线条颜色的属性
@property(nonatomic,strong)UIColor *lineColor;

//接收 多余的点
@property(nonatomic,assign)CGPoint destdationPoint;
@end

@implementation KBSpeedDialView
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(NSMutableArray<UIButton *> *)selectedArray
{
    if (!_selectedArray) {
         _selectedArray = [NSMutableArray array];
    }
    return _selectedArray;
}
- (UIColor *)lineColor
{
    if (!_lineColor) {
        
        _lineColor = [UIColor whiteColor];
    }
    
    return _lineColor;
    
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        for (int i = 0; i <9; i++) {
        
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.userInteractionEnabled = NO;
            [button setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
                 button.tag = i;
            button.backgroundColor = [UIColor redColor];
            self.backgroundColor = [UIColor blueColor];
            [self addSubview:button];
        }
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat w = 70;
    CGFloat h = w;
    NSInteger columns =3;
    CGFloat S_W = self.bounds.size.width;
    CGFloat margW = (S_W - w *columns)/(columns -1);
    CGFloat margH = margW;
    
    for (int i = 0; i< self.subviews.count; i++) {
        NSInteger row = i/columns;
        NSInteger col = i%columns;
        CGFloat butX = (margW + w) *col;
        CGFloat butY = (margH + h) *row;
        UIButton *button = self.subviews[i];
        button.layer.cornerRadius = w/2;
        button.frame = CGRectMake(butX, butY, w, h);
    }
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = touches.anyObject;
    CGPoint loc = [touch locationInView:touch.view];
     self.destdationPoint = loc;
    for (NSInteger i= 0; i<self.subviews.count; i+=1) {
        UIButton *button = self.subviews[i];
        if (CGRectContainsPoint(button.frame, loc)&& !button.highlighted) {
            button.highlighted = YES;
            [_selectedArray addObject:button];
            NSLog(@"%@",@(i));
        }
    }
    [self setNeedsDisplay];
}

-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = touches.anyObject;
    CGPoint loc = [touch locationInView:touch.view];
    //接收 多出来的点
    self.destdationPoint = loc;

    for (NSInteger i= 0; i<self.subviews.count; i+=1) {
        UIButton *button = self.subviews[i];
        if (CGRectContainsPoint(button.frame, loc)&& !button.highlighted) {
            button.highlighted = YES;
             [_selectedArray addObject:button];
            NSLog(@"%@",@(i));
        }
    }
    [self setNeedsDisplay];
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    self.destdationPoint = [[self.selectedArray lastObject] center];
    //1.获取密码
    NSMutableString *pwd = [NSMutableString string];
    for(UIButton *btn in self.selectedArray){
        
        //拼接密码
        [pwd appendFormat:@"%@",@(btn.tag)];
        
    }
    
    //2. 验证
    
    if([pwd isEqualToString:@"012"]){//正确
        // 正确: 按钮高亮状态消失, 线消失
        
        [self clearPath];
        
    }else{
        
        //不正确: 按钮红色, 线消失: 按钮状态消失
        
        for (UIButton *btn in self.selectedArray) {
            
            //按钮的状态 不能同时存在
            btn.highlighted = NO;
            btn.selected = YES;
            
        }
        
        //设置 线条颜色 为红色
        self.lineColor = [UIColor redColor];
        
        //重绘
        [self setNeedsDisplay];
        
        //关闭 交互
        self.userInteractionEnabled = NO;
        
        //延迟
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self clearPath];
            //开启交互
            self.userInteractionEnabled = YES;
            
        });
    }
    
}

-(void)drawRect:(CGRect)rect
{
    UIBezierPath *path = [UIBezierPath bezierPath];
    for (NSInteger i =0; i<self.selectedArray.count; i++) {
        if (i == 0) {
            [path moveToPoint:self.selectedArray[i].center];
        }else{
            [path addLineToPoint:self.selectedArray[i].center];
        }
    }
    
    
    if (self.selectedArray.count >0) {
        [path addLineToPoint:self.destdationPoint];
    }
    path.lineWidth = 15;
    [self.lineColor set];
    [path stroke];
}
//清空画线集合
- (void)clearPath
{
    
    //将原先的红色 在设置为白色
    self.lineColor = [UIColor whiteColor];
    
    //取消按钮的高亮
    for(UIButton *btn in self.selectedArray){
        
        btn.highlighted = NO;
        btn.selected = NO;
        
    }
    
    //清空 画线的集合
    [self.selectedArray removeAllObjects];
    
    //重绘
    [self setNeedsDisplay];
    
}

@end
