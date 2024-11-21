//
//  MKMUAxisSettingController.m
//  MKLoRaWAN-MTE_Example
//
//  Created by aa on 2021/5/27.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import "MKMUAxisSettingController.h"

#import "Masonry.h"

#import "MKMacroDefines.h"
#import "MKBaseTableView.h"
#import "UIView+MKAdd.h"

#import "MKHudManager.h"
#import "MKTextFieldCell.h"

#import "MKMUAxisSettingDataModel.h"

@interface MKMUAxisSettingController ()<UITableViewDelegate,
UITableViewDataSource,
MKTextFieldCellDelegate>

@property (nonatomic, strong)MKBaseTableView *tableView;

@property (nonatomic, strong)NSMutableArray *section0List;

@property (nonatomic, strong)MKMUAxisSettingDataModel *dataModel;

@end

@implementation MKMUAxisSettingController

- (void)dealloc {
    NSLog(@"MKMUAxisSettingController销毁");
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
    return 44.f;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.section0List.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MKTextFieldCell *cell = [MKTextFieldCell initCellWithTableView:tableView];
    cell.dataModel = self.section0List[indexPath.row];
    cell.delegate = self;
    return cell;
}

#pragma mark - MKTextFieldCellDelegate
/// textField内容发送改变时的回调事件
/// @param index 当前cell所在的index
/// @param value 当前textField的值
- (void)mk_deviceTextCellValueChanged:(NSInteger)index textValue:(NSString *)value {
    MKTextFieldCellModel *cellModel = self.section0List[index];
    cellModel.textFieldValue = value;
    if (index == 0) {
        //Wakeup Threshold
        self.dataModel.wakeupThreshold = value;
        return;
    }
    if (index == 1) {
        //Wakeup Duration
        self.dataModel.wakeupDuration = value;
        return;
    }
    if (index == 2) {
        //Motion  Threshold
        self.dataModel.motionThreshold = value;
        return;
    }
    if (index == 3) {
        //Motion  Duration
        self.dataModel.motionDuration = value;
        return;
    }
}

#pragma mark - interface
- (void)readDataFromDevice {
    [[MKHudManager share] showHUDWithTitle:@"Reading..." inView:self.view isPenetration:NO];
    @weakify(self);
    [self.dataModel readWithSucBlock:^{
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
    [self.dataModel configWithSucBlock:^{
        @strongify(self);
        [[MKHudManager share] hide];
        [self.view showCentralToast:@"Success"];
    } failedBlock:^(NSError * _Nonnull error) {
        @strongify(self);
        [[MKHudManager share] hide];
        [self.view showCentralToast:error.userInfo[@"errorInfo"]];
    }];
}

#pragma mark - loadSectionDatas
- (void)loadSectionDatas {
    [self loadSection0Datas];
    
    [self.tableView reloadData];
}

- (void)loadSection0Datas {
    MKTextFieldCellModel *cellModel1 = [[MKTextFieldCellModel alloc] init];
    cellModel1.index = 0;
    cellModel1.msg = @"Wakeup Threshold";
    cellModel1.textPlaceholder = @"1~20";
    cellModel1.textFieldType = mk_realNumberOnly;
    cellModel1.maxLength = 2;
    cellModel1.unit = @"x16mg";
    cellModel1.textFieldValue = self.dataModel.wakeupThreshold;
    [self.section0List addObject:cellModel1];
    
    MKTextFieldCellModel *cellModel2 = [[MKTextFieldCellModel alloc] init];
    cellModel2.index = 1;
    cellModel2.msg = @"Wakeup Duration";
    cellModel2.textPlaceholder = @"1~10";
    cellModel2.textFieldType = mk_realNumberOnly;
    cellModel2.maxLength = 2;
    cellModel2.unit = @"x10ms";
    cellModel2.textFieldValue = self.dataModel.wakeupDuration;
    [self.section0List addObject:cellModel2];
    
    MKTextFieldCellModel *cellModel3 = [[MKTextFieldCellModel alloc] init];
    cellModel3.index = 2;
    cellModel3.msg = @"Motion Threshold";
    cellModel3.textPlaceholder = @"10~250";
    cellModel3.textFieldType = mk_realNumberOnly;
    cellModel3.maxLength = 3;
    cellModel3.unit = @"x2mg";
    cellModel3.textFieldValue = self.dataModel.motionThreshold;
    [self.section0List addObject:cellModel3];
    
    MKTextFieldCellModel *cellModel4 = [[MKTextFieldCellModel alloc] init];
    cellModel4.index = 3;
    cellModel4.msg = @"Motion  Duration";
    cellModel4.textPlaceholder = @"1~50";
    cellModel4.textFieldType = mk_realNumberOnly;
    cellModel4.maxLength = 2;
    cellModel4.unit = @"x5ms";
    cellModel4.textFieldValue = self.dataModel.motionDuration;
    [self.section0List addObject:cellModel4];
    
    [self.tableView reloadData];
}

#pragma mark - UI
- (void)loadSubViews {
    self.defaultTitle = @"3-Axis Settings";
    [self.rightButton setImage:LOADICON(@"MKLoRaWAN-MTE", @"MKMUAxisSettingController", @"mu_slotSaveIcon.png") forState:UIControlStateNormal];
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
        _tableView.backgroundColor = RGBCOLOR(242, 242, 242);
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

- (MKMUAxisSettingDataModel *)dataModel {
    if (!_dataModel) {
        _dataModel = [[MKMUAxisSettingDataModel alloc] init];
    }
    return _dataModel;
}

@end
