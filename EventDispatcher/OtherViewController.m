//
//  OtherViewController.m
//  EventDispatcher
//
//  Created by silicn on 2024/7/29.
//

#import "OtherViewController.h"
#import "SLEventDispatcher.h"

@interface OtherViewController ()

@end

@implementation OtherViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    UIButton *triggeButon = [UIButton buttonWithType:UIButtonTypeSystem];
    triggeButon.backgroundColor = UIColor.blueColor;
    triggeButon.frame = CGRectMake(200, 300, 100, 80);
    [triggeButon setTitle:@"触发登录" forState:UIControlStateNormal];
    [self.view addSubview:triggeButon];
    
    [triggeButon addTarget:self action:@selector(triggleLogin) forControlEvents:UIControlEventTouchUpInside];
    
    
    // Do any additional setup after loading the view.
}

- (void)triggleLogin {
    [SLEventDispatcher.defaultDispatcher publishEvent:@"LoginEventName" withObject:@(15)];
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
