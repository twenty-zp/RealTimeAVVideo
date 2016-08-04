//
//  RTAVVideoEncoder.m
//  RealTimeAVideo
//
//  Created by iLogiEMAC on 16/8/3.
//  Copyright © 2016年 zp. All rights reserved.
//

#import "RTAVVideoEncoder.h"
#import "RTAVVideoConfiguration.h"
#import "RTAVVideoFrame.h"
@interface RTAVVideoEncoder ()
{
    VTCompressionSessionRef  compressSession;
    NSUInteger frameCount;
    
    NSData * sps;
    NSData * pps;
    
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
- (void)initCompressSession
{
    if (compressSession) {
        //如果存在强制将当前的会话结束帧编码
        VTCompressionSessionCompleteFrames(compressSession, kCMTimeInvalid);
        VTCompressionSessionInvalidate(compressSession);
        CFRelease(compressSession);
        compressSession = NULL;
    }
    
    VTCompressionSessionCreate(NULL, _configuration.videoSize.width, _configuration.videoSize.height, kCMVideoCodecType_H264, NULL, NULL, NULL, outputCallBack, (__bridge void *)self, &compressSession);
}
- (void)encoderVideoData:(CVPixelBufferRef)pixelBuffer timeStamp:(int64_t)timestamp
{
    frameCount++;
    CMTime presentationTimeStamp = CMTimeMake(frameCount, 1000); //固定压缩为每秒1000帧
    CMTime duration = CMTimeMake(1, (int32_t) _configuration.videoFrameRate); //当前帧的时间
    NSDictionary * dic = nil;
    if (frameCount % _configuration.videoFrameRate == 0) {
        dic = @{(__bridge NSString *)kVTEncodeFrameOptionKey_ForceKeyFrame: @YES};
    }
    VTEncodeInfoFlags  flags;
    
    VTCompressionSessionEncodeFrame(compressSession, pixelBuffer, presentationTimeStamp,duration, (CFDictionaryRef)dic, NULL, &flags);
}
void  outputCallBack(void * CM_NULLABLE outputCallbackRefCon,void * CM_NULLABLE sourceFrameRefCon,OSStatus status,VTEncodeInfoFlags infoFlags,CM_NULLABLE CMSampleBufferRef sampleBuffer )
{
    //不存在则代表压缩不成功或帧丢失
    if(!sampleBuffer) return;
    if (status != noErr) return;
    //返回sampleBuffer中包括可变字典的不可变数组,如果有错误则为NULL
   CFArrayRef  array =  CMSampleBufferGetSampleAttachmentsArray(sampleBuffer, true);
    if (!array)  return;
   
   CFDictionaryRef dic = CFArrayGetValueAtIndex(array, 0);
    if (!dic) return;
    
   //kCMSampleAttachmentKey_NotSync:没有这个键意味着同步, yes: 异步. no:同步
    BOOL keyframe = !CFDictionaryContainsKey(dic, kCMSampleAttachmentKey_NotSync); //此代表为同步
    RTAVVideoEncoder * encoder = (__bridge RTAVVideoEncoder *)(outputCallbackRefCon);
    
    //
    if (keyframe && !encoder -> sps) {
        //获取sample buffer 中的 CMVideoFormatDesc
        CMFormatDescriptionRef format = CMSampleBufferGetFormatDescription(sampleBuffer);
        
        //获取H264参数集合中的SPS和PPS
        const uint8_t * sparameterSet;
        size_t sparameterSetSize,sparameterSetCount ;
       OSStatus statusCode =    CMVideoFormatDescriptionGetH264ParameterSetAtIndex(format, 0, &sparameterSet, &sparameterSetSize, &sparameterSetCount, 0);
        if (statusCode == noErr) {
            size_t pparameterSetSize, pparameterSetCount;
            const uint8_t *pparameterSet;
         OSStatus statusCode =    CMVideoFormatDescriptionGetH264ParameterSetAtIndex(format, 1, &pparameterSet, &pparameterSetSize, &pparameterSetCount, 0);
            if (statusCode == noErr) {
                encoder->sps = [NSData dataWithBytes:sparameterSet length:sparameterSetSize];
                encoder->pps = [NSData dataWithBytes:pparameterSet length:pparameterSetSize];
            }
        }
    }
    CMBlockBufferRef blockBuffer = CMSampleBufferGetDataBuffer(sampleBuffer);
    size_t  lengthAtOffset,totalLength;
    char *dataPointer;
    //接收到的数据展示
    OSStatus blockBufferStatus = CMBlockBufferGetDataPointer(blockBuffer, 0, &lengthAtOffset, &totalLength, &dataPointer);
    if (blockBufferStatus != kCMBlockBufferNoErr)
    {
        size_t bufferOffset = 0;
        static const int AVCCHeaderLength = 4;
        while (bufferOffset < totalLength -  AVCCHeaderLength) {
            // Read the NAL unit length
            uint32_t NALUnitLength = 0;
            /**
             *  void *memcpy(void *dest, const void *src, size_t n);
             *  从源src所指的内存地址的起始位置开始拷贝n个字节到目标dest所指的内存地址的起始位置中
             */
            memcpy(&NALUnitLength, dataPointer + bufferOffset, AVCCHeaderLength);
            //字节从高位反转到低位
            NALUnitLength = CFSwapInt32BigToHost(NALUnitLength);
            
            RTAVVideoFrame * frame = [RTAVVideoFrame new];
            frame.sps = encoder -> sps;
            frame.pps = encoder -> pps;
            frame.data = [NSData dataWithBytes:(dataPointer+bufferOffset+AVCCHeaderLength) length:NALUnitLength];
            
            bufferOffset += NALUnitLength + AVCCHeaderLength;
        }
    }
}
@end
