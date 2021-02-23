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
        [self bt_setNavLineColor:BTCoreConfig.share.defaultNavLineColor];
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
        [self bt_initTitle:self.webTitle];
    }
    [self inileftBarSelf];
    [self bt_setNavLineColor:self.webNavLineColor ? self.webNavLineColor : [UIColor bt_RGBSame:238]];
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
    
    UIBarButtonItem * backItem = [self bt_createItemImg:[UIImage imageNamed:@"nav_back"] action:@selector(bt_leftBarClick)];
    UIBarButtonItem * closeItem = [self bt_createItemImg:self.closeImg action:@selector(closeClick)];
    self.navigationItem.leftBarButtonItems = @[backItem,closeItem];
}

- (void)closeClick{
    [super bt_leftBarClick];
}

- (void)bt_leftBarClick{
    if (self.closeImg && self.webView.canGoBack) {
        [self.webView goBack];
    }else{
        [super bt_leftBarClick];
    }
    
}

- (void)initWebView{
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    self.webView = [[WKWebView alloc] initWithFrame:self.view.bounds configuration:config];
    self.webView.navigationDelegate=self;
    self.webView.UIDelegate=self;
    [[self.webView configuration].userContentController addScriptMessageHandler:self name:@"back"];
    for (NSString * function in self.jsFunctionArray) {
        [[self.webView configuration].userContentController addScriptMessageHandler:self name:function];
    }
    self.webView.autoresizingMask=UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    [self.view insertSubview:self.webView atIndex:0];
    
    [self.webView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
    if (self.loadingType == BTWebViewLoadingProgress) {
        [self initProgressView];
    }
    if (self.btWebInitFinish) {
        self.btWebInitFinish(self.webView);
    }
    NSURL * url=[NSURL URLWithString:self.url];
    NSURLRequest * request=[[NSURLRequest alloc] initWithURL:url];
    if(self.requestSetBlock){
        self.requestSetBlock(request);
    }
    [self.webView loadRequest:request];
}

- (void)initProgressView{
    self.progressView = [[BTProgressView alloc] initBTViewWithSize:CGSizeMake(BTUtils.SCREEN_W, 2)];
    self.progressView.backgroundColor = UIColor.clearColor;
    self.progressView.progressColor = self.progressViewColor ? self.progressViewColor : UIColor.redColor;
    [self.view addSubview:self.progressView];
    [self.webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    self.progressView.percent = 0.05;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        self.progressView.hidden = NO;
        self.progressView.percent = self.webView.estimatedProgress;
        if (self.progressView.percent == 1) {
            self.progressView.hidden = YES;
        }
    }
    
    if ([keyPath isEqualToString:@"title"])
    {
        NSLog(@"%@",[object valueForKey:@"title"]);
        if (self.isTitleFollowWeb) {
            [self bt_initTitle:[object valueForKey:@"title"]];
        }
    }
}

#pragma mark WKNavigationDelegate
//页面开始加载的时候
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation{
    if (self.loadingType == BTWebViewLoadingProgress) {
        self.progressView.hidden = NO;
    }
}

// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation{
    if (self.loadingType == BTWebViewLoadingDefault) {
        [self.loadingHelp dismiss];
    }else{
        self.progressView.hidden = YES;
    }
    if (self.btWebLoadSuccessBlock) {
        self.btWebLoadSuccessBlock(webView);
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
    [self bt_showAlert:@"提示" msg:message btns:@[@"确定"] block:^(NSInteger index) {
        completionHandler();
    }];
}


- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL))completionHandler{
    [self bt_showAlert:@"提示" msg:message btns:@[@"取消",@"确定"] block:^(NSInteger index) {
        completionHandler(index==1);
    }];
}


- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * _Nullable))completionHandler{
    [self bt_showAlertEdit:@"编辑" defaultValue:@"" placeHolder:@"请输入内容" block:^(NSString * _Nullable result) {
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
        [self bt_leftBarClick];
    }else{
        if (self.jsFunctionBlock) {
            self.jsFunctionBlock(message.name, message.body);
        }
    }
}

#pragma mark 解决https加载问题
- (void)webView:(WKWebView*)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge*)challenge completionHandler:(void(^)(NSURLSessionAuthChallengeDisposition,NSURLCredential*_Nullable))completionHandler{

   if([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]){

       NSURLCredential *card = [[NSURLCredential alloc] initWithTrust:challenge.protectionSpace.serverTrust];

       completionHandler(NSURLSessionAuthChallengeUseCredential,card);

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
    for (NSString * function in self.jsFunctionArray) {
        [self.webView.configuration.userContentController removeScriptMessageHandlerForName:function];
    }
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


#import <BTHelp/UIImage+BTImage.h>


@implementation UIViewController (BTNavSet)



- (UIBarButtonItem*)bt_createItemStr:(NSString*)title
                            color:(UIColor*)color
                             font:(UIFont*)font
                           target:(nullable id)target
                           action:(nullable SEL)action{
    UIBarButtonItem * item=[[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStylePlain target:target action:action];
    [item setTitleTextAttributes:@{NSFontAttributeName:font,NSForegroundColorAttributeName:color} forState:UIControlStateNormal];
    [item setTitleTextAttributes:@{NSFontAttributeName:font,NSForegroundColorAttributeName:color} forState:UIControlStateSelected];
    return item;
}

- (UIBarButtonItem*)bt_createItemStr:(NSString*)title
                           target:(nullable id)target
                           action:(nullable SEL)action{
    return [self bt_createItemStr:title color:BTCoreConfig.share.mainColor font:[UIFont systemFontOfSize:15 weight:UIFontWeightMedium] target:target action:action];
}

- (UIBarButtonItem*)bt_createItemStr:(NSString*)title
                           action:(nullable SEL)action{
    return [self bt_createItemStr:title color:BTCoreConfig.share.mainColor font:[UIFont systemFontOfSize:15 weight:UIFontWeightMedium] target:self action:action];
}

- (UIBarButtonItem*)bt_createItemImg:(UIImage*)img
                           action:(nullable SEL)action{
    return [[UIBarButtonItem alloc] initWithImage:img style:UIBarButtonItemStylePlain target:self action:action];
}

- (UIBarButtonItem*)bt_createItemImg:(UIImage*)img
                           target:(nullable id)target
                           action:(nullable SEL)action{
    return [[UIBarButtonItem alloc] initWithImage:img style:UIBarButtonItemStylePlain target:target action:action];
}


- (void)bt_initTitle:(NSString*)title color:(UIColor*)color font:(UIFont*)font{
    self.title=title;
    self.navigationController.navigationBar.titleTextAttributes=@{NSFontAttributeName:font,NSForegroundColorAttributeName:color} ;
}
- (void)bt_initTitle:(NSString *)title color:(UIColor *)color{
    [self bt_initTitle:title color:color font:[BTCoreConfig share].defaultNavTitleFont];
}
- (void)bt_initTitle:(NSString *)title{
    [self bt_initTitle:title color:[BTCoreConfig share].defaultNavTitleColor font:[BTCoreConfig share].defaultNavTitleFont];
}


- (UIBarButtonItem*)bt_initRightBarStr:(NSString*)title color:(UIColor*)color font:(UIFont*)font{
    UIBarButtonItem * item=[self bt_createItemStr:title color:color font:font target:self action:@selector(bt_rightBarClick)];
    [item setTitleTextAttributes:@{NSFontAttributeName:font,NSForegroundColorAttributeName:color} forState:UIControlStateNormal];
    [item setTitleTextAttributes:@{NSFontAttributeName:font,NSForegroundColorAttributeName:color} forState:UIControlStateSelected];
    self.navigationItem.rightBarButtonItem=item;
    return item;
}
- (UIBarButtonItem*)bt_initRightBarStr:(NSString*)title color:(UIColor*)color{
    return [self bt_initRightBarStr:title color:color font:[BTCoreConfig share].defaultNavRightBarItemFont];
}
- (UIBarButtonItem*)bt_initRightBarStr:(NSString*)title{
    return [self bt_initRightBarStr:title color:[BTCoreConfig share].defaultNavRightBarItemColor];
}
- (UIBarButtonItem*)bt_initRightBarImg:(UIImage*)img{
    UIBarButtonItem * item = [[UIBarButtonItem alloc] initWithImage:img style:UIBarButtonItemStylePlain target:self action:@selector(bt_rightBarClick)];
    self.navigationItem.rightBarButtonItem = item;
    return item;
}
- (void)bt_rightBarClick;{
    
}


- (UIBarButtonItem*)bt_initLeftBarStr:(NSString*)title color:(UIColor*)color font:(UIFont*)font{
    UIBarButtonItem * item = [self bt_createItemStr:title color:color font:font target:self action:@selector(bt_leftBarClick)];
    [item setTitleTextAttributes:@{NSFontAttributeName:font,NSForegroundColorAttributeName:color} forState:UIControlStateNormal];
    [item setTitleTextAttributes:@{NSFontAttributeName:font,NSForegroundColorAttributeName:color} forState:UIControlStateSelected];
    self.navigationItem.leftBarButtonItem = item;
    return item;
}
- (UIBarButtonItem*)bt_initLeftBarStr:(NSString*)title color:(UIColor*)color{
    return [self bt_initLeftBarStr:title color:color font:[BTCoreConfig share].defaultNavLeftBarItemFont];
}
- (UIBarButtonItem*)bt_initLeftBarStr:(NSString*)title{
    return [self bt_initLeftBarStr:title color:[BTCoreConfig share].defaultNavLeftBarItemColor];
}
- (UIBarButtonItem*)bt_initLeftBarImg:(UIImage*)img{
    UIBarButtonItem * item = [[UIBarButtonItem alloc] initWithImage:img style:UIBarButtonItemStylePlain target:self action:@selector(bt_leftBarClick)];
    self.navigationItem.leftBarButtonItem = item;
    return item;
}
- (void)bt_leftBarClick{
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSArray<UIView*>*)bt_initCustomeItem:(NavItemType)type str:(NSArray<NSString*>*)strs{
    NSMutableArray * btns = [NSMutableArray new];
    NSInteger index = 0;
    for (NSString * str in strs) {
        UIButton * btn = [UIButton new];
        [btn setTitleColor:[self bt_customeStrColor:type index:index] forState:UIControlStateNormal];
        btn.titleLabel.font = [self bt_customeFont:type index:index];
        [btn setTitle:str forState:UIControlStateNormal];
        [btns addObject:btn];
        index++;
    }
    return [self bt_initCustomeItem:type views:btns];
}

- (NSArray<UIView*>*)bt_initCustomeItem:(NavItemType)type img:(NSArray<UIImage*>*)imgs{
    NSMutableArray * btns = [NSMutableArray new];
    for (UIImage * img in imgs) {
        UIButton * btn = [UIButton new];
        [btn setImage:img forState:UIControlStateNormal];
        [btns addObject:btn];
    }
    return [self bt_initCustomeItem:type views:btns];
}

- (NSArray<UIView*>*)bt_initCustomeItem:(NavItemType)type views:(NSArray<UIView*>*)views{
    UIView * parentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, BTUtils.NAVCONTENT_HEIGHT)];
    CGFloat startX = 0;
    for (int i=0; i<views.count; i++) {
        UIView * childView = views[i];
        startX += [self bt_customePadding:type index:i];
        CGSize size = [self bt_customeItemSize:type index:i];
        childView.frame = CGRectMake(startX, (BTUtils.NAVCONTENT_HEIGHT - size.height) / 2, size.width, size.height);
        startX += size.width;
        [parentView addSubview:childView];
        UIButton * btn = nil;
        if ([childView isKindOfClass:[UIButton class]]) {
            btn = (UIButton*)childView;
        }else{
            btn = [[UIButton alloc] initWithFrame:childView.frame];
            [childView addSubview:btn];
        }
        btn.tag = i;
        if (type == NavItemTypeRight) {
            [btn addTarget:self action:@selector(bt_customeItemRightClick:) forControlEvents:UIControlEventTouchUpInside];
        }else if(type == NavItemTypeLeft){
            [btn addTarget:self action:@selector(bt_customeItemLeftClick:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    parentView.BTWidth = startX;
    UIBarButtonItem * item = [[UIBarButtonItem alloc] initWithCustomView:parentView];
    if (type == NavItemTypeRight) {
        self.navigationItem.rightBarButtonItem = item;
    }else if(type == NavItemTypeLeft){
        self.navigationItem.leftBarButtonItem = item;
    }
    return parentView.subviews;
}

- (CGSize)bt_customeItemSize:(NavItemType)type index:(NSInteger)index{
    return CGSizeMake(36, 44);
}
- (CGFloat)bt_customePadding:(NavItemType)type index:(NSInteger)index{
    return 0;
}

- (UIFont*)bt_customeFont:(NavItemType)type index:(NSInteger)index{
    if (type == NavItemTypeLeft) {
        return BTCoreConfig.share.defaultNavLeftBarItemFont;
    }
    return BTCoreConfig.share.defaultNavRightBarItemFont;
}

- (UIColor*)bt_customeStrColor:(NavItemType)type index:(NSInteger)index{
    if (type == NavItemTypeLeft) {
        return BTCoreConfig.share.defaultNavLeftBarItemColor;
    }
    return BTCoreConfig.share.defaultNavRightBarItemColor;
}

- (void)bt_customeItemLeftClick:(UIButton*)btn{
    [self bt_customeItemClick:NavItemTypeLeft index:btn.tag];
}

- (void)bt_customeItemRightClick:(UIButton*)btn{
    [self bt_customeItemClick:NavItemTypeRight index:btn.tag];
}

- (void)bt_customeItemClick:(NavItemType)type index:(NSInteger)index{
    
}

- (void)bt_setItemPaddingDefault{
    [self bt_setItemPadding:[self bt_NavItemPadding:NavItemTypeLeft]
            rightPadding:[self bt_NavItemPadding:NavItemTypeRight]];
}

- (void)bt_setItemPadding:(CGFloat)padding{
    [self bt_setItemPadding:padding rightPadding:padding];
}

- (void)bt_setItemPadding:(CGFloat)leftPadding rightPadding:(CGFloat)rightPadding{
    UINavigationBar * navBar=self.navigationController.navigationBar;
    if (@available(iOS 12.0, *)) {
        UIView * contentView = nil;
        for (UIView * view in navBar.subviews) {
            if ([NSStringFromClass(view.class) isEqualToString:@"_UINavigationBarContentView"]) {
                contentView = view;
                break;
            }
        }
        
        UILayoutGuide * backButtonGuide = nil;
        UILayoutGuide * trailingBarGuide = nil;
        
        for (UILayoutGuide * guide in contentView.layoutGuides) {
//            NSLog(@"%@",guide.identifier);
            if ([guide.identifier hasPrefix:@"BackButtonGuide"]) {
                backButtonGuide = guide;
            }
            
            if ([guide.identifier hasPrefix:@"TrailingBarGuide"]) {
                trailingBarGuide = guide;
            }
            
        }
        
        if (self.navigationItem.rightBarButtonItem || self.navigationItem.rightBarButtonItems) {
            NSArray * array = [trailingBarGuide constraintsAffectingLayoutForAxis:UILayoutConstraintAxisHorizontal];
            for (NSLayoutConstraint * c in array) {
                
                NSString * className = NSStringFromClass([c class]);
                if (BTCoreConfig.share.navItemPaddingBlock(c) && [className isEqualToString:@"NSLayoutConstraint"]) {
//                    NSLog(@"shuai:%@",c);
                    if (c.constant > 0) {
                        c.constant=rightPadding;
                    }else{
                        c.constant=-rightPadding;
                    }
                    break;
                }
            }
        }
        
        NSArray * array = [backButtonGuide constraintsAffectingLayoutForAxis:UILayoutConstraintAxisHorizontal];
        for (NSLayoutConstraint * c in array) {
//                NSLog(@"shuai:%@",c);
            NSString * className = NSStringFromClass([c class]);
            if (BTCoreConfig.share.navItemPaddingBlock(c) && [className isEqualToString:@"NSLayoutConstraint"]) {
                if (c.constant > 0) {
                    c.constant=leftPadding;
                }else{
                    c.constant=-leftPadding;
                }
                break;
            }
        }
        
        
        
        return;
    }
    
    for (UIView * view in navBar.subviews) {
        for (NSLayoutConstraint *c  in view.constraints) {
//            NSLog(@"%f",c.constant);
            if (BTCoreConfig.share.navItemPaddingBlock(c)) {
                if (c.constant > 0) {
                    c.constant=leftPadding;
                }else{
                    c.constant=-leftPadding;
                }
            }
        }
    }
}

- (void)bt_setNavTrans{
    self.navigationController.navigationBar.translucent = true;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage bt_imageWithColor:UIColor.clearColor] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    [self.navigationController.navigationBar setClipsToBounds:YES];
    self.navigationController.navigationBar.backgroundColor=UIColor.clearColor;
}

- (void)bt_setNavLineHide{
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
}

- (void)bt_setNavLineColor:(UIColor*)color{
    [self bt_setNavLineColor:color height:.5];
}

- (void)bt_setNavLineColor:(UIColor*)color height:(CGFloat)height{
    [self.navigationController.navigationBar setShadowImage:[UIImage bt_imageWithColor:color size:CGSizeMake([UIScreen mainScreen].bounds.size.width, height)]];
}

- (UIBarButtonItem *)rt_customBackItemWithTarget:(id)target action:(SEL)action{
    [self bt_setItemPaddingDefault];
    UIBarButtonItem * item = [self bt_createItemImg:[UIImage imageNamed:@"nav_back"] action:@selector(bt_leftBarClick)];
    return item;
}



- (CGFloat)bt_NavItemPadding:(NavItemType)type{
    return BTCoreConfig.share.navItemPadding;
}


@end




@implementation UIViewController (BTDialog)

- (NSDictionary*)bt_createBtnDict:(NSString*)title color:(UIColor*)color{
    return [self bt_createBtnDict:title color:color style:UIAlertActionStyleDefault];
}

- (NSDictionary*)bt_createBtnDict:(NSString*)title color:(UIColor*)color style:(UIAlertActionStyle)style{
    return @{@"title":title,@"color":color,@"style":[NSNumber numberWithInteger:style]};
}

- (UIAlertController*)bt_createAlert:(NSString*)title
                                 msg:(NSString*)msg
                              action:(NSArray*)action
                               style:(UIAlertControllerStyle)style{
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:title message:msg preferredStyle:style];
    for (UIAlertAction * a in action) {
        [alertController addAction:a];
    }
    return alertController;
}

- (UIAlertAction*)bt_action:(NSString*)str
                      style:(UIAlertActionStyle)style
                    handler:(void (^ __nullable)(UIAlertAction *action))handler{
    return [UIAlertAction actionWithTitle:str
                                    style:style
                                  handler:handler];
}

- (UIAlertAction*_Nonnull)bt_action:(NSString*_Nullable)str
                              style:(UIAlertActionStyle)style
                              color:(UIColor*)color
                            handler:(void (^ __nullable)(UIAlertAction * _Nullable action))handler{
    UIAlertAction * action = [UIAlertAction actionWithTitle:str
                                                      style:style
                                                    handler:handler];
    [action setValue:color forKey:@"titleTextColor"];
    return action;
}


- (UIAlertController*_Nonnull)bt_showAlert:(NSString*)title
                                       msg:(NSString*)msg
                                      btns:(NSArray*)btns
                                     block:(BTDialogBlock)block{
    NSMutableArray * actions=[NSMutableArray new];
    for (int i=0; i<btns.count; i++) {
        NSString * str=btns[i];
        UIAlertAction * action =nil;
        if (btns.count==2) {
            if (i==0) {
                action=[self bt_action:str style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                    NSInteger index=[actions indexOfObject:action];
                    block(index);
                }];
            }else{
                action=[self bt_action:str style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                    NSInteger index=[actions indexOfObject:action];
                    block(index);
                }];
            }
        }else{
            if (i==btns.count-1) {
                action=[self bt_action:str style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                    NSInteger index=[actions indexOfObject:action];
                    block(index);
                }];
            }else{
                action=[self bt_action:str style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                    NSInteger index=[actions indexOfObject:action];
                    block(index);
                }];
            }
            
        }
        [actions addObject:action];
    }
    UIAlertController * controller=[self bt_createAlert:title msg:msg action:actions style:UIAlertControllerStyleAlert];
    dispatch_async(dispatch_get_main_queue(), ^(void){
        [self presentViewController:controller animated:YES completion:nil];
    });
    return controller;
}

