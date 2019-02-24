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



@interface BTPageLoadViewController : BTViewController

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

#pragma mark 初始化相关操作
- (void)initTableView:(NSArray<NSString*>*)cellNames;
- (void)initCollectionView:(NSArray<NSString*>*)cellNames;
- (void)setTableViewNoMoreEmptyLine;

#pragma mark 自动加载逻辑
- (void)autoLoadSuccess:(NSDictionary*)dict
                dataKey:(NSString*)dataKey
                infoKey:(NSString*)infoKey
                codeKey:(NSString*)codeKey
                  class:(Class)cla;

- (void)autoLoadSuccess:(NSDictionary*)dict class:(Class)cla;


- (void)autoLoadSuccess:(NSInteger)code
                   info:(NSString*)info
               dataDict:(NSArray*)dataDict
                  class:(Class)cls;
- (void)autoLoadNetError:(NSError*)error;


- (void)autoAnalyses:(NSArray<NSDictionary*>*)dataDict class:(Class)cla;


- (BOOL)autoCheckDataLoadFinish:(NSArray*)array;


#pragma mark 相关辅助方法
//获取字符串类型的pageNumber
- (NSString*)pageNumStr;
- (NSArray<NSDictionary*>*)pageLoadData:(NSDictionary*)dict;
- (NSArray<NSDictionary*>*)pageLoadData:(NSDictionary*)dict dataKey:(NSString*)dataKey;

#pragma mark 相关回调
//当进行自动解析创建modeld时候的回调，此时已经add进入数组
- (void)createModel:(NSObject*)model dict:(NSDictionary*)dict index:(NSInteger)index;
//所有逻辑进行完成
- (void)autoLoadFinish;

#pragma mark 刷新相关
- (void)startHeadRefresh;

- (void)endHeadRefresh;

- (void)endFootRefresh;

@end


