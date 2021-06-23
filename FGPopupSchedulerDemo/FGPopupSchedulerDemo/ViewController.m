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

@interface ViewController ()
@property (nonatomic, strong) FGPopupScheduler *FIFOScheduler;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.FIFOScheduler = [[FGPopupScheduler alloc] initWithStrategy:FGPopupSchedulerStrategyFIFO];
    
    BasePopupView *pop1 =  [[BasePopupView alloc] initWithDescrption:@"第一个"];
    AnimationShowPopupView *pop2 =  [[AnimationShowPopupView alloc] initWithDescrption:@"自定义动画 pop2"];
    ConditionsPopView *pop3 =  [[ConditionsPopView alloc] initWithDescrption:@"条件弹窗 pop3"];

    
    [self.FIFOScheduler add:pop1];
    [self.FIFOScheduler add:pop2];
    [self.FIFOScheduler add:pop3];
}


- (IBAction)register:(id)sender {
    [self.FIFOScheduler registerFirstPopupViewResponder];
}


- (IBAction)push:(id)sender {
    [self.navigationController pushViewController:[[BlueViewController alloc] init] animated:YES];
}

@end
