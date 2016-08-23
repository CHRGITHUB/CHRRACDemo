//
//  PersonViewModel.h
//  RAC基本使用
//
//  Created by 陈红荣 on 16/5/23.
//  Copyright © 2016年 chenHongRong. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "Person.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface PersonViewModel : NSObject

/**
 *  个人数组
 */
@property (nonatomic) NSMutableArray <Person *> *persons;


/**
 *  异步加载个人记录
 *
 */
- (RACSignal *)loadPersons;


@end
