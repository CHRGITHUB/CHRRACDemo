//
//  EditPersonViewController.h
//  RAC基本使用
//
//  Created by 陈红荣 on 16/5/23.
//  Copyright © 2016年 chenHongRong. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Person;
@interface EditPersonViewController : UIViewController

- (instancetype)initWithPerson:(Person *)person completion:(void (^)())completion;


@end