- (UIAlertController*_Nonnull)bt_showAlert:(NSString*_Nonnull)title
                                       msg:(NSString*_Nullable)msg
                                  btnDicts:(NSArray*_Nullable)btnDicts
                                     block:(BTDialogBlock _Nullable )block{
    NSMutableArray * actions=[NSMutableArray new];
    for (int i=0; i<btnDicts.count; i++) {
        NSDictionary * dict=btnDicts[i];
        NSString * title = dict[@"title"];
        UIColor * color = dict[@"color"];
        NSNumber * style = dict[@"style"];
        UIAlertAction * action =nil;
        action=[self bt_action:title style:style.integerValue color: color handler:^(UIAlertAction *action) {
            NSInteger index=[actions indexOfObject:action];
            block(index);
        }];
        
        [actions addObject:action];
    }
    UIAlertController * controller=[self bt_createAlert:title msg:msg action:actions style:UIAlertControllerStyleAlert];
    dispatch_async(dispatch_get_main_queue(), ^(void){
        [self presentViewController:controller animated:YES completion:nil];
    });
    return controller;
}



- (UIAlertController*_Nonnull)bt_showAlertDefault:(NSString*)title
                                              msg:(NSString*)msg
                                            block:(BTDialogBlock)block{
    UIAlertAction * actionCancel=[self bt_action:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        block(0);
    }];
    UIAlertAction * actionOk=[self bt_action:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        block(1);
    }];
    UIAlertController * alertController=[self bt_createAlert:title msg:msg action:@[actionCancel,actionOk] style:UIAlertControllerStyleAlert];
    dispatch_async(dispatch_get_main_queue(), ^(void){
        [self presentViewController:alertController animated:YES completion:nil];
    });
    return alertController;
}

