//
//  ViewController.m
//  RealTimeAVideo
//
//  Created by iLogiEMAC on 16/8/2.
//  Copyright © 2016年 zp. All rights reserved.
//

#import "ViewController.h"
#import "RTAVSession.h"
#import "RTAVVideoConfiguration.h"
@interface ViewController ()
{
    RTAVSession  * session;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
   session = [[RTAVSession alloc]initWithRTAVVideoConfiguration:[RTAVVideoConfiguration defaultConfigurationForQuality:kRTVideoQuality_FHD_Hight]];
  
    session.preView = self.view;
    
    session.running = YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
