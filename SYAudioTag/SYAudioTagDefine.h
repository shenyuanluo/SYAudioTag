//
//  SYAudioTagDefine.h
//  SYAudioTagSDK
//
//  Created by ShenYuanLuo on 2021/12/11.
//

#ifndef SYAudioTagDefine_h
#define SYAudioTagDefine_h

using namespace TagLib;

// 判断字符串是否为空
#define AT_EMPTY_STRING(str) (([str isKindOfClass:[NSNull class]] || nil == str || 1 > [str length]) ? YES : NO)
// 打印调试
#if DEBUG
    /* 输出方法名、行号 日志打印 */
    #define SYAudioTagLineLog(fmt, ...)    NSLog((@"SYAudioTag: %s [Line %d]: " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
    /* 普通打印打印 */
    #define SYAudioTagLog(fmt, ...)        NSLog((@"SYAudioTag: " fmt), ##__VA_ARGS__);
    /* 快速更新打印 */
    #define SYAudioTagPrintf(fmt, ...)    {fflush(stdout);                               \
                                        printf(("SYAudioTag: " fmt), ##__VA_ARGS__);}
#else
    #define SYAudioTagLineLog(fmt, ...)
    #define SYAudioTagLog(fmt, ...)
    #define SYAudioTagPrintf(fmt, ...)
#endif


const char bmp[2]    = {'B', 'M'};
const char gif[3]    = {'G', 'I', 'F'};
const char swf[3]    = {'F', 'W', 'S'};
const char swc[3]    = {'C', 'W', 'S'};
const char jpg[3]    = {static_cast<char>(0xff), static_cast<char>(0xd8), static_cast<char>(0xff)};
const char psd[4]    = {'8', 'B', 'P', 'S'};
const char iff[4]    = {'F', 'O', 'R', 'M'};
const char webp[4]   = {'R', 'I', 'F', 'F'};
const char ico[4]    = {0x00, 0x00, 0x01, 0x00};
const char tif_ii[4] = {'I','I', 0x2A, 0x00};
const char tif_mm[4] = {'M','M', 0x00, 0x2A};
const char png[8]    = {static_cast<char>(0x89), 0x50, 0x4e, 0x47, 0x0d, 0x0a, 0x1a, 0x0a};
const char jp2[12]   = {0x00, 0x00, 0x00, 0x0c, 0x6a, 0x50, 0x20, 0x20, 0x0d, 0x0a, static_cast<char>(0x87), 0x0a};

const char flac[4]   = {0x66, 0x4C, 0x61, 0x43};    // 'f'、'L'、'a'、'C'
const char wav[4]    = {0x52, 0x49, 0x46, 0x46};         // 'R'、'I'、'F'、'F'
const char mp3_1[3]  = {0x49, 0x44, 0x33};          // 'I'、'D'、'3'
const char mp3_2[2]  = {static_cast<char>(0xFF), 0xF};



// TagLib::String ——> NSString
static inline NSString *nsString(TagLib::String str)
{
    if (false == str.isNull())
    {
        return [NSString stringWithUTF8String:str.toCString(true)];
    }
    else
    {
        return @"";
    }
}

// NSString ——> TagLib::String
static inline TagLib::String tagLibString(NSString *str)
{
    return TagLib::String([str UTF8String], TagLib::String::UTF8);
}


// Private helper functions
static inline String imageTypeFromData(NSData *data)
{
    char bytes[12] = {0};
    [data getBytes:&bytes length:12];
    
    if (!memcmp(bytes, bmp, 2)) {
        return "image/x-ms-bmp";
    } else if (!memcmp(bytes, gif, 3)) {
        return "image/gif";
    } else if (!memcmp(bytes, jpg, 3)) {
        return "image/jpeg";
    } else if (!memcmp(bytes, psd, 4)) {
        return "image/psd";
    } else if (!memcmp(bytes, iff, 4)) {
        return "image/iff";
    } else if (!memcmp(bytes, webp, 4)) {
        return "image/webp";
    } else if (!memcmp(bytes, ico, 4)) {
        return "image/vnd.microsoft.icon";
    } else if (!memcmp(bytes, tif_ii, 4) || !memcmp(bytes, tif_mm, 4)) {
        return "image/tiff";
    } else if (!memcmp(bytes, png, 8)) {
        return "image/png";
    } else if (!memcmp(bytes, jp2, 12)) {
        return "image/jp2";
    } else if (!memcmp(bytes, flac, 4)) {
        return "audio/x-flac";
    } else if (!memcmp(bytes, mp3_1, 3) || !memcmp(bytes, mp3_2, 2)) {
        return "audio/mpeg";
    }
    
    return "application/octet-stream"; // default type
}


#endif /* SYAudioTagDefine_h */
