//
//  MKFilterByPirController.m
//  MKFilterPagesModule_Example
//
//  Created by aa on 2025/5/7.
//  Copyright © 2025 aadyx2007@163.com. All rights reserved.
//

#import "MKFilterByPirController.h"

#import "Masonry.h"

#import "MLInputDodger.h"

#import "MKMacroDefines.h"
#import "MKBaseTableView.h"
#import "UIView+MKAdd.h"
#import "NSString+MKAdd.h"

#import "MKHudManager.h"
#import "MKTextSwitchCell.h"
#import "MKTextButtonCell.h"

#import "MKFilterBeaconCell.h"

@interface MKFilterByPirController ()<UITableViewDelegate,
UITableViewDataSource,
mk_textSwitchCellDelegate,
MKTextButtonCellDelegate,
MKFilterBeaconCellDelegate>

@property (nonatomic, strong)MKBaseTableView *tableView;

@property (nonatomic, strong)NSMutableArray *section0List;

@property (nonatomic, strong)NSMutableArray *section1List;

@property (nonatomic, strong)NSMutableArray *section2List;

@end

@implementation MKFilterByPirController

- (void)dealloc {
    NSLog(@"MKFilterByPirController销毁");
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.view.shiftHeightAsDodgeViewForMLInputDodger = 50.0f;
    [self.view registerAsDodgeViewForMLInputDodgerWithOriginalY:self.view.frame.origin.y];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadSubViews];
    [self readDataFromDevice];
}

#pragma mark - super method
- (void)rightButtonMethod {
    [self configDataToDevice];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 2) {
        return 70.f;
    }
    return 44.f;
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
    if (section == 2) {
        return self.section2List.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        MKTextSwitchCell *cell = [MKTextSwitchCell initCellWithTableView:tableView];
        cell.dataModel = self.section0List[indexPath.row];
        cell.delegate = self;
        return cell;
    }
    if (indexPath.section == 1) {
        MKTextButtonCell *cell = [MKTextButtonCell initCellWithTableView:tableView];
        cell.dataModel = self.section1List[indexPath.row];
        cell.delegate = self;
        return cell;
    }
    MKFilterBeaconCell *cell = [MKFilterBeaconCell initCellWithTableView:tableView];
    cell.dataModel = self.section2List[indexPath.row];
    cell.delegate = self;
    return cell;
}

#pragma mark - mk_textSwitchCellDelegate
/// 开关状态发生改变了
/// @param isOn 当前开关状态
/// @param index 当前cell所在的index
- (void)mk_textSwitchCellStatusChanged:(BOOL)isOn index:(NSInteger)index {
    if (index == 0) {
        //
        self.protocol.isOn = isOn;
        MKTextSwitchCellModel *cellModel = self.section0List[0];
        cellModel.isOn = isOn;
        return;
    }
}

#pragma mark - MKTextButtonCellDelegate
/// 右侧按钮点击触发的回调事件
/// @param index 当前cell所在的index
/// @param dataListIndex 点击按钮选中的dataList里面的index
/// @param value dataList[dataListIndex]
- (void)mk_loraTextButtonCellSelected:(NSInteger)index
                        dataListIndex:(NSInteger)dataListIndex
                                value:(NSString *)value {
    MKTextButtonCellModel *cellModel = self.section1List[index];
    if (index == 0) {
        //Delay Response Status
        self.protocol.delayStatus = dataListIndex;
        return;
    }
    if (index == 1) {
        //Door Open/Close Status
        self.protocol.doorStatus = dataListIndex;
        return;
    }
    if (index == 2) {
        //Sensor Sensitivity
        self.protocol.sensitivity = dataListIndex;
        return;
    }
    if (index == 3) {
        //Detection Status
        self.protocol.detection = dataListIndex;
        return;
    }
}

#pragma mark - MKFilterBeaconCellDelegate
- (void)mk_beaconMinValueChanged:(NSString *)value index:(NSInteger)index {
    MKFilterBeaconCellModel *cellModel = self.section2List[index];
    cellModel.minValue = value;
    if (index == 0) {
        //Major
        self.protocol.minMajor = value;
        return;
    }
    if (index == 1) {
        //Minor
        self.protocol.minMinor = value;
        return;
    }
}

