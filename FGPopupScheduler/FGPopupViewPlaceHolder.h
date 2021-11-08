//
//  FGPopupViewPlaceHolder.h
//  FGPopupSchedulerDemo
//
//  Created by FoneG on 2021/11/8.
//

#import <Foundation/Foundation.h>
#import "FGPopupScheduler.h"

NS_ASSUME_NONNULL_BEGIN

/*
 为当前对象生成一个popup对象, 用于类似UIAlertController  这类无法直接遵守 <FGPopupView>的对象。类似这一类弹窗对象，需要做到下面3个步骤
 1. 告诉FGPopupViewPlaceHolder如何显示：showPopupViewCallBlock
 2. 告诉FGPopupViewPlaceHolder 如何隐藏：removePopupViewCallBlock
 3. 在<FGPopupView>主动消失的时候， RealPopView 需要通过 -remove：主动把 FGPopupViewPlaceHolder 从 FGPopupScheduler 中移除
 */
@interface FGPopupViewPlaceHolder : NSObject <FGPopupView>
@property (nonatomic, copy) void(^showPopupViewCallBlock)( __weak NSObject *weakObj);
@property (nonatomic, copy) void(^removePopupViewCallBlock)(__weak NSObject *weakObj);

+(instancetype)generatePlaceHolderWith:(NSObject *)RealPopView;
@end

NS_ASSUME_NONNULL_END
