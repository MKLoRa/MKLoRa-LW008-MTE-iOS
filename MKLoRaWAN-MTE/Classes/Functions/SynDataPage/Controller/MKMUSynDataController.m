//
//  MKMUSynDataController.m
//  MKLoRaWAN-MTE_Example
//
//  Created by aa on 2021/6/19.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import "MKMUSynDataController.h"

#import <MessageUI/MessageUI.h>

#import "Masonry.h"

#import "MLInputDodger.h"

#import "MKMacroDefines.h"
#import "MKBaseTableView.h"
#import "UIView+MKAdd.h"

#import "MKHudManager.h"
#import "MKTextField.h"
#import "MKCustomUIAdopter.h"

#import "MKBLEBaseSDKAdopter.h"

#import "MKMUDatabaseManager.h"

#import "MKMUInterface.h"
#import "MKMUInterface+MKMUConfig.h"
#import "MKMUCentralManager.h"

#import "MKMUSynTableHeaderView.h"
#import "MKMUSynDataCell.h"

static NSTimeInterval const parseDataInterval = 0.1;
static NSTimeInterval const dataTimerInterval = 30.f;

static NSString *synIconAnimationKey = @"synIconAnimationKey";

@interface MKMUSynDataController ()<UITableViewDelegate,
UITableViewDataSource,
MFMailComposeViewControllerDelegate,
mk_mu_storageDataDelegate>

@property (nonatomic, strong)MKBaseTableView *tableView;

@property (nonatomic, strong)NSMutableArray *dataList;

@property (nonatomic, strong)MKMUSynTableHeaderView *headerView;

@property (nonatomic, strong)NSMutableArray *contentList;

/// 定时解析数据
@property (nonatomic, strong)dispatch_source_t parseTimer;

/// 返回延时定时器
@property (nonatomic, strong)dispatch_source_t backTimer;

/// 点击了返回按钮，先发送暂停命令给设备，然后2s中没有需要解析的数据了，认为可用返回了
@property (nonatomic, assign)NSInteger backCount;

/// 为65535时，最近的数据在最上面；为1时，最早的数据在最上面；
@property (nonatomic, assign)BOOL isMaxCount;

/// 最新业务需求，当用户点击返回按钮时，如果接收到了存储数据的总条数，则需要存储总条数到本地，断开连接会清除本地缓存的这个记录
@property (nonatomic, copy)NSString *totalSum;

@property (nonatomic, strong)NSDateFormatter *formatter;

/// 定时通信，防止三分钟不同信断开连接
@property (nonatomic, strong)dispatch_source_t dataTimer;

@end

@implementation MKMUSynDataController

- (void)dealloc {
    NSLog(@"MKMUSynDataController销毁");
    if (self.dataTimer) {
        dispatch_cancel(self.dataTimer);
    }
    if (self.parseTimer) {
        dispatch_cancel(self.parseTimer);
    }
    if (self.backTimer) {
        dispatch_cancel(self.backTimer);
    }
    [[MKMUCentralManager shared] notifyStorageData:NO];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.view.shiftHeightAsDodgeViewForMLInputDodger = 50.0f;
    [self.view registerAsDodgeViewForMLInputDodgerWithOriginalY:self.view.frame.origin.y];
    //本页面禁止右划退出手势
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadSubViews];
    [self readDataFromLocal];
    [[MKMUCentralManager shared] notifyStorageData:YES];
    [MKMUCentralManager shared].dataDelegate = self;
}

#pragma mark - super method
- (void)leftButtonMethod {
    [self.headerView.synButton.topIcon.layer removeAnimationForKey:synIconAnimationKey];
    self.headerView.synButton.msgLabel.text = @"SYNC";
    [[MKHudManager share] showHUDWithTitle:@"Waiting..." inView:self.view isPenetration:NO];
    [MKMUInterface  mu_pauseSendLocalData:YES sucBlock:^{
        [self startBackTimer];
    } failedBlock:^(NSError * _Nonnull error) {
        [self startBackTimer];
    }];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [MKMUSynDataCell fetchCellHeight:self.dataList[indexPath.row]];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MKMUSynDataCell *cell = [MKMUSynDataCell initCellWithTableView:tableView];
    cell.dataModel = self.dataList[indexPath.row];
    return cell;
}

