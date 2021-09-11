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
    [super addPopupView:view Priority:Priority];
    [self _push_front:[PopupElement elementWith:view Priority:Priority]];
}

@end
