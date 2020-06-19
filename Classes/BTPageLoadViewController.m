//
//  BTPageLoadViewController.m
//  moneyMaker
//
//  Created by stonemover on 2019/1/22.
//  Copyright © 2019 stonemover. All rights reserved.
//

#import "BTPageLoadViewController.h"
#import "MJRefresh.h"
#import <BTHelp/BTUtils.h>
#import "BTModel.h"
#import "BTCoreConfig.h"
#import "BTNet.h"

@interface BTPageLoadViewController ()

@property (nonatomic, weak) UIScrollView * scrollView;

@end

@implementation BTPageLoadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.loadFinishDataNum=[BTCoreConfig share].pageLoadSizePage;
    self.pageNumber=[BTCoreConfig share].pageLoadStartPage;
}

#pragma mark 初始化相关操作
- (void)initTableView:(NSArray<NSString*>*)cellNames{
    [self initTableView:cellNames isRegisgerNib:YES];
}
- (void)initTableView:(NSArray<NSString*>*)cellNames isRegisgerNib:(BOOL)isRegisgerNib{
    self.tableView.frame=self.view.bounds;
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.dataArrayCellId=[NSMutableArray new];
    for (NSString * cellName in cellNames) {
        NSString * cellId = [NSString stringWithFormat:@"%@Id",cellName];
        [self.dataArrayCellId addObject:cellId];
        if (isRegisgerNib) {
            UINib * nib = [UINib nibWithNibName:cellName bundle:nil];
            [self.tableView registerNib:nib forCellReuseIdentifier:cellId];
        }else{
            [self.tableView registerClass:NSClassFromString(cellName) forCellReuseIdentifier:cellId];
        }
    }
    
    [self.view addSubview:self.tableView];
    self.scrollView=self.tableView;
}

- (UITableView*)tableView{
    if (!_tableView) {
        _tableView=[[UITableView alloc] init];
    }
    
    return _tableView;
}

- (void)initCollectionView:(NSArray<NSString*>*)cellNames{
    [self initCollectionView:cellNames isRegisgerNib:YES];
}

- (void)initCollectionView:(NSArray<NSString*>*)cellNames isRegisgerNib:(BOOL)isRegisgerNib{
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    self.collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.dataArrayCellId=[NSMutableArray new];
    for (NSString * cellName in cellNames) {
        NSString * cellId = [NSString stringWithFormat:@"%@Id",cellName];
        [self.dataArrayCellId addObject:cellId];
        if (isRegisgerNib) {
            UINib * nib = [UINib nibWithNibName:cellName bundle:nil];
            [self.collectionView registerNib:nib forCellWithReuseIdentifier:cellId];
        }else{
            [self.collectionView registerClass:NSClassFromString(cellName) forCellWithReuseIdentifier:cellId];
        }
        
    }
    
    
    self.collectionView.delegate=self;
    self.collectionView.dataSource=self;
    [self.view addSubview:self.collectionView];
    self.scrollView=self.collectionView;
}

- (void)setTableViewNoMoreEmptyLine{
    [self.tableView setTableFooterView:[[UIView alloc]initWithFrame:CGRectZero]];
}

#pragma mark 自动加载逻辑
- (void)autoLoad:(NSDictionary*)dict class:(Class)cla{
    if ([BTNet isSuccess:dict]) {
        NSArray * array=[self pageLoadData:dict];
        [self autoLoadSuccess:array class:cla];
    }else{
        [self autoLoadSeverError:[BTNet errorInfo:dict]];
    }
}

- (void)autoLoadSuccess:(NSArray*)dataDict class:(Class)cls{
    [self endHeadRefresh];
    [self endFootRefresh];
    if (self.isRefresh) {
        [self.dataArray removeAllObjects];
        self.isRefresh=NO;
    }
    
    [self autoAnalyses:dataDict class:cls];
    if (self.pageNumber==[BTCoreConfig share].pageLoadStartPage) {
        if (self.loadingHelp) {
            if(dataDict.count==0){
                [self bt_showEmpty];
                self.pageNumber--;
            }else{
                [self bt_loadingDismiss];
            }
        }else{
            if(dataDict.count==0){
                self.pageNumber--;
                [BTToast show:@"暂无数据"];
            }
        }
    }
    self.isLoadFinish=[self autoCheckDataLoadFinish:dataDict];
    self.pageNumber++;
    if (self.tableView) {
        [self.tableView reloadData];
    }
    if (self.collectionView) {
        [self.collectionView reloadData];
    }
}

