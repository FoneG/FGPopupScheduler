//
//  FGPopupList.m
//  FGPopupSchedulerDemo
//
//  Created by FoneG on 2021/6/24.
//

#import "FGPopupList.h"
#import <pthread/pthread.h>
#import <objc/runtime.h>
#include <list>

using namespace std;

@interface FGPopupList ()
{
    list<PopupElement*> _list;
    pthread_mutex_t _lock;
}
@property (nonatomic, strong) PopupElement *FirstFirstResponderElement;
@property (nonatomic, assign) BOOL hasFirstFirstResponder;
@end

@implementation FGPopupList

- (void)lock{
    pthread_mutex_lock(&_lock);
}

- (void)unLock{
    pthread_mutex_unlock(&_lock);
}

- (BOOL)hasFirstFirstPopupViewResponder{
    [self lock];
    BOOL hasFirstFirstResponder = self.hasFirstFirstResponder;
    [self unLock];
    return hasFirstFirstResponder;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        pthread_mutexattr_t attr;
        pthread_mutexattr_init(&attr);
        pthread_mutexattr_settype(&attr, PTHREAD_MUTEX_RECURSIVE);
        pthread_mutex_init(&_lock, &attr);
        pthread_mutexattr_destroy(&attr);
    }
    return self;
}

#pragma mark - FGPopupSchedulerStrategyQueue

- (void)addPopupView:(id<FGPopupView>)view{
    ///
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
    [self lock];
    _hasFirstFirstResponder = YES;
    NSLog(@"execute: _hasFirstFirstResponder %@", _hasFirstFirstResponder?@"yes":@"NO");
    PopupElement *elemt = [self hitTestFirstPopupResponder];
    id<FGPopupView> view = elemt.data;
    if (!view) {
        _hasFirstFirstResponder = NO;
        [self unLock];
        return;
    }
    _FirstFirstResponderElement = elemt;
    WS(wSelf);
    dispatch_async_main_safe((^(){
        if ([view respondsToSelector:@selector(showPopupViewWithAnimation:)]) {
            [view showPopupViewWithAnimation:^{
                SS(sSelf);
                [sSelf unLock];
            }];
        }else if([view respondsToSelector:@selector(showPopupView)]){
            [view showPopupView];
            SS(sSelf);
            [sSelf unLock];
        }else{
            SS(sSelf);
            [sSelf unLock];
        }
    }));
}

- (BOOL)isEmpty{
    return _list.empty();
}

- (void)clear{
    [self lock];
    _list.clear();
    [self unLock];
}

/*
 进行第一响应者测试并返回对应的节点
 
 @returns 作为第一响应者的节点
 */
- (PopupElement *)hitTestFirstPopupResponder{
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

#pragma mark - Internal

- (void)_push_back:(PopupElement *)e{
    _list.push_back(e);
}

- (void)_push_front:(PopupElement *)e{
    _list.push_front(e);
}

- (void)_insert:(PopupElement *)e index:(int)index{
    list<PopupElement*>::iterator it = _list.begin();
    do {
        it++;
        index--;
    } while (index>0);
    _list.insert(it, e);
}

- (void)_rm:(PopupElement *)elemt{
    [self _rm_data:elemt.data];
    _hasFirstFirstResponder = NO;
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
