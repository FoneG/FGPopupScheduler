//
//  FGPopupList+Monitor.m
//  FGPopupSchedulerDemo
//
//  Created by FoneG on 2021/7/23.
//

#import "FGPopupList+Monitor.h"
#import "NSObject+SwizzleMethod.h"
#import <objc/runtime.h>

static char kFGPopupListPopupMonitorKey;

@implementation FGPopupList (Monitor)

- (void)monitorRemoveEventWith:(id<FGPopupView>)popup{
    
    objc_setAssociatedObject(popup, &kFGPopupListPopupMonitorKey, self, OBJC_ASSOCIATION_ASSIGN);
    
    if ([popup respondsToSelector:@selector(dismissPopupView)]) {
        [[popup class] swizzleOrAddInstanceMethod:@selector(dismissPopupView) withNewSel:@selector(Monitor_dismissPopupView) withNewSelClass:self.class];
    }
    if ([popup respondsToSelector:@selector(dismissPopupViewWithAnimation:)]) {
        [[popup class] swizzleOrAddInstanceMethod:@selector(dismissPopupViewWithAnimation:) withNewSel:@selector(Monitor_dismissPopupViewWithAnimation:) withNewSelClass:self.class];
    }
}

- (void)Monitor_dismissPopupView{
    [self Monitor_dismissPopupView];

    FGPopupList *list = objc_getAssociatedObject(self, &kFGPopupListPopupMonitorKey);
    if (list && [self conformsToProtocol:@protocol(FGPopupView)]) {
        objc_setAssociatedObject(self, &kFGPopupListPopupMonitorKey, nil, OBJC_ASSOCIATION_ASSIGN);
        id<FGPopupView> obj = (id<FGPopupView>)self;
        [list removePopupView:obj];
    }
}

- (void)Monitor_dismissPopupViewWithAnimation:(FGPopupViewAnimationBlock)block{
    FGPopupViewAnimationBlock Monitor_block = ^(void){
        if (block) {
            block();
        }
        FGPopupList *list = objc_getAssociatedObject(self, &kFGPopupListPopupMonitorKey);
        if (list && [self conformsToProtocol:@protocol(FGPopupView)]) {
            objc_setAssociatedObject(self, &kFGPopupListPopupMonitorKey, nil, OBJC_ASSOCIATION_ASSIGN);
            id<FGPopupView> obj = (id<FGPopupView>)self;
            [list removePopupView:obj];
        }
    };
    
    [self Monitor_dismissPopupViewWithAnimation:Monitor_block];
}

@end