#pragma mark - MFMailComposeViewControllerDelegate
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
    switch (result) {
        case MFMailComposeResultCancelled:  //取消
            break;
        case MFMailComposeResultSaved:      //用户保存
            break;
        case MFMailComposeResultSent:       //用户点击发送
            [self.view showCentralToast:@"send success"];
            break;
        case MFMailComposeResultFailed: //用户尝试保存或发送邮件失败
            break;
        default:
            break;
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - mk_mu_storageDataDelegate
- (void)mk_mu_receiveStorageData:(NSString *)content {
    NSInteger number = [MKBLEBaseSDKAdopter getDecimalWithHex:content range:NSMakeRange(8, 2)];
    NSLog(@"接收到数据了:+++++++++++%@",content);
    if (number == 0) {
        //最后一条数据
        self.totalSum = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(10, 4)];
        self.headerView.sumLabel.text = [NSString stringWithFormat:@"Sum:%@",self.totalSum];
        if ([self.totalSum integerValue] == 0) {
            self.headerView.countLabel.text = @"Count:0";
        }
        //开启防无通信断开连接
        [self addDataTimer];
        return;
    }
    [self.contentList addObject:content];
}

#pragma mark - event method
- (void)startButtonPressed {
    if (!ValidStr(self.headerView.textField.text)
        || [self.headerView.textField.text integerValue] < 1
        || [self.headerView.textField.text integerValue] > 65535) {
        [self.view showCentralToast:@"Time must be 1 ~ 65535"];
        return;
    }
    [[MKHudManager share] showHUDWithTitle:@"Config..." inView:self.view isPenetration:NO];
    [MKMUInterface mu_readNumberOfDaysStoredData:[self.headerView.textField.text integerValue] sucBlock:^{
        self.isMaxCount = ([self.headerView.textField.text integerValue] == 65535);
        [[NSUserDefaults standardUserDefaults] setValue:self.headerView.textField.text forKey:@"mu_readRecordDataDayNumKey"];
        [[MKHudManager share] hide];
        [self startButtonMethod];
    } failedBlock:^(NSError * _Nonnull error) {
        [[MKHudManager share] hide];
        [self.view showCentralToast:error.userInfo[@"errorInfo"]];
    }];
}

- (void)synButtonPressed {
    [self syncButtonStateUpdate];
    [[MKHudManager share] showHUDWithTitle:@"Config..." inView:self.view isPenetration:NO];
    [MKMUInterface mu_pauseSendLocalData:!self.headerView.synButton.selected sucBlock:^{
        [[MKHudManager share] hide];
    } failedBlock:^(NSError * _Nonnull error) {
        [[MKHudManager share] hide];
        [self.view showCentralToast:error.userInfo[@"errorInfo"]];
    }];
}

- (void)emptyButtonPressed {
    [[MKHudManager share] showHUDWithTitle:@"Config..." inView:self.view isPenetration:NO];
    [MKMUInterface mu_clearAllDatasWithSucBlock:^{
        [[MKHudManager share] hide];
        [self.dataList removeAllObjects];
        [self.contentList removeAllObjects];
        if (self.parseTimer) {
            dispatch_cancel(self.parseTimer);
        }
        self.headerView.sumLabel.text = @"Sum:0";
        self.headerView.countLabel.text = @"Count:0";
        [self.tableView reloadData];
        [self emptyButtonMethod];
    } failedBlock:^(NSError * _Nonnull error) {
        [[MKHudManager share] hide];
        [self.view showCentralToast:error.userInfo[@"errorInfo"]];
    }];
}

