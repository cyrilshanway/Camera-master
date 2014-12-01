//
//  MainViewController.h
//  Camera
//
//  Created by Cyrilshanway on 2014/11/23.
//  Copyright (c) 2014年 Cyrilshanway. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Book.h"

@interface MainViewController : UIViewController
@property (nonatomic,weak) IBOutlet UIBarButtonItem *sideBarButton;
@property Book *myBook;
@end
