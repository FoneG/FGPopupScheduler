# FGPopupScheduler

[![Support](https://img.shields.io/badge/support-iOS%206%2B%20-blue.svg?style=flat)](https://www.apple.com/nl/ios/)&nbsp;
[![Version](https://img.shields.io/cocoapods/v/FGPopupScheduler.svg?style=flat)](https://cocoapods.org/pods/FGPopupScheduler)
[![License](https://img.shields.io/cocoapods/l/FGPopupScheduler.svg?style=flat)](https://cocoapods.org/pods/FGPopupScheduler)
[![Platform](https://img.shields.io/cocoapods/p/FGPopupScheduler.svg?style=flat)](https://cocoapods.org/pods/FGPopupScheduler)

iOS弹窗调用器，控制弹窗按照指定的策略进行显示    

[详细介绍](https://juejin.cn/post/6977774991802630151)

## 特性
- 低入侵性：遵守协议后就能作为popup对象用调度器进行管理，对项目的入侵小
- 策略模式：利用 C++ 链表实现三种调度策略，性能优越。
- 线程安全：对所有操作添加了信号量控制，保证线程安全
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
BasePopupView *pop1 =  [[BasePopupView alloc] initWithDescrption:@"第一个 pop" scheduler:Scheduler];
AnimationShowPopupView *pop2 =  [[AnimationShowPopupView alloc] initWithDescrption:@"自定义动画 pop2" scheduler:Scheduler];

[Scheduler add:pop1];
[Scheduler add:pop2 strategy:FGPopupViewStrategyKeep Priority:FGPopupStrategyPriorityLow];


/// 如果希望提前预存弹窗, 可以使用挂起模式.
Scheduler.suspended = YES;

```
注意该组件使用实例化方式使用，为了避免弹窗调度器提前释放，需要外部对其进行强持有（建议作为调用方的属性或实例变量）。


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


![image](https://note.youdao.com/yws/public/resource/5d0f46ddde197eb1269de27f6675abd2/xmlnote/WEBRESOURCEfc2aed555ac786e6b520aec9e1de6b09/14666)


## 问题交流
如果大家发现bug或者需求，请在GitHub提issue    
好用的话，请路过的朋友们给点个star 🙏🙏🙏🙏🙏