- (UIAlertController*_Nonnull)bt_showActionSheet:(NSString*)title
                                             msg:(NSString*)msg
                                            btns:(NSArray*)btns
                                           block:(BTDialogBlock)block{
    NSMutableArray * dataArray=[NSMutableArray new];
    for (NSString * btn in btns) {
        UIAlertAction * action=[self bt_action:btn style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            block([dataArray indexOfObject:action]);
        }];
        if ([BTCoreConfig share].actionColor) {
            [action setValue:[BTCoreConfig share].actionColor forKey:@"titleTextColor"];
        }
        
        [dataArray addObject:action];
    }
    
    UIAlertAction * action=[self bt_action:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        block(dataArray.count-1);
    }];
    
    if ([BTCoreConfig share].actionCancelColor) {
        [action setValue:[BTCoreConfig share].actionCancelColor forKey:@"titleTextColor"];
    }
    
    [dataArray addObject:action];
    UIAlertController * alertController=[self bt_createAlert:title msg:msg action:dataArray style:UIAlertControllerStyleActionSheet];
    
    dispatch_async(dispatch_get_main_queue(), ^(void){
        [self presentViewController:alertController animated:YES completion:nil];
    });
    return alertController;
}

- (UIAlertController*_Nonnull)bt_showActionSheet:(NSString*_Nullable)title
                                             msg:(NSString*_Nullable)msg
                                        btnDicts:(NSArray*_Nullable)btnDicts
                                           block:(BTDialogBlock _Nullable )block{
    NSMutableArray * dataArray=[NSMutableArray new];
    for (NSDictionary * dict in btnDicts) {
        NSString * title = dict[@"title"];
        UIColor * color = dict[@"color"];
        NSNumber * style = dict[@"style"];
        UIAlertAction * action=[self bt_action:title style:style.integerValue color:color handler:^(UIAlertAction *action) {
            block([dataArray indexOfObject:action]);
        }];
        [dataArray addObject:action];
    }
    
    UIAlertController * alertController=[self bt_createAlert:title msg:msg action:dataArray style:UIAlertControllerStyleActionSheet];
    
    dispatch_async(dispatch_get_main_queue(), ^(void){
        [self presentViewController:alertController animated:YES completion:nil];
    });
    return alertController;
}

