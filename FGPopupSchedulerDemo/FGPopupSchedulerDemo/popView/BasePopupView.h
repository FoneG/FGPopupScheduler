//
//  BasePopView.h
//  FGPopupSchedulerDemo
//
//  Created by FoneG on 2021/6/23.
//

#import <UIKit/UIKit.h>
#import "FGPopupView.h"
#import "FGPopupScheduler.h"

NS_ASSUME_NONNULL_BEGIN

@interface BasePopupView : UIView <FGPopupView>

- (instancetype)initWithDescrption:(NSString *)des;
- (instancetype)initWithDescrption:(NSString *)des scheduler:(FGPopupScheduler*)scheduler;

@property (nonatomic, strong, readonly) FGPopupScheduler *scheduler;

@end

NS_ASSUME_NONNULL_END
