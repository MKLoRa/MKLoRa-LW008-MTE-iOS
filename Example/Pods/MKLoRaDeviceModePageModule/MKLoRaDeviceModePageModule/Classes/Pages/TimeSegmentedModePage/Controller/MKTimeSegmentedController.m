//
//  MKTimeSegmentedController.m
//  MKLoRaDeviceModePageModule_Example
//
//  Created by aa on 2024/11/21.
//  Copyright © 2024 lovexiaoxia. All rights reserved.
//

#import "MKTimeSegmentedController.h"

#import "Masonry.h"

#import "MKMacroDefines.h"
#import "MKBaseTableView.h"
#import "UIView+MKAdd.h"
#import "UITableView+MKAdd.h"

#import "MKHudManager.h"
#import "MKTextButtonCell.h"
#import "MKPickerView.h"

#import "MKTimeSegmentedCell.h"
#import "MKTimeSegmentedAddCell.h"

@interface MKTimeSegmentedController ()<UITableViewDelegate,
UITableViewDataSource,
MKTextButtonCellDelegate,
MKTimeSegmentedAddCellDelegate,
MKTimeSegmentedCellDelegate>

@property (nonatomic, strong)MKBaseTableView *tableView;

@property (nonatomic, strong)NSMutableArray *section0List;

@property (nonatomic, strong)NSMutableArray *section1List;

@property (nonatomic, strong)NSMutableArray *section2List;

@end

@implementation MKTimeSegmentedController

- (void)dealloc {
    NSLog(@"MKTimeSegmentedController销毁");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadSubViews];
    [self readDataFromDevice];
}

#pragma mark - super method
- (void)rightButtonMethod {
    [self saveDataToDevice];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 44.f;
    }
    if (indexPath.section == 1) {
        return 80.f;
    }
    return 110.f;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return self.section0List.count;
    }
    if (section == 1) {
        return self.section1List.count;
    }
    return self.section2List.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        MKTextButtonCell *cell = [MKTextButtonCell initCellWithTableView:tableView];
        cell.dataModel = self.section0List[indexPath.row];
        cell.delegate = self;
        return cell;
    }
    
    if (indexPath.section == 1) {
        MKTimeSegmentedAddCell *cell = [MKTimeSegmentedAddCell initCellWithTableView:tableView];
        cell.dataModel = self.section1List[indexPath.row];
        cell.delegate = self;
        return cell;
    }
    MKTimeSegmentedCell *cell = [MKTimeSegmentedCell initCellWithTableView:tableView];
    cell.dataModel = self.section2List[indexPath.row];
    cell.delegate = self;
    [cell resetFlagForFrame];
    return cell;
}

#pragma mark - MKTextButtonCellDelegate
/// 右侧按钮点击触发的回调事件
/// @param index 当前cell所在的index
/// @param dataListIndex 点击按钮选中的dataList里面的index
/// @param value dataList[dataListIndex]
- (void)mk_loraTextButtonCellSelected:(NSInteger)index
                        dataListIndex:(NSInteger)dataListIndex
                                value:(NSString *)value {
    if (index == 0) {
        //Positioning Strategy
        MKTextButtonCellModel *cellModel = self.section0List[0];
        cellModel.dataListIndex = dataListIndex;
        self.protocol.strategy = dataListIndex;
        return;
    }
}

