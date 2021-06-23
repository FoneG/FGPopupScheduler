//
//  FGPopupSchedulerStrategyQueue.h
//  FGPopupSchedulerDemo
//
//  Created by FoneG on 2021/6/23.
//

#import <Foundation/Foundation.h>
#import "FGPopupView.h"

NS_ASSUME_NONNULL_BEGIN

@protocol FGPopupSchedulerStrategyQueue <NSObject>

- (void)addPopupView:(id<FGPopupView>)view;

- (void)execute;

- (void)clear;

- (BOOL)isEmpty;

@end

NS_ASSUME_NONNULL_END
