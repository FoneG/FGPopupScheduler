//
//  FGPopupViewScheduler.m
//  FGPopViewScheduler
//
//  Created by FoneG on 2021/6/22.
//

#import "FGPopupScheduler.h"
#import "FGPopupSchedulerStrategyQueue.h"
#import "FGPopupQueue.h"
#import "FGPopupStack.h"
#import <CoreFoundation/CFRunLoop.h>
//#import <libkern/OSAtomic.h>


static NSHashTable *FGPopupSchedulers(void) {
    static NSHashTable *schedulers = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        schedulers = [NSHashTable weakObjectsHashTable];
    });
    return schedulers;
}

static void FGRunLoopObserverCallBack(CFRunLoopObserverRef observer, CFRunLoopActivity activity, void *info){
    for (FGPopupScheduler *scheduler in FGPopupSchedulers()) {
        if (![scheduler isEmpty] && [scheduler canRegisterFirstPopupViewResponder]) {
            [scheduler registerFirstPopupViewResponder];
        }
    }
}

@interface FGPopupScheduler ()
{
    id<FGPopupSchedulerStrategyQueue> _list;
    FGPopupSchedulerStrategy _pps;
}
@property (nonatomic, assign) BOOL hasPopupView;

@end

@implementation FGPopupScheduler

+ (void)initialize{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        CFRunLoopObserverRef observer = CFRunLoopObserverCreate(CFAllocatorGetDefault(), kCFRunLoopBeforeWaiting | kCFRunLoopExit, true, 0xFFFFFF, FGRunLoopObserverCallBack, nil);
        CFRunLoopAddObserver(CFRunLoopGetMain(), observer, kCFRunLoopCommonModes);
        CFRelease(observer);
    });
}

- (instancetype)initWithStrategy:(FGPopupSchedulerStrategy)pps{
    if (self = [super init]) {
        [FGPopupSchedulers() addObject:self];
        [self setSchedulerStrategy:pps];
    }
    return self;
}

- (void)setSchedulerStrategy:(FGPopupSchedulerStrategy)pps{
    _pps = pps;
    switch (pps) {
        case FGPopupSchedulerStrategyFIFO:
            _list = [[FGPopupQueue alloc] init];
            break;
        case FGPopupSchedulerStrategyLIFO:
            _list = [[FGPopupStack alloc] init];
            break;
            
        case FGPopupSchedulerStrategyPriority:
            break;
    }
}

- (void)add:(id<FGPopupView>)view{
    [self add:view strategy:FGPopupViewStrategyKeep];
}

- (void)add:(id<FGPopupView>)view strategy:(FGPopupViewStrategy)pvs{
    /// 当前状态是否存在展示的弹窗
    if (_hasPopupView && pvs == FGPopupViewStrategyAbandon) {
        /// view被抛弃
    }else{
        [_list addPopupView:view];
    }
}

- (void)remove:(id<FGPopupView>)view{
    [_list removePopupView:view];
}

- (void)removeAllPopupViews{
    [_list clear];
}

- (BOOL)canRegisterFirstPopupViewResponder{
    BOOL firstFirstPopupViewResponder = [_list hasFirstFirstPopupViewResponder];
    return !firstFirstPopupViewResponder;
}

- (void)registerFirstPopupViewResponder{
    NSLog(@"%s", __func__);
    if ([self canRegisterFirstPopupViewResponder]) {
        [_list execute];
    }
}

- (BOOL)isEmpty{
    return [_list isEmpty];
}

@end
