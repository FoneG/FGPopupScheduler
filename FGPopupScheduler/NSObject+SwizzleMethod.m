//
//  NSObject+SwizzleMethod.m
//  FGPopupSchedulerDemo
//
//  Created by FoneG on 2021/7/23.
//

#import "NSObject+SwizzleMethod.h"
#import <objc/runtime.h>

@implementation NSObject (SwizzleMethod)

+ (BOOL)swizzleOrAddInstanceMethod:(SEL)originalSel
                        withNewSel:(SEL)newSel
                   withNewSelClass:(Class)newSelClass {
    Method originalMethod = class_getInstanceMethod(self, originalSel);
    Method newMethod = class_getInstanceMethod(newSelClass, newSel);
    if (!newMethod)
        return NO;
    if (originalMethod && newMethod) {//有新老sel的imp则交换
        IMP originImp = class_getMethodImplementation(self, originalSel);
        IMP newImp = class_getMethodImplementation(newSelClass, newSel);
        if (originImp == newImp) {
            return NO;
        }
        class_addMethod(self,
                        originalSel,
                        class_getMethodImplementation(self, originalSel),
                        method_getTypeEncoding(originalMethod));
        class_addMethod(self,
                        newSel,
                        class_getMethodImplementation(newSelClass, newSel),
                        method_getTypeEncoding(newMethod));
        method_exchangeImplementations(class_getInstanceMethod(self, originalSel),
                                       class_getInstanceMethod(self, newSel));
        return YES;
    }
    return NO;
}

@end
