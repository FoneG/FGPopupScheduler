//
//  FGPopupQueue.m
//  FGPopupSchedulerDemo
//
//  Created by FoneG on 2021/6/23.
//

#import "FGPopupQueue.h"
#import <pthread/pthread.h>
#include <list>
#import <objc/runtime.h>

using namespace std;

struct PopupElement {
    id<FGPopupView> data;
    FGPopupStrategyPriority Priority;
    double createStamp;
};

PopupElement PopupElementMake(id<FGPopupView> data, FGPopupStrategyPriority Priority, double createStamp){
    PopupElement element;
    element.data = data;
    element.Priority = Priority;
    element.createStamp = createStamp;
    return element;
}

@interface FGPopupQueue ()
{
    list<PopupElement> _list;
    pthread_mutex_t _lock;
}
@property (nonatomic, assign) BOOL hasFirstFirstResponder;
@end

@implementation FGPopupQueue

- (BOOL)hasFirstFirstPopupViewResponder{
    pthread_mutex_lock(&_lock);
    BOOL hasFirstFirstResponder = self.hasFirstFirstResponder;
    pthread_mutex_unlock(&_lock);
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

- (void)addPopupView:(id<FGPopupView>)view{
    if (view==nil || ![view conformsToProtocol:@protocol(FGPopupView)]) {
        return;
    }
    
    pthread_mutex_lock(&_lock);
    _list.push_back(PopupElementMake(view, FGPopupStrategyPriorityNormal, CFAbsoluteTimeGetCurrent()));
    pthread_mutex_unlock(&_lock);
}

- (void)remove:(id<FGPopupView>)view{
    pthread_mutex_lock(&_lock);
    [self _rm:view];
    pthread_mutex_unlock(&_lock);
}


- (void)execute{
    pthread_mutex_lock(&_lock);
    _hasFirstFirstResponder = YES;
    NSLog(@"execute: _hasFirstFirstResponder %@", _hasFirstFirstResponder?@"yes":@"NO");
    PopupElement elemt = [self hitTestFirstPopupResponder];
    id<FGPopupView> view = elemt.data;
    if (!view) {
        _hasFirstFirstResponder = NO;
        return;
    }
    WS(wSelf);
    dispatch_async_main_safe((^(){
        if ([view respondsToSelector:@selector(showPopupViewWithAnimation:)]) {
            [view showPopupViewWithAnimation:^{
                SS(sSelf);
                pthread_mutex_unlock(&sSelf->_lock);
            }];
        }else if([view respondsToSelector:@selector(showPopupView)]){
            [view showPopupView];
            SS(sSelf);
            pthread_mutex_unlock(&sSelf->_lock);
        }else{
            SS(sSelf);
            pthread_mutex_unlock(&sSelf->_lock);
        }
    }));
}



- (BOOL)isEmpty{
    return _list.empty();
}

- (void)clear{
    pthread_mutex_lock(&_lock);
    _list.clear();
    pthread_mutex_unlock(&_lock);
}

- (void)insert:(PopupElement)data{
    pthread_mutex_lock(&_lock);
    _list.push_back(data);
    pthread_mutex_unlock(&_lock);
}

/*
 进行第一响应者测试并返回对应的节点
 
 @returns 作为第一响应者的节点
 */
- (PopupElement)hitTestFirstPopupResponder{
    
    list<PopupElement>::iterator it = _list.begin();
    PopupElement element;
    do {
        PopupElement temp = *it;
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
        it++;
    } while (it!=_list.end());
    return element;
}

#pragma mark - private

- (void)_rm:(id<FGPopupView>)view{
    const auto& tmp = view;
    _list.remove_if([&tmp](PopupElement e){return e.data == tmp;});
    _hasFirstFirstResponder = NO;
}

@end
