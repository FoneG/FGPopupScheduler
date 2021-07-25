//
//  FGPopupPriority.m
//  FGPopupSchedulerDemo
//
//  Created by FoneG on 2021/6/25.
//

#import "FGPopupPriorityList.h"
#import "FGPopupList+Internal.h"

@implementation FGPopupPriorityList

- (void)addPopupView:(id<FGPopupView>)view Priority:(FGPopupStrategyPriority)Priority{
    
    BOOL jump = [self.FirstFirstResponderElement.data respondsToSelector:@selector(popupViewSwitchBehavior)] && self.FirstFirstResponderElement.data.popupViewSwitchBehavior != FGPopupViewSwitchBehaviorAwait;
    BOOL highPriority = self.FirstFirstResponderElement.Priority < Priority || (self.FirstFirstResponderElement.Priority == Priority && self.PPAS == FGPopupPriorityAddStrategyLIFO);
    
    if (jump && highPriority) {
        switch (self.FirstFirstResponderElement.data.popupViewSwitchBehavior) {
            case FGPopupViewSwitchBehaviorAwait:
                ///
                break;
            case FGPopupViewSwitchBehaviorLatent:
                ///
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
}

- (void)discardPopupElemnt:(PopupElement *)element{
    if ([element.data respondsToSelector:@selector(dismissPopupViewWithAnimation:)]) {
        [element.data dismissPopupViewWithAnimation:^{
            NSLog(@"-dismissPopupViewWithAnimation: Triggered by a higher priority popover");
        }];
    }
    else if([element.data respondsToSelector:@selector(dismissPopupView)]){
        [element.data dismissPopupView];
    }
}

@end
