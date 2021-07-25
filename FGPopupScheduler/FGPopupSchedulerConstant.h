//
//  FGPopupSchedulerConstant.h
//  FGPopViewScheduler
//
//  Created by FoneG on 2021/6/22.
//

#ifndef FGPopupSchedulerConstant_h
#define FGPopupSchedulerConstant_h

//
typedef NS_ENUM(NSUInteger, FGPopupSchedulerStrategy) {
    FGPopupSchedulerStrategyFIFO = 1 << 0,           //先进先出
    FGPopupSchedulerStrategyLIFO = 1 << 1,           //后进先出
    FGPopupSchedulerStrategyPriority = 1 << 2        //优先级调度
};

typedef NS_ENUM(NSUInteger, FGPopupViewSwitchBehavior) {
    FGPopupViewSwitchBehaviorDiscard,  //当该弹窗已经显示，如果后面来了弹窗优先级更高的弹窗时，显示更高优先级弹窗并且当前弹窗会被抛弃
    FGPopupViewSwitchBehaviorLatent,   //当该弹窗已经显示，如果后面来了弹窗优先级更高的弹窗时，显示更高优先级弹窗并且当前弹窗重新进入队列, PS：优先级相同时同 FGPopupViewSwitchBehaviorDiscard
    FGPopupViewSwitchBehaviorAwait,    //当该弹窗已经显示时，不会被后续高优线级的弹窗影响
};

typedef NS_ENUM(NSUInteger, FGPopupViewUntriggeredBehavior) {
    FGPopupViewUntriggeredBehaviorDiscard,          //当弹窗触发显示逻辑，但未满足条件时会被直接丢弃
    FGPopupViewUntriggeredBehaviorAwait,          //当弹窗触发显示逻辑，但未满足条件时会继续等待
};

typedef NSUInteger FGPopupStrategyPriority;
static const FGPopupStrategyPriority FGPopupStrategyPriorityVeryLow = 1;
static const FGPopupStrategyPriority FGPopupStrategyPriorityLow = 50;
static const FGPopupStrategyPriority FGPopupStrategyPriorityNormal = 100;
static const FGPopupStrategyPriority FGPopupStrategyPriorityHigh = 1000;
static const FGPopupStrategyPriority FGPopupStrategyPriorityVeryHigh= 2000;

typedef void(^FGPopupViewAnimationBlock)(void);

#define dispatch_sync_main_safe(block)\
if ([NSThread isMainThread]) {\
block();\
} else {\
dispatch_sync(dispatch_get_main_queue(), block);\
}

#define dispatch_async_main_safe(block)\
if ([NSThread isMainThread]) {\
block();\
} else {\
dispatch_async(dispatch_get_main_queue(), block);\
}


#define WS(wSelf)            __weak typeof(self) wSelf = self
#define SS(sSelf)            __strong typeof(wSelf) sSelf = wSelf

#endif /* FGPopupSchedulerConstant_h */
