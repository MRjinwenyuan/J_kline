//
//  YStockChartViewController.m
//  BTC-Kline
//
//  Created by yate1996 on 16/4/27.
//  Copyright © 2016年 yate1996. All rights reserved.
//

#import "JJStockChartViewController.h"
#import "Y_StockChartView.h"
#import "Y_KLineGroupModel.h"
#import "UIColor+Y_StockChart.h"
#import "AppDelegate.h"
//#import "BTBiModel.h"
//#import "BTDealMarketModel.h"
//#import "BTMarketModel.h"
//#import "LineKFullScreenViewController.h"
#import "UIViewController+INMOChildViewControlers.h"
#import "Y_KLineModel.h"
#import "Y_KLineView.h"
#import "Y_KLineMainView.h"
 #import "NetWorking.h"

#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define SCREEN_MAX_LENGTH MAX(KScreenWidth,kScreenHeight)
#define IS_IPHONE_X (IS_IPHONE && SCREEN_MAX_LENGTH == 812.0)
#define KHeaderHeight 100+410+10

typedef NS_ENUM(NSInteger, KLineTimeType) {
    KLineTimeTypeMinute = 100,
    KLineTimeTypeMinute5,
    KLineTimeTypeMinute15,
    KLineTimeTypeMinute30,
    KLineTimeTypeHour,
    KLineTimeTypeHour4,
    KLineTimeTypeDay,
    KLineTimeTypeWeek,
    KLineTimeTypeMonth,
    KLineTimeTypeOther
};
 
@interface JJStockChartViewController ()<Y_StockChartViewDataSource,Y_StockChartViewDelegate,UITableViewDelegate,UITableViewDataSource,SRWebSocketDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) Y_StockChartView *lineKView;

@property (assign, nonatomic) BOOL isShowKLineFullScreenViewController;

@property (nonatomic, strong) Y_KLineGroupModel *groupModel;

@property (nonatomic, copy) NSMutableDictionary <NSString*, Y_KLineGroupModel*> *modelsDict;

@property (nonatomic, assign) NSInteger currentIndex;

@property (nonatomic, copy) NSString *type;


@property (nonatomic, strong) NSMutableArray *dataArray;


@end

@implementation JJStockChartViewController

- (NSMutableArray *)dataArray
{
    if (_dataArray == nil) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"全屏" style:UIBarButtonItemStylePlain target:self action:@selector(full)];
    
    self.view.backgroundColor = RGB(13, 23, 35);
    self.currentIndex = -1;
//    self.isHidden = YES;
    //导航栏
    [self setupNavView];
    //初始化tableView
    [self setupTableView];
    //初始化头部
    [self setuptopView];
    //加载头部数据
    [self loadBiTopData];
    //加载深度
    [self loadDepthData];
   
}

#pragma mark - 推送
- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message {
    
    //收到服务端发送过来的消息
    NSDictionary *dict = [NSString dictionaryWithJsonString:message];
    if ([dict[@"type"] integerValue] == 2){ //最新成交
        
    }else if ([dict[@"type"] integerValue] == 4){ //头部最新价
        
        
    }else if ([dict[@"type"] integerValue] == 21){
        
        self.dataArray = dict[@"data"][@"datas"][@"data"];
        kWeakSelf(self)
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.groupModel != nil &&weakself.dataArray.count > 0) {
                //                NSLog(@"%@",self.dataArray[0]);
                Y_KLineModel *lineModel = [self.groupModel.models lastObject];
                [lineModel initWithArray:self.dataArray[0]];
                //                [weakself.lineKView.kLineView reDraw];
                //
                //                return ;
                
                
                NSDate *date = [NSDate dateWithTimeIntervalSince1970:lineModel.Date.doubleValue/1000 + self.type.integerValue * 60];
                BOOL  isresh  = [weakself compareDate:[NSDate date] withDate:date];
                
                if (!isresh) {
                    lineModel.Date = [NSString stringWithFormat:@"%@",@(lineModel.Date.doubleValue +1)];
                    [self reloadData];
                }else
                {
                    //                NSLog(@"122223312312321321321123");
                }
                //                NSString * price = [NSString stringWithFormat:@"%@ ",[EXUnit formatternumber:modle.quote_asset_precision.intValue assess:modle.last]];
                NSString *price = NSStringFormat(@"%@",self.dataArray[0][4]);
                [weakself.lineKView.kLineView.kLineMainView  uploadPrice:price];
                [weakself.lineKView.kLineView drawMainView];
            }
        });
    }else if ([dict[@"type"] integerValue] == 18){
        
        
    }else if ([dict[@"type"] integerValue] == 19){
    }
}

//比较两个日期的大小
- (BOOL)compareDate:(NSDate*)stary withDate:(NSDate*)end
{
    NSComparisonResult result = [stary compare: end];
    if (result==NSOrderedSame)
    {
        //相等
        //        NSLog(@"1111111");
        return NO;
    }else if (result==NSOrderedAscending)
    {
        //结束时间大于开始时间
        //        NSLog(@"22222222");
        return YES;
    }else if (result==NSOrderedDescending)
    {
        //结束时间小于开始时间
        //        NSLog(@"333333333");
        return NO;
    }
    return NO;
}

- (void)setupTableView
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kTopHeight, KScreenWidth, KScreenHeight-kTopHeight-kTabBarHeight) style:UITableViewStyleGrouped];
    self.tableView.backgroundColor = RGB(13, 23, 35);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.tableView];
}

