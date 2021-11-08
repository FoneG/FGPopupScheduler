//
//  FGPopupViewPlaceHolder.m
//  FGPopupSchedulerDemo
//
//  Created by FoneG on 2021/11/8.
//

#import "FGPopupViewPlaceHolder.h"

@interface FGPopupViewPlaceHolder ()
@property (nonatomic, strong) NSObject *target;
@end

@implementation FGPopupViewPlaceHolder

- (void)dealloc{
    NSLog(@"asdasdas");
}


+ (instancetype)generatePlaceHolderWith:(NSObject *)RealPopView{
    FGPopupViewPlaceHolder *handler = [FGPopupViewPlaceHolder new];
    handler.target = RealPopView;
    return handler;
}

- (void)showPopupView{
    if (self.showPopupViewCallBlock) {
        __weak NSObject *weakTarget = self.target;
        self.showPopupViewCallBlock(weakTarget);
    }
}

- (void)dismissPopupView{
    if (self.removePopupViewCallBlock) {
        __weak NSObject *weakTarget = self.target;
        self.removePopupViewCallBlock(weakTarget);
    }
}

@end
