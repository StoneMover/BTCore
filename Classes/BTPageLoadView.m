//
//  BTPageLoadView.m
//  BTCoreExample
//
//  Created by apple on 2020/9/3.
//  Copyright © 2020 stonemover. All rights reserved.
//

#import "BTPageLoadView.h"


@interface BTPageLoadView()

@property (nonatomic, weak) UIScrollView * scrollView;

@property (nonatomic, strong) UIImageView * tableViewBoundceHeadImgView;

@property (nonatomic, assign) CGFloat tableViewBoundceHeadImgViewOriHeight;

@end


@implementation BTPageLoadView

- (void)awakeFromNib{
    [super awakeFromNib];
    [self initSelf];
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    [self initSelf];
    return self;
}

- (void)layoutSubviews{
    if (self.tableView) {
        self.tableView.frame = self.bounds;
    }
    
    if (self.collectionView) {
        self.collectionView.frame = self.bounds;
    }
}


- (void)initSelf{
    self.loadFinishDataNum=[BTCoreConfig share].pageLoadSizePage;
    _pageNumber=[BTCoreConfig share].pageLoadStartPage;
}

- (void)initTableView:(NSArray<NSString*>*)cellNames{
    [self initTableView:cellNames isRegisgerNib:YES style:UITableViewStylePlain];
}

- (void)initTableView:(NSArray<NSString*>*)cellNames isRegisgerNib:(BOOL)isRegisgerNib{
    [self initTableView:cellNames isRegisgerNib:isRegisgerNib style:UITableViewStylePlain];
}

- (void)initTableView:(NSArray<NSString*>*)cellNames isRegisgerNib:(BOOL)isRegisgerNib style:(UITableViewStyle)style{
    NSMutableArray * cellIdArray = [NSMutableArray new];
    for (NSString * cellName in cellNames) {
        NSString * cellId = [NSString stringWithFormat:@"%@Id",cellName];
        [cellIdArray addObject:cellId];
    }
    [self initTableView:cellNames cellIdArray:cellIdArray isRegisgerNib:isRegisgerNib style:style];
}

- (void)initTableView:(NSArray<NSString*>*)cellNames cellIdArray:(NSArray<NSString*>*)cellIdArray isRegisgerNib:(BOOL)isRegisgerNib style:(UITableViewStyle)style{
    _tableView = [[UITableView alloc] initWithFrame:self.bounds style:style];
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    
    self.tableView.delegate = [self.delegate BTPageLoadTableDelegate:self];
    self.tableView.dataSource = [self.delegate BTPageLoadTableDataSource:self];
    
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _dataArrayCellId=[NSMutableArray new];
    for (int i=0; i<cellNames.count; i++) {
        NSString * cellName = cellNames[i];
        NSString * cellId = cellIdArray[i];
        [self.dataArrayCellId addObject:cellId];
        if (isRegisgerNib) {
            UINib * nib = [UINib nibWithNibName:cellName bundle:nil];
            [self.tableView registerNib:nib forCellReuseIdentifier:cellId];
        }else{
            [self.tableView registerClass:NSClassFromString(cellName) forCellReuseIdentifier:cellId];
        }
    }
    
    [self addSubview:self.tableView];
    self.scrollView=self.tableView;
}


- (void)initCollectionView:(NSArray<NSString*>*)cellNames{
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
    [self initCollectionView:cellNames isRegisgerNib:YES layout:layout];
}

- (void)initCollectionView:(NSArray<NSString*>*)cellNames isRegisgerNib:(BOOL)isRegisgerNib{
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
    [self initCollectionView:cellNames isRegisgerNib:isRegisgerNib layout:layout];
}

- (void)initCollectionView:(NSArray<NSString*>*)cellNames isRegisgerNib:(BOOL)isRegisgerNib layout:(UICollectionViewFlowLayout*)layout{
    
    _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:layout];
    self.collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _dataArrayCellId=[NSMutableArray new];
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
    
    
    
    self.collectionView.delegate=[self.delegate BTPageLoadCollectionDelegate:self];
    self.collectionView.dataSource=[self.delegate BTPageLoadCollectionDataSource:self];
    [self addSubview:self.collectionView];
    self.scrollView=self.collectionView;
}

- (void)setTableViewNoMoreEmptyLine{
    [self.tableView setTableFooterView:[[UIView alloc]initWithFrame:CGRectZero]];
}

