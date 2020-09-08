//
//  BTLogView.m
//  BTCoreExample
//
//  Created by apple on 2020/9/7.
//  Copyright © 2020 stonemover. All rights reserved.
//

#import "BTLogView.h"
#import "BTPageLoadView.h"
#import <BTHelp/NSDate+BTDate.h>
#import "BTCoreConfig.h"
#import <BTLoading/BTToast.h>
#import <BTWidgetView/UIView+BTViewTool.h>
#import <BTWidgetView/UIView+BTConstraint.h>

static BTLogView * logView = nil;

@interface BTLogView()<BTPageLoadViewDelegate,UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) BTLogWindow * window;

@property (nonatomic, strong) BTPageLoadView * pageView;

@property (nonatomic, strong) NSMutableArray * dataArray;

@property (nonatomic, strong) UIScrollView * scrollView;

@property (nonatomic, strong) UIButton * exportBtn;

@property (nonatomic, strong) UIButton * enableBtn;

@property (nonatomic, strong) UIButton * clearBtn;

@property (nonatomic, strong) UIButton * locationBtn;

@property (nonatomic, strong) UIButton * closeBtn;

@end


@implementation BTLogView

+ (instancetype)share{
    if (logView == nil) {
        logView = [BTLogView new];
    }
    return logView;
}

- (instancetype)init{
    self = [super init];
    [self initSelf];
    return self;
}

- (void)initSelf{
    self.dataArray = [NSMutableArray new];
    NSArray * localArray = [NSUserDefaults.standardUserDefaults valueForKey:@"BT_LOG_DATA"];
    if (localArray) {
        [self.dataArray addObjectsFromArray:localArray];
    }
}

- (void)initWindow{
    if (self.window) {
        return;
    }
    CGFloat size =  BTUtils.SCREEN_W / 2;
    self.window = [[BTLogWindow alloc] initBTViewWithSize:CGSizeMake(size, size)];
    [self.window setBTShade:0.2 radius:1];
    
    self.pageView = [[BTPageLoadView alloc] initWithFrame:self.window.bounds];
    self.pageView.delegate = self;
    [self.pageView initTableView:@[@"BTLogTableViewCell"] isRegisgerNib:NO];
    self.pageView.tableView.estimatedRowHeight = 10;
    [self.pageView setTableViewNoMoreEmptyLine];
    [self setLocation:2];
    self.pageView.tableView.contentInset = UIEdgeInsetsMake(20, 0, 0, 0);
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.window.BTWidth, 20)];
    self.scrollView.showsHorizontalScrollIndicator = NO;
    [self initBtn];
    [self.scrollView bt_addSubViewArray:@[self.enableBtn,self.locationBtn,self.clearBtn,self.closeBtn,self.exportBtn]];
    self.scrollView.contentSize = CGSizeMake(self.exportBtn.BTRight + 2, 20);
    
    [self.window bt_addSubViewArray:@[self.pageView,self.scrollView]];
    
    self.window.windowLevel = UIWindowLevelStatusBar;
}



- (void)initBtn{
    self.enableBtn = [[UIButton alloc] initBTViewWithSize:CGSizeMake(40, 20)];
    self.enableBtn.backgroundColor = UIColor.lightGrayColor;
    self.enableBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [self.enableBtn setTitle:@"透明" forState:UIControlStateNormal];
    [self.enableBtn addTarget:self action:@selector(hideClick) forControlEvents:UIControlEventTouchUpInside];
    
    self.clearBtn = [[UIButton alloc] initBTViewWithSize:CGSizeMake(40, 20)];
    self.clearBtn.backgroundColor = UIColor.lightGrayColor;
    self.clearBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [self.clearBtn setTitle:@"清除" forState:UIControlStateNormal];
    [self.clearBtn addTarget:self action:@selector(clear) forControlEvents:UIControlEventTouchUpInside];
    self.clearBtn.BTLeft = self.enableBtn.BTRight + 2;
    
    
    self.locationBtn = [[UIButton alloc] initBTViewWithSize:CGSizeMake(40, 20)];
    self.locationBtn.backgroundColor = UIColor.lightGrayColor;
    self.locationBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [self.locationBtn setTitle:@"位置" forState:UIControlStateNormal];
    [self.locationBtn addTarget:self action:@selector(localtionClick) forControlEvents:UIControlEventTouchUpInside];
    self.locationBtn.BTLeft = self.clearBtn.BTRight + 2;
    
    self.closeBtn = [[UIButton alloc] initBTViewWithSize:CGSizeMake(40, 20)];
    self.closeBtn.backgroundColor = UIColor.lightGrayColor;
    self.closeBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [self.closeBtn setTitle:@"关闭" forState:UIControlStateNormal];
    [self.closeBtn addTarget:self action:@selector(closeClick) forControlEvents:UIControlEventTouchUpInside];
    self.closeBtn.BTLeft = self.locationBtn.BTRight + 2;
    
    self.exportBtn = [[UIButton alloc] initBTViewWithSize:CGSizeMake(40, 20)];
    self.exportBtn.backgroundColor = UIColor.lightGrayColor;
    self.exportBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [self.exportBtn setTitle:@"导出" forState:UIControlStateNormal];
    [self.exportBtn addTarget:self action:@selector(exportClick) forControlEvents:UIControlEventTouchUpInside];
    self.exportBtn.BTLeft = self.closeBtn.BTRight + 2;
    
    
}

