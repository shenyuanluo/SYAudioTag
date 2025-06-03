//
//  SYAudioTag.m
//  SYAudioTagSDK
//
//  Created by ShenYuanLuo on 2021/12/11.
//

#import "SYAudioTag.h"
// Tag
#include "fileref.h"
#include "audioproperties.h"
// APE
#include "apefile.h"
#include "apetag.h"
// FLAC
#include "flacfile.h"
// WAV
#include "wavfile.h"
// MP3
#include "mpegfile.h"
#include "id3v2tag.h"
#include "id3v2frame.h"
#include "id3v2header.h"
#include "attachedpictureframe.h"
// MP4
#include <mp4file.h>
#include <mp4tag.h>
#include <mp4coverart.h>
#include <vorbisfile.h>

#include "SYAudioTagDefine.h"


/// 音频文件类型
typedef NS_ENUM(NSInteger, SYAudioTagFileType) {
    /// 未知
    SYAudioTagFileUnknow    = 0,
    /// APE
    SYAudioTagFileAPE,
    /// FLAC
    SYAudioTagFileFLAC,
    /// WAV
    SYAudioTagFileWAV,
    /// MP3
    SYAudioTagFileMP3,
    /// M4A、M4R、M4B、M4P、MP4、3G2、M4V
    SYAudioTagFileMP4,
    /// WMA/ASF
    SYAudioTagFileASF,
    /// Ogg::Vorbis
    SYAudioTagFileOGG,
    /// Ogg::FLAC
    SYAudioTagFileOGA,
    /// MPC
    SYAudioTagFileMPC,
    /// WavPack
    SYAudioTagFileSWV,
    /// Ogg::Speex
    SYAudioTagFileSPX,
    /// Ogg::Opus
    SYAudioTagFileOPUS,
    /// TrueAudio
    SYAudioTagFileTTA,
    /// AIFF
    SYAudioTagFileAIFF,
    /// MOD
    SYAudioTagFileMOD,
    /// S3M
    SYAudioTagFileS3M,
    /// IT
    SYAudioTagFileIT,
    /// XM
    SYAudioTagFileXM,
};


//class ImageFile : public TagLib::File
//{
//public:
//    ImageFile(const char *file) : TagLib::File(file)
//    {
//        
//    }
//    
//    TagLib::ByteVector data()
//    {
//        return readBlock(length());
//    }
//    
//    
//private:
//    virtual TagLib::Tag *tag() const { return 0; }
//    virtual TagLib::AudioProperties *audioProperties() const { return 0; }
//    virtual bool save() { return false; }
//};


@interface SYAudioTag()
{
    FileRef m_tagFileRef;
}
/// 文件类型
@property (nonatomic, readwrite, assign) SYAudioTagFileType fileType;
@end

@implementation SYAudioTag
@synthesize path = _path;

- (instancetype)initWithFileAtPath:(NSString *)path
{
    if (self = [super init])
    {
        _path = path;
        if (NO == AT_EMPTY_STRING(_path))
        {
            m_tagFileRef = FileRef([path UTF8String]);
            [self parseFileType:path];
        }
    }
    return self;
}

