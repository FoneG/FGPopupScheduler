//
//  FGPopupList.m
//  FGPopupSchedulerDemo
//
//  Created by FoneG on 2021/6/24.
//

#import "FGPopupList.h"
#import <objc/runtime.h>
#include <list>
#import "FGPopupList+Monitor.h"

using namespace std;

@interface FGPopupList ()
{
    list<PopupElement*> _list;
}
@property (nonatomic, strong) PopupElement *FirstFirstResponderElement;
@end

@implementation FGPopupList

- (BOOL)canRegisterFirstFirstPopupViewResponder{
    return self.FirstFirstResponderElement == nil ;
}

#pragma mark - FGPopupSchedulerStrategyQueue

- (void)addPopupView:(id<FGPopupView>)view Priority:(FGPopupStrategyPriority)Priority{
    [self monitorRemoveEventWith:view];
}


- (void)removePopupView:(id<FGPopupView>)view{
    [self _rm_data:view];
    if (_FirstFirstResponderElement.data == view) {
        _FirstFirstResponderElement = nil;
    }
}

- (void)execute{
    PopupElement *elemt = [self _hitTestFirstPopupResponder];
    id<FGPopupView> view = elemt.data;
    if (!view) {
        return;
    }
    self.FirstFirstResponderElement = elemt;
    
    if ([view respondsToSelector:@selector(showPopupViewWithAnimation:)]) {
        [view showPopupViewWithAnimation:^{}];
    }
    else if([view respondsToSelector:@selector(showPopupView)]){
        [view showPopupView];
    }
}

- (BOOL)isEmpty{
    return _list.empty();
}

- (void)clear{
    
    _list.clear();
    
    id<FGPopupView> data = self.FirstFirstResponderElement.data;
    
    if ([data respondsToSelector:@selector(dismissPopupView)]) {
        [data dismissPopupView];
        self.FirstFirstResponderElement = nil;
    }
    else if ([data respondsToSelector:@selector(dismissPopupViewWithAnimation:)]) {
        WS(wSelf);
        [data dismissPopupViewWithAnimation:^{
            SS(sSelf);
            sSelf.FirstFirstResponderElement = nil;
        }];
    }
}

/*
 进行第一响应者测试并返回对应的节点
 
 @returns 作为第一响应者的节点
 */
- (PopupElement *)_hitTestFirstPopupResponder{
    PopupElement *element;
    for(auto itor=_list.begin(); itor!=_list.end();) {
        PopupElement *temp = *itor;
        id<FGPopupView> data = temp.data;
        __block BOOL canRegisterFirstPopupViewResponder = YES;
        if ([data respondsToSelector:@selector(canRegisterFirstPopupViewResponder)]) {
            canRegisterFirstPopupViewResponder = [data canRegisterFirstPopupViewResponder];
        }
        
        if (canRegisterFirstPopupViewResponder) {
            element = temp;
            break;
        }
        /// 这里只能由为显示的popup所触发
        else if([data respondsToSelector:@selector(popupViewUntriggeredBehavior)] && [data popupViewUntriggeredBehavior] == FGPopupViewUntriggeredBehaviorDiscard){
            itor = _list.erase(itor++);
        }
        else{
            itor++;
        }
    }
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
    while (index>0) {
        it++;
        index--;
    }
    _list.insert(it, e);
}

- (void)_rm:(PopupElement *)elemt{
    [self _rm_data:elemt.data];
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
