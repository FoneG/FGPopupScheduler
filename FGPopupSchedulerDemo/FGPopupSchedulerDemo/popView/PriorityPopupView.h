//
//  PriorityPopupView.h
//  FGPopupSchedulerDemo
//
//  Created by FoneG on 2021/6/25.
//

#import "BasePopupView.h"
#import "FGPopupSchedulerConstant.h"

NS_ASSUME_NONNULL_BEGIN

@interface PriorityPopupView : BasePopupView

@property (nonatomic, assign) FGPopupStrategyPriority psp;

@end

NS_ASSUME_NONNULL_END