- (void)exportButtonPressed {
    if (![MFMailComposeViewController canSendMail]) {
        //如果是未绑定有效的邮箱，则跳转到系统自带的邮箱去处理
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"MESSAGE://"]
                                          options:@{}
                                completionHandler:nil];
        return;
    }
    if (!ValidArray(self.dataList)) {
        [self.view showCentralToast:@"No data to send"];
        return;
    }
    NSArray *list = [self.dataList mutableCopy];
    NSMutableData *emailData = [NSMutableData data];
    for (NSDictionary *dic in list) {
        NSString *timeString = @"Time: N/A";
        NSString *rawData = @"Raw Data: N/A";
        if (ValidDict(dic[@"date"])) {
            timeString = [@"Time: " stringByAppendingString:dic[@"date"]];
        }
        if (ValidStr(dic[@"rawData"])) {
            rawData = [@"Raw Data: " stringByAppendingString:dic[@"rawData"]];
        }
        NSString *stringToWrite = [NSString stringWithFormat:@"\n%@\n%@",timeString,rawData];
        NSData *stringData = [stringToWrite dataUsingEncoding:NSUTF8StringEncoding];
        [emailData appendData:stringData];
    }
    if (!ValidData(emailData)) {
        [self.view showCentralToast:@"Log data error"];
        return;
    }
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    NSString *bodyMsg = [NSString stringWithFormat:@"APP Version: %@ + + OS: %@",
                         version,
                         kSystemVersionString];
    MFMailComposeViewController *mailComposer = [[MFMailComposeViewController alloc] init];
    mailComposer.mailComposeDelegate = self;
    
    //收件人
    [mailComposer setToRecipients:@[@"Development@mokotechnology.com"]];
    //邮件主题
    [mailComposer setSubject:@"Feedback of mail"];
    [mailComposer addAttachmentData:emailData
                           mimeType:@"application/txt"
                           fileName:@"LoRaWAN-MT Data.txt"];
    [mailComposer setMessageBody:bodyMsg isHTML:NO];
    [self presentViewController:mailComposer animated:YES completion:nil];
}

#pragma mark - 数据库
- (void)readDataFromLocal {
    [[MKHudManager share] showHUDWithTitle:@"Reading..." inView:self.view isPenetration:NO];
    [MKMUDatabaseManager readDataListWithSucBlock:^(NSArray<NSDictionary *> * _Nonnull dataList) {
        [[MKHudManager share] hide];
        [self.dataList addObjectsFromArray:dataList];
        [self processStatus];
    } failedBlock:^(NSError * _Nonnull error) {
        [[MKHudManager share] hide];
        [self.view showCentralToast:error.userInfo[@"errorInfo"]];
    }];
}

- (void)processStatus {
    self.headerView.textField.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"mu_readRecordDataDayNumKey"];
    self.totalSum = [[NSUserDefaults standardUserDefaults] objectForKey:@"mu_recordDataTotalSumKey"];
    if (ValidStr(self.totalSum)) {
        self.headerView.sumLabel.text = [NSString stringWithFormat:@"Sum:%@",self.totalSum];
    }else {
        self.headerView.sumLabel.text = @"Sum:N/A";
    }
    
    if (self.dataList.count > 0) {
        self.headerView.countLabel.text = [NSString stringWithFormat:@"Count:%ld",(long)self.dataList.count];
        
    }else {
        //本地没有存储数据，则start、empty、sync不可用
        self.headerView.countLabel.text = @"Count:N/A";
        
        self.headerView.synButton.enabled = NO;
        self.headerView.synButton.topIcon.image = LOADICON(@"MKLoRaWAN-MTE", @"MKMUSynDataController", @"mu_sync_disableIcon.png");
        
        self.headerView.emptyButton.enabled = NO;
        self.headerView.emptyButton.topIcon.image = LOADICON(@"MKLoRaWAN-MTE", @"MKMUSynDataController", @"mu_delete_disableIcon.png");
        
        self.headerView.exportButton.enabled = NO;
        self.headerView.exportButton.topIcon.image = LOADICON(@"MKLoRaWAN-MTE", @"MKMUSynDataController", @"mu_export_disableIcon.png");
    }
    
    [self.tableView reloadData];
}

#pragma mark - 按钮刷新UI事件

