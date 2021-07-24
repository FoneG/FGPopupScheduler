//
//  NSObject+SwizzleMethod.h
//  FGPopupSchedulerDemo
//
//  Created by FoneG on 2021/7/23.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (SwizzleMethod)

+ (BOOL)swizzleOrAddInstanceMethod:(SEL)originalSel
                        withNewSel:(SEL)newSel
                   withNewSelClass:(Class)newSelClass;

@end

NS_ASSUME_NONNULL_END
