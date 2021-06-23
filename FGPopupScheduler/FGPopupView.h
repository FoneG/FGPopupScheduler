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

/*
 FGPopupSchedulerStrategyQueue会根据 -showPopupView: 来监听显示逻辑，如果含有动画请实现-showPopupViewWithAnimation:方法
 */
- (void)showPopupView;

/*
 FGPopupSchedulerStrategyQueue会根据 -dismissPopupView: 来监听隐藏逻辑，如果含有动画请实现-showPopupViewWithAnimation:方法
 */
- (void)dismissPopupView;


@optional

/*
 FGPopupSchedulerStrategyQueue会根据 -showPopupViewWithAnimation: 来监听显示逻辑
 */
- (void)showPopupViewWithAnimation:(FGPopupViewAnimationBlock)block;

/*
 FGPopupSchedulerStrategyQueue会根据 -dismissPopupView: 来监听隐藏逻辑，如果含有动画请实现-dismissPopupViewWithAnimation:方法
 */
- (void)dismissPopupViewWithAnimation:(FGPopupViewAnimationBlock)block;

/**
 FGPopupSchedulerStrategyQueue会根据-canRegisterFirstPopupView判断，当队列顺序轮到它的时候是否能够成为响应的第一个优先级PopupView。默认为YES
 */
- (BOOL)canRegisterFirstPopupViewResponder;


@end

NS_ASSUME_NONNULL_END
