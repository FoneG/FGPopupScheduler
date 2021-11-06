//
//  NSObject+FGPopupViewHandler.m
//  FGPopupSchedulerDemo
//
//  Created by FoneG on 2021/11/6.
//

#import "NSObject+FGPopupViewHandler.h"
#import <objc/runtime.h>

@interface _FGPopupViewHandler ()
@property (nonatomic, strong) NSObject *target; /// 做强引用避免 target被提前释放
@end

@implementation _FGPopupViewHandler

- (instancetype)initWith:(NSObject *)obj{
    if(self = [super init])
    {
        self.target = obj;
    }
    return self;
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
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
    [self.target performSelector:@selector(_clearPopupScheduler)];
#pragma clang diagnostic pop
}

@end


@implementation NSObject (FGPopupViewHandler)

- (id<FGPopupView> )FGPopupViewHandler {
    _FGPopupViewHandler *value = objc_getAssociatedObject(self, @selector(FGPopupViewHandler));
    if (!value) {
        value = [[_FGPopupViewHandler alloc] initWith:self];
        objc_setAssociatedObject(self, @selector(FGPopupViewHandler), value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return value;
}

- (void)clearPopupSchedulerWhenPopViewDidDismiss:(FGPopupScheduler *)scheduler{
    [scheduler remove:self.FGPopupViewHandler];
    objc_setAssociatedObject(self, @selector(FGPopupViewHandler), nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)_clearPopupScheduler{
    objc_setAssociatedObject(self, @selector(FGPopupViewHandler), nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