- (void)parseFileType:(NSString *)path
{
    if (AT_EMPTY_STRING(path)) return;
    
    TagLib::String fileType;
    TagLib::String fileName = path.UTF8String;
    const int pos = fileName.rfind(".");
    if(pos != -1) {
        fileType = fileName.substr(pos + 1).upper();
    }
    if(fileType == "APE")
        self.fileType = SYAudioTagFileAPE;
    else if(fileType == "FLAC")
        self.fileType = SYAudioTagFileFLAC;
    else if(fileType == "WAV")
        self.fileType = SYAudioTagFileWAV;
    else if(fileType == "MP3")
        self.fileType = SYAudioTagFileMP3;
    else if(fileType == "M4A" || fileType == "M4R" || fileType == "M4B" || fileType == "M4P" || fileType == "MP4" || fileType == "3G2" || fileType == "M4V")
        self.fileType = SYAudioTagFileMP4;
    else if(fileType == "OGG")
        self.fileType = SYAudioTagFileOGG;
    else if(fileType == "OGA")
        self.fileType = SYAudioTagFileOGA;
    else if(fileType == "MPC")
        self.fileType = SYAudioTagFileMPC;
    else if(fileType == "WV")
        self.fileType = SYAudioTagFileSWV;
    else if(fileType == "SPX")
        self.fileType = SYAudioTagFileSPX;
    else if(fileType == "OPUS")
        self.fileType = SYAudioTagFileOPUS;
    else if(fileType == "TTA")
        self.fileType = SYAudioTagFileTTA;
    else if(fileType == "WMA" || fileType == "ASF")
        self.fileType = SYAudioTagFileASF;
    else if(fileType == "AIF" || fileType == "AIFF" || fileType == "AFC" || fileType == "AIFC")
        self.fileType = SYAudioTagFileAIFF;
    else if(fileType == "MOD" || fileType == "MODULE" || fileType == "NST" || fileType == "WOW")
        self.fileType = SYAudioTagFileMOD;
    else if(fileType == "S3M")
        self.fileType = SYAudioTagFileS3M;
    else if(fileType == "IT")
        self.fileType = SYAudioTagFileIT;
    else if(fileType == "XM")
        self.fileType = SYAudioTagFileXM;
    else
        self.fileType = SYAudioTagFileUnknow;
    NSLog(@"self.fileType: %ld", (long)self.fileType);
}

- (BOOL)save
{
    SYAudioTagLog(@"保存设置: %@", self.path.lastPathComponent);
    return m_tagFileRef.save();
}


#pragma mark - Setter/Getter
- (void)setTitle:(NSString *)title
{
    if (nil == title) return;
    SYAudioTagLog(@"设置-Title: %@", title);
    m_tagFileRef.tag()->setTitle(tagLibString(title));
}
- (NSString *)title
{
    return nsString(m_tagFileRef.tag()->title());
}

- (void)setArtist:(NSString *)artist
{
    if (nil == artist) return;
    SYAudioTagLog(@"设置-Artist: %@", artist);
    m_tagFileRef.tag()->setArtist(tagLibString(artist));
}
- (NSString *)artist
{
    return nsString(m_tagFileRef.tag()->artist());
}

- (void)setAlbum:(NSString *)album
{
    if (nil == album) return;
    SYAudioTagLog(@"设置-Album: %@", album);
    m_tagFileRef.tag()->setAlbum(tagLibString(album));
}
- (NSString *)album
{
    return nsString(m_tagFileRef.tag()->album());
}

- (void)setComment:(NSString *)comment
{
    if (nil == comment) return;
    SYAudioTagLog(@"设置-Comment: %@", comment);
    m_tagFileRef.tag()->setComment(tagLibString(comment));
}
- (NSString *)comment
{
    return nsString(m_tagFileRef.tag()->comment());
}

- (void)setGenre:(NSString *)genre
{
    if (nil == genre) return;
    SYAudioTagLog(@"设置-Genre: %@", genre);
    m_tagFileRef.tag()->setGenre(tagLibString(genre));
}
- (NSString *)genre
{
    return nsString(m_tagFileRef.tag()->genre());
}

- (void)setYear:(unsigned int)year
{
    SYAudioTagLog(@"设置-Year: %u", year);
    m_tagFileRef.tag()->setYear(year);
}
- (unsigned int)year
{
    return m_tagFileRef.tag()->year();
}

- (void)setTrack:(unsigned int)track
{
    SYAudioTagLog(@"设置-Track: %u", track);
    m_tagFileRef.tag()->setTrack(track);
}
- (unsigned int)track
{
    return m_tagFileRef.tag()->track();
}