- (void)autoLoadSuccess:(NSArray *)dataArray{
    [self endHeadRefresh];
    [self endFootRefresh];
    if (self.isRefresh) {
        [self.dataArray removeAllObjects];
        self.isRefresh=NO;
    }
    
    [self.dataArray addObjectsFromArray:dataArray];
    if (self.pageNumber==[BTCoreConfig share].pageLoadStartPage) {
        if (self.loadingHelp) {
            if(dataArray.count==0){
                [self bt_showEmpty];
                self.pageNumber--;
            }else{
                [self bt_loadingDismiss];
            }
        }else{
            if(dataArray.count==0){
                self.pageNumber--;
                [BTToast show:@"暂无数据"];
            }
        }
    }
    self.isLoadFinish=[self autoCheckDataLoadFinish:dataArray];
    self.pageNumber++;
    if (self.tableView) {
        [self.tableView reloadData];
    }
    if (self.collectionView) {
        [self.collectionView reloadData];
    }
}

- (void)autoLoadError:(NSError*)error errorInfo:(NSString*)errorInfo{
    if (error) {
        [self autoLoadNetError:error];
    }else{
        [self autoLoadSeverError:errorInfo];
    }
}

- (void)autoLoadSeverError:(NSString*)errorInfo{
    [self endHeadRefresh];
    [self endFootRefresh];
    if (self.pageNumber==[BTCoreConfig share].pageLoadStartPage&&self.loadingHelp&&!self.isRefresh) {
        //当数据请求为第一页的时候,并且挡板已经初始化,并且不是刷新状态的时候,给出挡板的错误提示
        [self.loadingHelp showError:errorInfo];
        return;
    }
    self.isRefresh=NO;
    [BTToast showErrorInfo:errorInfo];
}

- (void)autoLoadNetError:(NSError*)error{
    [self endHeadRefresh];
    [self endFootRefresh];
    NSString * info=nil;
    if ([error.userInfo.allKeys containsObject:@"NSLocalizedDescription"]) {
        info=[error.userInfo objectForKey:@"NSLocalizedDescription"];
    }else {
        info=error.domain;
    }
    self.isRefresh=NO;
    if (self.pageNumber==[BTCoreConfig share].pageLoadStartPage&&self.loadingHelp&&!self.isRefresh) {
        //当数据请求为第一页的时候,并且挡板已经初始化,并且不是刷新状态的时候,给出挡板的错误提示
        [self.loadingHelp showError:info];
        return;
    }
    
    [BTToast showErrorInfo:info];
}

- (void)autoAnalyses:(NSArray<NSDictionary*>*)dataDict class:(Class)cla{
    NSInteger index=0;
    for (NSDictionary * dict in dataDict) {
        BTModel * modelChild=[[cla alloc]init];
        [modelChild analisys:dict];
        [self createModel:modelChild dict:dict index:index];
        [self.dataArray addObject:modelChild];
        index++;
    }
}

- (BOOL)autoCheckDataLoadFinish:(NSArray*)array{
    if (array.count<self.loadFinishDataNum) {
        
        return YES;
    }
    return NO;
}

- (void)setIsLoadFinish:(BOOL)isLoadFinish{
    if (isLoadFinish==_isLoadFinish) {
        return;
    }
    _isLoadFinish=isLoadFinish;
    if (isLoadFinish) {
        //由于刷新结束需要0.4s的动画，所以延时后才能保证状态正确
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.scrollView.mj_footer endRefreshingWithNoMoreData];
        });
    }else{
        [self.scrollView.mj_footer resetNoMoreData];
    }
}

#pragma mark 相关回调
- (void)createModel:(NSObject*)model dict:(NSDictionary*)dict index:(NSInteger)index{
    
}



