//
//  ViewController.m
//  Camera
//
//  Created by Cyrilshanway on 2014/11/23.
//  Copyright (c) 2014年 Cyrilshanway. All rights reserved.
//

#import "CameraViewController.h"
#import "SWRevealViewController.h"
#import "MainViewController.h"

@interface CameraViewController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation CameraViewController

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
- (IBAction)selectPhotoBtnPressed:(id)sender {
    //先檢查是否有照相機功能
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;//使用內建相簿
        //modal
        [self presentViewController:picker animated:YES completion:nil];
    }
}
- (IBAction)takePhotoBtnPressed:(id)sender {
    //使用內建相簿
    if ([UIImagePickerController isSourceTypeAvailable:(UIImagePickerControllerSourceTypeSavedPhotosAlbum)]) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        
        [self presentViewController:picker animated:YES completion:nil];
    }
}

#pragma mark - delegte
//使用相機照相或是相簿選照片此delegate方法會被呼叫
//info是一個NSDictionary，包含原始圖像以及讓UIImagePickerControllerEditedImage標籤來存取的編輯後圖像
//，當app允許使用者編輯圖片時，就會用編輯後的圖片來取代遠使的圖片
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    self.imageView.image = chosenImage;
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}
//user有可能會按"cancel"取消操作
//只要移除PickerController就可以了
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}



@end
