//
//  ScanViewController.m
//  Camera
//
//  Created by Cyrilshanway on 2014/11/26.
//  Copyright (c) 2014年 Cyrilshanway. All rights reserved.
//

#import "ScanViewController.h"
#import "Book.h"
#import "MainViewController.h"
#import <XMLReader.h>
#import <ZBarSDK.h>
#import "ShowBookViewController.h"
#import "SWRevealViewController.h"
#import "AFNetworking.h"
#import "LoginViewController.h"

@interface ScanViewController ()<UIAlertViewDelegate,ZBarReaderDelegate,UIGestureRecognizerDelegate>

//@property (nonatomic, strong) NSDictionary *currentMyDictionary;

@property (weak, nonatomic) IBOutlet UITextField *scanTextField;

//@property Book *myBook;
@end

@implementation ScanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
    
    
    MainViewController *mainVC = [[MainViewController alloc] init];
    
    //設定按鈕顏色
    mainVC.sideBarButton.tintColor = [UIColor colorWithWhite:0.1f alpha:0.9f];
    //設定側邊欄按鈕動作，按下時，顯示側邊欄
    mainVC.sideBarButton.target = self.revealViewController;
    mainVC.sideBarButton.action = @selector(revealToggle:);
    
    //設定手勢
    //[self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    //先讓鍵盤升起
    //[self.scanTextField becomeFirstResponder];
    
    //[self scanBtnPressed];
    //[self scan2BookAPI];
    
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSMutableDictionary *) customerDictionary {
    
    if(!_currentDictionary)
        _currentDictionary = [[NSMutableDictionary alloc] init];
    return _currentDictionary;
}

-(void)dismissKeyboard {
    [_scanTextField resignFirstResponder];
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (IBAction)ScanBacBtnPressed:(id)sender {
    /*掃描二維條碼部分：
     導入ZBarSDK文件並引入一下框架
     AVFoundation.framework
     CoreMedia.framework
     CoreVideo.framework
     QuartzCore.framework
     libiconv.dylib
     引入頭文件#import “ZBarSDK.h” 即可使用
     當找到條碼時，執行代理方法
     
     - (void) imagePickerController: (UIImagePickerController*) reader didFinishPickingMediaWithInfo: (NSDictionary*) info
     
     最後讀取並顯示了條碼的圖片和内容。*/
    
    ZBarReaderViewController *reader = [ZBarReaderViewController new];
    reader.readerDelegate = self;
    reader.supportedOrientationsMask = ZBarOrientationMaskAll;
    
    ZBarImageScanner *scanner = reader.scanner;
    
    [scanner setSymbology: ZBAR_I25
                   config: ZBAR_CFG_ENABLE
                       to: 0];
    
    [self presentModalViewController: reader
                            animated: YES];
}

//未使用
- (IBAction):scanBtnPressed{
    /*掃描二維條碼部分：
     導入ZBarSDK文件並引入一下框架
     AVFoundation.framework
     CoreMedia.framework
     CoreVideo.framework
     QuartzCore.framework
     libiconv.dylib
     引入頭文件#import “ZBarSDK.h” 即可使用
     當找到條碼時，執行代理方法
     
     - (void) imagePickerController: (UIImagePickerController*) reader didFinishPickingMediaWithInfo: (NSDictionary*) info
     
     最後讀取並顯示了條碼的圖片和内容。*/
    
    ZBarReaderViewController *reader = [ZBarReaderViewController new];
    reader.readerDelegate = self;
    reader.supportedOrientationsMask = ZBarOrientationMaskAll;
    
    ZBarImageScanner *scanner = reader.scanner;
    
    [scanner setSymbology: ZBAR_I25
                   config: ZBAR_CFG_ENABLE
                       to: 0];
    
    [self presentModalViewController: reader
                            animated: YES];
}

- (void) imagePickerController: (UIImagePickerController*) reader
 didFinishPickingMediaWithInfo: (NSDictionary*) info
{
    id<NSFastEnumeration> results =
    [info objectForKey: ZBarReaderControllerResults];
    ZBarSymbol *symbol = nil;
    for(symbol in results)
        
        break;
    NSLog(@"%@",symbol.data);
    //imageview.image =
    [info objectForKey: UIImagePickerControllerOriginalImage];
    
    [reader dismissModalViewControllerAnimated: YES];
    
    //判断是否包含 頭'http:'
    NSString *regex = @"http+:[^\\s]*";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    
    //判断是否包含 頭'ssid:'
    NSString *ssid = @"ssid+:[^\\s]*";;
    NSPredicate *ssidPre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",ssid];
    
    self.scanTextField.text =  symbol.data ;
    
    if ([predicate evaluateWithObject:self.scanTextField.text]) {
        
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil
                                                        message:@"It will use the browser to this URL。"
                                                       delegate:nil
                                              cancelButtonTitle:@"Close"
                                              otherButtonTitles:@"Ok", nil];
        alert.delegate = self;
        alert.tag=1;
        [alert show];
        
        
        
        
    }
    else if([ssidPre evaluateWithObject:self.scanTextField.text]){
        
        NSArray *arr = [self.scanTextField.text componentsSeparatedByString:@";"];
        
        NSArray * arrInfoHead = [[arr objectAtIndex:0] componentsSeparatedByString:@":"];
        
        NSArray * arrInfoFoot = [[arr objectAtIndex:1] componentsSeparatedByString:@":"];
        
        
        self.scanTextField.text=
        [NSString stringWithFormat:@"ssid: %@ \n password:%@",
         [arrInfoHead objectAtIndex:1],[arrInfoFoot objectAtIndex:1]];
        
        
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:self.scanTextField.text
                                                        message:@"The password is copied to the clipboard , it will be redirected to the network settings interface"
                                                       delegate:nil
                                              cancelButtonTitle:@"Close"
                                              otherButtonTitles:@"Ok", nil];
        
        
        alert.delegate = self;
        alert.tag=2;
        [alert show];
        
        
        UIPasteboard *pasteboard=[UIPasteboard generalPasteboard];
        //        然後，可以使用如下代碼來把一個字符串放到剪貼板上：
        pasteboard.string = [arrInfoFoot objectAtIndex:1];
        
        
    }
}

