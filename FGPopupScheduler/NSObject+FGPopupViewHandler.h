//
//  NSObject+FGPopupViewHandler.h
//  FGPopupSchedulerDemo
//
//  Created by FoneG on 2021/11/6.
//

#import <Foundation/Foundation.h>
#import "FGPopupScheduler.h"

NS_ASSUME_NONNULL_BEGIN

@class _FGPopupViewHandler;
@interface NSObject (FGPopupViewHandler)

/// 为当前对象生成一个popup对象, 用于类似UIAlertController  这类无法直接遵守 <FGPopupView>的对象。类似这一类弹窗对象，需要做到下面3个步骤
/// 1. 告诉FGPopupScheduler如何显示：showPopupViewCallBlock
/// 2. 告诉FGPopupScheduler 如何隐藏：removePopupViewCallBlock
/// 3. 在<FGPopupView>主动消失的时候，通过执行-clearPopupSchedulerWhenPopViewDidDismiss方法，主动把 FGPopupViewHandler 从 FGPopupScheduler 中移除：
@property (nonatomic, strong, readonly) _FGPopupViewHandler *FGPopupViewHandler;

/// 请
- (void)clearPopupSchedulerWhenPopViewDidDismiss:(FGPopupScheduler *)scheduler;

@end

@interface _FGPopupViewHandler : NSObject <FGPopupView>
@property (nonatomic, copy) void(^showPopupViewCallBlock)(NSObject *weakObj);
@property (nonatomic, copy) void(^removePopupViewCallBlock)(NSObject *weakObj);
@end

NS_ASSUME_NONNULL_END
