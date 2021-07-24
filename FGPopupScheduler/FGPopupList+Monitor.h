//
//  FGPopupList+Monitor.h
//  FGPopupSchedulerDemo
//
//  Created by FoneG on 2021/7/23.
//

#import "FGPopupList.h"

NS_ASSUME_NONNULL_BEGIN

@interface FGPopupList (Monitor)

- (void)monitorRemoveEventWith:(id<FGPopupView>)popup;

@end

NS_ASSUME_NONNULL_END
