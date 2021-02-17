//
//  BTPageLoadView.h
//  BTCoreExample
//
//  Created by apple on 2020/9/3.
//  Copyright © 2020 stonemover. All rights reserved.
//


/**
 使用方式
 self.pageLoadView = [[BTPageLoadView alloc] initWithFrame:self.view.bounds];
 self.pageLoadView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
 self.pageLoadView.delegate = self;
 [self.view addSubview:self.pageLoadView];
 
 */

#import <UIKit/UIKit.h>
#import <MJRefresh/MJRefresh.h>
#import <BTHelp/BTUtils.h>
#import <BTHelp/BTModel.h>
#import <BTLoading/BTToast.h>
#import <BTLoading/BTLoadingView.h>
#import <BTWidgetView/UIView+BTViewTool.h>
#import "BTCoreConfig.h"
#import "BTHttp.h"


@class BTPageLoadView;

NS_ASSUME_NONNULL_BEGIN

@protocol BTPageLoadViewDelegate <NSObject>

@required

//网络请求加载数据
- (void)BTPageLoadGetData:(BTPageLoadView*)loadView;



@optional

- (id<UITableViewDelegate>)BTPageLoadTableDelegate:(BTPageLoadView*)loadView;
- (id<UITableViewDataSource>)BTPageLoadTableDataSource:(BTPageLoadView*)loadView;

- (id<UICollectionViewDelegate>)BTPageLoadCollectionDelegate:(BTPageLoadView*)loadView;
- (id<UICollectionViewDataSource>)BTPageLoadCollectionDataSource:(BTPageLoadView*)loadView;

//自动化创建model的时候回调,如果你想计算cell的高度则可以实现此代理进行计算即可,会将转换后的model以及字典传回
- (void)BTPageLoadCreate:(BTPageLoadView*)loadView obj:(NSObject*)obj dict:(NSDictionary*)dict index:(NSInteger)index;

//MJFoot刷新距离底部的距离，适配iphonex,普通手机不会用到
- (CGFloat)BTPageLoadIgnoredContentInsetBottom:(BTPageLoadView*)loadView;


//获取array数组的方法回调，如果结构复杂则重写该方法然后返回数组字典即可
- (NSArray<NSDictionary*>*)BTPageLoadData:(BTPageLoadView*)loadView dataOri:(NSDictionary*)dataOri;

//下拉刷新的头部
- (MJRefreshHeader*)BTPageLoadRefreshHeader:(BTPageLoadView*)loadView;

//上拉加载的footer
- (MJRefreshFooter*)BTPageLoadRefreshFooter:(BTPageLoadView*)loadView;

//空数据Toast执行方法，需要自定义可重写方法
- (void)BTPageLoadEmptyDataToast;

@end

@interface BTPageLoadView : UIView

@property (nonatomic, weak) id<BTPageLoadViewDelegate> delegate;

//需要loading的情况下传入对应的对象即可,是关联vc里面的对象,而不是重新初始化一个
@property (nonatomic, strong, nullable) BTLoadingView * loadingHelp;

//tableview 对象需要通过initTableView方法生成
@property (nonatomic, strong, nullable ,readonly) UITableView * tableView;

//collectionView 需要通过initCollectionView生成
@property (nonatomic, strong, nullable ,readonly) UICollectionView * collectionView;

//上次刷新的时间key,如果不设置为当前类的名称
@property (nonatomic, strong, nullable) NSString * refreshTimeKey;

//当前分页下标数字
@property (nonatomic, assign, readonly) NSInteger pageNumber;

//数据加载完成的标记，当数组中的条数少于该值则认为加载完毕
@property (nonatomic, assign) NSInteger loadFinishDataNum;

//是否需要下拉加载
@property (nonatomic, assign) BOOL isNeedHeadRefresh;

//是否需要上拉刷新
@property (nonatomic, assign) BOOL isNeedFootRefresh;

//是否已经加载完成数据
@property (nonatomic, assign, readonly) BOOL isLoadFinish;

//是否是下拉刷新加载数据
@property (nonatomic, assign, readonly) BOOL isRefresh;

//数据源
@property (nonatomic, strong) NSMutableArray * dataArray;

//cellId 数组
@property (nonatomic, strong, nullable ,readonly) NSMutableArray * dataArrayCellId;

//数据为空的时候是否Toast提示
@property (nonatomic, assign) BOOL isToastWhenDataEmpty;

#pragma mark 初始化相关操作
- (void)initTableView:(NSArray<NSString*>*)cellNames;
- (void)initTableView:(NSArray<NSString*>*)cellNames isRegisgerNib:(BOOL)isRegisgerNib;
- (void)initTableView:(NSArray<NSString*>*)cellNames isRegisgerNib:(BOOL)isRegisgerNib style:(UITableViewStyle)style;
- (void)initTableView:(NSArray<NSString*>*)cellNames cellIdArray:(NSArray<NSString*>*)cellIdArray isRegisgerNib:(BOOL)isRegisgerNib style:(UITableViewStyle)style;

- (void)initCollectionView:(NSArray<NSString*>*)cellNames;
- (void)initCollectionView:(NSArray<NSString*>*)cellNames isRegisgerNib:(BOOL)isRegisgerNib;
- (void)initCollectionView:(NSArray<NSString*>*)cellNames isRegisgerNib:(BOOL)isRegisgerNib layout:(UICollectionViewFlowLayout*)layout;

- (void)setTableViewNoMoreEmptyLine;

#pragma mark 自动加载逻辑

//自定解析传入的model数据，dict:最外层的字典数据
- (void)autoLoad:(NSDictionary*)dict class:(Class)cla;

//成功传入数据自动解析
- (void)autoLoadSuccess:(NSArray*)dataDict class:(Class)cls;

//成功传入已经解析好的数组
- (void)autoLoadSuccess:(NSArray *)dataArray;

//服务器错误与网络错误提示，如果error不空则进入autoLoadNetError方法，反之进入autoLoadSeverError方法
- (void)autoLoadError:(NSError* _Nullable)error errorInfo:(NSString* _Nullable)errorInfo;

//服务器错误状态显示
- (void)autoLoadSeverError:(NSString*)errorInfo;

//网络错误状态显示
- (void)autoLoadNetError:(NSError*)error;



#pragma mark 刷新相关
- (void)startHeadRefresh;

- (void)endHeadRefresh;

- (void)endFootRefresh;


#pragma mark 相关辅助方法
//获取字符串类型的pageNumber
- (NSString*)pageNumStr;

//获取cell的Id
- (NSString* _Nullable)cellId:(NSInteger)index;

//获取当前第一个的cellID
- (NSString* _Nullable)cellId;

//删除列表数据为空的时候请求,每删除一条数据后调用
- (void)emptyGetData;

//恢复所有值到默认状态，然后请求数据
- (void)resetValueAndGetData;

//设置MJ刷新头部的主题颜色为白色
- (void)setRefreshHeadThemeWhite;

//去除系统contentInset
- (void)clearTableViewSystemInset;

//设置tableview弹性头部图片，把headView背景设置为透明
- (void)setTableViewBounceHeadImgView:(NSString *)imgName height:(CGFloat)height;

//当scrollView的代理滑动的时候调用如下方法，则可实现头部图片缩放功能
- (void)bt_scrollViewDidScroll:(UIScrollView*)scrollView;

@end

NS_ASSUME_NONNULL_END
