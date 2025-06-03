//
//  SYAudioTag.h
//  SYAudioTagSDK
//
//  Created by ShenYuanLuo on 2021/12/11.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SYAudioTag : NSObject
/// 文件路径
@property (nonatomic, readonly, copy) NSString *path;
/// 标题
@property (nonatomic, readwrite, copy) NSString *title;
/// 艺术家
@property (nonatomic, readwrite, copy) NSString *artist;
/// 专辑
@property (nonatomic, readwrite, copy) NSString *album;
/// 注释
@property (nonatomic, readwrite, copy) NSString *comment;
/// 流派
@property (nonatomic, readwrite, copy) NSString *genre;
/// 年份
@property (nonatomic, readwrite, assign) unsigned int year;
/// 轨道
@property (nonatomic, readwrite, assign) unsigned int track;
/// 封面
@property (nonatomic, readwrite, copy) NSData * _Nullable frontCoverPicture;
/// 艺术家封面
@property (nonatomic, readwrite, copy) NSData * _Nullable artistPicture;

- (instancetype)initWithFileAtPath:(NSString *)path;

- (BOOL)save;

@end

NS_ASSUME_NONNULL_END
