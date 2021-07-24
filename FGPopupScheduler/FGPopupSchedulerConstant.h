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

//当前显示弹窗已经存在时，会根据FGPopupViewStrategy策略判断是否如何处理弹窗
typedef NS_ENUM(NSUInteger, FGPopupViewStrategy) {
    FGPopupViewStrategyKeep,          //保留
    FGPopupViewStrategyAbandon,       //抛弃
};


typedef NS_ENUM(NSUInteger, FGPopupViewUntriggeredBehavior) {
    FGPopupViewUntriggeredBehaviorDiscard,          //弹窗产生时，但未满足条件时直接丢弃
    FGPopupViewUntriggeredBehaviorAwait,          //弹窗产生时，但未满足条件时会继续等待
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
