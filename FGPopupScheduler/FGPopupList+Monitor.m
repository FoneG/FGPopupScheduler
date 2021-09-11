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

    BOOL exist = NO;
    if ([popup respondsToSelector:@selector(dismissPopupView)]) {
        exist = YES;
        [[popup class] swizzleOrAddInstanceMethod:@selector(dismissPopupView) withNewSel:@selector(Monitor_dismissPopupView) withNewSelClass:self.class];
    }
    if ([popup respondsToSelector:@selector(dismissPopupViewWithAnimation:)]) {
        exist = YES;
        [[popup class] swizzleOrAddInstanceMethod:@selector(dismissPopupViewWithAnimation:) withNewSel:@selector(Monitor_dismissPopupViewWithAnimation:) withNewSelClass:self.class];
    }
    NSAssert(exist, @"You must have to implementation -dismissPopupView or -dismissPopupViewWithAnimation:");
}

- (void)Monitor_dismissPopupView{
    [self Monitor_dismissPopupView];

    if ([self conformsToProtocol:@protocol(FGPopupView)]) {
        id<FGPopupView> obj = (id<FGPopupView>)self;
        [FGPopupList tryRemovePopupView:obj];
    }
}

- (void)Monitor_dismissPopupViewWithAnimation:(FGPopupViewAnimationBlock)block{
    FGPopupViewAnimationBlock Monitor_block = ^(void){
        if (block) {
            block();
        }
        if ([self conformsToProtocol:@protocol(FGPopupView)]) {
            id<FGPopupView> obj = (id<FGPopupView>)self;
            [FGPopupList tryRemovePopupView:obj];
        }
    };
    
    [self Monitor_dismissPopupViewWithAnimation:Monitor_block];
}

+ (void)tryRemovePopupView:(id<FGPopupView>)obj{
    FGPopupList *list = objc_getAssociatedObject(obj, &kFGPopupListPopupMonitorKey);
    if (list) {
        objc_setAssociatedObject(obj, &kFGPopupListPopupMonitorKey, nil, OBJC_ASSOCIATION_ASSIGN);
        [list removePopupView:obj];
        [list execute];
    }
}

@end