//https://www.goodreads.com/book/isbn?isbn=9780307887894&key=${WJGaq9KTqxo5n03ngpxRg}&format=xml
//test isbn:9789867889591
- (IBAction)scan2BookAPI {
    //輸入完鍵盤落下
    [self.scanTextField resignFirstResponder];
    
    NSString *final = [self.scanTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    NSString *enterIsbn = [NSString stringWithFormat:@"%@", final];
    
    NSString *urlString = [NSString stringWithFormat:@"http://www.goodreads.com/book/isbn?format=xml&isbn=%@&key=%@",enterIsbn, @"WJGaq9KTqxo5n03ngpxRg"];
    
    NSLog(@"%@", urlString);
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (!connectionError || data != nil) {
            
            NSError *error = nil;
            
            NSDictionary *xmlDictionInfo = [XMLReader dictionaryForXMLData:data error:&error];
            
            if (!error) {
                //book
                NSDictionary *bookDict = [[xmlDictionInfo objectForKey:@"GoodreadsResponse"] objectForKey:@"book"];
                //NSLog(@"XML Dict Book Info: %@", bookDict);
                
                //data放進欄位
                NSDictionary *bookTitle = [bookDict objectForKey:@"title"];
                NSLog(@"%@", bookTitle[@"text"]);
                NSDictionary *isbnNum = [bookDict objectForKey:@"isbn13"];
                NSDictionary *bookPublished = [bookDict objectForKey:@"publication_year"];
                NSDictionary *bookPulisher = [bookDict objectForKey:@"publisher"];
                NSDictionary *imageUrl = [bookDict objectForKey:@"image_url"];
                NSDictionary *bookPageNum = [bookDict objectForKey:@"num_pages"];
                NSDictionary *bookDiscription = [bookDict objectForKey:@"description"];
                
                //找author
                NSDictionary *bookDict2 = [[[[xmlDictionInfo objectForKey:@"GoodreadsResponse"]
                                             objectForKey:@"book"]
                                            objectForKey:@"authors"]
                                           objectForKey:@"author"];
                //NSLog(@"%@", bookDict2);
                NSDictionary *bookAuthor = [bookDict2 objectForKey:@"name"];
                
                //NSLog(@"%@ %@ %@ %@ %@ ",bookAuthor, bookPageNum, bookPublished, bookPulisher, bookTitle);
                
                //存圖片(同步處理)
                UIImage * result;
                NSLog(@"%@", imageUrl[@"text"]);
                NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageUrl[@"text"]]];
                result = [UIImage imageWithData:data];
                
                //NSUserDefault test//-----------------
                
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                NSString *defaultuser = [defaults objectForKey:@"user"];
                //NSString *defaultEmail = [defaults objectForKey:@"email"];
                
                //NSUserDefault test//-----------------
                
                Book *myNewBook = [[Book alloc] init];
                myNewBook.owner = self.myBook.owner;
                myNewBook.owner = defaultuser;
                //myNewBook.email = self.myBook.email;
                myNewBook.name          = bookAuthor[@"text"];
                myNewBook.title         = bookTitle[@"text"];
                myNewBook.ISBNNum       = isbnNum[@"text"];
                myNewBook.bookPublished = bookPublished[@"text"];
                myNewBook.bookPublisher = bookPulisher[@"text"];
                myNewBook.imageAuthor   = result;
                myNewBook.pageNum       = bookPageNum[@"text"];
                myNewBook.descriptionBook   = bookDiscription[@"text"];
                myNewBook.bookImgUrl    =imageUrl[@"text"];
        
                
                self.currentDictionary = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                          myNewBook.owner,@"owner",
                                          myNewBook.email,@"email",
                                          bookAuthor[@"text"], @"name",
                                          bookTitle[@"text"],@"title",
                                          isbnNum[@"text"],@"ISBNNum",
                                          bookPublished[@"text"],@"bookPublished",
                                          bookPulisher[@"text"], @"bookPublisher",
                                          result,@"imageAuthor",
                                          bookPageNum[@"text"],@"pageNum",
                                          bookDiscription[@"text"],@"description",
                                          nil];//value/key;
                myNewBook.oneBookInfoDictionary = self.currentDictionary;
                
                self.myBook = myNewBook;
                
                
                //show book
                
//                ShowBookViewController *vc = [[ShowBookViewController alloc] init];
//                [self.navigationController pushViewController:vc animated:YES];

                [self performSegueWithIdentifier:@"searchSegue" sender:self];

                
            }
            
        } else {
//            ScanViewController *vc = [[ScanViewController alloc] init];
//            
//            
//            NSLog(@"Connection with: %@", connectionError);
//            [self.navigationController pushViewController:vc animated:YES];
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提醒" message:@"查無此書" delegate:self cancelButtonTitle:@"確認" otherButtonTitles: nil];
        }
        
    }];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    ShowBookViewController* vc = segue.destinationViewController;
    vc.myBook = self.myBook;
}
@end
