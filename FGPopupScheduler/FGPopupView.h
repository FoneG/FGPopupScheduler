//
//  FGPopupView.h
//  FGPopViewScheduler
//
//  Created by FoneG on 2021/6/22.
//

#import <Foundation/Foundation.h>
#import "FGPopupSchedulerConstant.h"

NS_ASSUME_NONNULL_BEGIN

@protocol FGPopupView <NSObject>

@optional
/*
 FGPopupSchedulerStrategyQueue会根据 -showPopupView: 做显示逻辑，如果含有动画请实现-showPopupViewWithAnimation:方法
 */
- (void)showPopupView;

/*
 FGPopupSchedulerStrategyQueue会根据 -dismissPopupView: 做隐藏逻辑，如果含有动画请实现-showPopupViewWithAnimation:方法
 */
- (void)dismissPopupView;

/*
 FGPopupSchedulerStrategyQueue会根据 -showPopupViewWithAnimation: 来做显示逻辑。如果block不传可能会出现意料外的问题
 */
- (void)showPopupViewWithAnimation:(FGPopupViewAnimationBlock)block;

/*
 FGPopupSchedulerStrategyQueue会根据 -dismissPopupView: 做隐藏逻辑，如果含有动画请实现-dismissPopupViewWithAnimation:方法，如果block不传可能会出现意料外的问题
 */
- (void)dismissPopupViewWithAnimation:(FGPopupViewAnimationBlock)block;

/**
 FGPopupSchedulerStrategyQueue会根据-canRegisterFirstPopupView判断，当队列顺序轮到它的时候是否能够成为响应的第一个优先级PopupView。默认为YES
 */
- (BOOL)canRegisterFirstPopupViewResponder;



/** 0.4.0 新增*/

/**
 FGPopupSchedulerStrategyQueue 会根据 - popupViewUntriggeredBehavior：来决定触发时弹窗的显示行为，默认为 FGPopupViewUntriggeredBehaviorAwait
 */
- (FGPopupViewUntriggeredBehavior)popupViewUntriggeredBehavior;


/**
 FGPopupViewSwitchBehavior 会根据 - popupViewSwitchBehavior：来决定已经显示的弹窗，是否会被后续更高优先级的弹窗锁影响，默认为 FGPopupViewSwitchBehaviorAwait  ⚠️⚠️ 只在FGPopupSchedulerStrategyPriority生效
 */
- (FGPopupViewSwitchBehavior)popupViewSwitchBehavior;

@end

NS_ASSUME_NONNULL_END