- (void)setupNavView
{
 
}

- (void)setuptopView
{
    UIView *topView = [[UIView alloc] init];
    topView.backgroundColor = RGB(21, 32, 54);
    topView.height = KHeaderHeight;
    self.tableView.tableHeaderView = topView;
    
    
    _lineKView = [[Y_StockChartView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 410)];
    _lineKView.backgroundColor = RGB(21, 32, 54);
    _lineKView.isFullScreen = NO;
    _isShowKLineFullScreenViewController = NO;
    _lineKView.itemModels = @[
                              [Y_StockChartViewItemModel itemModelWithTitle:BTLanguage(@"分时") type:Y_StockChartcenterViewTypeKline],
                              [Y_StockChartViewItemModel itemModelWithTitle:BTLanguage(@"15分") type:Y_StockChartcenterViewTypeKline],
                              [Y_StockChartViewItemModel itemModelWithTitle:BTLanguage(@"1小时") type:Y_StockChartcenterViewTypeKline],
                              //                              [Y_StockChartViewItemModel itemModelWithTitle:@"4小时" type:Y_StockChartcenterViewTypeKline],
                              [Y_StockChartViewItemModel itemModelWithTitle:BTLanguage(@"日线") type:Y_StockChartcenterViewTypeKline],
                              [Y_StockChartViewItemModel itemModelWithTitle:BTLanguage(@"更多") type:Y_StockChartcenterViewTypeOther],
                              [Y_StockChartViewItemModel itemModelWithTitle:BTLanguage(@"指标") type:Y_StockChartcenterViewTypeOther],
                              ];
    _lineKView.dataSource = self;
    _lineKView.delegate = self;
    [self addLinesView];
    [topView addSubview:self.lineKView];
 
}

- (NSMutableDictionary<NSString *,Y_KLineGroupModel *> *)modelsDict
{
    if (!_modelsDict) {
        _modelsDict = @{}.mutableCopy;
    }
    return _modelsDict;
}

#pragma mark - Y_StockChartViewDataSource

-(id)stockDatasWithIndex:(NSInteger)index {
    NSLog(@"JJStockChartViewController stockDatasWithIndex %ld",(long)index);
    NSString *type;
    switch (index) {
        case 0:type = @"1min";//@"1min";
            break;
        case 1:type = @"15min";//@"15min";
            break;
        case 2:type = @"1hour";//@"1hour";
            break;
        case 3:type = @"1day";//@"1day";
            break;
        case 5:type = @"1min";//@"1min";
            break;
        case 6:type = @"5min";//@"5min";
            break;
        case 7:type = @"30min";//@"30min";
            break;
        case 8:type = @"1week";//@"1week";
            break;
        case 9:type = @"1month";//@"1month";
            break;
        default:
            break;
    }
    
    self.currentIndex = index;
    self.type = type;
 
    if(![self.modelsDict objectForKey:type]){
        [self reloadData];
    }
    else{
        return [self.modelsDict objectForKey:type].models;
    }
    
    return nil;
}


- (void)loadBiTopData
{
 
}

//深度
- (void)loadDepthData
{
   
}

//最新成交价
- (void)loadNewPriceData
{
   
}


- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
 
    return 1;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    return [UITableViewCell new];
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    //sectionheader的高度，这是要放分段控件的
    return 0.01;
}

- (void)addLinesView {
    CGFloat white = _lineKView.bounds.size.height /4;
    CGFloat height = _lineKView.bounds.size.width /4;
    //横格
    for (int i = 0;i < 4;i++ ) {
        UIView *hengView = [[UIView alloc] initWithFrame:CGRectMake(0, white * (i + 1),_lineKView.bounds.size.width , 1)];
        hengView.backgroundColor = RGB(30, 43, 62);
        [_lineKView addSubview:hengView];
        [_lineKView sendSubviewToBack:hengView];
    }
    //竖格
    for (int i = 0;i < 4;i++ ) {
        
        UIView *shuView = [[UIView alloc]initWithFrame:CGRectMake(height * (i + 1), 47, 1, _lineKView.bounds.size.height - 62)];
        shuView.backgroundColor = RGB(30, 43, 62);
        [_lineKView addSubview:shuView];
        [_lineKView sendSubviewToBack:shuView];
    }
    UIImageView *logo = [[UIImageView alloc]initWithFrame:CGRectMake(5, 245, 73, 20)];
    [logo setImage:IMAGE_NAMED(@"logo")];
    [_lineKView addSubview:logo];
    [_lineKView sendSubviewToBack:logo];
}


- (void)reloadData
{
    kWeakSelf(self)
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"type"] = self.type;
    param[@"market"] = @"btc_usdt";
    param[@"size"] = @"1000";
    [NetWorking requestWithApi:@"http://api.bitkk.com/data/v1/kline" param:param thenSuccess:^(NSDictionary *responseObject) {
        Y_KLineGroupModel *groupModel = [Y_KLineGroupModel objectWithArray:responseObject[@"data"]];
        weakself.groupModel = groupModel;
        [weakself.modelsDict setObject:groupModel forKey:self.type];
        [weakself.lineKView reloadData];
    } fail:^{
        
    }];
}

- (void)showKLineFullScreenViewController{
 
}

#pragma mark - Y_StockChartViewDelegate

- (void)onClickFullScreenButtonWithTimeType:(Y_StockChartCenterViewType )timeType{
    if (!_isShowKLineFullScreenViewController) {
        [self showKLineFullScreenViewController];
    }
}


@end
