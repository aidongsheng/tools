//
//  OnlineVideoPlayer.m
//  wochacha
//
//  Created by wcc on 2018/4/24.
//  Copyright © 2018年 wochacha. All rights reserved.
//

#import "OnlineVideoPlayer.h"

@interface OnlineVideoPlayer()
@property (nonatomic, strong) UILabel *labelNetworkStatus;
@property (nonatomic, strong) UIButton *buttonClosePlayer;
@property (nonatomic ,strong) AVPlayer *player;     //  播放器
@property (nonatomic, strong) AVPlayerItem *playItem;   //  播放器资源对象
@end
@implementation OnlineVideoPlayer


+ (Class)layerClass {
    return [AVPlayerLayer class];
}

- (AVPlayer *)player {
    return [(AVPlayerLayer *)[self layer] player];
}

- (void)setPlayer:(AVPlayer *)player {
    [(AVPlayerLayer *)[self layer] setPlayer:player];
}

- (instancetype)initWithVideoUrl:(NSString *)videoUrl delegate:(id<OnlineVideoPlayerDelegate>)delegate
{
    if (self = [super init]) {
        self.delegate = delegate;
        [self playerVideoWithUrl:videoUrl];
        [self addSubview:self.buttonClosePlayer];
        [self addSubview:self.labelNetworkStatus];
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}
- (void)stopPlay
{
    [self.player pause];
}

- (void)playerVideoWithUrl:(NSString *)videoUrl
{
    _bDidFinishPlay = NO;
    _bVideoAdClicked = NO;
    ((AVPlayerLayer *)(self.layer)).videoGravity = AVLayerVideoGravityResizeAspect;
    
    if ([self isWiFi]) {
        if ([self isCachedVideoFileExsit:videoUrl]) {
            [self playCachedVideoWithUrl:videoUrl];
        }else{
            [self playOnlineVideoWithUrl:videoUrl];
            [self downloadVideoWithVideoUrl:videoUrl];
        }
    }else{
        
        if ([self isCachedVideoFileExsit:videoUrl]) {
            NSLog(@"非wifi环境，但是有对应 url 的缓存，则播放缓存文件");
            [self playCachedVideoWithUrl:videoUrl];
        }else{
            NSLog(@"既无缓存，也是非WiFi环境，则直接进入主页");
            if (self.delegate && [self.delegate respondsToSelector:@selector(closeStartADController)]) {
                [self.delegate closeStartADController];
            }
        }
    }
    [self addObserver];
}

/**
 添加监听对象
 */
- (void)addObserver
{
    if (_playItem != nil && self.player != nil) {
        [self.player addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
        [self.player addObserver:self forKeyPath:@"rate" options:NSKeyValueObservingOptionNew context:nil];
        [self.player addPeriodicTimeObserverForInterval:CMTimeMake(1.0, 30.0) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
            _currentTime = ceil(CMTimeGetSeconds(time));
        }];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didPlayToEnd) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
        [_playItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
        [_playItem addObserver:self forKeyPath:@"playbackBufferEmpty" options:NSKeyValueObservingOptionNew context:nil];
        [_playItem addObserver:self forKeyPath:@"playbackLikelyToKeepUp" options:NSKeyValueObservingOptionNew context:nil];
    }
}

/**
 移除监听对象
 */
- (void)removeObserver
{
    if (_playItem != nil && self.player != nil) {
        [self.player removeTimeObserver:self];
        [self.player removeObserver:self forKeyPath:@"status"];
        [self.player removeObserver:self forKeyPath:@"rate"];
        
        [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
        [_playItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
        [_playItem removeObserver:self forKeyPath:@"playbackBufferEmpty"];
        [_playItem removeObserver:self forKeyPath:@"playbackLikelyToKeepUp"];
        
        
    }
}
/**
 根据通知，播放结束时自动调用
 */
- (void)didPlayToEnd
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(didStopVideoPlayer)]) {
        [self.delegate didStopVideoPlayer];
        _bDidFinishPlay = YES;
    }
}
- (void)didFailedToPlayToEnd {
    NSLog(@"didFailedToPlayToEnd");
}
- (UILabel *)labelNetworkStatus
{
    if (_labelNetworkStatus == nil) {
        _labelNetworkStatus = [[UILabel alloc]init];
        _labelNetworkStatus.textColor = [UIColor whiteColor];
        _labelNetworkStatus.backgroundColor = [UIColor blackColor];
        _labelNetworkStatus.layer.cornerRadius = 10;
        _labelNetworkStatus.clipsToBounds = YES;
        _labelNetworkStatus.alpha = 0.5;
        _labelNetworkStatus.text = @"已在WiFi下预加载";
        if (iPhone4s) {
            _labelNetworkStatus.font = [UIFont HeitiSCWithFontSize:12];
        }else{
            _labelNetworkStatus.font = [UIFont HeitiSCWithFontSize:15];
        }
        _labelNetworkStatus.textAlignment = NSTextAlignmentCenter;
        _labelNetworkStatus.hidden = YES;
    }
    return _labelNetworkStatus;
}
- (UIButton *)buttonClosePlayer
{
    if (_buttonClosePlayer == nil) {
        _buttonClosePlayer = [[UIButton alloc]init];
        _buttonClosePlayer.titleLabel.textColor = [UIColor whiteColor];
        _buttonClosePlayer.layer.cornerRadius = 3.3;
        _buttonClosePlayer.backgroundColor = [UIColor grayColor];
        _buttonClosePlayer.alpha = 0.5;
        [_buttonClosePlayer setTitle:@"跳过" forState:UIControlStateNormal];
        if (iPhone4s) {
            _buttonClosePlayer.titleLabel.font = [UIFont HeitiSCWithFontSize:12];
        }else{
            _buttonClosePlayer.titleLabel.font = [UIFont HeitiSCWithFontSize:15];
        }
        [_buttonClosePlayer addTarget:self action:@selector(didInterruptADPlaying) forControlEvents:UIControlEventTouchUpInside];
    }
    return _buttonClosePlayer;
}

