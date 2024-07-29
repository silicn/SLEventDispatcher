//
//  SLEventDispather.m
//  EventDispatcher
//
//  Created by silicn on 2024/7/29.
//

#import "SLEventDispatcher.h"
#import <pthread.h>

@interface SLDistribureProxy () {
    pthread_rwlock_t lock;
}
@property (nonatomic, strong, readwrite) NSPointerArray *subscribers;

@end

@implementation SLDistribureProxy

- (void)dealloc {
    pthread_rwlock_destroy(&lock);
}

- (instancetype)init {
    _subscribers = [NSPointerArray weakObjectsPointerArray];
    pthread_rwlock_init(&lock, 0);
    return self;
}

- (void)addTarget:(id)subscriber {
    pthread_rwlock_rdlock(&lock);
    [_subscribers compact];
    for (id target_ in _subscribers ) {
        if (target_ == subscriber) {
            pthread_rwlock_unlock(&lock);
            return;
        }
    }
    [_subscribers addPointer:(__bridge void *)subscriber];
    pthread_rwlock_unlock(&lock);
}

- (void)removeTarget:(id)subscriber {
    pthread_rwlock_wrlock(&lock);
    [_subscribers compact];
    for (NSUInteger i = 0; i < _subscribers.count; i++) {
        if ([_subscribers pointerAtIndex:i] == (__bridge void *)(subscriber)) {
            [_subscribers removePointerAtIndex:i];
            pthread_rwlock_unlock(&lock);
            return;
        }
    }
    pthread_rwlock_unlock(&lock);
}


#pragma mark - Override

- (void)forwardInvocation:(NSInvocation *)invocation {
    NSPointerArray *targets = _subscribers;
    for (id target in targets) {
        if ([target respondsToSelector:invocation.selector]) {
            [invocation invokeWithTarget:target];
        }
    }
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)selector {
    NSMethodSignature *signature;
    NSPointerArray *targets = _subscribers;
    for (id target in targets) {
        signature = [target methodSignatureForSelector:selector];
        if (signature)
            break;
    }
    if (signature == nil) {
        return  [NSObject instanceMethodSignatureForSelector:@selector(init)];
    }
    return signature;
}

- (BOOL)respondsToSelector:(SEL)aSelector {
    pthread_rwlock_wrlock(&lock);
    NSPointerArray *targets = _subscribers;
    for (id target in targets) {
        if ([target respondsToSelector:aSelector]) {
            pthread_rwlock_unlock(&lock);
            return YES;
        }
    }
    pthread_rwlock_unlock(&lock);
    return NO;
}

- (BOOL)isProxy {
    return YES;
}


@end


@interface SLEventDispatcher () {
    SLDistribureProxy *_proxy;
}

@property (nonatomic, strong) NSMapTable * hashMap;

@end

@implementation SLEventDispatcher

static SLEventDispatcher *dispatcher = nil;

+ (instancetype)defaultDispatcher {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dispatcher = [[SLEventDispatcher alloc] init];
    });
    return dispatcher;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.hashMap = [NSMapTable mapTableWithKeyOptions:NSPointerFunctionsCopyIn valueOptions:NSPointerFunctionsCopyIn];
        _proxy = [[SLDistribureProxy alloc] init];
    }
    return self;
}

- (void)subscribeEventName:(SLEventName)eventName subscriber:(id)subscriber selector:(nonnull SEL)aSelector {
    if (!subscriber) { return; }
    if (!eventName) { return; }
    if (!aSelector) { return; }
    [_proxy addTarget:subscriber];
    [_hashMap setObject:NSStringFromSelector(aSelector) forKey:eventName];
}

- (void)removeSubscriber:(id)subscriber {
    if (!subscriber) { return; }
    [_proxy removeTarget:subscriber];
}

- (void)removeEventName:(SLEventName)eventName {
    if (! eventName) { return; }
    [_hashMap removeObjectForKey:eventName];
}

+ (void)removeSubscriber:(id)subscriber {
    if (!subscriber) { return; }
    if (dispatcher->_proxy) {
        [dispatcher->_proxy removeTarget:subscriber];
    }
}

// 发布某个事件
- (void)publishEvent:(SLEventName)eventName {
    if (eventName == nil) { return; }
    NSString *selectorName = [_hashMap objectForKey:eventName];
    if (selectorName != nil) {
        SEL aSelector = NSSelectorFromString(selectorName);
        [_proxy performSelector:aSelector];
    }
}

- (void)publishEvent:(SLEventName)eventName withObject:(id)object {
    if (eventName == nil) { return; }
    NSString *selectorName = [_hashMap objectForKey:eventName];
    if (selectorName != nil) {
        SEL aSelector = NSSelectorFromString(selectorName);
        [_proxy performSelector:aSelector withObject:object];
    }
}

- (void)removeObserver:(nonnull id)observer forEventName:(nonnull SLEventName)name {
    [_hashMap removeObjectForKey:name];
}

@end
