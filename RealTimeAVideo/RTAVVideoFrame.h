//
//  RTAVVideoFrame.h
//  RealTimeAVideo
//
//  Created by iLogiEMAC on 16/8/4.
//  Copyright © 2016年 zp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RTAVVideoFrame : NSObject
@property (nonatomic,strong)NSData *data;
@property (nonatomic,strong)NSData *sps;
@property (nonatomic,strong)NSData *pps;
@property (nonatomic,assign)uint64_t timeStamp;
///< flv或者rtmp包头
@property (nonatomic, strong) NSData *header;
@property (nonatomic,assign)BOOL  isKeyFrame;
@end