- (void)startButtonMethod {
    //用户发送给设备开始读取数据了
    //清除数据库数据和数据列表数据
    if (self.parseTimer) {
        dispatch_cancel(self.parseTimer);
    }
    [self.dataList removeAllObjects];
    [self.contentList removeAllObjects];
    [self.tableView reloadData];
    
    //start按钮置灰、empty、export都不可用
    self.headerView.startButton.enabled = NO;
    [self.headerView.startButton setBackgroundColor:[UIColor grayColor]];
    [self.headerView.startButton setTitleColor:DEFAULT_TEXT_COLOR forState:UIControlStateNormal];
    
    self.headerView.emptyButton.enabled = NO;
    self.headerView.emptyButton.topIcon.image = LOADICON(@"MKLoRaWAN-MTE", @"MKMUSynDataController", @"mu_delete_disableIcon.png");
    
    self.headerView.exportButton.enabled = NO;
    self.headerView.exportButton.topIcon.image = LOADICON(@"MKLoRaWAN-MTE", @"MKMUSynDataController", @"mu_export_disableIcon.png");
    
    //sync按钮可用，选中状态，开启动画
    self.headerView.synButton.enabled = YES;
    self.headerView.synButton.selected = YES;
    self.headerView.synButton.topIcon.image = LOADICON(@"MKLoRaWAN-MTE", @"MKMUSynDataController", @"mu_sync_enableIcon.png");
    [self.headerView.synButton.topIcon.layer removeAnimationForKey:synIconAnimationKey];
    //开始旋转
    [self.headerView.synButton.topIcon.layer addAnimation:[MKCustomUIAdopter refreshAnimation:2.f] forKey:synIconAnimationKey];
    self.headerView.synButton.msgLabel.text = @"STOP";
    self.headerView.sumLabel.text = @"Sum:N/A";
    self.totalSum = @"";
    [self addTimerForRefresh];
}

- (void)syncButtonStateUpdate {
    self.headerView.synButton.selected = !self.headerView.synButton.selected;
    [self.headerView.synButton.topIcon.layer removeAnimationForKey:synIconAnimationKey];
    if (self.headerView.synButton.selected) {
        //如果监听数据，start按钮置灰、empty、export都不可用
        self.headerView.emptyButton.enabled = NO;
        self.headerView.emptyButton.topIcon.image = LOADICON(@"MKLoRaWAN-MTE", @"MKMUSynDataController", @"mu_delete_disableIcon.png");
        
        self.headerView.exportButton.enabled = NO;
        self.headerView.exportButton.topIcon.image = LOADICON(@"MKLoRaWAN-MTE", @"MKMUSynDataController", @"mu_export_disableIcon.png");
        
        //开始旋转
        [self.headerView.synButton.topIcon.layer addAnimation:[MKCustomUIAdopter refreshAnimation:2.f] forKey:synIconAnimationKey];
        self.headerView.synButton.msgLabel.text = @"STOP";
        self.totalSum = @"";
        [self addTimerForRefresh];
    }else {
        //停止监听数据，start按钮恢复正常状态,本地如果有数据,empty、export都可用，如果没有则empty、export都不可用
        self.headerView.startButton.enabled = YES;
        [self.headerView.startButton setBackgroundColor:NAVBAR_COLOR_MACROS];
        [self.headerView.startButton setTitleColor:COLOR_WHITE_MACROS forState:UIControlStateNormal];
        
        BOOL enable = (self.dataList.count > 0);
        self.headerView.emptyButton.enabled = enable;
        self.headerView.emptyButton.topIcon.image = (enable ? LOADICON(@"MKLoRaWAN-MTE", @"MKMUSynDataController", @"mu_delete_enableIcon.png") : LOADICON(@"MKLoRaWAN-MTE", @"MKMUSynDataController", @"mu_delete_disableIcon.png"));
        
        self.headerView.exportButton.enabled = enable;
        self.headerView.exportButton.topIcon.image = (enable ? LOADICON(@"MKLoRaWAN-MTE", @"MKMUSynDataController", @"mu_export_enableIcon.png") : LOADICON(@"MKLoRaWAN-MTE", @"MKMUSynDataController", @"mu_export_disableIcon.png"));
        
        self.headerView.synButton.msgLabel.text = @"SYNC";
        if (self.parseTimer) {
            dispatch_cancel(self.parseTimer);
            self.parseTimer = nil;
        }
    }
}

