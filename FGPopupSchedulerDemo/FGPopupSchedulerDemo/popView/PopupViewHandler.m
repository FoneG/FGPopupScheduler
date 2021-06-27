//
//  PopupViewHandler.m
//  FGPopupSchedulerDemo
//
//  Created by FoneG on 2021/6/27.
//

#import "PopupViewHandler.h"
@interface PopupViewHandler()
@property (nonatomic, strong) BasePopupView *popView;
@end
@implementation PopupViewHandler

- (instancetype)initWithDescrption:(NSString *)des scheduler:(FGPopupScheduler*)scheduler{
    self = [super init];
    BasePopupView *view = [[BasePopupView alloc] initWithDescrption:des scheduler:scheduler];
    WS(wSelf);
    view.touchCallBack = ^{
        [wSelf dismissPopupView];
    };
    self.popView = view;
    return self;
}

- (void)showPopupView{
    [self.popView showPopupView];
}

- (void)dismissPopupView{
    [self.popView removeFromSuperview];
    [self.popView.scheduler remove:self];
}

@end
