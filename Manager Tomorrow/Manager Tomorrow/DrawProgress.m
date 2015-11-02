//
//  DrawProgress.m
//  Manager Tomorrow
//
//  Created by ios on 15/11/2.
//  Copyright © 2015年 tandepeng. All rights reserved.
//

#import "DrawProgress.h"

@implementation DrawProgress
- (void)setBaifenbi:(float)baifenbi{
    _baifenbi = baifenbi;
    
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    
        //画圆弧
    //1.圆心
    CGPoint centerPoint = CGPointMake((rect.origin.x+rect.size.width)/2.0, (rect.origin.y+rect.size.height)/2.0);
    //2.半径
    float radius = (rect.size.width > rect.size.height)?rect.size.height:rect.size.width;
    radius /= 2;
    radius -= 10;
    //3.起点
    CGFloat start = -M_PI_2;
    //4.终点
    CGFloat end = (M_PI * 2) * self.baifenbi - M_PI_2;

    //5.绘制
    
    //绘制一个灰色的地圈
    UIBezierPath *grayPath = [UIBezierPath bezierPathWithArcCenter:centerPoint radius:radius startAngle:-M_PI_2 endAngle:M_PI*2-M_PI_2 clockwise:YES];
    grayPath.lineWidth = 10;
    grayPath.lineCapStyle = kCGLineCapRound;
    [[UIColor grayColor]set];
    [grayPath stroke];

    
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:centerPoint radius:radius startAngle:start endAngle:end clockwise:YES];
    path.lineWidth = 10;
    path.lineCapStyle = kCGLineCapRound;
    [[UIColor blueColor]set];
    [path stroke];
    
    

}
@end
