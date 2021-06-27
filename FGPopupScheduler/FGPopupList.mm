//
//  FGPopupList.m
//  FGPopupSchedulerDemo
//
//  Created by FoneG on 2021/6/24.
//

#import "FGPopupList.h"
#import <objc/runtime.h>
#include <list>

using namespace std;

@interface FGPopupList ()
{
    list<PopupElement*> _list;
    dispatch_semaphore_t _semaphore_t;
    BOOL _clearFlag;   ///清除时同样被认为不能进行注册新响应者
}
@property (nonatomic, strong) PopupElement *FirstFirstResponderElement;
@property (nonatomic, assign) BOOL hasFirstFirstResponder;
@end

@implementation FGPopupList

- (void)lock{
    intptr_t result = dispatch_semaphore_wait(_semaphore_t, DISPATCH_TIME_FOREVER);
    if (result!=0) {
        NSLog(@"lock failed: %ld", result);
    }
}

- (void)unLock{
    dispatch_semaphore_signal(_semaphore_t);
}

- (BOOL)canRegisterFirstFirstPopupViewResponder{
    [self lock];
    BOOL canRegisterFirstFirstPopupViewResponder = !self.hasFirstFirstResponder && !_clearFlag;
    [self unLock];
    return canRegisterFirstFirstPopupViewResponder;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _semaphore_t = dispatch_semaphore_create(1);
    }
    return self;
}

#pragma mark - FGPopupSchedulerStrategyQueue

- (void)addPopupView:(id<FGPopupView>)view Priority:(FGPopupStrategyPriority)Priority{
    @throw([NSException exceptionWithName:@"FGPopupList" reason:@"You must overWrite this method!" userInfo:nil]);
}

- (void)removePopupView:(id<FGPopupView>)view{
    [self lock];
    [self _rm_data:view];
    if (_FirstFirstResponderElement.data == view) {
        _hasFirstFirstResponder = NO;
    }
    [self unLock];
}

- (void)execute{
    //fix：在其他线程尝试pthread_mutex_unlock操作会返回失败
    [self lock];
    self.hasFirstFirstResponder = YES;
    PopupElement *elemt = [self _hitTestFirstPopupResponder];
    id<FGPopupView> view = elemt.data;

    if (!view) {
        self->_hasFirstFirstResponder = NO;
        [self unLock];
        return;
    }
    self.FirstFirstResponderElement = elemt;
    [self unLock];
    
    dispatch_sync_main_safe(^(){
        if ([view respondsToSelector:@selector(showPopupViewWithAnimation:)]) {
            [view showPopupViewWithAnimation:^{}];
        }
        else if([view respondsToSelector:@selector(showPopupView)]){
            [view showPopupView];
        }
    });
}

- (BOOL)isEmpty{
    return _list.empty();
}

- (void)clear{
    [self lock];
    id<FGPopupView> data = self.FirstFirstResponderElement.data;
    if (!data) {
        [self unLock];
        return;
    }
    _clearFlag = YES;
    _list.clear();
    [self unLock];
    
    dispatch_async_main_safe(^(){
        if ([data respondsToSelector:@selector(dismissPopupView)]) {
            [data dismissPopupView];
            [self lock];
            self->_clearFlag = NO;
            [self unLock];
        }
        else if ([data respondsToSelector:@selector(dismissPopupViewWithAnimation:)]) {
            WS(wSelf);
            [data dismissPopupViewWithAnimation:^{
                SS(sSelf);
                [sSelf lock];
                sSelf->_clearFlag = NO;
                [sSelf unLock];
            }];
        }
    });
}

#pragma mark - Internal

/*
 进行第一响应者测试并返回对应的节点
 
 @returns 作为第一响应者的节点
 */
- (PopupElement *)_hitTestFirstPopupResponder{
    list<PopupElement*>::iterator itor = _list.begin();
    PopupElement *element;
    do {
        PopupElement *temp = *itor;
        id<FGPopupView> data = temp.data;
        __block BOOL canRegisterFirstPopupViewResponder = YES;
        if ([data respondsToSelector:@selector(canRegisterFirstPopupViewResponder)]) {
            dispatch_sync_main_safe(^(){
                canRegisterFirstPopupViewResponder = [data canRegisterFirstPopupViewResponder];
            });
        }
        if (canRegisterFirstPopupViewResponder) {
            element = temp;
            break;
        }
        itor++;
    } while (itor!=_list.end());
    return element;
}


- (void)_push_back:(PopupElement *)e{
    _list.push_back(e);
}

- (void)_push_front:(PopupElement *)e{
    _list.push_front(e);
    
    list<PopupElement*>::iterator it = _list.begin();
    PopupElement *elemnt = *it;
}

- (void)_insert:(PopupElement *)e index:(int)index{
    list<PopupElement*>::iterator it = _list.begin();
    while (index>0) {
        it++;
        index--;
    }
    _list.insert(it, e);
}

- (void)_rm:(PopupElement *)elemt{
    [self _rm_data:elemt.data];
    _hasFirstFirstResponder = NO;
}

- (void)_enumerateObjectsUsingBlock:(void (NS_NOESCAPE ^)(PopupElement *obj, NSUInteger idx, BOOL *stop))block{
    list<PopupElement*>::iterator it = _list.begin();
    NSUInteger index = 0;
    BOOL stop = NO;
    while (it!=_list.end() && stop==NO) {
        if (block) {
            PopupElement *elemnt = *it;
            block(elemnt, index, &stop);
        }
        it++;
        index++;
    }
}

- (void)_rm_data:(id)data{
    const auto& tmp = data;
    _list.remove_if([&tmp](PopupElement *e){return e.data == tmp;});
}

@end

@implementation PopupElement

+ (instancetype)elementWith:(id<FGPopupView>)data Priority:(FGPopupStrategyPriority)Priority{
    PopupElement *element = [PopupElement new];
    element.data = data;
    element.Priority = Priority;
    element.createStamp = CFAbsoluteTimeGetCurrent();
    return element;
}
@end
