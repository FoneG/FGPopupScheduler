//
//  FGPopupViewScheduler.h
//  FGPopViewScheduler
//
//  Created by FoneG on 2021/6/22.
//

#import <Foundation/Foundation.h>
#import "FGPopupSchedulerConstant.h"
#import "FGPopupView.h"

NS_ASSUME_NONNULL_BEGIN

@interface FGPopupScheduler : NSObject

/// 根据指定的策略生成一个弹窗控制队列
/// @param pps 策略类型

/**
 根据指定的策略生成一个弹窗控制队列
 
 @param pss  FIFO、LIFO、Priority
 @return 返回指定策略的调度器，需要外部持有生命周期
 */
- (instancetype)initWithStrategy:(FGPopupSchedulerStrategy)pss;

/**
 向队列插入一个弹窗，FGPopupScheduler会根据设置的策略状态来控制在队列中插入的位置, 弹窗默认使用FGPopupViewStrategyKeep策略, 支持线程安全
 
 @param view 弹窗实例
 */
- (void)add:(id<FGPopupView>)view;

/**
 向队列插入一个弹窗，FGPopupScheduler会根据设置的策略状态来控制在队列中插入的位置, 支持线程安全
 
 @param view 弹窗实例
 @param pvs 当插入时存在显示的弹窗会根据FGPopupViewStrategy来判断是否保留弹窗
 @param psp 当选择优先级调度策略时，会根据 FGPopupStrategyPriority来判断弹窗插入的位置
 */
- (void)add:(id<FGPopupView>)view strategy:(FGPopupViewStrategy)pvs Priority:(FGPopupStrategyPriority)psp;


/**
把弹窗种队列种移除, 不会触发<FGPopupView>的-dismissPopupViewW or -dismissPopupViewWithAnimation: 方法，支持线程安全
 
@param view 弹窗实例
 */
- (void)remove:(id<FGPopupView>)view;

/**
 移除队列中所有的弹窗队列，显示的弹窗将会触发<FGPopupView>的-dismissPopupViewW or -dismissPopupViewWithAnimation: 方法,  并优先执行-dismissPopupViewWithAnimation:方法。 支持线程安全
 */
- (void)removeAllPopupViews;

/**
 返回当前调取队列是否存在弹窗
 
 @return true or false is a question
 */
- (BOOL)isEmpty;


/**
 返回当前调度器是否拥有已经显示的弹窗
 */
- (BOOL)canRegisterFirstPopupViewResponder;


/**
 向调度器主动发送一个执行显示弹窗的命令, 支持线程安全
 
 */
- (void)registerFirstPopupViewResponder;


@end

/**
 获取一个指定调取策略全局的弹窗调度器
 */
extern FGPopupScheduler * FGPopupSchedulerGetForPSS(FGPopupSchedulerStrategy pss);

NS_ASSUME_NONNULL_END

