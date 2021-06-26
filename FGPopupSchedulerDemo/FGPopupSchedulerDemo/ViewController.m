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
#import "PriorityPopupView.h"

#import "FGPopupScheduler.h"
#import "BlueViewController.h"
#import "FGPopupList.h"

@interface ViewController ()
@property (nonatomic, weak) FGPopupScheduler *Scheduler;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    BOOL suspend = YES;
    
    UIBarButtonItem *suspended = [[UIBarButtonItem alloc] initWithTitle:suspend?@"恢复":@"挂起" style:UIBarButtonItemStyleDone target:self action:@selector(suspendedState:)];
    UIBarButtonItem *pss = [[UIBarButtonItem alloc] initWithTitle:@"切换策略" style:UIBarButtonItemStyleDone target:self action:@selector(exchangeScheduler)];
    UIBarButtonItem *clear = [[UIBarButtonItem alloc] initWithTitle:@"清空" style:UIBarButtonItemStyleDone target:self action:@selector(clearScheduler)];
    self.navigationItem.leftBarButtonItem = clear;
    self.navigationItem.rightBarButtonItems = @[suspended, pss];

    
    [self setState:FGPopupSchedulerStrategyPriority|FGPopupSchedulerStrategyLIFO];
    self.Scheduler.suspended = suspend;
    [self fillPopupViews];
}

- (void)setState:(FGPopupSchedulerStrategy)pss{
    FGPopupScheduler *Scheduler = FGPopupSchedulerGetForPSS(pss);
    self.Scheduler = Scheduler;
    
    if (pss & FGPopupSchedulerStrategyPriority) {
        self.title = pss & FGPopupSchedulerStrategyLIFO ? @"优先级 & LIFO": @"优先级 & FIFO";
    }
    else if (pss == FGPopupSchedulerStrategyFIFO) {
        self.title = @"先进先出";
    }
    else if(pss == FGPopupSchedulerStrategyLIFO){
        self.title = @"后进先出";
    }
}

- (void)fillPopupViews{
    FGPopupScheduler *Scheduler = self.Scheduler;
    BasePopupView *pop1 =  [[BasePopupView alloc] initWithDescrption:@"第一个 pop1" scheduler:Scheduler];
    AnimationShowPopupView *pop2 =  [[AnimationShowPopupView alloc] initWithDescrption:@"自定义动画 pop2" scheduler:Scheduler];
    ConditionsPopView *pop3 =  [[ConditionsPopView alloc] initWithDescrption:@"条件弹窗 pop3" scheduler:Scheduler];
    PriorityPopupView *pop4 =  [[PriorityPopupView alloc] initWithDescrption:@"优先级动画 pop4" scheduler:Scheduler];
    PriorityPopupView *pop5 =  [[PriorityPopupView alloc] initWithDescrption:@"优先级动画 pop5" scheduler:Scheduler];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [Scheduler add:pop1];
        [Scheduler add:pop2];
//        [Scheduler add:pop3];
//        [Scheduler add:pop4 strategy:FGPopupViewStrategyKeep Priority:FGPopupStrategyPriorityLow];
//        [Scheduler add:pop5 strategy:FGPopupViewStrategyKeep Priority:FGPopupStrategyPriorityLow];
    });
}

- (void)exchangeScheduler{
    UIAlertController *alter = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];

    UIAlertAction *FIFO = [UIAlertAction actionWithTitle:@"先进先出" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.Scheduler removeAllPopupViews];
        [self setState:FGPopupSchedulerStrategyFIFO];
        [self fillPopupViews];
    }];
    UIAlertAction *LIFO = [UIAlertAction actionWithTitle:@"后进先出" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.Scheduler removeAllPopupViews];
        [self setState:FGPopupSchedulerStrategyLIFO];
        [self fillPopupViews];
    }];
    UIAlertAction *PriorityFIFO = [UIAlertAction actionWithTitle:@"优先级 & FIFO" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.Scheduler removeAllPopupViews];
        [self setState:FGPopupSchedulerStrategyPriority];
        [self fillPopupViews];
    }];
    UIAlertAction *PriorityLIFO = [UIAlertAction actionWithTitle:@"优先级 & LIFO" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.Scheduler removeAllPopupViews];
        [self setState:FGPopupSchedulerStrategyPriority | FGPopupSchedulerStrategyLIFO];
        [self fillPopupViews];
    }];
    
    [alter addAction:FIFO];
    [alter addAction:LIFO];
    [alter addAction:PriorityFIFO];
    [alter addAction:PriorityLIFO];

    [self presentViewController:alter animated:YES completion:nil];
}

- (void)suspendedState:(UIBarButtonItem *)item{
    item.title = self.Scheduler.isSuspended?@"恢复":@"挂起";
    self.Scheduler.suspended = !self.Scheduler.isSuspended;
}

- (IBAction)push:(id)sender {
    [self.navigationController pushViewController:[[BlueViewController alloc] init] animated:YES];
}

- (void)clearScheduler{
    [self.Scheduler removeAllPopupViews];
}

@end
