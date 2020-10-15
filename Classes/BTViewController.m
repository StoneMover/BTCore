//
//  BTViewController.m
//  moneyMaker
//
//  Created by stonemover on 2019/1/22.
//  Copyright © 2019 stonemover. All rights reserved.
//

#import "BTViewController.h"
#import <WebKit/WebKit.h>
#import <BTWidgetView/BTProgressView.h>


@implementation BTViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.isTouceViewEndCloseKeyBoard=YES;
    if (BTCoreConfig.share.defaultNavLineColor) {
        [self setNavLineColor:BTCoreConfig.share.defaultNavLineColor];
    }
    
    if (BTCoreConfig.share.defaultVCBgColor) {
        self.view.backgroundColor = BTCoreConfig.share.defaultVCBgColor;
    }
}

#pragma mark 生命周期
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.viewWillAppearIndex++;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (self.viewDidAppearIndex==0) {
        [self viewDidAppearFirst];
    }
    self.viewDidAppearIndex++;
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

- (void)viewDidAppearFirst{
    
}

#pragma mark loading
- (void)getData{
    
}

- (void)bt_loadingReload{
    [super bt_loadingReload];
    [self getData];
}




@end


@implementation BTNavigationController

- (void)viewDidLoad {
    self.transferNavigationBarAttributes = true;
    self.useSystemBackBarButtonItem = false;
    [super viewDidLoad];
    self.navigationBar.translucent = false;
    self.navigationBar.tintColor=UIColor.blackColor;
    self.navigationBar.barTintColor = UIColor.whiteColor;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/



- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.childViewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    [super pushViewController:viewController animated:animated];
    
    
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    
}

//- (void)_layoutViewController:(NSObject*)obj{
//    //    [super layoutViewController];
//}





@end



@interface BTWebViewController ()<WKNavigationDelegate,WKUIDelegate,WKScriptMessageHandler>

@property (nonatomic, strong) WKWebView * webView;

@property (nonatomic, strong) BTProgressView * progressView;

@end

@implementation BTWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    if (self.webTitle) {
        [self initTitle:self.webTitle];
    }
    [self inileftBarSelf];
    [self setNavLineColor:[UIColor bt_RGBSame:238]];
    if (self.loadingType == BTWebViewLoadingDefault) {
        [self bt_initLoading];
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.35 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //先让loading界面加载完成，由于初始化webView很耗时间
        [self initWebView];
        
    });
}

- (void)inileftBarSelf{
    if (!self.closeImg) {
        return;
    }
    
    UIBarButtonItem * backItem = [self createItemImg:[UIImage imageNamed:@"nav_back"] action:@selector(leftBarClick)];
    UIBarButtonItem * closeItem = [self createItemImg:self.closeImg action:@selector(closeClick)];
    self.navigationItem.leftBarButtonItems = @[backItem,closeItem];
}

- (void)closeClick{
    [super leftBarClick];
}

- (void)leftBarClick{
    if (self.closeImg && self.webView.canGoBack) {
        [self.webView goBack];
    }else{
        [super leftBarClick];
    }
    
}

- (void)initWebView{
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    self.webView = [[WKWebView alloc] initWithFrame:self.view.bounds configuration:config];
    self.webView.navigationDelegate=self;
    self.webView.UIDelegate=self;
    [[self.webView configuration].userContentController addScriptMessageHandler:self name:@"back"];
    self.webView.autoresizingMask=UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    [self.view insertSubview:self.webView atIndex:0];
    
    [self.webView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
    if (self.loadingType == BTWebViewLoadingProgress) {
        [self initProgressView];
    }
    NSURL * url=[NSURL URLWithString:self.url];
    NSURLRequest * request=[[NSURLRequest alloc] initWithURL:url];
    [self.webView loadRequest:request];
}

- (void)initProgressView{
    self.progressView = [[BTProgressView alloc] initBTViewWithSize:CGSizeMake(BTUtils.SCREEN_W, 2)];
    self.progressView.backgroundColor = UIColor.clearColor;
    self.progressView.progressView.backgroundColor = self.progressViewColor ? self.progressViewColor : UIColor.redColor;
    [self.view addSubview:self.progressView];
    [self.webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    self.progressView.percent = 0.05;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        self.progressView.hidden = NO;
        self.progressView.percent = self.webView.estimatedProgress;
    }
    
    if ([keyPath isEqualToString:@"title"])
    {
        NSLog(@"%@",[object valueForKey:@"title"]);
        if (self.isTitleFollowWeb) {
            [self initTitle:[object valueForKey:@"title"]];
        }
    }
}

#pragma mark WKNavigationDelegate
// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation{
    if (self.loadingType == BTWebViewLoadingDefault) {
        [self.loadingHelp dismiss];
    }else{
        self.progressView.hidden = YES;
    }
    
}

// 当main frame开始加载数据失败时，会回调
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    if (self.loadingType == BTWebViewLoadingDefault) {
        [self.loadingHelp showError:@"加载失败"];
    }else{
        self.progressView.hidden = YES;
    }
    
}

// 当main frame最后下载数据失败时，会回调
- (void)webView:(WKWebView *)webView didFailNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    if (self.loadingType == BTWebViewLoadingDefault) {
        [self.loadingHelp showError:@"加载失败"];
    }else{
        self.progressView.hidden = YES;
    }
    
}

#pragma mark WKUIDelegate
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler{
    [self showAlert:@"提示" msg:message btns:@[@"确定"] block:^(NSInteger index) {
        completionHandler();
    }];
}


- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL))completionHandler{
    [self showAlert:@"提示" msg:message btns:@[@"取消",@"确定"] block:^(NSInteger index) {
        completionHandler(index==1);
    }];
}


- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * _Nullable))completionHandler{
    [self showAlertEdit:@"编辑" defaultValue:@"" placeHolder:@"请输入内容" block:^(NSString * _Nullable result) {
        if (!result) {
            completionHandler(@"");
        }else{
            completionHandler(result);
        }
    }];
}

#pragma mark WKScriptMessageHandler
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    //message.name  方法名
    //message.body  参数值
    if ([message.name isEqualToString:@"back"]) {
        [self leftBarClick];
    }
}

#pragma mark kvo

- (void)bt_loadingReload{
    [super bt_loadingReload];
    NSURL * url=[NSURL URLWithString:self.url];
    NSURLRequest * request=[[NSURLRequest alloc] initWithURL:url];
    [self.webView loadRequest:request];
}

- (void)dealloc{
    [self.webView.configuration.userContentController removeScriptMessageHandlerForName:@"back"];
    [self.webView removeObserver:self forKeyPath:@"title"];
    if (self.loadingType == BTWebViewLoadingProgress) {
        [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
    }
}

@end



@implementation BTPageLoadViewController


- (void)viewDidLoad{
    [super viewDidLoad];
    _pageLoadView = [[BTPageLoadView alloc] initWithFrame:self.view.bounds];
    self.pageLoadView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.pageLoadView.delegate = self;
    self.pageLoadView.refreshTimeKey = NSStringFromClass([self class]);
    [self.view addSubview:self.pageLoadView];
}

//MARK:BTPageLoadViewDelegate
- (void)BTPageLoadGetData:(BTPageLoadView*)loadView{
    [self getData];
}

- (void)setLayoutFromStatusBar{
    self.edgesForExtendedLayout = UIRectEdgeAll;
    if (@available(iOS 13.0, *)) {
        self.pageLoadView.tableView.automaticallyAdjustsScrollIndicatorInsets = NO;
    }
    self.extendedLayoutIncludesOpaqueBars = YES;
}

@end
