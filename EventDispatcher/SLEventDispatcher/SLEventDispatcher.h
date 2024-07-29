//
//  SLEventDispather.h
//  EventDispatcher
//
//  Created by silicn on 2024/7/29.
//

/*
 这个类似于系统的NSNotificationCenter,用于通知事件，然后各个订阅者触发各自的函数
 结构原理
 
                   |->SLDistribureProxy -> subscribers
 SLEventDispather ->
                   |->hashMap -> (key:eventName,value:SEL)
 
 
 SLDistribureProxy:NSProxy 是一个代理类，负责转发消息，里面的subscribers负责存储订阅者
 SLEventDispather:hashMap ->  负责存储 eventName和 SEL 的 map
 
 
 Sample Code:
 
 SLEventName LoginEventName = @"LoginEventName";

 @interface ClasA ()
 
 @end
 @implementation ClasA

 - (void)dealloc {
     [SLEventDispatcher.defaultDispatcher removeSubscriber:self];
 }

 - (instancetype)init {
    self = [super init];
    if (self) {
        [SLEventDispatcher.defaultDispatcher subscribeEventName:LoginEventName subscriber:self selector:@selector(loginA:)];
    }
    return self;
 }

 - (void)loginA:(id)object {
     NSLog(@" ClasA The User Login");
 }
 @end
 
 ## 你可以在多处订阅LoginEventName，并且执行不同的 SEL
 
 ## 你可以在任何地方使用
 ## [SLEventDispatcher.defaultDispatcher publishEvent:LoginEventName withObject:nil];
 ## 来触发LoginEventName事件的执行
 
 */

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NSString * SLEventName;

@interface SLDistribureProxy : NSProxy

- (instancetype)init;

- (void)addTarget:(id)target;

- (void)removeTarget:(id)target;

@property (nonatomic, strong, readonly) NSPointerArray *subscribers;

@end



@interface SLEventDispatcher : NSObject

+ (instancetype)defaultDispatcher;

/* 
 订阅某个事件
 subscriber： 订阅者
 selector：订阅者执行动作
 */
- (void)subscribeEventName:(SLEventName)eventName subscriber:(id)subscriber selector:(nonnull SEL)aSelector;


/* 
 移除某个订阅者
 subscriber： 订阅者
 */
- (void)removeSubscriber:(id)subscriber;

/*
 移除某个事件,将会导致所有本事件的订阅者收不到消息
 注意：此时subscriber并未移除
 eventName: 事件名称
 */
- (void)removeEventName:(SLEventName)eventName;

/*
 发布某个事件 或者说 触发某个事件
 */
- (void)publishEvent:(SLEventName)eventName;

/*
 发布某个事件 或者说 触发某个事件
 object：参数
 */
- (void)publishEvent:(SLEventName)eventName withObject:(id)object;


@end

NS_ASSUME_NONNULL_END
