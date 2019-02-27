//
//  BTPageLoadViewController.m
//  moneyMaker
//
//  Created by stonemover on 2019/1/22.
//  Copyright © 2019 stonemover. All rights reserved.
//

#import "BTPageLoadViewController.h"
#import "BTModel.h"
#import "MJRefresh.h"
#import "Const.h"

@interface BTPageLoadViewController ()<UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, weak) UIScrollView * scrollView;

@end

@implementation BTPageLoadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.loadFinishDataNum=15;
    self.pageNumber=1;
}

#pragma mark 初始化相关操作
- (void)initTableView:(NSArray<NSString*>*)cellNames{
    self.tableView.frame=self.view.bounds;
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    for (NSString * cellName in cellNames) {
        [self.tableView registerNib:[UINib nibWithNibName:cellName bundle:nil] forCellReuseIdentifier:[NSString stringWithFormat:@"%@Id",cellName]];
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
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    self.collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    for (NSString * cellName in cellNames) {
        [self.collectionView registerNib:[UINib nibWithNibName:cellName bundle:nil]
              forCellWithReuseIdentifier:[NSString stringWithFormat:@"%@Id",cellName]];
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
- (void)autoLoadSuccess:(NSDictionary*)dict
                dataKey:(NSString*)dataKey
                infoKey:(NSString*)infoKey
                codeKey:(NSString*)codeKey
                  class:(Class)cla{
    if ([dict.allKeys containsObject:infoKey]&&[dict.allKeys containsObject:codeKey]) {
        NSArray * array=[[dict objectForKey:dataKey] objectForKey:@"list"];
        NSString * info=[NSString stringWithFormat:@"%@",[dict objectForKey:infoKey]];
        NSString * code=[NSString stringWithFormat:@"%@",[dict objectForKey:codeKey]];
        [self autoLoadSuccess:code.integerValue info:info dataDict:array class:cla];
        
    }else{
        NSLog(@"字典中应该包含info和code字段");
    }
    
}

- (void)autoLoadSuccess:(NSDictionary*)dict class:(Class)cla{
    [self autoLoadSuccess:dict dataKey:@"data" infoKey:@"description" codeKey:@"succeed" class:cla];
}

- (void)autoLoadSuccess:(NSInteger)code
                   info:(NSString*)info
               dataDict:(NSArray*)dataDict
                  class:(Class)cls{
    [self endHeadRefresh];
    [self endFootRefresh];
    switch (code) {
        case 1:
        {
            if (self.isRefresh) {
                [self.dataArray removeAllObjects];
                self.isRefresh=NO;
            }
            
            [self autoAnalyses:dataDict class:cls];
            if (self.pageNumber==1) {
                if (self.loadingHelp) {
                    if(dataDict.count==0){
                        [self showEmpty];
                        self.pageNumber--;
                    }else{
                        [self dismiss];
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
            break;
        case 0:
        {
            
            if (self.pageNumber==1&&self.loadingHelp&&!self.isRefresh) {
                //当数据请求为第一页的时候,并且挡板已经初始化,并且不是刷新状态的时候,给出挡板的错误提示
                [self.loadingHelp showError:info];
                return;
            }
            self.isRefresh=NO;
            [BTToast showError:info];
        }
            break;
    }
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
    if (self.pageNumber==1&&self.loadingHelp&&!self.isRefresh) {
        //当数据请求为第一页的时候,并且挡板已经初始化,并且不是刷新状态的时候,给出挡板的错误提示
        [self.loadingHelp showError:info];
        return;
    }
    
    [BTToast showError:info];
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
    return [self pageLoadData:dict dataKey:@"data"];
}

- (NSArray<NSDictionary*>*)pageLoadData:(NSDictionary*)dict dataKey:(NSString*)dataKey{
    if (![dict.allKeys containsObject:dataKey]) {
        return nil;
    }
    //可以根据项目需要自己调整data数组位置，如果结构复杂就自己解析出数组使用
    NSArray * array=[dict objectForKey:dataKey];
    return array;
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
            if (UI_IS_IPHONEX) {
                self.scrollView.mj_footer.ignoredScrollViewContentInsetBottom=HOME_INDICATOR_HEIGHT;
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
    self.pageNumber=1;
    self.isLoadFinish=NO;
    self.isRefresh=YES;
    [self getData];
}
- (void)footRefreshLoad{
    [self getData];
}

@end
