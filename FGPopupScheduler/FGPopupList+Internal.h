//
//  FGPopupList+Internal.h
//  FGPopupSchedulerDemo
//
//  Created by FoneG on 2021/6/24.
//

#import "FGPopupList.h"

NS_ASSUME_NONNULL_BEGIN

@interface FGPopupList ()

/**
 list操作方法
 */
- (void)_push_back:(PopupElement *)e;
- (void)_push_front:(PopupElement *)e;
- (void)_insert:(PopupElement *)e index:(int)index;
- (void)_rm:(PopupElement *)e;

@end


NS_ASSUME_NONNULL_END
