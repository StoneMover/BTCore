//
//  BTPageLoadViewController.h
//  moneyMaker
//
//  Created by stonemover on 2019/1/22.
//  Copyright © 2019 stonemover. All rights reserved.
//

#import "BTViewController.h"
#import <MJRefresh/MJRefresh.h>

//NSString * const BT_PAGE_LOAD_CODE=@"code";
//const NSString * BT_PAGE_LOAD_DATA=@"data";
//const NSString * BT_PAGE_LOAD_INFO=@"info";



@interface BTPageLoadViewController : BTViewController<UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) UITableView * tableView;

@property (nonatomic, strong) UICollectionView * collectionView;

//上次刷新的时间key
@property (nonatomic, strong) NSString * refreshTimeKey;

//当前分页标记
@property (nonatomic, assign) NSInteger pageNumber;

//数据加载完成的标记，默认15条，当一页数据小于15的时候认定为加载完成
@property (nonatomic, assign) NSInteger loadFinishDataNum;

//是否需要下拉加载
@property (nonatomic, assign) BOOL isNeedHeadRefresh;

//是否需要上拉刷新
@property (nonatomic, assign) BOOL isNeedFootRefresh;

//是否已经加载完成数据
@property (nonatomic, assign) BOOL isLoadFinish;

//是否是下拉刷新加载数据
@property (nonatomic, assign) BOOL isRefresh;

//数据源
@property (nonatomic, strong) NSMutableArray * dataArray;

//cellId 数组
@property (nonatomic, strong) NSMutableArray * dataArrayCellId;

#pragma mark 初始化相关操作
- (void)initTableView:(NSArray<NSString*>*)cellNames;
- (void)initCollectionView:(NSArray<NSString*>*)cellNames;
- (void)setTableViewNoMoreEmptyLine;

#pragma mark 自动加载逻辑
//自定解析传入的model数据，dict:最外层的字典数据，dataKey:数组对应的key，infoKey:服务器状态描述key，codeKey状态码key
- (void)autoLoad:(NSDictionary*)dict
         dataKey:(NSString*)dataKey
         infoKey:(NSString*)infoKey
         codeKey:(NSString*)codeKey
           class:(Class)cla;

//自定解析传入的model数据，dict:最外层的字典数据
- (void)autoLoad:(NSDictionary*)dict class:(Class)cla;

//成功传入数据自动解析
- (void)autoLoadSuccess:(NSArray*)dataDict class:(Class)cls;

//服务器错误与网络错误提示，如果error不空则进入autoLoadNetError方法，反之进入autoLoadSeverError方法
- (void)autoLoadError:(NSError*)error errorInfo:(NSString*)errorInfo;

//服务器错误状态显示
- (void)autoLoadSeverError:(NSString*)errorInfo;

//网络错误状态显示
- (void)autoLoadNetError:(NSError*)error;

//自动解析model
- (void)autoAnalyses:(NSArray<NSDictionary*>*)dataDict class:(Class)cla;

//自动结束状态判断
- (BOOL)autoCheckDataLoadFinish:(NSArray*)array;


#pragma mark 相关回调
//当进行自动解析创建modeld时候的回调，此时已经add进入数组
- (void)createModel:(NSObject*)model dict:(NSDictionary*)dict index:(NSInteger)index;


#pragma mark 刷新相关
- (void)startHeadRefresh;

- (void)endHeadRefresh;

- (void)endFootRefresh;


#pragma mark 相关辅助方法
//获取字符串类型的pageNumber
- (NSString*)pageNumStr;

//获取array数组的方法回调，如果结构复杂则重写该方法然后返回数组字典即可
- (NSArray<NSDictionary*>*)pageLoadData:(NSDictionary*)dict;

//获取cell的Id
- (NSString*)cellId:(NSInteger)index;

//获取当前第一个的cellID
- (NSString*)cellId;

//删除列表数据为空的时候请求,每删除一条数据后调用
- (void)emptyGetData;

//恢复所有值到默认状态，然后请求数据
- (void)resetValueAndGetData;

//设置MJ刷新头部的主题颜色
- (void)setRefreshHeadThemeColor:(UIColor *)color;

@end


