//
//  ViewController.m
//  Manager Tomorrow
//
//  Created by ios on 15/11/2.
//  Copyright © 2015年 tandepeng. All rights reserved.
//

#import "ViewController.h"
#import "DrawProgress.h"
#import "PlanViewController.h"
@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet DrawProgress *progressView;
@property (weak, nonatomic) IBOutlet UILabel *timaLabel;
@property(nonatomic,assign)float time;
@property(nonatomic,assign)float totalTime;
@property (weak, nonatomic) IBOutlet UIButton *startBtn;

@property (nonatomic,strong) NSMutableDictionary *boolDic;




@end

@implementation ViewController
{
    NSDictionary *_dic;
    NSArray *_array;

  

    
}
//懒加载
- (NSMutableDictionary *)boolDic{
    if (!_boolDic) {
        _boolDic = [NSMutableDictionary dictionary];
    }
    return _boolDic;
}

//从本地读取数据
- (NSDictionary *)readLocalData{
    //从本地读取数据
    NSString *str = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *path = [str stringByAppendingPathComponent:@"dataDic.plist"];
    
    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:path];
    
    return dic;
}
//从本地读取是否选中的数据
- (NSMutableDictionary *)readBoolData{
    //从本地读取数据
    NSString *str = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *path = [str stringByAppendingPathComponent:@"boolDic.plist"];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithContentsOfFile:path];
    return dic;
    
}
//时间间隔的数组
- (NSArray *)readLocalArray{
    NSString *str = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *path1 = [str stringByAppendingPathComponent:@"array.plist"];
    
    NSArray *array = [NSArray arrayWithContentsOfFile:path1];
    return array;
}
//重写标志是否完成计划的数组
- (void)writeBoolDic{
    //把数据写到本地
    NSString *str = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *path = [str stringByAppendingPathComponent:@"boolDic.plist"];
    
    [self.boolDic writeToFile:path atomically:YES];
    
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    /**
     做的第一件事情就是起床，
     所以bool数组的第一个值，，应该改为yes
     **/
    self.boolDic = [self readBoolData];
    [self.boolDic setObject:@(1) forKey:@"起床"];
    //数据本地化
    [self writeBoolDic];
    
    //先把数据从本地取出
    _dic = [self readLocalData];
    _array = [self readLocalArray];
    
    NSArray *arr = [_dic allKeys];


    if (arr) {
        self.label.text = arr[1];

    }
    //对总时间进行赋值
    NSLog(@"%@",_array[0]);
    self.totalTime = [_array[0] floatValue];
    
    //添加向左滑动的手势
    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeAction:)];
    swipe.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:swipe];
    
    //添加向右滑动的手势
    UISwipeGestureRecognizer *swipe1 = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeAction:)];
    swipe1.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swipe1];


    
    
        
}


/**
 ============================
 手势的响应方法
 ============================
 **/
- (void)swipeAction:(UISwipeGestureRecognizer *)swipe{
    if (swipe.direction == UISwipeGestureRecognizerDirectionLeft) {
        UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        PlanViewController *plan = [story instantiateViewControllerWithIdentifier:@"plan"];
        //推出z
        [self presentViewController:plan animated:NO completion:^{
            
        }];
//        [self.navigationController pushViewController:plan animated:YES];

    }else if (swipe.direction == UISwipeGestureRecognizerDirectionRight){
        
        UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        PlanViewController *complete = [story instantiateViewControllerWithIdentifier:@"complete"];
        //推出z
        [self presentViewController:complete animated:NO completion:^{
            
        }];
       
        
        
    }

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
        //如果到了时间，停止计时器，说明这件计划已经完成
        [timer invalidate];
        self.startBtn.hidden = NO;
        //将bool数组的中的改为yes
        //获取key值，既刚完成的这件事
        NSString *key = self.label.text;
        [self.boolDic setObject:@(1) forKey:key];
        //数据本地化
        [self writeBoolDic];
        
        
        return;
    }
    //计算剩余的时间
    float next = self.totalTime - self.time;
    NSInteger min = next/60;
    float second = next - min*60;


    //将时间label赋值
    NSString *strTime = [NSString stringWithFormat:@"%02ld:%02.0f",min,second];
    self.timaLabel.text = strTime;
    
        
        
        



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
