//
//  PlanViewController.m
//  Manager Tomorrow
//
//  Created by ios on 15/11/3.
//  Copyright © 2015年 tandepeng. All rights reserved.
//

#import "PlanViewController.h"

@interface PlanViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UIDatePicker *pickView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
//申明一个字典用来存放，计划要干什么事情，什么时间去干。
@property (nonatomic,strong) NSMutableDictionary *dataDic;
@property (weak, nonatomic) IBOutlet UIDatePicker *startPicker;
@property (weak, nonatomic) IBOutlet UIDatePicker *pickerTime;
@property (weak, nonatomic) IBOutlet UITextField *doingSome;
- (IBAction)finishBtn:(UIButton *)sender;
//标志计划是否完成的bool值
@property (nonatomic,strong) NSMutableDictionary *boolDic;


@end

@implementation PlanViewController
{
    //本地通知
    UILocalNotification *localNotification;
}
/**
 *对存放数据的字典进行懒加载，并且存入一个数据，我们就对数据进行本地化
 *取数据的时候我们也是从本地进行读取
 **/
- (NSMutableDictionary *)dataDic{
    if (!_dataDic) {
        _dataDic = [NSMutableDictionary dictionary];
    }
    
    return _dataDic;
}
- (NSMutableDictionary *)boolDic{
    if (!_boolDic) {
        _boolDic = [NSMutableDictionary dictionary];
    }
    return _boolDic;
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
    NSLog(@"===========\n%@",self.pickView.date);
    localNotification.alertBody = @"起床了,新的一天,请开启战斗模式";
    localNotification.soundName = @"80s Back Beat 01.caf";
    //通过app调度本地通知
    UIApplication *app = [UIApplication sharedApplication];
    [app scheduleLocalNotification:localNotification];
    
//    //将起床的时间放到字典中,将字典数据本地化
    [self.dataDic setObject:self.pickView.date forKey:@"起床"];
    
    [self dataLocal];
    
}
//数据的本地化
- (void)dataLocal{
    //先构建路径
    NSString *str = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *path = [str stringByAppendingPathComponent:@"dataDic.plist"];
    [self.dataDic writeToFile:path atomically:YES];
    
    NSString *path1 = [str stringByAppendingPathComponent:@"boolDic.plist"];
    [self.boolDic writeToFile:path1 atomically:YES];
    //刷新表视图
    [self.tableView reloadData];
    

}

//从本地读取数据
- (void)readLocalData{
    //从本地读取数据
    NSString *str = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *path = [str stringByAppendingPathComponent:@"dataDic.plist"];
    
    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:path];
    self.dataDic = (NSMutableDictionary *)dic;

}

#pragma mark-UITableViewDataSource and UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    [self readLocalData];
    return self.dataDic.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
    NSArray *arr = [self.dataDic allKeys];

    //获取做该件事情的时间
    cell.textLabel.text = arr[indexPath.row];
    NSDate *date = [self.dataDic objectForKey:cell.textLabel.text];
    //截取date中的时间
    NSString *string  = [NSString stringWithFormat:@"%@",date];
    NSArray *component = [string componentsSeparatedByString:@" "];
    cell.detailTextLabel.text = component[1];
    
    
    return cell;
    
}
- (IBAction)finishBtn:(UIButton *)sender {
    //当点击完成的时候，我们把用户选择的要干的事情和开始时间本地化
    [self.dataDic setObject:self.startPicker.date forKey:self.doingSome.text];

    [self.boolDic setObject:@(0) forKey:self.doingSome.text];
     //本地化数据
    [self dataLocal];
    
    //将完成这件事持续的时间也记录下来
    NSMutableArray *array = [NSMutableArray array];
    [array addObject:@(self.pickerTime.countDownDuration)];
    NSString *str = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *path1 = [str stringByAppendingPathComponent:@"array.plist"];
    [array writeToFile:path1 atomically:YES];
    
    NSLog(@"%@",NSHomeDirectory());
    
    
    //测试本地的数据
    [self readLocalData];
    NSLog(@"%@",self.dataDic);
    
    //将输入框中的内容清空
    self.doingSome.text = nil;
}
@end
