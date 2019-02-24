//
//  BTWebViewController.m
//  moneyMaker
//
//  Created by Motion Code on 2019/1/29.
//  Copyright © 2019 stonemover. All rights reserved.
//

#import "BTWebViewController.h"
#import <WebKit/WebKit.h>
#import "Const.h"

@interface BTWebViewController ()<WKNavigationDelegate>

@property (nonatomic, strong) WKWebView * webView;



@end

@implementation BTWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initLoading];
    [self initWebView];
}


- (void)initWebView{
    self.webView=[[WKWebView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight)];
    [self.view insertSubview:self.webView atIndex:0];
    self.webView.navigationDelegate=self;
    [self addSelfObserver];
    NSURL * url=[NSURL URLWithString:self.url];
    NSURLRequest * request=[[NSURLRequest alloc] initWithURL:url];
    [self.webView loadRequest:request];
}

#pragma mark WKNavigationDelegate
// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation{
    [self.loadingHelp dismiss];
}

// 当main frame开始加载数据失败时，会回调
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    [self.loadingHelp showError:@"加载失败"];
}

// 当main frame最后下载数据失败时，会回调
- (void)webView:(WKWebView *)webView didFailNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    [self.loadingHelp showError:@"加载失败"];
}

#pragma mark kvo
- (void)addSelfObserver{
    [self.webView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"title"])
    {
        NSLog(@"%@",[object valueForKey:@"title"]);
        if (!self.isTitleNoFlowWeb) {
            [self initTitle:[object valueForKey:@"title"]];
        }
    }
}

- (void)reload{
    [super reload];
    NSURL * url=[NSURL URLWithString:self.url];
    NSURLRequest * request=[[NSURLRequest alloc] initWithURL:url];
    [self.webView loadRequest:request];
}

- (void)dealloc{
    [self.webView removeObserver:self forKeyPath:@"title"];
}

@end
