//
//  RTAVSession.h
//  RealTimeAVideo
//
//  Created by iLogiEMAC on 16/8/3.
//  Copyright © 2016年 zp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class RTAVVideoConfiguration;
@interface RTAVSession : NSObject
@property (nonatomic,assign)BOOL running;
@property (nonatomic,strong)UIView * preView;

- (instancetype)initWithRTAVVideoConfiguration:(RTAVVideoConfiguration *)configuration;

@end
