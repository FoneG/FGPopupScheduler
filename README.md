# FGPopupScheduler

[![Support](https://img.shields.io/badge/support-iOS%206%2B%20-blue.svg?style=flat)](https://www.apple.com/nl/ios/)&nbsp;
[![Version](https://img.shields.io/cocoapods/v/FGPopupScheduler.svg?style=flat)](https://cocoapods.org/pods/FGPopupScheduler)
[![License](https://img.shields.io/cocoapods/l/FGPopupScheduler.svg?style=flat)](https://cocoapods.org/pods/FGPopupScheduler)
[![Platform](https://img.shields.io/cocoapods/p/FGPopupScheduler.svg?style=flat)](https://cocoapods.org/pods/FGPopupScheduler)

iOS弹窗调用器，控制弹窗按照指定的策略进行显示    

[详细介绍](https://juejin.cn/post/6979459370807476261)

## 特性
- 低入侵性：遵守协议后就能作为popup对象用调度器进行管理，对项目的入侵小
- 策略模式：利用 C++ 链表实现三种调度策略，性能优越。
- 线程安全：对scheduler的操作保证线程安全
- 自动触发：监听Runloop，在每次主线程空闲时就会触发调度器进行hitTest


## 安装

### CocoaPods

1. 在 Podfile 中添加 `pod 'FGPopupScheduler'`。
2. 执行 `pod install` 或 `pod update`。
3. 导入 `<FGPopupScheduler/FGPopupScheduler.h>`。

若搜索不到库，可使用 rm ~/Library/Caches/CocoaPods/search_index.json 移除本地索引然后再执行安装，或者更新一下 CocoaPods 版本。

### 手动导入

1. 下载 FGPopupScheduler 文件夹所有内容并且拖入你的工程中。
2. 导入 `FGPopupScheduler.h`。

## 用法

可下载 DEMO 参考各种弹窗在不同策略下被调度显示的案例。

### 基本使用

```
FGPopupScheduler *Scheduler = FGPopupSchedulerGetForPSS(FGPopupSchedulerStrategyFIFO);
AnimationShowPopupView *pop1 =  [[AnimationShowPopupView alloc] initWithDescrption:@"自定义动画 pop2" scheduler:Scheduler];
ConditionsPopView *pop2 =  [[ConditionsPopView alloc] initWithDescrption:@"条件弹窗 pop3 Discard" scheduler:Scheduler];

[Scheduler add:pop];
[Scheduler add:pop2];

```
注意该组件使用实例化方式使用，为了避免弹窗调度器提前释放，需要外部对其进行强持有（建议作为调用方的属性或实例变量）。

### 挂起

```
/**
 可以将调度器进行挂起，可以中止队列触发- execute。挂起状态不会影响已经execute的弹窗
 */
@property (nonatomic, assign, getter=isSuspended) BOOL suspended;
```
如果希望同时添加多个弹窗后再根据指定的策略进行显示，需要先将队列挂起，添加完成后再恢复。

### 调度策略

调度策略有三种：
```
typedef NS_ENUM(NSUInteger, FGPopupSchedulerStrategy) {
    FGPopupSchedulerStrategyFIFO = 1 << 0,           //先进先出
    FGPopupSchedulerStrategyLIFO = 1 << 1,           //后进先出
    FGPopupSchedulerStrategyPriority = 1 << 2        //优先级调度
};
```

可以根据需求选择合适的策略，另外实际上还可以结合 FGPopupSchedulerStrategyPriority | FGPopupSchedulerStrategyFIFO 一起使用，来处理当选择优先级策略时，如何决定同一优先级弹窗的排序。

### 触发策略

目前支持2种触发行为, 用户可以根据它来决定，当弹窗触发显示逻辑时是否要继续等待
```
typedef NS_ENUM(NSUInteger, FGPopupViewUntriggeredBehavior) {
    FGPopupViewUntriggeredBehaviorDiscard,          //未满足条件时会被直接丢弃
    FGPopupViewUntriggeredBehaviorAwait,          //未满足条件时会继续等待
};
```

### 切换策略

目前支持3种切换行为, 用户可以根据它来决定，当该弹窗已经显示时，是否会被后续高优线级的弹窗影响。仅在优先级调度策略时生效：FGPopupSchedulerStrategyPriority
```
typedef NS_ENUM(NSUInteger, FGPopupViewSwitchBehavior) {
    FGPopupViewSwitchBehaviorDiscard,  //当该弹窗已经显示，如果后面来了弹窗优先级更高的弹窗时，显示更高优先级弹窗并且当前弹窗会被抛弃
    FGPopupViewSwitchBehaviorLatent,   //当该弹窗已经显示，如果后面来了弹窗优先级更高的弹窗时，显示更高优先级弹窗并且当前弹窗重新进入队列, PS：优先级相同时同 FGPopupViewSwitchBehaviorDiscard
    FGPopupViewSwitchBehaviorAwait,    //当该弹窗已经显示时，不会被后续高优线级的弹窗影响
};
```


![image](https://note.youdao.com/yws/public/resource/5d0f46ddde197eb1269de27f6675abd2/xmlnote/WEBRESOURCEfc2aed555ac786e6b520aec9e1de6b09/14666)


## 问题交流
发现bug或者需求，请在GitHub提issue    
如果喜欢，请顺手我一个star吧~ ：）