- (UIAlertController*_Nonnull)bt_showAlertEdit:(NSString*)title
                                  defaultValue:(NSString*)value
                                   placeHolder:(NSString*)placeHolder
                                         block:(void(^)(NSString * result))block{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title
                                                                             message:@""
                                                                      preferredStyle:(UIAlertControllerStyleAlert)];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder =placeHolder;
        textField.returnKeyType=UIReturnKeyDone;
        textField.text=value;
        textField.clearButtonMode=UITextFieldViewModeWhileEditing;
    }];
    
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction *action) {
        
    }];
    //    [cancelAction setValue:BT_MAIN_COLOR forKey:@"_titleTextColor"];
    [alertController addAction:cancelAction];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction *action) {
        //获得文本框
        UITextField * field = alertController.textFields.firstObject;
        NSString * text=field.text;
        block(text);
    }];
    //    [okAction setValue:BT_MAIN_COLOR forKey:@"_titleTextColor"];
    [alertController addAction:okAction];
    dispatch_async(dispatch_get_main_queue(), ^(void){
        [self presentViewController:alertController animated:YES completion:nil];
    });
    return alertController;
}


- (UIAlertController*_Nonnull)bt_showAlertEdit:(NSString*_Nullable)title
                                  defaultValue:(NSString*_Nullable)value
                                   placeHolder:(NSString*_Nullable)placeHolder
                                      btnDicts:(NSArray*_Nullable)btnDicts
                                         block:(void(^_Nullable)(NSString * _Nullable result))block{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title
                                                                             message:@""
                                                                      preferredStyle:(UIAlertControllerStyleAlert)];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder =placeHolder;
        textField.returnKeyType=UIReturnKeyDone;
        textField.text=value;
        textField.clearButtonMode=UITextFieldViewModeWhileEditing;
    }];
    
    if ([btnDicts.firstObject isKindOfClass:[NSString class]]) {
        UIAlertAction *cancelAction = [self bt_action:btnDicts.firstObject style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nullable action) {
            
        }];
        [alertController addAction:cancelAction];
    }else{
        NSDictionary * dict = btnDicts.firstObject;
        NSString * title = dict[@"title"];
        UIColor * color = dict[@"color"];
        NSNumber * style = dict[@"style"];
        UIAlertAction *cancelAction = [self bt_action:title style:style.integerValue color:color handler:^(UIAlertAction *action) {
            
        }];

        [alertController addAction:cancelAction];
    }
    
    if ([btnDicts.lastObject isKindOfClass:[NSString class]]) {
        UIAlertAction *okAction = [self bt_action:btnDicts.lastObject style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nullable action) {
            //获得文本框
            UITextField * field = alertController.textFields.firstObject;
            NSString * text=field.text;
            block(text);
        }];
        [alertController addAction:okAction];
    }else{
        NSDictionary * dict = btnDicts.lastObject;
        NSString * title = dict[@"title"];
        UIColor * color = dict[@"color"];
        NSNumber * style = dict[@"style"];
        UIAlertAction *okAction = [self bt_action:title style:style.integerValue color:color handler:^(UIAlertAction *action) {
            //获得文本框
            UITextField * field = alertController.textFields.firstObject;
            NSString * text=field.text;
            block(text);
        }];

        [alertController addAction:okAction];
    }
    dispatch_async(dispatch_get_main_queue(), ^(void){
        [self presentViewController:alertController animated:YES completion:nil];
    });
    return alertController;
}

@end

