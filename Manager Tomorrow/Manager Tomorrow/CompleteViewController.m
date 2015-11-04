//
//  CompleteViewController.m
//  Manager Tomorrow
//
//  Created by ios on 15/11/3.
//  Copyright © 2015年 tandepeng. All rights reserved.
//

#import "CompleteViewController.h"
#import "DaliyCircle.h"
@interface CompleteViewController ()
@property (weak, nonatomic) IBOutlet UILabel *bigtitle;
@property (weak, nonatomic) IBOutlet DaliyCircle *circleView;
@property (weak, nonatomic) IBOutlet UILabel *hasFinishedLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalTasksLabel;

@property (nonatomic,strong) NSMutableDictionary *boolDic;

@end

@implementation CompleteViewController
//懒加载
- (NSMutableDictionary *)boolDic{
    if (!_boolDic) {
        _boolDic = [[NSMutableDictionary alloc]init];
    }
    return _boolDic;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //添加向左滑动的手势
    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeAction:)];
    swipe.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:swipe];

    NSDictionary *dic = [self readLocalData];
    //对UI控件进行赋值
    self.totalTasksLabel.text = [NSString stringWithFormat:@"今日总计划数:%lu",(unsigned long)dic.count];
    //对已经完成的计划进行计算
    int finish = 0;
    //取出bool字典
    NSDictionary *boolDic = [self readBoolData];
    //通过key值遍历字典，查找bool值为yes的个数
    NSArray *array = [boolDic allKeys];
    for (NSString *str in array) {
        NSNumber *number = [boolDic objectForKey:str];
        BOOL isFin = [number boolValue];
        if (isFin) {
            finish ++;
        }
    }
    self.hasFinishedLabel.text = [NSString stringWithFormat:@"已完成计划数:%d",finish];
    //对中心表示进度的圆圈的属性进行赋值
    self.circleView.result = finish/dic.count;

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
- (NSDictionary *)readBoolData{
    //从本地读取数据
    NSString *str = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *path = [str stringByAppendingPathComponent:@"boolDic.plist"];
    
    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:path];
    return dic;
    
}



#pragma mark-手势的响应方法
- (void)swipeAction:(UISwipeGestureRecognizer *)swipe{
    
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
    
}

@end
