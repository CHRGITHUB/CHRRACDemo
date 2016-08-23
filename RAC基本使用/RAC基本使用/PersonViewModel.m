//
//  PersonViewModel.m
//  RAC基本使用
//
//  Created by 陈红荣 on 16/5/23.
//  Copyright © 2016年 chenHongRong. All rights reserved.
//

#import "PersonViewModel.h"

@implementation PersonViewModel

- (instancetype)init {
    self = [super init];
    if (self) {
        _persons = [NSMutableArray array];
    }
    return self;
}


- (RACSignal *)loadPersons {
    
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                
        // 模拟异步加载数据
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [NSThread sleepForTimeInterval:1.0];
            
            NSMutableArray <Person *> *persons = [NSMutableArray array];
            
            for (NSInteger i = 0; i < 20; i++) {
                Person *person = [Person new];
                
                person.name = [@"chr - " stringByAppendingFormat:@"%zd", i];
                person.pwd = [NSString stringWithFormat:@"%d",(15 + arc4random_uniform(20))];
                
                [persons addObject:person];
            }
            
            // 拼接数据
            [_persons addObjectsFromArray:persons];
            
            // 主队列回调
            dispatch_async(dispatch_get_main_queue(), ^{
                // 通知订阅者，监听的消息
                [subscriber sendNext:self];
                
                // 通知订阅者，异步加载完成
                [subscriber sendCompleted];
            });
        });
        
        return nil;
    }];
}



@end
