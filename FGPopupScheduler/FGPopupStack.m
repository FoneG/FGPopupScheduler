//
//  FGPopupStack.m
//  FGPopupSchedulerDemo
//
//  Created by FoneG on 2021/6/25.
//

#import "FGPopupStack.h"
#import "FGPopupList+Internal.h"

@implementation FGPopupStack

- (void)addPopupView:(id<FGPopupView>)view Priority:(FGPopupStrategyPriority)Priority{
    [self lock];
    [self _push_front:[PopupElement elementWith:view Priority:Priority]];
    [self unLock];
}

@end
