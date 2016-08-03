//
//  RTAVVideoConfiguration.h
//  RealTimeAVideo
//
//  Created by iLogiEMAC on 16/8/3.
//  Copyright © 2016年 zp. All rights reserved.
//

#import <Foundation/Foundation.h>
@import CoreGraphics;
//分辨率
typedef NS_ENUM(NSUInteger,RTVideoSessionPreset) {
    kRTVideoSessionPreset640x480,   //普通
    kRTVideoSessionPreset960x540,   //标准
    kRTVideoSessionPreset1280x720,  //高清
    kRTVideoSessionPreset1920x1080  //全高清
};

//视频质量
typedef NS_ENUM(NSUInteger,RTVideoQuality) {
    /**
     * 普通分辨率
     */
    // 码率:800Kbps  帧数:15
    kRTVideoQuality_Common_Low = 0,
    // 码率:800Kbps  帧数:24
    kRTVideoQuality_Common_Medium,
    // 码率:800Kbps  帧数:30
    kRTVideoQuality_Common_High,
    /**
     *  标准分辨率
     */
     // 码率:1000Kbps  帧数:15
    kRTVideoQuality_Standard_Low,
      // 码率:1000Kbps  帧数:25
    kRTVideoQuality_Standard_Medium,
      // 码率:1000Kbps  帧数:30
    kRTVideoQuality_Standard_Hight,
    /**
     *  高清分辨率
     */
    // 码率:2000Kbps  帧数:25
    kRTVideoQuality_HD_Low,
    // 码率:2000Kbps  帧数:30
    kRTVideoQuality_HD_Medium,
    // 码率:3000Kbps  帧数:30
    kRTVideoQuality_HD_Hight,
    //全高清分辨率
    // 码率:3500Kbps  帧数:30
    kRTVideoQuality_FHD_Low,
    // 码率:4000Kbps  帧数:30
    kRTVideoQuality_FHD_Medium,
    // 码率:5000Kbps  帧数:30
    kRTVideoQuality_FHD_Hight,
    
    kRTVideoQuality_Default = kRTVideoQuality_Standard_Medium
};

@interface RTAVVideoConfiguration : NSObject

// 默认视频配置
+ (instancetype)defaultConfiguration;
//默认视频配置质量
+ (instancetype)defaultConfigurationForQuality:(RTVideoQuality)quality;
//默认视频配置质量和横竖屏
+ (instancetype)defaultConfigurationForQuality:(RTVideoQuality)quality landscape:(BOOL)landscape;
/// 视频的分辨率，宽高务必设定为 2 的倍数，否则解码播放时可能出现绿边
@property (nonatomic, assign) CGSize videoSize;
//码流 (bps)
@property (nonatomic,assign)NSUInteger videoBitRate;
//最大码流 (bps)
@property (nonatomic,assign)NSUInteger videoMaxBitRate;
//最小码流(bps)
@property (nonatomic,assign)NSUInteger videoMinBitRate;
//帧率(帧速度、fps）
@property (nonatomic,assign)NSUInteger videoFrameRate;
//最大帧率
@property (nonatomic,assign)NSUInteger videoMaxFrameRate;
//最小帧率
@property (nonatomic,assign)NSUInteger videoMinFrameRate;
//采样率 由AVFoundation中的代理控制
//分辨率
@property (nonatomic,assign)RTVideoSessionPreset sessionPreset;


@property (nonatomic,assign,readonly)NSString *avsessionPreset;
@end
