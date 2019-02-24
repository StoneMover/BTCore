//
//  BTLoadingHelp.m
//  moneyMaker
//
//  Created by Motion Code on 2019/2/13.
//  Copyright © 2019 stonemover. All rights reserved.
//

#import "BTLoadingHelp.h"

static BTLoadingHelp * help=nil;

@interface BTLoadingHelp()

@property (nonatomic, strong) NSMutableArray * delegates;

@end



@implementation BTLoadingHelp

+(void)load
{
    [self performSelectorOnMainThread:@selector(share) withObject:nil waitUntilDone:NO];
}

+ (BTLoadingHelp*)share{
    if (!help) {
        help=[BTLoadingHelp new];
    }
    
    return help;
}

- (instancetype)init{
    self=[super init];
    self.delegates=[NSMutableArray new];
    [self initNotification];
    return self;
}

- (void)initNotification{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)addDelegate:(id)delegate{
    [self.delegates addObject:delegate];
}
- (void)removeDelegate:(id)delegate{
    [self.delegates removeObject:delegate];
}

#pragma mark 键盘监听
//当键盘消失的时候调用
- (void)keyboardWillHide:(NSNotification *)notif {
    self.keyboardHeight=0;
    for (id del in self.delegates) {
        if ([del respondsToSelector:@selector(keyBoradHeightChange)]) {
            [del keyBoradHeightChange];
        }
    }
}

//当键盘出现或改变时调用
- (void)keyboardWillShow:(NSNotification *)aNotification
{
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    CGFloat h = keyboardRect.size.height;
    if (h==self.keyboardHeight) {
        return;
    }
    self.keyboardHeight=h;
    for (id del in self.delegates) {
        if ([del respondsToSelector:@selector(keyBoradHeightChange)]) {
            [del keyBoradHeightChange];
        }
    }
}


@end