- (void)emptyButtonMethod {
    
    [self.headerView.startButton setBackgroundColor:NAVBAR_COLOR_MACROS];
    [self.headerView.startButton setTitleColor:COLOR_WHITE_MACROS forState:UIControlStateNormal];
    self.headerView.startButton.enabled = YES;
    
    self.headerView.synButton.enabled = NO;
    self.headerView.synButton.topIcon.image = LOADICON(@"MKLoRaWAN-MTE", @"MKMUSynDataController", @"mu_sync_disableIcon.png");
    
    self.headerView.emptyButton.enabled = YES;
    self.headerView.emptyButton.topIcon.image = LOADICON(@"MKLoRaWAN-MTE", @"MKMUSynDataController", @"mu_delete_enableIcon.png");
    
    self.headerView.exportButton.enabled = YES;
    self.headerView.exportButton.topIcon.image = LOADICON(@"MKLoRaWAN-MTE", @"MKMUSynDataController", @"mu_export_enableIcon.png");
}

- (void)startBackTimer {
    self.backTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,dispatch_get_global_queue(0, 0));
    dispatch_source_set_timer(self.backTimer, dispatch_time(DISPATCH_TIME_NOW, 0.5 * NSEC_PER_SEC),  0.5 * NSEC_PER_SEC, 0);
    @weakify(self);
    dispatch_source_set_event_handler(self.backTimer, ^{
        @strongify(self);
        self.backCount ++;
        if (self.backCount == 4) {
            //数据全部解析完成,把所有数据缓存到本地
            moko_dispatch_main_safe(^{
                dispatch_cancel(self.backTimer);
                [self saveDataToLocal];
            });
            return;
        }
    });
    dispatch_resume(self.backTimer);
}

- (void)saveDataToLocal {
    [MKMUDatabaseManager clearDataTable];
    [[NSUserDefaults standardUserDefaults] setValue:SafeStr(self.totalSum) forKey:@"mu_recordDataTotalSumKey"];
    if (self.dataList.count == 0) {
        [[MKHudManager share] hide];
        [super leftButtonMethod];
        return;
    }
    [MKMUDatabaseManager insertDataList:self.dataList sucBlock:^{
        [[MKHudManager share] hide];
        [super leftButtonMethod];
    } failedBlock:^(NSError * _Nonnull error) {
        [[MKHudManager share] hide];
        [self.view showCentralToast:error.userInfo[@"errorInfo"]];
    }];
}

#pragma mark - 维持通信
- (void)addDataTimer {
    self.dataTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,dispatch_get_global_queue(0, 0));
    dispatch_source_set_timer(self.dataTimer, dispatch_walltime(NULL, 0),  dataTimerInterval * NSEC_PER_SEC, 0);
    @weakify(self);
    dispatch_source_set_event_handler(self.dataTimer, ^{
        @strongify(self);
        moko_dispatch_main_safe(^{
            [MKMUInterface mu_readThreeAxisWakeupConditionsWithSucBlock:nil failedBlock:nil];
        });
    });
    dispatch_resume(self.dataTimer);
}

#pragma mark - 刷新
- (void)addTimerForRefresh {
    self.parseTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,dispatch_get_global_queue(0, 0));
    dispatch_source_set_timer(self.parseTimer, dispatch_time(DISPATCH_TIME_NOW, parseDataInterval * NSEC_PER_SEC),  parseDataInterval * NSEC_PER_SEC, 0);
    @weakify(self);
    dispatch_source_set_event_handler(self.parseTimer, ^{
        @strongify(self);
        moko_dispatch_main_safe(^{
            [self parseContentDatas];
        });
    });
    dispatch_resume(self.parseTimer);
}

