//
//  ViewController.m
//  Manager Tomorrow
//
//  Created by ios on 15/11/2.
//  Copyright © 2015年 tandepeng. All rights reserved.
//

#import "ViewController.h"
#import "DrawProgress.h"
@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet DrawProgress *progressView;
@property (weak, nonatomic) IBOutlet UILabel *timaLabel;
@property(nonatomic,assign)float time;
@property(nonatomic,assign)float totalTime;


- (IBAction)startButton:(UIButton *)sender;

@end

@implementation ViewController
//懒加载
- (float)totalTime{
    if (!_totalTime) {
        _totalTime = 20;
    }
    return _totalTime;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.label.text = @"不玩手机";
    
    
        
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)startButton:(UIButton *)sender {
    
        //启动定时器,对UI控件进行刷新

    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerAction:) userInfo:nil repeats:YES];
    sender.hidden = YES;
    //当事件完成后就推送本地通知
    [self addLocalNotification];


}
//定时器响应的方法
- (void)timerAction:(NSTimer *)timer{
    self.time ++;
    if (self.time >= self.totalTime + 1) {
        //如果到了时间，停止计时器
        [timer invalidate];
        return;
    }
    //计算剩余的时间
    float next = self.totalTime - self.time;
    NSInteger min = next/60;
    float second = next - min*60;
    //当秒数为整数的时候再给label赋值
    if ((self.time - (self.time / 1)) == 0 ) {

        //将时间label赋值
        NSString *strTime = [NSString stringWithFormat:@"%02ld:%02.0f",min,second];
        self.timaLabel.text = strTime;
        
        
        

    }


    //将进度图赋值
    self.progressView.baifenbi = self.time/self.totalTime;
    
}
//本地的通知
- (void)addLocalNotification{
    UILocalNotification *localNotification = [[UILocalNotification alloc]init];
    localNotification.fireDate = [NSDate dateWithTimeIntervalSinceNow:self.totalTime];
    localNotification.alertBody = self.label.text;
    
    UIApplication *app = [UIApplication sharedApplication];
    [app scheduleLocalNotification:localNotification];
    
}

@end
