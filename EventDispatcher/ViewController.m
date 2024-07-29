//
//  ViewController.m
//  EventDispatcher
//
//  Created by silicn on 2024/7/29.
//

#import "ViewController.h"
#import "OtherViewController.h"
#import "SLEventDispatcher.h"

SLEventName LoginEventName = @"LoginEventName";

@interface ViewController ()
@end
@implementation ViewController

- (void)dealloc {
    [SLEventDispatcher.defaultDispatcher removeSubscriber:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [SLEventDispatcher.defaultDispatcher subscribeEventName:LoginEventName subscriber:self selector:@selector(login:)];
}

- (void)login:(id)object {
    NSLog(@"The User Login");
}

- (IBAction)butonAction:(id)sender {
    
    OtherViewController *other = [[OtherViewController alloc] init];
    [self.navigationController pushViewController:other animated:YES];
    
}


@end
