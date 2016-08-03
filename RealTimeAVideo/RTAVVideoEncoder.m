//
//  RTAVVideoEncoder.m
//  RealTimeAVideo
//
//  Created by iLogiEMAC on 16/8/3.
//  Copyright © 2016年 zp. All rights reserved.
//

#import "RTAVVideoEncoder.h"
#import "RTAVVideoConfiguration.h"
@interface RTAVVideoEncoder ()
{
    VTCompressionSessionRef  compressSession;
}
@property (nonatomic,strong)RTAVVideoConfiguration *configuration;
@end
@implementation RTAVVideoEncoder
- (nullable instancetype)initWithVideoConfiguration:(nullable RTAVVideoConfiguration *)configuration;
{
    if (self = [super init]) {
        _configuration = configuration;
        [self initCompressSession];
    }
    return self;
}
- (instancetype)init
{
    if (self = [super init]) {
        
        [self initCompressSession];
    }
    return self;
}
- (void)initCompressSession
{
    if (compressSession) {
        //如果存在强制将当前的会话结束帧编码
        VTCompressionSessionCompleteFrames(compressSession, kCMTimeInvalid);
        VTCompressionSessionInvalidate(compressSession);
        CFRelease(compressSession);
        compressSession = NULL;
    }
    
//    VTCompressionSessionCreate(NULL, <#int32_t width#>, <#int32_t height#>, <#CMVideoCodecType codecType#>, <#CFDictionaryRef  _Nullable encoderSpecification#>, <#CFDictionaryRef  _Nullable sourceImageBufferAttributes#>, <#CFAllocatorRef  _Nullable compressedDataAllocator#>, <#VTCompressionOutputCallback  _Nullable outputCallback#>, <#void * _Nullable outputCallbackRefCon#>, <#VTCompressionSessionRef  _Nullable * _Nonnull compressionSessionOut#>)
    
}
@end