- (void)hideClick{
    if ([self.enableBtn.titleLabel.text isEqualToString:@"透明"]) {
        self.window.alpha = 0.1;
        self.pageView.userInteractionEnabled = NO;
        [self.enableBtn setTitle:@"显示" forState:UIControlStateNormal];
    }else{
        self.window.alpha = 1;
        self.pageView.userInteractionEnabled = YES;
        [self.enableBtn setTitle:@"透明" forState:UIControlStateNormal];
    }
}


- (void)localtionClick{
    if (self.location == 2) {
        _location = 0;
    }else{
        _location++;
    }
    [self setLocation:_location];
}

- (void)closeClick{
    [self hide];
}

- (void)exportClick{
    UIPasteboard.generalPasteboard.string = [self exportData];
    [BTToast showSuccess:@"数据已复制到粘贴板"];
}

- (void)show{
    if (!BTCoreConfig.share.isOpenLog) {
        return;
    }
    [self initWindow];
    self.window.hidden = NO;
    [self.pageView.tableView reloadData];
}

- (void)hide{
    if (!BTCoreConfig.share.isOpenLog) {
        return;
    }
    [self.window bt_removeAllChildView];
    self.window = nil;
}

- (void)add:(NSString*)str{
    if (!BTCoreConfig.share.isOpenLog) {
        return;
    }
    NSString * data = [[[NSDate bt_initLocalDate] bt_dateStr:@"YYYY-MM-dd HH:mm:ss"] stringByAppendingFormat:@"\n%@",str];
    [self.dataArray addObject:data];
    [self.pageView.tableView reloadData];
}

- (void)addAndSave:(NSString*)str{
    if (!BTCoreConfig.share.isOpenLog) {
        return;
    }
    NSString * data = [[[NSDate bt_initLocalDate] bt_dateStr:@"YYYY-MM-dd HH:mm:ss"] stringByAppendingFormat:@"\n%@",str];
    [self.dataArray addObject:data];
    [NSUserDefaults.standardUserDefaults setValue:self.dataArray forKey:@"BT_LOG_DATA"];
    [NSUserDefaults.standardUserDefaults synchronize];
    [self.pageView.tableView reloadData];
}

- (void)clear{
    if (!BTCoreConfig.share.isOpenLog) {
        return;
    }
    [self.dataArray removeAllObjects];
    [NSUserDefaults.standardUserDefaults setValue:self.dataArray forKey:@"BT_LOG_DATA"];
    [NSUserDefaults.standardUserDefaults synchronize];
    [self.pageView.tableView reloadData];
}

- (NSString * _Nullable)exportData{
    NSMutableArray * array = [self.dataArray mutableCopy];
    for (int i=0; i<array.count; i++) {
        NSString * str = array[i];
        array[i] = [str stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
    }
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:array options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString;
    if (!jsonData) {
        return nil;
    }else{
        jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    NSMutableString *mutStr = [NSMutableString stringWithString:jsonString];
    return mutStr;
}

- (void)setLocation:(NSInteger)location{
    if (!BTCoreConfig.share.isOpenLog) {
        return;
    }
    _location = location;
    switch (location) {
        case 0:
        {
            self.window.BTTop = BTUtils.NAV_HEIGHT;
        }
            break;
        case 1:
        {
            self.window.BTCenterY = BTUtils.SCREEN_H / 2;
        }
            break;
        case 2:
        {
            self.window.BTBottom = BTUtils.SCREEN_H;
        }
            break;
    }
}


#pragma mark BTPageLoadViewDelegate
- (void)BTPageLoadGetData:(BTPageLoadView*)loadView{
    
}

- (id<UITableViewDataSource>)BTPageLoadTableDataSource:(BTPageLoadView *)loadView{
    return self;
}

- (id<UITableViewDelegate>)BTPageLoadTableDelegate:(BTPageLoadView *)loadView{
    return self;
}

#pragma mark tableView data delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.dataArray count];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    BTLogTableViewCell * cell=[tableView dequeueReusableCellWithIdentifier:self.pageView.cellId];
    cell.labelTitle.text = self.dataArray[indexPath.row];
    return cell;
}


#pragma mark tableView delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString * str = self.dataArray[indexPath.row];
    NSArray * array = [str componentsSeparatedByString:@"\n"];
    UIPasteboard.generalPasteboard.string = array[1];
    [BTToast showSuccess:@"复制成功"];
    
}



@end



@implementation BTLogTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    [self initLabel];
//    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    return self;
}



- (void)initLabel{
    self.labelTitle=[[UILabel alloc] init];
    self.labelTitle.translatesAutoresizingMaskIntoConstraints=NO;
    self.labelTitle.font=[UIFont systemFontOfSize:10 weight:UIFontWeightMedium];
    self.labelTitle.textColor=[UIColor blackColor];
    self.labelTitle.numberOfLines = 0;
    [self addSubview:self.labelTitle];
    [self.labelTitle bt_addTopToItemView:self constant:2];
    [self.labelTitle bt_addLeftToItemView:self constant:0];
    [self.labelTitle bt_addBottomToItemView:self constant:-2];
    [self.labelTitle bt_addRightToItemView:self constant:0];
}




@end


@implementation BTLogWindow

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    if (self.alpha == 1) {
        return [super hitTest:point withEvent:event];
    }
    
    if (point.y < 20) {
        return [super hitTest:point withEvent:event];
    }
    
    return nil;
}

@end
