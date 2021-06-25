//
//  FGPopupStack.m
//  FGPopupSchedulerDemo
//
//  Created by FoneG on 2021/6/25.
//

#import "FGPopupStack.h"
#import "FGPopupList+Internal.h"

@implementation FGPopupStack

- (void)addPopupView:(id<FGPopupView>)view{
    [super addPopupView:view];
    [self lock];
    [self _push_front:[PopupElement elementWith:view Priority:FGPopupStrategyPriorityNormal]];
    [self unLock];
}

@end