- (void)setFrontCoverPicture:(NSData *)data
{
//    if (nil == data || 0 >= data.length) return;  // 赋值为空，作删除处理
    SYAudioTagLog(@"设置-FrontCover: %lu", (unsigned long)data.length);
    switch (self.fileType)
    {
        case SYAudioTagFileAPE:    // APE
        {
            TagLib::APE::File *apeFile = (TagLib::APE::File *)m_tagFileRef.file();
            TagLib::APE::Tag *apeTag   = (TagLib::APE::Tag *)apeFile->APETag();
            if (!apeTag)  break;   // 不存在 tag，不执行操作
            
            // 先移除已存在的
            TagLib::ByteVector emptyBV;
            apeTag->setData("COVER ART (FRONT)", emptyBV);
            // 再添加新的
            if (nil != data && 0 < data.length)
            {
                TagLib::ByteVector bv;
                bv.append('\0');
                bv.append(ByteVector((const char *)[data bytes], (int)[data length]));
                apeTag->setData("COVER ART (FRONT)", bv);
            }
        }
            break;
            
        case SYAudioTagFileFLAC:    // FLAC
        {
            TagLib::FLAC::File *flacFile = (TagLib::FLAC::File *)m_tagFileRef.file();
            // 先移除已存在的
            List<TagLib::FLAC::Picture *> pictureList = flacFile->pictureList();
            List<TagLib::FLAC::Picture *>::Iterator it;
            for (it = pictureList.begin(); it != pictureList.end(); ++it)
            {
                TagLib::FLAC::Picture *picture = dynamic_cast<TagLib::FLAC::Picture *>(*it);
                if(TagLib::FLAC::Picture::FrontCover == picture->type())
                {
                    flacFile->removePicture(picture);
                    break;
                }
            }
            // 再添加新的
            if (nil != data && 0 < data.length)
            {
                TagLib::FLAC::Picture *picture = new TagLib::FLAC::Picture();
                TagLib::ByteVector bv          = ByteVector((const char *)[data bytes], (int)[data length]);
                picture->setData(bv);
                picture->setType(TagLib::FLAC::Picture::FrontCover);
                picture->setMimeType(imageTypeFromData(data));
                flacFile->addPicture(picture);
            }
        }
            break;
            
        case SYAudioTagFileWAV: // WAV
        {
            TagLib::RIFF::WAV::File *wavFile = (TagLib::RIFF::WAV::File *)m_tagFileRef.file();
            ID3v2::Tag *tag                  = wavFile->ID3v2Tag();
            if (!tag)  break;   // 不存在 tag，不执行操作
            
            // 先移除已存在的
            TagLib::ID3v2::FrameList frameList = wavFile->ID3v2Tag()->frameListMap()["APIC"];
            TagLib::ID3v2::FrameList::Iterator it;
            for (it = frameList.begin(); it != frameList.end(); ++it)
            {
                TagLib::ID3v2::AttachedPictureFrame *picture = dynamic_cast<TagLib::ID3v2::AttachedPictureFrame *>(*it);
                if(TagLib::ID3v2::AttachedPictureFrame::FrontCover == picture->type())
                {
                    tag->removeFrame(picture);
                    break;
                }
            }
            // 再添加新的
            if (nil != data && 0 < data.length)
            {
                TagLib::ID3v2::AttachedPictureFrame *picture = new TagLib::ID3v2::AttachedPictureFrame();
                TagLib::ByteVector bv                        = ByteVector((const char *)[data bytes], (int)[data length]);
                picture->setPicture(bv);
                picture->setMimeType(imageTypeFromData(data));
                picture->setType(TagLib::ID3v2::AttachedPictureFrame::FrontCover);
                tag->addFrame(picture);
            }
        }
            break;
            
        case SYAudioTagFileMP3: // MP3
        {
            TagLib::MPEG::File *mp3File = (TagLib::MPEG::File *)m_tagFileRef.file();
            ID3v2::Tag *tag             = mp3File->ID3v2Tag();
            if (!tag)  break;   // 不存在 tag，不执行操作
            
            // 先移除已存在的
            TagLib::ID3v2::FrameList frameList = mp3File->ID3v2Tag()->frameListMap()["APIC"];
            TagLib::ID3v2::FrameList::Iterator it;
            for (it = frameList.begin(); it != frameList.end(); ++it)
            {
                TagLib::ID3v2::AttachedPictureFrame *picture = dynamic_cast<TagLib::ID3v2::AttachedPictureFrame *>(*it);
                if(TagLib::ID3v2::AttachedPictureFrame::FrontCover == picture->type())
                {
                    tag->removeFrame(picture);
                    break;
                }
            }
            // 再添加新的
            if (nil != data && 0 < data.length)
            {
                TagLib::ID3v2::AttachedPictureFrame *picture = new TagLib::ID3v2::AttachedPictureFrame();
                TagLib::ByteVector bv                        = ByteVector((const char *)[data bytes], (int)[data length]);
                picture->setPicture(bv);
                picture->setMimeType(imageTypeFromData(data));
                picture->setType(TagLib::ID3v2::AttachedPictureFrame::FrontCover);
                tag->addFrame(picture);
            }
        }
            break;
            
        case SYAudioTagFileMP4: // MP4（M4A 无法区分 front cover 和 artist cover）
        {
            TagLib::MP4::File *mp4File = (TagLib::MP4::File *)m_tagFileRef.file();
            TagLib::MP4::Tag* mp4Tag   = mp4File->tag();
            if (!mp4Tag)  break;   // 不存在 tag，不执行操作
            // 先移除已存在的
            mp4Tag->removeItem("covr");
            // 再添加新的
            if (nil != data && 0 < data.length)
            {
                TagLib::MP4::ItemListMap itemsListMap  = mp4Tag->itemListMap();
                TagLib::ByteVector bv                  = ByteVector((const char *)[data bytes], (int)[data length]);
                TagLib::MP4::CoverArt coverArt(TagLib::MP4::CoverArt::PNG, bv);
                TagLib::MP4::CoverArtList coverArtList; // create cover art list
                coverArtList.append(coverArt);  // append instance
                TagLib::MP4::Item coverItem(coverArtList);  // convert to item
                mp4Tag->setItem("covr", coverItem); // set item to tag
            }
        }
            break;
            
        default:
            break;
    }
}
- (NSData *)frontCoverPicture
{
    switch (self.fileType)
    {
        case SYAudioTagFileAPE:    // APE
        {
            TagLib::APE::File *apeFile            = (TagLib::APE::File *)m_tagFileRef.file();
            TagLib::APE::Tag *apeTag              = (TagLib::APE::Tag *)apeFile->APETag();
            if (!apeTag)  break;   // 不存在 tag，不执行操作
            
            TagLib::APE::ItemListMap itemsListMap = apeTag->itemListMap();
            if (itemsListMap.contains("COVER ART (FRONT)"))
            {
                const TagLib::ByteVector nullStringTerminator(1, 0);
                TagLib::ByteVector item = itemsListMap["COVER ART (FRONT)"].value();
                int pos = item.find(nullStringTerminator);   // Skip the filename
                if (++pos > 0)
                {
                    const TagLib::ByteVector &bytes=item.mid(pos);
                    return [NSData dataWithBytes:bytes.data() length:bytes.size()];
                }
            }
        }
            break;
            
        case SYAudioTagFileFLAC:    // FLAC
        {
            TagLib::FLAC::File *flacFile              = (TagLib::FLAC::File *)m_tagFileRef.file();
            List<TagLib::FLAC::Picture *> pictureList = flacFile->pictureList();
            List<TagLib::FLAC::Picture *>::Iterator it;
            for (it = pictureList.begin(); it != pictureList.end(); ++it)
            {
                TagLib::FLAC::Picture *picture = dynamic_cast<TagLib::FLAC::Picture *>(*it);
                if(TagLib::FLAC::Picture::FrontCover == picture->type())
                {
                    TagLib::ByteVector bv = picture->data();
                    return [NSData dataWithBytes:bv.data() length:bv.size()];
                }
            }
        }
            break;
            
        case SYAudioTagFileWAV: // WAV
        {
            TagLib::RIFF::WAV::File *wavFile = (TagLib::RIFF::WAV::File *)m_tagFileRef.file();
            TagLib::ID3v2::Tag *wavTag       = wavFile->ID3v2Tag();
            if (!wavTag)  break;   // 不存在 tag，不执行操作
            
            TagLib::ID3v2::FrameList frameList = wavTag->frameListMap()["APIC"];
            TagLib::ID3v2::FrameList::Iterator it;
            
            for (it = frameList.begin(); it != frameList.end(); ++it)
            {
                TagLib::ID3v2::AttachedPictureFrame *picture = dynamic_cast<TagLib::ID3v2::AttachedPictureFrame *>(*it);
                if(TagLib::ID3v2::AttachedPictureFrame::FrontCover == picture->type())
                {
                    TagLib::ByteVector bv = picture->picture();
                    return [NSData dataWithBytes:bv.data() length:bv.size()];
                }
            }
        }
            break;
            
        case SYAudioTagFileMP3: // MP3
        {
            TagLib::MPEG::File *mp3File        = (TagLib::MPEG::File *)m_tagFileRef.file();
            TagLib::ID3v2::FrameList frameList = mp3File->ID3v2Tag()->frameListMap()["APIC"];
            TagLib::ID3v2::FrameList::Iterator it;
            
            for (it = frameList.begin(); it != frameList.end(); ++it)
            {
                TagLib::ID3v2::AttachedPictureFrame *picture = dynamic_cast<TagLib::ID3v2::AttachedPictureFrame *>(*it);
                if(TagLib::ID3v2::AttachedPictureFrame::FrontCover == picture->type())
                {
                    TagLib::ByteVector bv = picture->picture();
                    return [NSData dataWithBytes:bv.data() length:bv.size()];
                }
            }
        }
            break;
            
        case SYAudioTagFileMP4: // MP4（M4A 无法区分 front cover 和 artist cover）
        {
            TagLib::MP4::File *mp4File = (TagLib::MP4::File *)m_tagFileRef.file();
            TagLib::MP4::Tag* mp4Tag   = mp4File->tag();
            if (!mp4Tag)  break;   // 不存在 tag，不执行操作
            
            TagLib::MP4::ItemListMap itemsListMap  = mp4Tag->itemListMap();
            TagLib::MP4::Item coverItem            = itemsListMap["covr"];
            TagLib::MP4::CoverArtList coverArtList = coverItem.toCoverArtList();
            if (!coverArtList.isEmpty()) {
                TagLib::MP4::CoverArt coverArt = coverArtList.front();
                NSData *data = [NSData dataWithBytes:coverArt.data().data() length:coverArt.data().size()];
                return data;
            }
        }
            break;
            
        default:
            break;
    }
    return nil;
}

