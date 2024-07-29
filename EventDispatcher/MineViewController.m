//
//  MineViewController.m
//  EventDispatcher
//
//  Created by silicn on 2024/7/29.
//

#import "MineViewController.h"
#import "SLEventDispatcher.h"


@interface MineViewController ()

@end

@implementation MineViewController

- (void)dealloc {
    [SLEventDispatcher.defaultDispatcher removeSubscriber:self];
}

- (void)viewDidLoad {
    self.view.backgroundColor = UIColor.cyanColor;
    [super viewDidLoad];

    [SLEventDispatcher.defaultDispatcher subscribeEventName:@"LoginEventName" subscriber:self selector:@selector(login:)];
}

- (void)login:(id)object {
    NSLog(@"Mine Login");
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
