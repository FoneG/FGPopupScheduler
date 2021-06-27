//
//  PopupViewHandler.h
//  FGPopupSchedulerDemo
//
//  Created by FoneG on 2021/6/27.
//

#import <Foundation/Foundation.h>
#import "BasePopupView.h"

NS_ASSUME_NONNULL_BEGIN

@interface PopupViewHandler : NSObject <FGPopupView>
- (instancetype)initWithDescrption:(NSString *)des scheduler:(FGPopupScheduler*)scheduler;

@end

NS_ASSUME_NONNULL_END
