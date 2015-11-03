//
//  PlanViewController.m
//  Manager Tomorrow
//
//  Created by ios on 15/11/3.
//  Copyright © 2015年 tandepeng. All rights reserved.
//

#import "PlanViewController.h"

@interface PlanViewController ()
@property (weak, nonatomic) IBOutlet UIDatePicker *pickView;

@end

@implementation PlanViewController
{
    //本地通知
    UILocalNotification *localNotification;
}
- (void)viewDidLoad {
    [super viewDidLoad];

    
    //添加向右滑动的手势
    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeAction:)];
    swipe.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swipe];
    
    

    
    
}

/**
 ============================
 手势的响应方法
 ============================
 **/
- (void)swipeAction:(UISwipeGestureRecognizer *)swipe{

    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)pickView:(UIDatePicker *)sender {
    /**
     因为pickView中的值每修改一次，就会去调用该方法
     为了避免创建多个本地的通知
     我们需要的只是最后一个通知
     其它的都移除
     **/
    if (localNotification) {
        [[UIApplication sharedApplication]cancelLocalNotification:localNotification];
        localNotification = nil;
        
    }
    //添加通知
    [self startLocalNotification];
}

/**
 ==============================
 *pickView选择完成后，开启闹钟
 *获取到pickView上的时间
 *通过设定的起床时间定制起床闹钟
 ==============================
 **/

- (void)startLocalNotification{
    localNotification = [[UILocalNotification alloc]init];
    localNotification.fireDate = self.pickView.date;
    localNotification.alertBody = @"起床了,新的一天,请开启战斗模式";
    localNotification.soundName = @"80s Back Beat 01.caf";
    //通过app调度本地通知
    UIApplication *app = [UIApplication sharedApplication];
    [app scheduleLocalNotification:localNotification];

}
@end