- (void)setArtistPicture:(NSData *)data
{
//    if (nil == data || 0 >= data.length) return;  // 赋值为空，作删除处理
    SYAudioTagLog(@"设置-ArtistCover: %lu", (unsigned long)data.length);
    switch (self.fileType)
    {
        case SYAudioTagFileAPE:    // APE
        {
            TagLib::APE::File *apeFile = (TagLib::APE::File *)m_tagFileRef.file();
            TagLib::APE::Tag *apeTag   = (TagLib::APE::Tag *)apeFile->APETag();
            if (!apeTag)  break;   // 不存在 tag，不执行操作
            
            // 先移除已存在的
            TagLib::ByteVector emptyBV;
            apeTag->setData("COVER ART (ARTIST)", emptyBV);
            // 再添加新的
            if (nil != data && 0 < data.length)
            {
                TagLib::APE::ItemListMap itemsListMap = apeTag->itemListMap();
                TagLib::ByteVector bv;
                bv.append('\0');
                bv.append(ByteVector((const char *)[data bytes], (int)[data length]));
                apeTag->setData("COVER ART (ARTIST)", bv);
            }
        }
            break;
            
        case SYAudioTagFileFLAC:    // FLAC
        {
            TagLib::FLAC::File *flacFile = (TagLib::FLAC::File *)m_tagFileRef.file();
            // 先移除已存在的
            List<TagLib::FLAC::Picture *> pictureList = flacFile->pictureList();
            List<TagLib::FLAC::Picture *>::Iterator it;
            for (it = pictureList.begin(); it != pictureList.end(); ++it)
            {
                TagLib::FLAC::Picture *picture = dynamic_cast<TagLib::FLAC::Picture *>(*it);
                if(TagLib::FLAC::Picture::Artist == picture->type())
                {
                    flacFile->removePicture(picture);
                    break;
                }
            }
            // 再添加新的
            if (nil != data && 0 < data.length)
            {
                TagLib::FLAC::Picture *picture = new TagLib::FLAC::Picture();
                TagLib::ByteVector bv          = ByteVector((const char *)[data bytes], (int)[data length]);
                picture->setData(bv);
                picture->setType(TagLib::FLAC::Picture::Artist);
                picture->setMimeType(imageTypeFromData(data));
                flacFile->addPicture(picture);
            }
        }
            break;
            
        case SYAudioTagFileWAV: // WAV
        {
            TagLib::RIFF::WAV::File *wavFile = (TagLib::RIFF::WAV::File *)m_tagFileRef.file();
            ID3v2::Tag *tag                  = wavFile->ID3v2Tag();
            if (!tag)  break;   // 不存在 tag，不执行操作
            
            // 先移除已存在的
            TagLib::ID3v2::FrameList frameList = wavFile->ID3v2Tag()->frameListMap()["APIC"];
            TagLib::ID3v2::FrameList::Iterator it;
            for (it = frameList.begin(); it != frameList.end(); ++it)
            {
                TagLib::ID3v2::AttachedPictureFrame *picture = dynamic_cast<TagLib::ID3v2::AttachedPictureFrame *>(*it);
                if(TagLib::ID3v2::AttachedPictureFrame::Artist == picture->type())
                {
                    tag->removeFrame(picture);
                    break;
                }
            }
            // 再添加新的
            if (nil != data && 0 < data.length)
            {
                TagLib::ID3v2::AttachedPictureFrame *picture = new TagLib::ID3v2::AttachedPictureFrame();
                TagLib::ByteVector bv                        = ByteVector((const char *)[data bytes], (int)[data length]);
                picture->setPicture(bv);
                picture->setMimeType(imageTypeFromData(data));
                picture->setType(TagLib::ID3v2::AttachedPictureFrame::Artist);
                tag->addFrame(picture);
            }
        }
            break;
            
        case SYAudioTagFileMP3: // MP3
        {
            TagLib::MPEG::File *mp3File = (TagLib::MPEG::File *)m_tagFileRef.file();
            ID3v2::Tag *tag             = mp3File->ID3v2Tag();
            if (!tag)  break;   // 不存在 tag，不执行操作
            
            // 先移除已存在的
            TagLib::ID3v2::FrameList frameList = mp3File->ID3v2Tag()->frameListMap()["APIC"];
            TagLib::ID3v2::FrameList::Iterator it;
            for (it = frameList.begin(); it != frameList.end(); ++it)
            {
                TagLib::ID3v2::AttachedPictureFrame *picture = dynamic_cast<TagLib::ID3v2::AttachedPictureFrame *>(*it);
                if(TagLib::ID3v2::AttachedPictureFrame::Artist == picture->type())
                {
                    tag->removeFrame(picture);
                    break;
                }
            }
            // 再添加新的
            if (nil != data && 0 < data.length)
            {
                TagLib::ID3v2::AttachedPictureFrame *picture = new TagLib::ID3v2::AttachedPictureFrame();
                TagLib::ByteVector bv                        = ByteVector((const char *)[data bytes], (int)[data length]);
                picture->setPicture(bv);
                picture->setMimeType(imageTypeFromData(data));
                picture->setType(TagLib::ID3v2::AttachedPictureFrame::Artist);
                tag->addFrame(picture);
            }
        }
            break;
            
        case SYAudioTagFileMP4: // MP4（M4A 无法区分 front cover 和 artist cover）
        {
            TagLib::MP4::File *mp4File = (TagLib::MP4::File *)m_tagFileRef.file();
            TagLib::MP4::Tag* mp4Tag   = mp4File->tag();
            if (!mp4Tag)  break;   // 不存在 tag，不执行操作
            
            // 先移除已存在的
            mp4Tag->removeItem("covr");
            // 再添加新的
            if (nil != data && 0 < data.length)
            {
                TagLib::MP4::ItemListMap itemsListMap  = mp4Tag->itemListMap();
                TagLib::ByteVector bv                  = ByteVector((const char *)[data bytes], (int)[data length]);
                TagLib::MP4::CoverArt coverArt(TagLib::MP4::CoverArt::PNG, bv);
                TagLib::MP4::CoverArtList coverArtList; // create cover art list
                coverArtList.append(coverArt);  // append instance
                TagLib::MP4::Item coverItem(coverArtList);  // convert to item
                mp4Tag->setItem("covr", coverItem); // set item to tag
            }
        }
            break;
            
        default:
            break;
    }
    
}
- (NSData *)artistPicture
{
    switch (self.fileType)
    {
        case SYAudioTagFileAPE:    // APE
        {
            TagLib::APE::File *apeFile = (TagLib::APE::File *)m_tagFileRef.file();
            TagLib::APE::Tag *apeTag   = (TagLib::APE::Tag *)apeFile->APETag();
            if (!apeTag)  break;   // 不存在 tag，不执行操作
            
            TagLib::APE::ItemListMap itemsListMap = apeTag->itemListMap();
            if (itemsListMap.contains("COVER ART (ARTIST)"))
            {
                const TagLib::ByteVector nullStringTerminator(1, 0);
                TagLib::ByteVector item = itemsListMap["COVER ART (ARTIST)"].value();
                int pos = item.find(nullStringTerminator);   // Skip the filename
                if (++pos > 0)
                {
                    const TagLib::ByteVector &bytes=item.mid(pos);
                    return [NSData dataWithBytes:bytes.data() length:bytes.size()];
                }
            }
        }
            break;
            
        case SYAudioTagFileFLAC:    // FLAC
        {
            TagLib::FLAC::File *flacFile              = (TagLib::FLAC::File *)m_tagFileRef.file();
            List<TagLib::FLAC::Picture *> pictureList = flacFile->pictureList();
            List<TagLib::FLAC::Picture *>::Iterator it;
            for (it = pictureList.begin(); it != pictureList.end(); ++it)
            {
                TagLib::FLAC::Picture *picture = dynamic_cast<TagLib::FLAC::Picture *>(*it);
                if(TagLib::FLAC::Picture::Artist == picture->type())
                {
                    TagLib::ByteVector bv = picture->data();
                    return [NSData dataWithBytes:bv.data() length:bv.size()];
                }
            }
        }
            break;
            
        case SYAudioTagFileWAV: // WAV
        {
            TagLib::RIFF::WAV::File *wavFile = (TagLib::RIFF::WAV::File *)m_tagFileRef.file();
            TagLib::ID3v2::Tag *wavTag       = wavFile->ID3v2Tag();
            if (!wavTag)  break;   // 不存在 tag，不执行操作
            
            TagLib::ID3v2::FrameList frameList = wavTag->frameListMap()["APIC"];
            TagLib::ID3v2::FrameList::Iterator it;
            
            for (it = frameList.begin(); it != frameList.end(); ++it)
            {
                TagLib::ID3v2::AttachedPictureFrame *picture = dynamic_cast<TagLib::ID3v2::AttachedPictureFrame *>(*it);
                if(TagLib::ID3v2::AttachedPictureFrame::Artist == picture->type())
                {
                    TagLib::ByteVector bv = picture->picture();
                    return [NSData dataWithBytes:bv.data() length:bv.size()];
                }
            }
        }
            break;
            
        case SYAudioTagFileMP3: // MP3
        {
            TagLib::MPEG::File *mp3File = (TagLib::MPEG::File *)m_tagFileRef.file();
            TagLib::ID3v2::Tag *mp3Tag  = mp3File->ID3v2Tag();
            if (!mp3Tag)  break;   // 不存在 tag，不执行操作
            
            TagLib::ID3v2::FrameList frameList = mp3Tag->frameListMap()["APIC"];
            TagLib::ID3v2::FrameList::Iterator it;
            
            for (it = frameList.begin(); it != frameList.end(); ++it)
            {
                TagLib::ID3v2::AttachedPictureFrame *picture = dynamic_cast<TagLib::ID3v2::AttachedPictureFrame *>(*it);
                if(TagLib::ID3v2::AttachedPictureFrame::Artist == picture->type())
                {
                    TagLib::ByteVector bv = picture->picture();
                    return [NSData dataWithBytes:bv.data() length:bv.size()];
                }
            }
        }
            break;
            
        case SYAudioTagFileMP4: // MP4（M4A 无法区分 front cover 和 artist cover）
        {
            TagLib::MP4::File *mp4File             = (TagLib::MP4::File *)m_tagFileRef.file();
            TagLib::MP4::Tag* mp4Tag               = mp4File->tag();
            if (!mp4Tag)  break;   // 不存在 tag，不执行操作
            
            TagLib::MP4::ItemListMap itemsListMap  = mp4Tag->itemListMap();
            TagLib::MP4::Item coverItem            = itemsListMap["covr"];
            TagLib::MP4::CoverArtList coverArtList = coverItem.toCoverArtList();
            if (!coverArtList.isEmpty()) {
                TagLib::MP4::CoverArt coverArt = coverArtList.front();
                return [NSData dataWithBytes:coverArt.data().data() length:coverArt.data().size()];
            }
        }
            break;
            
        default:
            break;
    }
    return nil;
}

@end
