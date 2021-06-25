//
//  ViewController.m
//  FGPopupSchedulerDemo
//
//  Created by FoneG on 2021/6/23.
//

#import "ViewController.h"
#import "BasePopupView.h"
#import "AnimationShowPopupView.h"
#import "ConditionsPopView.h"
#import "FGPopupScheduler.h"
#import "BlueViewController.h"
#import "FGPopupList.h"

@interface ViewController ()
@property (nonatomic, strong) FGPopupScheduler *Scheduler;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"切换策略" style:UIBarButtonItemStyleDone target:self action:@selector(exchangeScheduler)];
    
    [self setState:FGPopupSchedulerStrategyLIFO];
}

- (void)setState:(FGPopupSchedulerStrategy)pss{
    self.Scheduler = [[FGPopupScheduler alloc] initWithStrategy:pss];
    
    BasePopupView *pop1 =  [[BasePopupView alloc] initWithDescrption:@"第一个" scheduler:self.Scheduler];
    AnimationShowPopupView *pop2 =  [[AnimationShowPopupView alloc] initWithDescrption:@"自定义动画 pop2" scheduler:self.Scheduler];
    ConditionsPopView *pop3 =  [[ConditionsPopView alloc] initWithDescrption:@"条件弹窗 pop3" scheduler:self.Scheduler];
    AnimationShowPopupView *pop4 =  [[AnimationShowPopupView alloc] initWithDescrption:@"自定义动画 pop4" scheduler:self.Scheduler];
    
    [self.Scheduler add:pop1];
    [self.Scheduler add:pop2];
    [self.Scheduler add:pop3];
    [self.Scheduler add:pop4];
    
    switch (pss) {
        case FGPopupSchedulerStrategyFIFO:
            self.title = @"先进先出";
            break;
        case FGPopupSchedulerStrategyLIFO:
            self.title = @"后进先出";
            break;
        default:
            break;
    }
}

- (void)exchangeScheduler{
    UIAlertController *alter = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];

    UIAlertAction *FIFO = [UIAlertAction actionWithTitle:@"先进先出" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.Scheduler removeAllPopupViews];
        [self setState:FGPopupSchedulerStrategyFIFO];
    }];
    UIAlertAction *LIFO = [UIAlertAction actionWithTitle:@"后进先出" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.Scheduler removeAllPopupViews];
        [self setState:FGPopupSchedulerStrategyLIFO];
    }];
    
    [alter addAction:FIFO];
    [alter addAction:LIFO];
    [self presentViewController:alter animated:YES completion:nil];
}

- (IBAction)push:(id)sender {
    [self.navigationController pushViewController:[[BlueViewController alloc] init] animated:YES];
}

@end