/**
 中断播放代理
 */
- (void)didInterruptADPlaying
{
    NSLog(@"中断播放代理");
    if (self.delegate && [self.delegate respondsToSelector:@selector(didInterruptADPlaying:)]) {
        [self.delegate didInterruptADPlaying:_currentTime];
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(playerCloseButtonBeClicked)]) {
        [self.delegate playerCloseButtonBeClicked];
    }
}
/**
 在线播放视频
 
 @param videoUrl 视频链接
 */
- (void)playOnlineVideoWithUrl:(NSString *)videoUrl
{
    NSURL *videoURL = [NSURL URLWithString:videoUrl];
    AVURLAsset *URLAsset = [AVURLAsset assetWithURL:videoURL];
    _playItem = [AVPlayerItem playerItemWithAsset:URLAsset];
    self.player = [AVPlayer playerWithPlayerItem:_playItem];
    [self.player play];
    if (self.delegate && [self.delegate respondsToSelector:@selector(didStartVideoPlayer)]) {
        [self.delegate didStartVideoPlayer];
    }
}

/**
 播放本地视频
 
 @param videoUrl 视频链接
 */
- (void)playCachedVideoWithUrl:(NSString *)videoUrl
{
//    [[ToastViewAlert defaultCenter] postAlertWithMessage:@"此视频为本地播放"];
    if (![self isWiFi]) {
        self.labelNetworkStatus.hidden = NO;
    }
    NSString *strVideoUrl = [self cachedVideoURL:videoUrl];
    NSURL *urlVideoUrl = [NSURL fileURLWithPath:strVideoUrl];
    _playItem = [AVPlayerItem playerItemWithURL:urlVideoUrl];
    self.player = [AVPlayer playerWithPlayerItem:_playItem];
    [self.player play];
    if (self.delegate && [self.delegate respondsToSelector:@selector(didStartVideoPlayer)]) {
        [self.delegate didStartVideoPlayer];
    }
    
}
/**
 判断是否是WiFi环境
 
 @return 是否是WiFi的标识
 */