#pragma mark 自动加载逻辑
- (void)autoLoad:(NSDictionary*)dict class:(Class)cla{
    if ([BTNet isSuccess:dict]) {
        NSArray * array = nil;
        if (self.delegate && [self.delegate respondsToSelector:@selector(BTPageLoadData:dataOri:)]) {
            array = [self.delegate BTPageLoadData:self dataOri:dict];
        }
        
        if (array == nil) {
            array = [BTNet defaultDictArray:dict];
        }
        
        [self autoLoadSuccess:array class:cla];
    }else{
        [self autoLoadSeverError:[BTNet errorInfo:dict]];
    }
}

- (void)autoLoadSuccess:(NSArray*)dataDict class:(Class)cls{
    if (dataDict == nil || [dataDict isKindOfClass:[NSNull class]]) {
        dataDict = [NSArray new];
    }
    
    NSMutableArray * dataArray = [NSMutableArray new];
    NSInteger index=0;
    for (NSDictionary * dict in dataDict) {
        BTModel * modelChild=[[cls alloc]init];
        [modelChild analisys:dict];
        if (self.delegate && [self.delegate respondsToSelector:@selector(BTPageLoadCreate:obj:dict:index:)]) {
            [self.delegate BTPageLoadCreate:self obj:modelChild dict:dict index:index];
        }
        [dataArray addObject:modelChild];
        index++;
    }
    [self autoLoadSuccess:dataArray];
}

- (void)autoLoadSuccess:(NSArray *)dataArray{
    [self endHeadRefresh];
    [self endFootRefresh];
    if (self.isRefresh) {
        [self.dataArray removeAllObjects];
        _isRefresh=NO;
    }
    
    [self.dataArray addObjectsFromArray:dataArray];
    if (self.pageNumber == [BTCoreConfig share].pageLoadStartPage) {
        if (self.loadingHelp) {
            if(dataArray.count==0){
                [self.loadingHelp showEmpty];
                _pageNumber--;
            }else{
                [self.loadingHelp dismiss];
            }
        }else{
            if(dataArray.count==0){
                _pageNumber--;
                [self emptyDataToast];
            }
        }
    }
    self.isLoadFinish = dataArray.count < self.loadFinishDataNum;
    _pageNumber++;
    if (self.tableView) {
        [self.tableView reloadData];
    }
    if (self.collectionView) {
        [self.collectionView reloadData];
    }
}

- (void)autoLoadError:(NSError* _Nullable)error errorInfo:(NSString* _Nullable)errorInfo{
    if (error) {
        [self autoLoadNetError:error];
    }else if(errorInfo){
        [self autoLoadSeverError:errorInfo];
    }else{
        [self autoLoadSeverError:@"未知错误"];
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
    _isRefresh=NO;
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
    _isRefresh=NO;
    if (self.pageNumber==[BTCoreConfig share].pageLoadStartPage&&self.loadingHelp&&!self.isRefresh) {
        //当数据请求为第一页的时候,并且挡板已经初始化,并且不是刷新状态的时候,给出挡板的错误提示
        [self.loadingHelp showError:info];
        return;
    }
    
    [BTToast showErrorInfo:info];
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





#pragma mark 刷新相关
- (void)setIsNeedHeadRefresh:(BOOL)isNeedHeadRefresh{
    if (_isNeedHeadRefresh!=isNeedHeadRefresh) {
        _isNeedHeadRefresh=isNeedHeadRefresh;
        if (isNeedHeadRefresh) {
            __weak BTPageLoadView * weakSelf=self;
            if (self.delegate && [self.delegate respondsToSelector:@selector(BTPageLoadRefreshHeader:)]) {
                self.scrollView.mj_header = [self.delegate BTPageLoadRefreshHeader:self];
                self.scrollView.mj_header.refreshingBlock = ^{
                    [weakSelf headRefreshLoad];
                };
            }else{
                self.scrollView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
                    [weakSelf headRefreshLoad];
                }];
            }
            
            
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
            __weak BTPageLoadView * weakSelf=self;
            if (self.delegate && [self.delegate respondsToSelector:@selector(BTPageLoadRefreshFooter:)]) {
                self.scrollView.mj_footer = [self.delegate BTPageLoadRefreshFooter:self];
                self.scrollView.mj_footer.refreshingBlock = ^{
                    [weakSelf footRefreshLoad];
                };
            }else{
                self.scrollView.mj_footer=[MJRefreshBackNormalFooter
                                           footerWithRefreshingBlock:^{
                                               [weakSelf footRefreshLoad];
                                           }];
            }
            
            CGFloat result = BTUtils.UI_IS_IPHONEX ? 34 : 0;
            if (self.delegate && [self.delegate respondsToSelector:@selector(BTPageLoadIgnoredContentInsetBottom:)]) {
                result = [self.delegate BTPageLoadIgnoredContentInsetBottom:self];
            }
            self.scrollView.mj_footer.ignoredScrollViewContentInsetBottom=result + self.scrollView.contentInset.bottom;
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
    _pageNumber=[BTCoreConfig share].pageLoadStartPage;
    self.isLoadFinish=NO;
    _isRefresh=YES;
    if (self.delegate && [self.delegate respondsToSelector:@selector(BTPageLoadGetData:)]) {
        [self.delegate BTPageLoadGetData:self];
    }
}
- (void)footRefreshLoad{
    if (self.delegate && [self.delegate respondsToSelector:@selector(BTPageLoadGetData:)]) {
        [self.delegate BTPageLoadGetData:self];
    }
}

#pragma mark 相关辅助方法
- (NSMutableArray*)dataArray{
    if (_dataArray==nil) {
        _dataArray=[NSMutableArray new];
    }
    
    return _dataArray;
}

- (NSString*)pageNumStr{
    return [NSString stringWithFormat:@"%ld",(long)self.pageNumber];
}




- (NSString*_Nullable)cellId:(NSInteger)index{
    if (self.dataArrayCellId&&index<self.dataArrayCellId.count) {
        return self.dataArrayCellId[index];
    }
    
    return nil;
}

- (NSString*_Nullable)cellId{
    return [self cellId:0];
}

- (void)emptyGetData{
    if (self.dataArray.count==0) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.isLoadFinish=NO;
            self->_pageNumber=[BTCoreConfig share].pageLoadStartPage;
            [self.loadingHelp showLoading];
            if (self.delegate && [self.delegate respondsToSelector:@selector(BTPageLoadGetData:)]) {
                [self.delegate BTPageLoadGetData:self];
            }
        });
    }
}

