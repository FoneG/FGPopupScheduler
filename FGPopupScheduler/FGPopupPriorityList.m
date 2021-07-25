//
//  FGPopupPriority.m
//  FGPopupSchedulerDemo
//
//  Created by FoneG on 2021/6/25.
//

#import "FGPopupPriorityList.h"
#import "FGPopupList+Internal.h"
#import <objc/runtime.h>

@implementation FGPopupPriorityList

- (void)addPopupView:(id<FGPopupView>)view Priority:(FGPopupStrategyPriority)Priority{
    id<FGPopupView> firstResponderPopuper = self.FirstFirstResponderElement.data;
    FGPopupStrategyPriority firstResponderPriority = self.FirstFirstResponderElement.Priority;
    
    BOOL jump = [firstResponderPopuper respondsToSelector:@selector(popupViewSwitchBehavior)] && firstResponderPopuper.popupViewSwitchBehavior != FGPopupViewSwitchBehaviorAwait;
    BOOL highPriority = firstResponderPriority < Priority || (firstResponderPriority == Priority && self.PPAS == FGPopupPriorityAddStrategyLIFO);
    
    BOOL reinsert = NO;
    if (jump && highPriority) {
        switch (firstResponderPopuper.popupViewSwitchBehavior) {
            case FGPopupViewSwitchBehaviorAwait:
                ///
                break;
            case FGPopupViewSwitchBehaviorLatent:
                reinsert = firstResponderPriority < Priority;
                [self discardPopupElemnt:self.FirstFirstResponderElement];
                break;
            case FGPopupViewSwitchBehaviorDiscard:
                [self discardPopupElemnt:self.FirstFirstResponderElement];
                break;
        }
    }
    
    [self lock];
    [super addPopupView:view Priority:Priority];
    __block int index = 0;
    /// create FIFO
    [self _enumerateObjectsUsingBlock:^(PopupElement * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.Priority > Priority) {
            index++;
        }else if(obj.Priority == Priority && self.PPAS == FGPopupPriorityAddStrategyFIFO){
            index++;
        }else{
            *stop = YES;
        }
    }];
    [self _insert:[PopupElement elementWith:view Priority:Priority] index:index];
    [self unLock];
    
    if (reinsert) {
        [self addPopupView:firstResponderPopuper Priority:firstResponderPriority];
    }
}

- (void)discardPopupElemnt:(PopupElement *)element{
    if([element.data respondsToSelector:@selector(dismissPopupView)]){
        [element.data dismissPopupView];
    }
    else if ([element.data respondsToSelector:@selector(dismissPopupViewWithAnimation:)]) {
        [element.data dismissPopupViewWithAnimation:^{
            NSLog(@"-dismissPopupViewWithAnimation: Triggered by a higher priority popover");
        }];
    }
}

@end
