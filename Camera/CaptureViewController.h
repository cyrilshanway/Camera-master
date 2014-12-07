//
//  CaptureViewController.h
//  Camera
//
//  Created by Cyrilshanway on 2014/11/23.
//  Copyright (c) 2014年 Cyrilshanway. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import <MobileCoreServices/MobileCoreServices.h>

@interface CaptureViewController : UIViewController

//儲存目前影片的URL
@property (nonatomic, strong) NSURL *videoURLString;
@property (nonatomic, strong) NSString *videoURL;
//負責影片播放
@property (nonatomic, strong) MPMoviePlayerController *videoController;

- (IBAction)captureVideo:(id)sender;
@end