#pragma mark - MKTimeSegmentedAddCellDelegate
- (void)mk_timeSegmentedAddCell_addPressed {
    if (self.section2List.count >= 10) {
        //最多10组
        [self.view showCentralToast:@"You can set up to 10 time points!"];
        return;
    }
    MKTimeSegmentedCellModel *cellModel = [[MKTimeSegmentedCellModel alloc] init];
    cellModel.index = self.section2List.count;
    cellModel.startHour = 0;
    cellModel.startMinuteGear = 0;
    cellModel.endHour = 0;
    cellModel.endMinuteGear = 0;
    cellModel.interval = @"600";
    [self.section2List addObject:cellModel];
    
    [self.tableView mk_reloadSection:2 withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark - MKTimeSegmentedCellDelegate
/**
 删除
 
 @param index 所在index
 */
- (void)mk_timeSegmentedCell_deleteButtonPressed:(NSInteger)index {
    if (index > self.section2List.count - 1) {
        return;
    }
    [self.section2List removeObjectAtIndex:index];
    
    for (NSInteger i = 0; i < self.section2List.count; i ++) {
        MKTimeSegmentedCellModel *cellModel = self.section2List[i];
        cellModel.index = i;
    }
    
    [self.tableView mk_reloadSection:2 withRowAnimation:UITableViewRowAnimationNone];
}

/// Hour按钮选择
/// - Parameters:
///   - index: 当前cell所在index
///   - start: 起始时间还是结束时间
///   - hour: 当前选择的hour
- (void)mk_timeSegmentedCell_hourButtonPressed:(NSInteger)index start:(BOOL)start hour:(NSInteger)hour {
    if (![self cellCanSelected]) {
        return;
    }
    MKTimeSegmentedCellModel *cellModel = self.section2List[index];
    if (start) {
        cellModel.startHour = hour;
    }else {
        cellModel.endHour = hour;
    }
}

/// Minute按钮选择
/// - Parameters:
///   - index: 当前cell所在index
///   - start: 起始时间还是结束时间
///   - hour: 当前选择的minuteGear
- (void)mk_timeSegmentedCell_minuteGearButtonPressed:(NSInteger)index start:(BOOL)start minuteGear:(NSInteger)minuteGear {
    if (![self cellCanSelected]) {
        return;
    }
    MKTimeSegmentedCellModel *cellModel = self.section2List[index];
    if (start) {
        cellModel.startMinuteGear = minuteGear;
    }else {
        cellModel.endMinuteGear = minuteGear;
    }
}

/**
 重新设置cell的子控件位置，主要是删除按钮方面的处理
 */
- (void)mk_cellResetFrame {
    [self cellCanSelected];
}

- (void)mk_cellTapAction {
    [self cellCanSelected];
}

#pragma mark - interface
- (void)readDataFromDevice {
    [[MKHudManager share] showHUDWithTitle:@"Reading..." inView:self.view isPenetration:NO];
    @weakify(self);
    [self.protocol readDataWithSucBlock:^{
        @strongify(self);
        [[MKHudManager share] hide];
        [self loadSectionDatas];
    } failedBlock:^(NSError * _Nonnull error) {
        @strongify(self);
        [[MKHudManager share] hide];
        [self.view showCentralToast:error.userInfo[@"errorInfo"]];
    }];
}

- (void)saveDataToDevice {
    NSMutableArray *tempList = [NSMutableArray array];
    for (NSInteger i = 0; i < self.section2List.count; i ++) {
        MKTimeSegmentedCellModel *cellModel = self.section2List[i];
        if (!ValidStr(cellModel.interval)) {
            [self.view showCentralToast:@"Report Interval cannot be empty!"];
            return;
        }
        MKTimeSegmentedTimePeriodModel *pointModel = [[MKTimeSegmentedTimePeriodModel alloc] init];
        pointModel.startHour = cellModel.startHour;
        if (cellModel.startHour == 24) {
            pointModel.startMinuteGear = 0;
        }else {
            pointModel.startMinuteGear = cellModel.startMinuteGear;
        }
        
        pointModel.endHour = cellModel.endHour;
        if (cellModel.endHour == 24) {
            pointModel.endMinuteGear = 0;
        }else {
            pointModel.endMinuteGear = cellModel.endMinuteGear;
        }
        
        pointModel.interval = [cellModel.interval integerValue];
        [tempList addObject:pointModel];
    }
    [[MKHudManager share] showHUDWithTitle:@"Config..." inView:self.view isPenetration:NO];
    @weakify(self);
    [self.protocol configData:tempList sucBlock:^{
        @strongify(self);
        [[MKHudManager share] hide];
        [self.view showCentralToast:@"Success"];
    } failedBlock:^(NSError * _Nonnull error) {
        @strongify(self);
        [[MKHudManager share] hide];
        [self.view showCentralToast:error.userInfo[@"errorInfo"]];
    }];
}

#pragma mark - private method
/**
 当有cell右侧的删除按钮出现时，不能触发点击事件
 
 @return YES可点击，NO不可点击
 */
- (BOOL)cellCanSelected{
    BOOL canSelected = YES;
    NSArray *arrCells = [self.tableView visibleCells];
    for (int i = 0; i < [arrCells count]; i++) {
        UITableViewCell *cell = arrCells[i];
        if ([cell isKindOfClass:MKTimeSegmentedCell.class]) {
            MKTimeSegmentedCell *tempCell = (MKTimeSegmentedCell *)cell;
            if ([tempCell canReset]) {
                [tempCell resetCellFrame];
                canSelected = NO;
            }
        }
    }
    return canSelected;
}

#pragma mark - loadSectionDatas
- (void)loadSectionDatas {
    [self loadSection0Datas];
    [self loadSection1Datas];
    [self loadSection2Datas];
    
    [self.tableView reloadData];
}

- (void)loadSection0Datas {
    MKTextButtonCellModel *cellModel = [[MKTextButtonCellModel alloc] init];
    cellModel.index = 0;
    cellModel.msg = @"Positioning Strategy";
    cellModel.dataList = @[@"BLE",@"GPS",@"BLE+GPS",@"BLE*GPS",@"BLE&GPS"];
    cellModel.dataListIndex = self.protocol.strategy;
    [self.section0List addObject:cellModel];
}

- (void)loadSection1Datas {
    MKTimeSegmentedAddCellModel *cellModel = [[MKTimeSegmentedAddCellModel alloc] init];
    cellModel.msg = @"Time Period Setting";
    [self.section1List addObject:cellModel];
}

- (void)loadSection2Datas {
    for (NSInteger i = 0; i < self.protocol.pointList.count; i ++) {
        MKTimeSegmentedTimePeriodModel *tempModel = self.protocol.pointList[i];
        MKTimeSegmentedCellModel *cellModel = [[MKTimeSegmentedCellModel alloc] init];
        cellModel.index = i;
        cellModel.startHour = tempModel.startHour;
        cellModel.startMinuteGear = tempModel.startMinuteGear;
        cellModel.endHour = tempModel.endHour;
        cellModel.endMinuteGear = tempModel.endMinuteGear;
        cellModel.interval = [NSString stringWithFormat:@"%@",@(tempModel.interval)];
        [self.section2List addObject:cellModel];
    }
}

#pragma mark - UI
- (void)loadSubViews {
    self.defaultTitle = @"Time-Segmented Mode";
    [self.rightButton setImage:LOADICON(@"MKLoRaDeviceModePageModule", @"MKTimeSegmentedController", @"mk_loraDeviceMode_slotSaveIcon.png") forState:UIControlStateNormal];
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
    }
    return _tableView;
}

- (NSMutableArray *)section0List {
    if (!_section0List) {
        _section0List = [NSMutableArray array];
    }
    return _section0List;
}

- (NSMutableArray *)section1List {
    if (!_section1List) {
        _section1List = [NSMutableArray array];
    }
    return _section1List;
}

- (NSMutableArray *)section2List {
    if (!_section2List) {
        _section2List = [NSMutableArray array];
    }
    return _section2List;
}

@end
