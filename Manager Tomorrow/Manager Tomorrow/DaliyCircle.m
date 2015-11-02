//
//  DaliyCircle.m
//  Manager Tomorrow
//
//  Created by ios on 15/11/2.
//  Copyright © 2015年 tandepeng. All rights reserved.
//

#import "DaliyCircle.h"

@implementation DaliyCircle

- (void)drawRect:(CGRect)rect {
    /**
     ==================
     *1.先画一个底部的圆
     ==================
     **/
    //1.圆心
    CGPoint centerPoint = CGPointMake((rect.origin.x + rect.size.width)/2, (rect.origin.y + rect.size.height)/2);
    //2.半径
    CGFloat radius = (rect.size.width <= rect.size.height)?rect.size.width:rect.size.height;
    radius /= 2;
    radius -= 5;
    //4.画一整个圆
    UIBezierPath *allPath = [UIBezierPath bezierPathWithArcCenter:centerPoint radius:radius startAngle:-M_PI_2 endAngle:M_PI*2-M_PI_2 clockwise:YES];
    [[UIColor orangeColor]set];
    [allPath fill];
    
    /**
     ==================
     *2.根据今日完成的计划数，画圆弧
     ==================
     **/
     //终点
    CGFloat endAngle = (M_PI*2) * .3 -M_PI_2;
    UIBezierPath *resultPath = [UIBezierPath bezierPathWithArcCenter:centerPoint radius:radius startAngle:-M_PI_2 endAngle:endAngle clockwise:YES];
    //画两条线，形成一个弧
    CGContextRef context = UIGraphicsGetCurrentContext();
    //第一条线
    CGContextMoveToPoint(context, centerPoint.x, centerPoint.y);
    CGContextAddLineToPoint(context,centerPoint.x,centerPoint.y - radius);
    CGContextStrokePath(context);
    //第二条线
        CGContextMoveToPoint(context, centerPoint.x, centerPoint.y);
    //第二条线的终点
    CGFloat angle = endAngle - (endAngle/M_PI_2) * M_PI_2;
    float x = rect.origin.x + radius * sin(angle);
    float y = rect.origin.y + radius * cos(angle);

    CGContextAddLineToPoint(context,x,y);
    CGContextStrokePath(context);

    
    [[UIColor redColor]set];
    [resultPath stroke];
    

    
}

@end