- (BOOL)isWiFi
{
//    return [[NetworkStatusHelper getNetWorkStates] isEqualToString:@"wifi"] ? YES : NO;
    return YES;
}

/**
 下载视频
 */
- (void)downloadVideoWithVideoUrl:(NSString *)videlUrl
{
    NSURL *urlVideoUrl = [NSURL URLWithString:videlUrl];
    NSMutableURLRequest *reqDownload = [NSMutableURLRequest requestWithURL:urlVideoUrl cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:30];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]
                                                          delegate:self
                                                     delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionDownloadTask *downloadtask = [session downloadTaskWithRequest:reqDownload];
    [downloadtask resume];
}
/**
 根据视频链接，返回本地文件路径
 
 @param videoUrl 视频链接
 @return 本地文件路径
 */
- (NSString *)cachedVideoURL:(NSString *)videoUrl
{
    NSString *strFilePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    strFilePath = [strFilePath stringByAppendingPathComponent:@"video"];
    NSString *strMD5VideoUrl = [videoUrl ads_MD5String];
    strFilePath = [strFilePath stringByAppendingPathComponent:[NSString stringWithFormat:@"/%@.mp4",strMD5VideoUrl]];
    return strFilePath;
}

/**
 判断对应 videourl 的本地视频文件是否存在
 
 @param videoUrl 视频链接地址
 @return 是否存在的标识
 */
- (BOOL)isCachedVideoFileExsit:(NSString *)videoUrl
{
    NSString *strVideoFilePath = [self cachedVideoURL:videoUrl];
    return [[NSFileManager defaultManager] fileExistsAtPath:strVideoFilePath];
}

