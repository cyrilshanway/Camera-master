//
//  ShowBookViewController.h
//  Camera
//
//  Created by Cyrilshanway on 2014/11/26.
//  Copyright (c) 2014年 Cyrilshanway. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Book.h"

@interface ShowBookViewController : UIViewController

@property (nonatomic, strong) NSDictionary *currentDictionary;
@property Book *myBook;
@end
