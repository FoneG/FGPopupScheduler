//
//  FGPopupList.h
//  FGPopupSchedulerDemo
//
//  Created by FoneG on 2021/6/24.
//

#import <Foundation/Foundation.h>
#import "FGPopupSchedulerStrategyQueue.h"

NS_ASSUME_NONNULL_BEGIN

@class PopupElement;
@interface FGPopupList : NSObject <FGPopupSchedulerStrategyQueue>

/**
 线程安全操作
 */
- (void)lock;
- (void)unLock;

@end

@interface PopupElement : NSObject
/**
 弹窗数据
 */
@property (nonatomic, strong) id<FGPopupView> data;
/**
 弹窗优先级，默认FGPopupStrategyPriorityNormal
 */
@property (nonatomic, assign) FGPopupStrategyPriority Priority;
/**
 创建时间戳，当优先级相同时根据createStamp判断在list中的序列，默认FIFO
 */
@property (nonatomic, assign) double createStamp;
/**
 根据弹窗和优先级初始化弹窗节点对象，createStamp默认为CFAbsoluteTimeGetCurrent()
 */
+ (instancetype)elementWith:(id<FGPopupView>)data Priority:(FGPopupStrategyPriority)Priority;

@end


NS_ASSUME_NONNULL_END
