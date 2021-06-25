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
    [self lock];
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
    NSLog(@"Priority: %d index:%d", Priority, index);
}


@end