- (void)parseContentDatas {
    if (self.contentList.count == 0) {
        NSInteger tempNumber = self.dataList.count;
        if (ValidStr(self.totalSum) && [self.totalSum integerValue] == tempNumber) {
            //解析完成
            if (self.parseTimer) {
                dispatch_cancel(self.parseTimer);
            }
        }
        self.headerView.countLabel.text = [NSString stringWithFormat:@"Count: %ld",(long)tempNumber];
        return;
    }
    NSString *firstContent = self.contentList[0];
    NSArray *tempList = [self parseSynData:firstContent];
    [self.contentList removeObjectAtIndex:0];
    //业务需求最近的数据在最上面
    if (self.isMaxCount && self.dataList.count > 0) {
        for (NSDictionary *dic in tempList) {
            [self.dataList insertObject:dic atIndex:0];
        }
    }else {
        [self.dataList addObjectsFromArray:tempList];
    }
    NSInteger number = self.dataList.count;
    if (ValidStr(self.totalSum) && [self.totalSum integerValue] < number) {
        number = [self.totalSum integerValue];
    }
    self.headerView.countLabel.text = [NSString stringWithFormat:@"Count: %ld",(long)number];
    [self.tableView reloadData];
}

#pragma mark - UI
- (void)loadSubViews {
    self.defaultTitle = @"Local Data Sync";
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(self.view.mas_safeAreaLayoutGuideTop);
        make.bottom.mas_equalTo(self.view.mas_safeAreaLayoutGuideBottom);
    }];
}

#pragma mark - getter
- (MKBaseTableView *)tableView {
    if (!_tableView) {
        _tableView = [[MKBaseTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.backgroundColor = COLOR_WHITE_MACROS;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        _tableView.tableHeaderView = self.headerView;
    }
    return _tableView;
}

- (NSMutableArray *)dataList {
    if (!_dataList) {
        _dataList = [NSMutableArray array];
    }
    return _dataList;
}

- (NSMutableArray *)contentList {
    if (!_contentList) {
        _contentList = [NSMutableArray array];
    }
    return _contentList;
}

- (MKMUSynTableHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[MKMUSynTableHeaderView alloc] initWithFrame:CGRectMake(0, 0, kViewWidth, 100.f)];
        [_headerView.startButton addTarget:self
                                    action:@selector(startButtonPressed)
                          forControlEvents:UIControlEventTouchUpInside];
        [_headerView.synButton addTarget:self
                                  action:@selector(synButtonPressed)
                        forControlEvents:UIControlEventTouchUpInside];
        [_headerView.emptyButton addTarget:self
                                    action:@selector(emptyButtonPressed)
                          forControlEvents:UIControlEventTouchUpInside];
        [_headerView.exportButton addTarget:self
                                     action:@selector(exportButtonPressed)
                           forControlEvents:UIControlEventTouchUpInside];
    }
    return _headerView;
}

- (NSDateFormatter *)formatter {
    if (!_formatter) {
        _formatter = [[NSDateFormatter alloc] init];
        _formatter.dateFormat = @"YYYY/MM/dd hh:mm:ss";
    }
    return _formatter;
}

- (NSArray *)parseSynData:(NSString *)content {
    content = [content substringFromIndex:10];
    
    NSInteger index = 0;
    NSMutableArray *dataList = [NSMutableArray array];
    NSString *date = [self.formatter stringFromDate:[NSDate date]];
    for (NSInteger i = 0; i < content.length; i ++) {
        if (index >= content.length) {
            break;
        }
        NSInteger subLen = [MKBLEBaseSDKAdopter getDecimalWithHex:content range:NSMakeRange(index, 2)];
        index += 2;
        if (content.length < (index + subLen * 2)) {
            break;
        }
        NSString *subContent = [content substringWithRange:NSMakeRange(index, subLen * 2)];
        index += subLen * 2;
        NSDictionary *dic = @{
            @"date":date,
            @"rawData":subContent,
        };
        [dataList addObject:dic];
    }
    return dataList;
}

@end
