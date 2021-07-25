//
//  ViewController.m
//  FGPopupSchedulerDemo
//
//  Created by FoneG on 2021/6/23.
//

#import "ViewController.h"
#import "BlueViewController.h"

#import "BasePopupView.h"
#import "AnimationShowPopupView.h"
#import "ConditionsPopView.h"
#import "PriorityPopupView.h"
#import "PopupViewHandler.h"

#import "FGPopupScheduler.h"
#import "FGPopupList.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIButton *insertHightPopupButton;
@property (nonatomic, weak) FGPopupScheduler *Scheduler;
@end

@implementation ViewController

static BOOL suspendState = NO;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    BOOL suspend = suspendState;
    
    UIBarButtonItem *suspended = [[UIBarButtonItem alloc] initWithTitle:suspend?@"恢复":@"挂起" style:UIBarButtonItemStyleDone target:self action:@selector(suspendedState:)];
    UIBarButtonItem *pss = [[UIBarButtonItem alloc] initWithTitle:@"切换策略" style:UIBarButtonItemStyleDone target:self action:@selector(exchangeScheduler)];
    UIBarButtonItem *clear = [[UIBarButtonItem alloc] initWithTitle:@"清空" style:UIBarButtonItemStyleDone target:self action:@selector(clearScheduler)];
    self.navigationItem.leftBarButtonItem = clear;
    self.navigationItem.rightBarButtonItems = @[suspended, pss];


    [self setState:FGPopupSchedulerStrategyPriority|FGPopupSchedulerStrategyLIFO];

    [self fillPopupViews];
}

- (void)setState:(FGPopupSchedulerStrategy)pss{
    FGPopupScheduler *Scheduler = FGPopupSchedulerGetForPSS(pss);
//    Scheduler.suspended = suspendState;
    self.Scheduler = Scheduler;

    self.insertHightPopupButton.hidden = !(pss & FGPopupSchedulerStrategyPriority);
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
    Scheduler.suspended = YES;

    BasePopupView *pop1 =  [[BasePopupView alloc] initWithDescrption:@"switch行为弹窗 pop" scheduler:Scheduler];
    
    AnimationShowPopupView *pop2 =  [[AnimationShowPopupView alloc] initWithDescrption:@"自定义动画 pop2" scheduler:Scheduler];
    ConditionsPopView *pop3 =  [[ConditionsPopView alloc] initWithDescrption:@"条件弹窗 pop3 Discard" scheduler:Scheduler];
    pop3.UntriggeredBehavior = FGPopupViewUntriggeredBehaviorDiscard;
    PriorityPopupView *pop4 =  [[PriorityPopupView alloc] initWithDescrption:@"高优先级动画 pop4" scheduler:Scheduler];
    PriorityPopupView *pop5 =  [[PriorityPopupView alloc] initWithDescrption:@"低优先级动画 pop5" scheduler:Scheduler];
    ConditionsPopView *pop6 =  [[ConditionsPopView alloc] initWithDescrption:@"条件弹窗 pop6 wait" scheduler:Scheduler];
    pop6.UntriggeredBehavior = FGPopupViewUntriggeredBehaviorAwait;
    
    PopupViewHandler *handler = [[PopupViewHandler alloc] initWithDescrption:@"弹窗组手" scheduler:Scheduler];

    pop1.switchBehavior = FGPopupViewSwitchBehaviorDiscard;
    [Scheduler add:pop1 Priority:FGPopupStrategyPriorityVeryHigh];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [Scheduler add:pop2];
        [Scheduler add:pop3];
        [Scheduler add:pop4 Priority:FGPopupStrategyPriorityHigh];
        [Scheduler add:pop5 Priority:FGPopupStrategyPriorityLow];
        [Scheduler add:pop6 Priority:FGPopupStrategyPriorityVeryLow];
        [Scheduler add:handler];
        
        Scheduler.suspended = NO;
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
- (IBAction)jumpHighPriorityPopupView:(id)sender {
    
    BasePopupView *pop =  [[BasePopupView alloc] initWithDescrption:@"VeryHigh PopupView" scheduler:self.Scheduler];
    [self.Scheduler add:pop Priority:FGPopupStrategyPriorityVeryHigh];
}

- (void)clearScheduler{
    [self.Scheduler removeAllPopupViews];
}

@end