- (void)mk_beaconMaxValueChanged:(NSString *)value index:(NSInteger)index {
    MKFilterBeaconCellModel *cellModel = self.section2List[index];
    cellModel.maxValue = value;
    if (index == 0) {
        //Major
        self.protocol.maxMajor = value;
        return;
    }
    if (index == 1) {
        //Minor
        self.protocol.maxMinor = value;
        return;
    }
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

- (void)configDataToDevice {
    [[MKHudManager share] showHUDWithTitle:@"Config..." inView:self.view isPenetration:NO];
    @weakify(self);
    [self.protocol configDataWithSucBlock:^{
        @strongify(self);
        [[MKHudManager share] hide];
        [self.view showCentralToast:@"Setup succeed!"];
    } failedBlock:^(NSError * _Nonnull error) {
        @strongify(self);
        [[MKHudManager share] hide];
        [self.view showCentralToast:error.userInfo[@"errorInfo"]];
    }];
}

#pragma mark - loadSectionDatas
- (void)loadSectionDatas {
    [self loadSection0Datas];
    [self loadSection1Datas];
    [self loadSection2Datas];
    
    [self.tableView reloadData];
}

- (void)loadSection0Datas {
    MKTextSwitchCellModel *cellModel = [[MKTextSwitchCellModel alloc] init];
    cellModel.index = 0;
    cellModel.msg = @"MK-PIR";
    cellModel.isOn = self.protocol.isOn;
    [self.section0List addObject:cellModel];
}

- (void)loadSection1Datas {
    MKTextButtonCellModel *cellModel1 = [[MKTextButtonCellModel alloc] init];
    cellModel1.index = 0;
    cellModel1.msg = @"Delay Response Status";
    cellModel1.dataList = @[@"Low delay",@"Medium delay",@"High delay",@"All"];
    cellModel1.dataListIndex = self.protocol.delayStatus;
    [self.section1List addObject:cellModel1];
    
    MKTextButtonCellModel *cellModel2 = [[MKTextButtonCellModel alloc] init];
    cellModel2.index = 1;
    cellModel2.msg = @"Door Open/Close Status";
    cellModel2.dataList = @[@"Close",@"Open",@"All"];
    cellModel2.dataListIndex = self.protocol.doorStatus;
    [self.section1List addObject:cellModel2];
    
    MKTextButtonCellModel *cellModel3 = [[MKTextButtonCellModel alloc] init];
    cellModel3.index = 2;
    cellModel3.msg = @"Sensor Sensitivity";
    cellModel3.dataList = @[@"Low",@"Medium",@"High",@"All"];
    cellModel3.dataListIndex = self.protocol.sensitivity;
    [self.section1List addObject:cellModel3];
    
    MKTextButtonCellModel *cellModel4 = [[MKTextButtonCellModel alloc] init];
    cellModel4.index = 3;
    cellModel4.msg = @"Detection Status";
    cellModel4.dataList = @[@"No motion detected",@"Motion detected",@"All"];
    cellModel4.dataListIndex = self.protocol.detection;
    cellModel4.buttonLabelFont = MKFont(13.f);
    [self.section1List addObject:cellModel4];
}

- (void)loadSection2Datas {
    MKFilterBeaconCellModel *cellModel1 = [[MKFilterBeaconCellModel alloc] init];
    cellModel1.index = 0;
    cellModel1.msg = @"MK-PIR Major";
    cellModel1.minValue = self.protocol.minMajor;
    cellModel1.maxValue = self.protocol.maxMajor;
    [self.section2List addObject:cellModel1];
    
    MKFilterBeaconCellModel *cellModel2 = [[MKFilterBeaconCellModel alloc] init];
    cellModel2.index = 1;
    cellModel2.msg = @"MK-PIR Minor";
    cellModel2.minValue = self.protocol.minMinor;
    cellModel2.maxValue = self.protocol.maxMinor;
    [self.section2List addObject:cellModel2];
}

#pragma mark - UI
- (void)loadSubViews {
    self.defaultTitle = self.protocol.pageTitle;
    [self.rightButton setImage:LOADICON(@"MKFilterPagesModule", @"MKFilterByPirController", @"mk_filterPages_slotSaveIcon.png") forState:UIControlStateNormal];
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
