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
#import <UIView+BTViewTool.h>
#import <UIView+BTConstraint.h>

static BTLogView * logView = nil;

@interface BTLogView()<BTPageLoadViewDelegate,UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) BTPageLoadView * pageView;

@property (nonatomic, strong) NSMutableArray * dataArray;

@property (nonatomic, strong) UIButton * enableBtn;

@property (nonatomic, strong) UIButton * clearBtn;

@end


@implementation BTLogView

+ (instancetype)share{
    if (logView == nil) {
        CGFloat size =  BTUtils.SCREEN_W / 2;
        logView = [[BTLogView alloc] initWithFrame:CGRectMake(0, (BTUtils.SCREEN_H - size)/2, size, size)];
    }
    return logView;
}



- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    [self setBTDefaultShade];
    self.dataArray = [NSMutableArray new];
    
    NSArray * localArray = [NSUserDefaults.standardUserDefaults valueForKey:@"BT_LOG_DATA"];
    if (localArray) {
        [self.dataArray addObjectsFromArray:localArray];
    }
    
    self.pageView = [[BTPageLoadView alloc] initWithFrame:self.bounds];
    self.pageView.delegate = self;
    [self.pageView initTableView:@[@"BTLogTableViewCell"] isRegisgerNib:NO];
    self.pageView.tableView.estimatedRowHeight = 10;
    [self.pageView setTableViewNoMoreEmptyLine];
    [self setLocation:1];
    
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
    
    self.pageView.tableView.contentInset = UIEdgeInsetsMake(20, 0, 0, 0);
    
    [self bt_addSubViewArray:@[self.pageView,self.enableBtn,self.clearBtn]];
    
    
    
    return self;
}

- (void)hideClick{
    if ([self.enableBtn.titleLabel.text isEqualToString:@"透明"]) {
        self.alpha = 0.1;
        self.pageView.userInteractionEnabled = NO;
        [self.enableBtn setTitle:@"显示" forState:UIControlStateNormal];
    }else{
        self.alpha = 1;
        self.pageView.userInteractionEnabled = YES;
        [self.enableBtn setTitle:@"透明" forState:UIControlStateNormal];
    }
}




- (void)show{
    [BTUtils.APP_WINDOW addSubview:self];
    [BTUtils.APP_WINDOW bringSubviewToFront:self];
    [self.pageView.tableView reloadData];
}

- (void)hide{
    [self removeFromSuperview];
}

- (void)add:(NSString*)str{
    NSString * data = [[[NSDate bt_initLocalDate] bt_dateStr:@"YYYY-MM-dd HH:mm:ss"] stringByAppendingFormat:@"\n%@",str];
    [self.dataArray addObject:data];
    [self.pageView.tableView reloadData];
}

- (void)addAndSave:(NSString*)str{
    NSString * data = [[[NSDate bt_initLocalDate] bt_dateStr:@"YYYY-MM-dd HH:mm:ss"] stringByAppendingFormat:@"\n%@",str];
    [self.dataArray addObject:data];
    [NSUserDefaults.standardUserDefaults setValue:self.dataArray forKey:@"BT_LOG_DATA"];
    [NSUserDefaults.standardUserDefaults synchronize];
    [self.pageView.tableView reloadData];
}

- (void)clear{
    [self.dataArray removeAllObjects];
    [NSUserDefaults.standardUserDefaults setValue:self.dataArray forKey:@"BT_LOG_DATA"];
    [NSUserDefaults.standardUserDefaults synchronize];
    [self.pageView.tableView reloadData];
}

- (void)setLocation:(NSInteger)location{
    switch (location) {
        case 0:
        {
            self.BTTop = 0;
        }
            break;
        case 1:
        {
            self.BTCenterY = BTUtils.SCREEN_H / 2;
        }
            break;
        case 2:
        {
            self.BTBottom = BTUtils.SCREEN_H;
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
}



@end



@implementation BTLogTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    [self initLabel];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
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