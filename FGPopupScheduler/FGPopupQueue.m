//
//  FGPopupQueue.m
//  FGPopupSchedulerDemo
//
//  Created by FoneG on 2021/6/23.
//

#import "FGPopupQueue.h"
#import "FGPopupList+Internal.h"

@implementation FGPopupQueue

- (void)addPopupView:(id<FGPopupView>)view Priority:(FGPopupStrategyPriority)Priority{
    [self lock];
    [self _push_back:[PopupElement elementWith:view Priority:Priority]];
    [self unLock];
}


@end
