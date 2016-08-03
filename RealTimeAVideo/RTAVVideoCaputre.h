//
//  RTAVVideoCaputre.h
//  RealTimeAVideo
//
//  Created by iLogiEMAC on 16/8/3.
//  Copyright © 2016年 zp. All rights reserved.
//

#import <Foundation/Foundation.h>
@import AVFoundation;

@class RTAVVideoCaputre,RTAVVideoConfiguration;
@protocol RTAVVideoCaputreDelegate <NSObject>

- (void)captureOutput:(nullable RTAVVideoCaputre *)capture pixelBuffer:(nullable CVImageBufferRef)pixelBuffer;

@end

@interface RTAVVideoCaputre : NSObject

- (nullable instancetype)initWithVideoConfiguration:(nullable RTAVVideoConfiguration *)configuration;
@property (nonatomic,assign)BOOL runing;

@property (nonatomic,weak,nullable)id <RTAVVideoCaputreDelegate> delegate;
@end
