//
//  GCDViewController.m
//  BTCoreExample
//
//  Created by apple on 2020/9/14.
//  Copyright © 2020 stonemover. All rights reserved.
//


/**
 
 任务
 
 同步执行（sync）
 
    同步添加任务到指定的队列中，在添加的任务执行结束之前，会一直等待，直到队列里面的任务完成之后再继续执行。
    只能在当前线程中执行任务，不具备开启新线程的能力。

 异步执行（async）：

    异步添加任务到指定的队列中，它不会做任何等待，可以继续执行任务。
    可以在新的线程中执行任务，具备开启新线程的能力。

队列（Dispatch Queue）
 
 串行队列（Serial Dispatch Queue）：

     每次只有一个任务被执行。让任务一个接着一个地执行。（只开启一个线程，一个任务执行完毕后，再执行下一个任务）

 并发队列（Concurrent Dispatch Queue）：

     可以让多个任务并发（同时）执行。（可以开启多个线程，并且同时执行任务）

 并发队列 的并发功能只有在异步（dispatch_async）方法下才有效。
 
 
 
 */

#import "GCDViewController.h"

@interface GCDViewController ()

@end

@implementation GCDViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initTitle:@"GCD"];
}


- (void)createQueue{
    /*
     第一个参数表示队列的唯一标识符，用于 DEBUG，可为空。队列的名称推荐使用应用程序 ID 这种逆序全程域名。
     第二个参数用来识别是串行队列还是并发队列。DISPATCH_QUEUE_SERIAL 表示串行队列，DISPATCH_QUEUE_CONCURRENT 表示并发队列。
     */
    // 串行队列的创建方法
    dispatch_queue_t queueSerial = dispatch_queue_create("net.bujige.testQueue", DISPATCH_QUEUE_SERIAL);
    // 并发队列的创建方法
    dispatch_queue_t queueConcurrent = dispatch_queue_create("net.bujige.testQueue", DISPATCH_QUEUE_CONCURRENT);

    /**
     对于串行队列，GCD 默认提供了：『主队列（Main Dispatch Queue）』,所有放在主队列中的任务，都会放到主线程中执行。
     */
    
    // 主队列的获取方法
    dispatch_queue_t queueMain = dispatch_get_main_queue();

    /**
        对于并发队列，GCD 默认提供了 『全局并发队列（Global Dispatch Queue）』。
        可以使用 dispatch_get_global_queue 方法来获取全局并发队列。需要传入两个参数。第一个参数表示队列优先级，一般用 DISPATCH_QUEUE_PRIORITY_DEFAULT。第二个参数暂时没用，用 0 即可。
     */
    
    // 全局并发队列的获取方法
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);

}


- (void)createTask{
    // 同步执行任务创建方法
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_sync(queue, ^{
        // 这里放同步执行任务代码
    });
    // 异步执行任务创建方法
    dispatch_async(queue, ^{
        // 这里放异步执行任务代码
    });

}

