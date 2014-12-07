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
#import <MessageUI/MessageUI.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "Line.h"


@interface CameraViewController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIButton *checkBtn;
@property (weak, nonatomic) IBOutlet UIButton *saveBtn;

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
    
    self.imageView.frame = CGRectMake(0, 0, 0, 0);
    self.saveBtn.hidden = YES;
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
    
    self.imageView.frame = CGRectMake(0, 20, 375, 450);
    self.imageView.image = chosenImage;
    self.saveBtn.hidden = NO;
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}
//user有可能會按"cancel"取消操作
//只要移除PickerController就可以了
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)shareBtnPressed:(id)sender {
    
    switch (self.saveBtn.hidden == NO) {
        case 0:
        {
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提醒"
                                                            message:@"尚未選擇相片"
                                                           delegate:self
                                                  cancelButtonTitle:@"確定"
                                                  otherButtonTitles: nil];
            [alert show];
        }
            break;
        case 1:
        {
            UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"請選擇"
                                                                     delegate:self
                                                            cancelButtonTitle:@"取消" destructiveButtonTitle:@"想分享到" otherButtonTitles:@"Email" ,@"Line", nil];
            
            actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
            //actionSheet.tag = 1;
            
            [actionSheet showInView:[UIApplication sharedApplication].keyWindow];
        }
        default:
            break;
    }
    
    
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{

    if (buttonIndex == 1) {
        NSLog(@"Open Mail");
        [self openMail];
    }else if(buttonIndex == 2){
        [self openLine];
    }else{
        NSLog(@"Cancel");
    }
}

-(void)openMail{
    NSString *emailTitle = @"Hello";
    //NSString *messageBody = [NSString stringWithFormat:@"Test Message"];
    
    NSData * imageAsNSData = UIImagePNGRepresentation( self.imageView.image );
    
    if ([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
        mc.mailComposeDelegate = self;
        
        [mc setSubject:emailTitle];
        //[mc setMessageBody:self.imageView.image isHTML:YES];
        [mc addAttachmentData: imageAsNSData
                              mimeType: @"image/png"
                              fileName: @"myPhoto.png"];
        
        //Present mail view on screen
        [self presentViewController:mc animated:YES completion:nil];
    }else{
        UIAlertView *alerView = [[UIAlertView alloc] initWithTitle:@"提醒"
                                                           message:@"Email 尚未設定"
                                                          delegate:nil
                                                 cancelButtonTitle:@"確定"
                                                 otherButtonTitles: nil];
        [alerView show];
    }
}

-(void)openLine{
    if (![Line isLineInstalled]) {
        NSLog(@"Line is not installed");
    }else{
                //一次只能傳一樣東西
        //[Line shareImage:[UIImage imageNamed:@"test.jpg"]];
        [Line shareImage:self.imageView.image];
    }
}
//mailComposeController delegate
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    NSLog(@"mailComposeController:result:error");
    
    switch (result) {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail canceled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent");
            break;
        case MFMailComposeResultFailed  :
            NSLog(@"Mail sent failed: %@", [error localizedDescription]);
            break;
        default:
            break;
    }
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (IBAction)saveBtnPressed:(id)sender {
    UIImageWriteToSavedPhotosAlbum(self.imageView.image, nil, nil, nil);
    
}



@end
