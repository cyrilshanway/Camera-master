//
//  CaptureViewController.m
//  Camera
//
//  Created by Cyrilshanway on 2014/11/23.
//  Copyright (c) 2014年 Cyrilshanway. All rights reserved.
//



#import "CaptureViewController.h"
#import "MainViewController.h"
#import "SWRevealViewController.h"

@interface CaptureViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@end

@implementation CaptureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    MainViewController *mainVC = [[MainViewController alloc] init];
    
    //設定按鈕顏色
    mainVC.sideBarButton.tintColor = [UIColor colorWithWhite:0.1f alpha:0.9f];
    //設定側邊欄按鈕動作，按下時，顯示側邊欄
    mainVC.sideBarButton.target = self.revealViewController;
    mainVC.sideBarButton.action = @selector(revealToggle:);
    
    //設定手勢
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - private
//負責建立.設定與顯示圖像挑選器(image picker)作為影片錄製
- (IBAction)captureVideo:(id)sender {
    if ([UIImagePickerController isSourceTypeAvailable:
        //和照相機設定一樣
        UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        //依照媒體形式，挑選器針對照片或影片來顯示不同的介面
        //default是kUTTypeMovie(是委派相機介面)
        picker.mediaTypes = [[NSArray alloc] initWithObjects:(NSString *)kUTTypeMovie, nil];
        
        [self presentViewController:picker animated:YES completion:nil];
    }
}

//要讓影片播放，需要：<使用delegate的imagePickerController:picker>
//(1.)取得擷取影片的系統URL
//(2.)移除UIImagePickController
//(3.)使用MPMoviePlayerController類別來播放影片(這是一種內建類別，可以播放來自檔案(或網路串流的影片))

#pragma mark - delegate
//和照相實作delegate兩個方法相同
//當user確認使用此影片，就會呼叫imagePickerController:picker
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    //1.取得影片的URL(在info參數裡，但不是存在照片庫中，必須明確指定它)
    self.videoURL = info[UIImagePickerControllerMediaURL];
    
    //2.解除挑選器
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    //3.1實體化一個MPMoviePlayerController類別
    self.videoController = [[MPMoviePlayerController alloc] init];
    
    //3.2並將影片URL傳遞給它播放
    [self.videoController setContentURL:self.videoURL];
    [self.videoController.view setFrame:CGRectMake(0, 0, 320, 460)];
    
    [self.view addSubview:self.videoController.view];
    
    [self.videoController play];
    
    //MPMoviePlayerController的通知功能(用來控制影片播放)
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(videoPlaybackDidFinish:) name:MPMoviePlayerPlaybackDidFinishNotification object:self.videoController];
}
//user有可能會按"cancel"取消操作
//只要移除PickerController就可以了
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}


-(void)videoPlaybackDidFinish:(NSNotification *)notification{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
    
    // 停止影片播放器且從視圖中刪除
    [self.videoController stop];
    [self.videoController.view removeFromSuperview];
    self.videoController = nil;
    
    NSString *title = @"Video Playback";
    NSString *message = @"Just Finished the Video playback. The video is now removed.";
    NSString *cancelButtonTitle = @"OK";
    
    //顯示訊息
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:message
                                                   delegate:nil
                                          cancelButtonTitle:cancelButtonTitle
                                          otherButtonTitles:nil, nil];
    
    [alert show];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