//  下载完成后调用此方法，在此处执行创建文件夹以及保存缓存文件至目的文件
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location
{
    NSLog(@"下载的位置%@",location);
    NSString *strDestPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    strDestPath = [strDestPath stringByAppendingPathComponent:@"video"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL bIsDir;
    //  创建文件夹路径
    if (![fileManager fileExistsAtPath:strDestPath isDirectory:&bIsDir]) {
        NSError * createFolderError = nil;
        [fileManager createDirectoryAtPath:strDestPath withIntermediateDirectories:YES attributes:nil error:&createFolderError];
        if (createFolderError) {
            NSLog(@"创建文件夹 %@ 失败",strDestPath);
        }else{
            NSLog(@"创建文件夹 %@ 成功",strDestPath);
        }
    }else{
        NSLog(@"文件夹 %@ 已存在，请勿重复创建",strDestPath);
    }
    //  创建文件路径
    NSString *strMD5VideoURL = [NSString stringWithFormat:@"%@",downloadTask.originalRequest.URL];
    strMD5VideoURL = [strMD5VideoURL ads_MD5String];
    NSString *strFilePath = [strDestPath stringByAppendingPathComponent:[NSString stringWithFormat:@"/%@.mp4",strMD5VideoURL]];
    if (![fileManager fileExistsAtPath:strFilePath]) {
        NSLog(@"创建文件 %@ 成功",strFilePath);
        NSError *moveFileError = nil;
        [fileManager moveItemAtPath:location.path toPath:strFilePath error:&moveFileError];
        if (moveFileError) {
            NSLog(@"将临时文件 %@ 移动到文件 %@ 失败 %@",location.path,strFilePath,moveFileError);
        }else{
            NSLog(@"将临时文件 %@ 移动到文件 %@ 成功",location.path,strFilePath);
        }
    }else{
        NSLog(@"文件 %@ 已存在，请勿重复下载",strFilePath);
    }
    
    
}
//  实现此处可获取当前下载进度
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite
{
    NSLog(@"写入比特:%10lli,全部已写入比特:%10lli,全部待写入比特%10lli,已下载: %3.1f",bytesWritten,totalBytesWritten,totalBytesExpectedToWrite,(float)totalBytesWritten/totalBytesExpectedToWrite);
}
//  实现此处即可实现大文件断点续传
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didResumeAtOffset:(int64_t)fileOffset expectedTotalBytes:(int64_t)expectedTotalBytes
{
    
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    if(iPhone4s) {
        self.labelNetworkStatus.frame = CGRectMake(self.width/2-80, STATUS_HEIGHT+5+5, 160, 20);
        self.buttonClosePlayer.frame = CGRectMake(self.width - 60, STATUS_HEIGHT+5, 50, 30);
    }else{
        self.labelNetworkStatus.frame = CGRectMake(self.width/2-100, STATUS_HEIGHT+5+5, 200, 20);
        self.buttonClosePlayer.frame = CGRectMake(self.width - 70, STATUS_HEIGHT+5, 60, 30);
    }
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    if (self.delegate && [self.delegate respondsToSelector:@selector(didTapedVideoPlayer)]) {
        [self.delegate didTapedVideoPlayer];
        _bVideoAdClicked = YES;
    }
}

/**
 获取缓冲进度

 @return 缓冲总计秒数
 */
- (NSTimeInterval)availableDuration {
    NSArray *loadedTimeRanges = [[self.player currentItem] loadedTimeRanges];
    CMTimeRange timeRange = [loadedTimeRanges.firstObject CMTimeRangeValue];// 获取缓冲区域
    float startSeconds = CMTimeGetSeconds(timeRange.start);
    float durationSeconds = CMTimeGetSeconds(timeRange.duration);
    NSTimeInterval result = startSeconds + durationSeconds;// 计算缓冲总进度
    return result;
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
//    if ([object isEqual:self.player] && [keyPath isEqualToString:@"rate"]) {
//        if (self.player.rate == 0) {
//            NSLog(@"播放暂停了");
//        }
//    }
    //监控网络加载情况属性
    if ([object isEqual:_playItem] && [keyPath isEqualToString:@"loadedTimeRanges"]) {
        NSLog(@"playeritem's loadedTimeRanges : %@",_playItem.loadedTimeRanges);
        NSTimeInterval timeInterval = [self availableDuration];
        CMTime timeRange = self.playItem.duration;
        CGFloat totalDuration = CMTimeGetSeconds(timeRange);
        NSLog(@"总缓冲秒数:%4.1f s , 视频时长: %4.1f",timeInterval,totalDuration);
        _totalDuration = totalDuration;
        _totalDuration = ceil(_totalDuration);
        
    }
//    if ([object isEqual:_playItem] && [keyPath isEqualToString:@"playbackBufferFull"]) {
//
//    }
//    //缓存可以播放的时候调用
//    if ([object isEqual:_playItem] && [keyPath isEqualToString:@"playbackLikelyToKeepUp"]) {
//        NSLog(@"缓存可以播放了，开始播放");
//        [self.player play];
//    }
//    //监听播放的区域缓存是否为空
//    if ([object isEqual:_playItem] && [keyPath isEqualToString:@"playbackBufferEmpty"]) {
//
//    }
//    //监控状态属性，注意AVPlayer也有一个status属性，通过监控它的status也可以获得播放状态
//    if ([object isEqual:self.player] && [keyPath isEqualToString:@"status"]) {
//        if (self.player.status == AVPlayerStatusReadyToPlay) {
//            NSLog(@"播放器状态【ReadyToPlay】");
//            [self.player play];
//        }else if (self.player.status == AVPlayerStatusFailed) {
//            NSLog(@"播放器状态【StatusFailed】");
//        }else if (self.player.status == AVPlayerStatusUnknown) {
//            NSLog(@"播放器状态【Unknown】");
//        }
//    }
}

//- (NSString *)md5S

- (void)dealloc
{
    [self removeObserver];
}
@end