//同步-并发队列,没有开启新线程，串行执行任务,比如我们基于AFNetworing发送多个有序的网络请求
- (IBAction)test_0:(id)sender {
    NSLog(@"0---%@",[NSThread currentThread]);
    dispatch_queue_t queue = dispatch_queue_create("net.bujige.testQueue", DISPATCH_QUEUE_CONCURRENT);
    dispatch_sync(queue, ^{
        [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
        NSLog(@"1---%@",[NSThread currentThread]);      // 打印当前线程
    });
    
    dispatch_sync(queue, ^{
        NSLog(@"2---%@",[NSThread currentThread]);      // 打印当前线程
    });
    
}

//同步-串行队列,没有开启新线程，串行执行任务
- (IBAction)test_1:(id)sender {
    
    NSLog(@"0---%@",[NSThread currentThread]);
    dispatch_queue_t queue = dispatch_queue_create("net.bujige.testQueue", DISPATCH_QUEUE_SERIAL);
    dispatch_sync(queue, ^{
        [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
        NSLog(@"1---%@",[NSThread currentThread]);      // 打印当前线程
    });
    
    dispatch_sync(queue, ^{
        NSLog(@"2---%@",[NSThread currentThread]);      // 打印当前线程
    });
    
}

//同步-主队列,锁死
- (IBAction)test_3:(id)sender {
    
    NSLog(@"0---%@",[NSThread currentThread]);
    dispatch_queue_t queue = dispatch_get_main_queue();
    dispatch_sync(queue, ^{
        [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
        NSLog(@"1---%@",[NSThread currentThread]);      // 打印当前线程
    });

}

//异步-并发队列,有开启新线程，并发执行任务,当我们需要开启多个线程进行某一个文件的下载
- (IBAction)test_4:(id)sender {
    NSLog(@"0---%@",[NSThread currentThread]);
    dispatch_queue_t queue = dispatch_queue_create("test", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(queue, ^{
        [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
        NSLog(@"1---%@",[NSThread currentThread]);      // 打印当前线程
    });
    
    dispatch_async(queue, ^{
        [NSThread sleepForTimeInterval:1];              // 模拟耗时操作
        NSLog(@"2---%@",[NSThread currentThread]);      // 打印当前线程
    });
    
    dispatch_async(queue, ^{
        [NSThread sleepForTimeInterval:0.5];              // 模拟耗时操作
        NSLog(@"3---%@",[NSThread currentThread]);      // 打印当前线程
    });
    
    dispatch_async(queue, ^{
        NSLog(@"4---%@",[NSThread currentThread]);      // 打印当前线程
    });
    
}

//异步-串行队列,有开启新线程（1条），串行执行任务,当我们需要有序的读取几个文件数据时不阻塞主线程
- (IBAction)test_5:(id)sender {
    NSLog(@"0---%@",[NSThread currentThread]);
    dispatch_queue_t queue = dispatch_queue_create("test", DISPATCH_QUEUE_SERIAL);
    dispatch_async(queue, ^{
        //这里嵌套同步执行会死锁,嵌套异步执行没事
        dispatch_async(queue, ^{
            NSLog(@"5---%@",[NSThread currentThread]);      // 打印当前线程
        });
        
        [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
        NSLog(@"1---%@",[NSThread currentThread]);      // 打印当前线程
        
        
    });
    
    
    dispatch_async(queue, ^{
        [NSThread sleepForTimeInterval:1];              // 模拟耗时操作
        NSLog(@"2---%@",[NSThread currentThread]);      // 打印当前线程
    });
    
    dispatch_async(queue, ^{
        [NSThread sleepForTimeInterval:0.5];              // 模拟耗时操作
        NSLog(@"3---%@",[NSThread currentThread]);      // 打印当前线程
    });
    
    dispatch_async(queue, ^{
        NSLog(@"4---%@",[NSThread currentThread]);      // 打印当前线程
    });
}

//异步-主队列,没有开启新线程，串行执行任务,从其它线程回到主线程刷新UI
- (IBAction)test_6:(id)sender {
    NSLog(@"0---%@",[NSThread currentThread]);
    dispatch_queue_t queue = dispatch_get_main_queue();
    dispatch_async(queue, ^{
        [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
        NSLog(@"1---%@",[NSThread currentThread]);      // 打印当前线程
    });
    
    dispatch_async(queue, ^{
        [NSThread sleepForTimeInterval:1];              // 模拟耗时操作
        NSLog(@"2---%@",[NSThread currentThread]);      // 打印当前线程
    });
    
    dispatch_async(queue, ^{
        [NSThread sleepForTimeInterval:0.5];              // 模拟耗时操作
        NSLog(@"3---%@",[NSThread currentThread]);      // 打印当前线程
    });
    
    dispatch_async(queue, ^{
        NSLog(@"4---%@",[NSThread currentThread]);      // 打印当前线程
    });
}
@end
