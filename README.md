# SLEventDispatcher


# 一个简易、高效的替代NSNotificationCenter的方案

类似于系统的`NSNotificationCenter`,用于通知事件，然后各个订阅者触发各自的函数

结构原理
 
                   |->SLDistribureProxy -> subscribers
     SLEventDispatcher ->
                   |->hashMap -> (key:eventName,value:SEL)   


`SLDistribureProxy`:`NSProxy` 是一个代理类，负责转发消息，里面的`subscribers`负责存储订阅者
`SLEventDispather`:`hashMap` ->  负责存储 `eventName`和 `SEL` 的 `map`

```
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
```

 # 你可以在多处订阅LoginEventName，并且执行不同的 SEL
 
 # 你可以在任何地方使用
 `[SLEventDispatcher.defaultDispatcher publishEvent:LoginEventName withObject:nil];`
 来触发`LoginEventName`事件的执行
