//
//  FGPopupViewScheduler.m
//  FGPopViewScheduler
//
//  Created by FoneG on 2021/6/22.
//

#import "FGPopupScheduler.h"
#import "FGPopupSchedulerStrategyQueue.h"
#import "FGPopupQueue.h"

@interface FGPopupScheduler ()
{
    id<FGPopupSchedulerStrategyQueue> _list;
    FGPopupSchedulerStrategy _pps;
}
@property (nonatomic, assign) BOOL hasPopupView;

@end

@implementation FGPopupScheduler

- (instancetype)initWithStrategy:(FGPopupSchedulerStrategy)pps{
    if (self = [super init]) {
        [self setSchedulerStrategy:pps];
    }
    return self;
}

- (void)setSchedulerStrategy:(FGPopupSchedulerStrategy)pps{
    _pps = pps;
    switch (pps) {
        case FGPopupSchedulerStrategyFIFO:
            _list = [[FGPopupQueue alloc] init];
            break;
        case FGPopupSchedulerStrategyLIFO:
            break;
            
        case FGPopupSchedulerStrategyPriority:
            break;
    }
}

- (void)add:(id<FGPopupView>)view{
    [self add:view strategy:FGPopupViewStrategyKeep];
}

- (void)add:(id<FGPopupView>)view strategy:(FGPopupViewStrategy)pvs{
    /// 当前状态是否存在展示的弹窗
    if (_hasPopupView && pvs == FGPopupViewStrategyAbandon) {
        /// view被抛弃
    }else{
        [_list addPopupView:view];
    }
}


- (void)registerFirstPopupViewResponder{
    [_list execute];
}

@end
