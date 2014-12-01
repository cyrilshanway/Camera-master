//
//  BookViewController.h
//  Camera
//
//  Created by Cyrilshanway on 2014/11/26.
//  Copyright (c) 2014年 Cyrilshanway. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Book : NSObject

// book
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *ISBNNum;

@property (nonatomic, strong) NSString *bookPublished;
@property (nonatomic, strong) NSString *bookPublisher;
@property (nonatomic, strong) UIImage *imageAuthor;
@property (nonatomic, strong) NSString *bookImgUrl;

@property (nonatomic, strong) NSString *smallImgUrl;
@property (nonatomic, strong) NSString *pageNum;
//author
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *descriptionBook;


@property (nonatomic, strong) NSString *owner;
@property (nonatomic, strong) NSString *email;

@property (nonatomic, strong) UIImage *saveImag;

//判斷
@property (nonatomic, strong) NSDictionary *oneBookInfoDictionary;//
//@property (nonatomic, strong) NSMutableDictionary *oneOwnerAllBooks;//isbn/oneBookInfoDictionary
//@property (nonatomic, strong) NSMutableArray *ISBNbookArray;

@property Book *myBook;
@end
