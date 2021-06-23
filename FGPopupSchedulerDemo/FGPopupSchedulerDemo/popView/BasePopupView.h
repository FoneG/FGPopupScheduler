//
//  BasePopView.h
//  FGPopupSchedulerDemo
//
//  Created by FoneG on 2021/6/23.
//

#import <UIKit/UIKit.h>
#import "FGPopupView.h"

NS_ASSUME_NONNULL_BEGIN

@interface BasePopupView : UIView <FGPopupView>

- (instancetype)initWithDescrption:(NSString *)des;

@end

NS_ASSUME_NONNULL_END