- (void)resetValueAndGetData{
    self.isLoadFinish=NO;
    _pageNumber=[BTCoreConfig share].pageLoadStartPage;
    [self.dataArray removeAllObjects];
    [self.loadingHelp showLoading];
    if (self.delegate && [self.delegate respondsToSelector:@selector(BTPageLoadGetData:)]) {
        [self.delegate BTPageLoadGetData:self];
    }
}

- (void)setRefreshHeadThemeWhite{
    if (self.tableView.mj_header&&[self.tableView.mj_header isKindOfClass:[MJRefreshNormalHeader class]]) {
        MJRefreshNormalHeader * header=(MJRefreshNormalHeader*)self.tableView.mj_header;
        header.stateLabel.textColor=UIColor.whiteColor;
        header.lastUpdatedTimeLabel.textColor=UIColor.whiteColor;
        header.loadingView.activityIndicatorViewStyle=UIActivityIndicatorViewStyleWhite;
    }
    
}

- (void)clearTableViewSystemInset{
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
}

- (void)emptyDataToast{
    if (!self.isToastWhenDataEmpty) {
        return;
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(BTPageLoadEmptyDataToast)]) {
        [self.delegate BTPageLoadEmptyDataToast];
        return;
    }
    
    [BTToast show:@"暂无数据"];
}

- (void)setTableViewBounceHeadImgView:(NSString *)imgName height:(CGFloat)height{
    self.tableView.backgroundColor = UIColor.clearColor;
    self.tableViewBoundceHeadImgViewOriHeight = height;
    UIImageView * bgView =  [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, BTUtils.SCREEN_W, height)];
    bgView.clipsToBounds = YES;
    bgView.image = [UIImage imageNamed:imgName];
    bgView.contentMode = UIViewContentModeScaleAspectFill;
    self.tableViewBoundceHeadImgView = bgView;
    [self insertSubview:bgView atIndex:0];
}


- (void)bt_scrollViewDidScroll:(UIScrollView*)scrollView{
    if (scrollView.contentOffset.y < 0) {
        self.tableViewBoundceHeadImgView.BTTop = 0;
        self.tableViewBoundceHeadImgView.BTHeight = self.tableViewBoundceHeadImgViewOriHeight + fabs(scrollView.contentOffset.y);
    }else if(scrollView.contentOffset.y > 0){
        self.tableViewBoundceHeadImgView.BTTop = - scrollView.contentOffset.y;
        self.tableViewBoundceHeadImgView.BTHeight = self.tableViewBoundceHeadImgViewOriHeight;
    }else{
        self.tableViewBoundceHeadImgView.BTTop = 0;
        self.tableViewBoundceHeadImgView.BTHeight = self.tableViewBoundceHeadImgViewOriHeight;
    }

}

@end
