//
//  WebViewController.m
//  Camera
//
//  Created by Cyrilshanway on 2014/11/23.
//  Copyright (c) 2014年 Cyrilshanway. All rights reserved.
//

#import "WebViewController.h"
#import "MainViewController.h"
#import "SWRevealViewController.h"
#import "MBProgressHUD.h"
#import "Line.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <MessageUI/MessageUI.h>

@interface WebViewController ()<UIScrollViewDelegate, UIWebViewDelegate, MBProgressHUDDelegate, MFMailComposeViewControllerDelegate>
{
    MBProgressHUD   *progressHUD;
}

@property (weak, nonatomic) IBOutlet UIScrollView *backgroundScrollView;
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    MainViewController *mainVC = [[MainViewController alloc] init];
    
    //設定按鈕顏色
    mainVC.sideBarButton.tintColor = [UIColor colorWithWhite:0.1f alpha:0.9f];
    //設定側邊欄按鈕動作，按下時，顯示側邊欄
    mainVC.sideBarButton.target = self.revealViewController;
    mainVC.sideBarButton.action = @selector(revealToggle:);
    
    //設定手勢
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    
    
    //scrollView(background)
    self.backgroundScrollView.contentSize = CGSizeMake(320.0f, 900.0f);
    
    self.webView.alpha = 0.0f;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - webView delegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    
    NSLog(@"Raw: %@", request);
    NSString *requestPath = [[request URL] absoluteString];
    NSLog(@"Final: %@", requestPath);
    
    if ([requestPath rangeOfString:@"ServiceLogin"].location != NSNotFound) {
        NSLog(@"Login...");
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提醒" message:@"登入" delegate:self cancelButtonTitle:@"關閉" otherButtonTitles: nil];
        
        [alert show];
    }
    
    return YES;
}
- (void)webViewDidStartLoad:(UIWebView *)webView{
    NSLog(@"開始跑");
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    NSLog(@"結束");
    [progressHUD hide:YES];
}
//line發送
- (IBAction)lineBtnPressed:(id)sender {
    [Line shareText:@"Hello，DuReading~"];
}
//mail發送
- (IBAction)mailBtnPressed:(id)sender {
    NSString *emailTitle = @"Hello，DuReading";
    //NSString *messageBody = [NSString stringWithFormat:@"Test Message"];
    NSArray *toRecipients = [NSArray arrayWithObject: @"dubookreading@gmail.com"];
    
    if ([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
        mc.mailComposeDelegate = self;
        
        [mc setSubject:emailTitle];
        //[mc setMessageBody:messageBody isHTML:YES];
        [mc setToRecipients:toRecipients];
        
        //Present mail view on screen
        [self presentViewController:mc animated:YES completion:nil];
    }else{
        UIAlertView *alerView = [[UIAlertView alloc] initWithTitle:@"測試"
                                                           message:@"Email 尚未設定"
                                                          delegate:nil
                                                 cancelButtonTitle:@"確定"
                                                 otherButtonTitles: nil];
        [alerView show];
    }

}
//網站show
- (IBAction)webBtnPressed:(id)sender {
    self.webView.alpha = 1.0f;
    self.webView.frame = CGRectMake(0, 20, 375, 500);
    //webView
    NSURL *url = [NSURL URLWithString:@"http://www.dubookreading.com/"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    self.webView.delegate = self;
    [self.webView loadRequest:request];
    
    
    //Loading 圈圈
    if (progressHUD)
        [progressHUD removeFromSuperview];
    
    progressHUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:progressHUD];
    progressHUD.dimBackground = NO;
    
    progressHUD.dimBackground = YES;
    progressHUD.labelText = @"載入中...";
    progressHUD.margin = 20.f;
    progressHUD.yOffset = 10.f;
    progressHUD.removeFromSuperViewOnHide = YES;
    [progressHUD show:YES];

}

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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