#pragma mark 刷新相关
- (void)setIsNeedHeadRefresh:(BOOL)isNeedHeadRefresh{
    if (_isNeedHeadRefresh!=isNeedHeadRefresh) {
        _isNeedHeadRefresh=isNeedHeadRefresh;
        if (isNeedHeadRefresh) {
            __weak BTPageLoadViewController * weakSelf=self;
            self.scrollView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
                [weakSelf headRefreshLoad];
            }];
            self.scrollView.mj_header.lastUpdatedTimeKey=self.refreshTimeKey?self.refreshTimeKey:NSStringFromClass([self class]);
            self.scrollView.mj_header.ignoredScrollViewContentInsetTop=self.scrollView.contentInset.top;
        }else{
            if (self.scrollView.mj_header){
                [self.scrollView.mj_header setHidden:true];
            }
        }
    }
}

- (void)setIsNeedFootRefresh:(BOOL)isNeedFootRefresh{
    if (_isNeedFootRefresh!=isNeedFootRefresh) {
        _isNeedFootRefresh=isNeedFootRefresh;
        if (isNeedFootRefresh) {
            __weak BTPageLoadViewController * weakSelf=self;
            self.scrollView.mj_footer=[MJRefreshBackNormalFooter
                                       footerWithRefreshingBlock:^{
                                           [weakSelf footRefreshLoad];
                                       }];
            if (BTUtils.UI_IS_IPHONEX) {
                self.scrollView.mj_footer.ignoredScrollViewContentInsetBottom=[self mjFootIgnoredScrollViewContentInsetBottom];
            }
            
        }else{
            if (self.scrollView.mj_footer) {
                self.scrollView.mj_footer.hidden=YES;
            }
        }
    }
    
}

- (void)startHeadRefresh{
    if (self.scrollView.mj_header) {
        [self.scrollView.mj_header beginRefreshing];
    }
}

- (void)endHeadRefresh{
    if (self.scrollView.mj_header) {
        [self.scrollView.mj_header endRefreshing];
    }
}

- (void)endFootRefresh{
    if (self.scrollView.mj_footer) {
        [self.scrollView.mj_footer endRefreshing];
    }
}

- (void)headRefreshLoad{
    self.pageNumber=[BTCoreConfig share].pageLoadStartPage;
    self.isLoadFinish=NO;
    self.isRefresh=YES;
    [self getData];
}
- (void)footRefreshLoad{
    [self getData];
}

#pragma mark 相关辅助方法
- (NSMutableArray*)dataArray{
    if (_dataArray==nil) {
        _dataArray=[NSMutableArray new];
    }
    
    return _dataArray;
}

- (NSString*)pageNumStr{
    return [NSString stringWithFormat:@"%ld",self.pageNumber];
}

- (NSArray<NSDictionary*>*)pageLoadData:(NSDictionary*)dict{
    return [BTNet defaultDictArray:dict];
}




- (NSString*)cellId:(NSInteger)index{
    if (self.dataArrayCellId&&index<self.dataArrayCellId.count) {
        return self.dataArrayCellId[index];
    }
    
    return nil;
}

- (NSString*)cellId{
    return [self cellId:0];
}

- (void)emptyGetData{
    if (self.dataArray.count==0) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.isLoadFinish=NO;
            self.pageNumber=[BTCoreConfig share].pageLoadStartPage;
            [self.loadingHelp showLoading];
            [self getData];
        });
    }
}

- (void)resetValueAndGetData{
    self.isLoadFinish=NO;
    self.pageNumber=[BTCoreConfig share].pageLoadStartPage;
    [self.dataArray removeAllObjects];
    [self.loadingHelp showLoading];
    [self getData];
}

- (void)setRefreshHeadThemeWhite{
    if (self.tableView.mj_header&&[self.tableView.mj_header isKindOfClass:[MJRefreshNormalHeader class]]) {
        MJRefreshNormalHeader * header=(MJRefreshNormalHeader*)self.tableView.mj_header;
        header.stateLabel.textColor=UIColor.whiteColor;
        header.lastUpdatedTimeLabel.textColor=UIColor.whiteColor;
        header.loadingView.activityIndicatorViewStyle=UIActivityIndicatorViewStyleWhite;
    }
    
}


- (CGFloat)mjFootIgnoredScrollViewContentInsetBottom{
    return 34;
}


@end
