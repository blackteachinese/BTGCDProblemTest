//
//  ViewController.m
//  BTGCDProblemTest
//
//  Created by Blacktea on 5/17/18.
//  Copyright © 2018 Blacktea. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self testGCDMaxThreadAndSync];
}


/*
    1. 并发队列最多生成线程最多64个
    2. 64个线程都在执行时，sync任务无法执行会导致
 */
- (void)testGCDMaxThreadAndSync {
    dispatch_queue_t gq = [self concurrentQueue];
    for (int index = 0; index < NSUIntegerMax; index ++) {
        NSLog(@"fire task index = %d;thread = %@", index, [NSThread currentThread]);
        dispatch_async(gq, ^{
            NSLog(@"before task index = %d;thread = %@", index, [NSThread currentThread]);
            dispatch_queue_t gq = [self concurrentQueue];
            dispatch_sync(gq, ^{
                NSLog(@"before sync  index = %d; thread = %@", index, [NSThread currentThread]);
                sleep(1);
                NSLog(@"after sync  index = %d; thread = %@", index, [NSThread currentThread]);
            });
            NSLog(@"end task  index = %d; thread = %@", index, [NSThread currentThread]);
        });
    }
}

- (dispatch_queue_t)concurrentQueue {
    static dispatch_queue_t queue = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        queue = dispatch_queue_create("test.concurrentQueue", DISPATCH_QUEUE_CONCURRENT);
        //        queue = dispatch_queue_create("test.concurrentQueue", DISPATCH_QUEUE_SERIAL);
    });
    
    return queue;
}

@end
