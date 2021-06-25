//
//  FGPopupPriority.h
//  FGPopupSchedulerDemo
//
//  Created by FoneG on 2021/6/25.
//

#import "FGPopupList.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, FGPopupPriorityAddStrategy) {
    FGPopupPriorityAddStrategyFIFO, //FIFO
    FGPopupPriorityAddStrategyLIFO, //LIFO
};

@interface FGPopupPriorityList : FGPopupList

/**
 当两个弹窗之间的优先级相同的时候，会根据选择的添加策略来决定出队列的顺序，默认为FGPopupPriorityAddStrategyFIFO
 */
@property (nonatomic, assign) FGPopupPriorityAddStrategy PPAS;

@end

NS_ASSUME_NONNULL_END
