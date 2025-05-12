//
//  MKFilterByOtherController.m
//  MKFilterPagesModule_Example
//
//  Created by aa on 2025/5/7.
//  Copyright © 2025 aadyx2007@163.com. All rights reserved.
//

#import "MKFilterByOtherController.h"

#import "Masonry.h"

#import "MLInputDodger.h"

#import "MKMacroDefines.h"
#import "MKBaseTableView.h"
#import "UIView+MKAdd.h"
#import "UITableView+MKAdd.h"

#import "MKHudManager.h"
#import "MKTextSwitchCell.h"
#import "MKTextButtonCell.h"
#import "MKTableSectionLineHeader.h"

#import "MKFilterByRawDataCell.h"
#import "MKFilterEditSectionHeaderView.h"

@interface MKFilterByOtherController ()<UITableViewDelegate,
UITableViewDataSource,
mk_textSwitchCellDelegate,
MKFilterEditSectionHeaderViewDelegate,
MKFilterByRawDataCellDelegate,
MKTextButtonCellDelegate>

@property (nonatomic, strong)MKBaseTableView *tableView;

@property (nonatomic, strong)NSMutableArray *section0List;

@property (nonatomic, strong)NSMutableArray *section1List;

@property (nonatomic, strong)NSMutableArray *section2List;

@end

@implementation MKFilterByOtherController

- (void)dealloc {
    NSLog(@"MKFilterByOtherController销毁");
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
    if (indexPath.section == 1) {
        return 110.f;
    }
    return 44.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        return 30.f;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        MKFilterEditSectionHeaderView *headerView = [MKFilterEditSectionHeaderView initHeaderViewWithTableView:tableView];
        MKFilterEditSectionHeaderViewModel *model = [[MKFilterEditSectionHeaderViewModel alloc] init];
        model.index = 0;
        model.msg = @"Edit Filter Condition";
        model.contentColor = COLOR_WHITE_MACROS;
        headerView.dataModel = model;
        headerView.delegate = self;
        return headerView;
    }
    MKTableSectionLineHeader *headerView = [MKTableSectionLineHeader initHeaderViewWithTableView:tableView];
    return headerView;
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
        return (self.section1List.count > 0 ? self.section2List.count : 0);
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
        MKFilterByRawDataCell *cell = [MKFilterByRawDataCell initCellWithTableView:tableView];
        cell.dataModel = self.section1List[indexPath.row];
        cell.delegate = self;
        return cell;
    }
    MKTextButtonCell *cell = [MKTextButtonCell initCellWithTableView:tableView];
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

#pragma mark - MKFilterEditSectionHeaderViewDelegate
/// 加号点击事件
/// @param index 所在index
- (void)mk_filterEditSectionHeaderView_addButtonPressed:(NSInteger)index {
    if (index != 0) {
        return;
    }
    if (self.section1List.count >= 3) {
        [self.view showCentralToast:@"You can set up to 3 filters!"];
        return;
    }
    NSInteger cellModelIndex = self.section1List.count;
    MKFilterByRawDataCellModel *cellModel = [[MKFilterByRawDataCellModel alloc] init];
    if (cellModelIndex == 0) {
        //Condition A
        cellModel.msg = @"Condition A";
    }else if (cellModelIndex == 1) {
        //Condition B
        cellModel.msg = @"Condition B";
    }else if (cellModelIndex == 2) {
        //Condition C
        cellModel.msg = @"Condition C";
    }
    cellModel.dataTypePlaceHolder = @"Data Type";
    cellModel.minTextFieldPlaceHolder = @"00-29";
    cellModel.maxTextFieldPlaceHolder = @"00-29";
    cellModel.rawTextFieldPlaceHolder = @"Raw Data Field";
    cellModel.index = cellModelIndex;
    [self.section1List addObject:cellModel];
    
    //更新底部逻辑关系选择
    MKTextButtonCellModel *relationshipModel = self.section2List[0];
    relationshipModel.dataList = [self loadFilterRelationshipList];
    relationshipModel.dataListIndex = cellModelIndex;
    
    [self.tableView reloadData];
    
}

/// 减号点击事件
/// @param index 所在index
- (void)mk_filterEditSectionHeaderView_subButtonPressed:(NSInteger)index {
    if (index != 0 || self.section1List.count == 0) {
        return;
    }
    [self.section1List removeLastObject];
    //更新底部逻辑关系选择
    NSArray *shipList = [self loadFilterRelationshipList];
    MKTextButtonCellModel *relationshipModel = self.section2List[0];
    relationshipModel.dataList = shipList;
    relationshipModel.dataListIndex = shipList.count - 1;
    
    [self.tableView reloadData];
}

#pragma mark - MKFilterByRawDataCellDelegate
/// 输入框内容发生改变
/// @param textType 哪个输入框发生改变了
/// @param index 当前cell所在的row
/// @param textValue 当前textField内容
- (void)mk_rawFilterDataChanged:(mk_filterByRawDataTextType)textType
                          index:(NSInteger)index
                      textValue:(NSString *)textValue {
    if (index >= self.section1List.count) {
        return;
    }
    MKFilterByRawDataCellModel *cellModel = self.section1List[index];
    if (textType == mk_filterByRawDataTextTypeDataType) {
        //过滤类型输入框内容发生改变
        cellModel.dataType = textValue;
        return;
    }
    if (textType == mk_filterByRawDataTextTypeMinIndex) {
        //开始过滤的Byte索引输入框发生改变
        cellModel.minIndex = textValue;
        return;
    }
    if (textType == mk_filterByRawDataTextTypeMaxIndex) {
        //截止过滤的Byte索引输入框发生改变
        cellModel.maxIndex = textValue;
        return;
    }
    if (textType == mk_filterByRawDataTextTypeRawDataType) {
        //过滤内容输入框发生改变
        cellModel.rawData = textValue;
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
    if (index == 0) {
        //Filter  Relationship
        MKTextButtonCellModel *cellModel = self.section2List[0];
        cellModel.dataListIndex = dataListIndex;
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
    NSMutableArray *list = [NSMutableArray array];
    for (NSInteger i = 0; i < self.section1List.count; i ++) {
        MKFilterByRawDataCellModel *cellModel = self.section1List[i];
        MKFilterRawAdvDataModel *model = [[MKFilterRawAdvDataModel alloc] init];
        model.dataType = cellModel.dataType;
        model.maxIndex = [cellModel.maxIndex integerValue];
        model.minIndex = [cellModel.minIndex integerValue];
        model.rawData = cellModel.rawData;
        if (![model validParams]) {
            [self.view showCentralToast:@"Filter by Raw Adv Data Params Error"];
            return;
        }
        [list addObject:model];
    }
    for (NSInteger i = 0; i < self.section1List.count; i ++) {
        MKFilterByRawDataCellModel *cellModel = self.section1List[i];
        if (!ValidStr(cellModel.dataType) || [cellModel.dataType isEqualToString:@"00"]) {
            cellModel.maxIndex = @"0";
            cellModel.minIndex = @"0";
        }
    }
    [self.tableView mk_reloadSection:1 withRowAnimation:UITableViewRowAnimationNone];
    [[MKHudManager share] showHUDWithTitle:@"Config..." inView:self.view isPenetration:NO];
    @weakify(self);
    [self.protocol configWithRawDataList:list relationship:[self loadCurrentRelationship] sucBlock:^{
        @strongify(self);
        [[MKHudManager share] hide];
        [self.view showCentralToast:@"Setup succeed!"];
    } failedBlock:^(NSError * _Nonnull error) {
        @strongify(self);
        [[MKHudManager share] hide];
        [self.view showCentralToast:error.userInfo[@"errorInfo"]];
    }];
}

#pragma mark - private method
- (NSArray *)loadFilterRelationshipList {
    if (self.section1List.count == 1) {
        return @[@"A"];
    }
    if (self.section1List.count == 2) {
        return @[@"A & B",@"A | B"];
    }
    if (self.section1List.count == 3) {
        return @[@"A & B & C",@"(A & B) | C",@"A | B | C",];
    }
    return @[];
}

- (NSInteger)loadFilterRelationshipIndex {
    if (self.section1List.count == 2 && self.protocol.relationship == 2) {
        //@[@"A & B",@"A | B"]
        //当前设备为A | B
        return 1;
    }
    if (self.section1List.count == 3) {
        //@[@"A & B & C",@"(A & B) | C",@"A | B | C"]
        //
        if (self.protocol.relationship == 4) {
            return 1;
        }
        if (self.protocol.relationship == 5) {
            return 2;
        }
    }
    return 0;
}

- (mk_filterByOther)loadCurrentRelationship {
    MKTextButtonCellModel *cellModel = self.section2List[0];
    if (self.section1List.count == 1) {
        //@[@"A"];
        return mk_filterByOther_A;
    }
    if (self.section1List.count == 2) {
        //@[@"A & B",@"A | B"]
        if (cellModel.dataListIndex == 0) {
            return mk_filterByOther_AB;
        }
        return mk_filterByOther_AOrB;
    }
    if (self.section1List.count == 3) {
        //@[@"A & B & C",@"(A & B) | C",@"A | B | C"]
        if (cellModel.dataListIndex == 0) {
            return mk_filterByOther_ABC;
        }
        if (cellModel.dataListIndex == 1) {
            return mk_filterByOther_ABOrC;
        }
        if (cellModel.dataListIndex == 2) {
            return mk_filterByOther_AOrBOrC;
        }
    }
    return mk_filterByOther_AOrBOrC;
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
    cellModel.msg = @"Other";
    cellModel.isOn = self.protocol.isOn;
    [self.section0List addObject:cellModel];
}

- (void)loadSection1Datas {
    for (NSInteger i = 0; i < self.protocol.rawDataList.count; i ++) {
        NSDictionary *dic = self.protocol.rawDataList[i];
        MKFilterByRawDataCellModel *cellModel = [[MKFilterByRawDataCellModel alloc] init];
        if (i == 0) {
            //Condition A
            cellModel.msg = @"Condition A";
        }else if (i == 1) {
            //Condition B
            cellModel.msg = @"Condition B";
        }else if (i == 2) {
            //Condition C
            cellModel.msg = @"Condition C";
        }
        cellModel.dataTypePlaceHolder = @"Data Type";
        if (ValidStr(dic[@"type"]) && [dic[@"type"] isEqualToString:@"00"]) {
            cellModel.dataType = @"";
        }else {
            cellModel.dataType = dic[@"type"];
        }
        cellModel.minTextFieldPlaceHolder = @"00-29";
        cellModel.minIndex = [NSString stringWithFormat:@"%@",dic[@"start"]];
        cellModel.maxTextFieldPlaceHolder = @"00-29";
        cellModel.maxIndex = [NSString stringWithFormat:@"%@",dic[@"end"]];
        cellModel.rawTextFieldPlaceHolder = @"Raw Data Field";
        cellModel.rawData = [SafeStr(dic[@"data"]) lowercaseString];
        cellModel.index = i;
        [self.section1List addObject:cellModel];
    }
}

- (void)loadSection2Datas {
    MKTextButtonCellModel *cellModle = [[MKTextButtonCellModel alloc] init];
    cellModle.index = 0;
    cellModle.msg = @"Filter Relationship";
    cellModle.dataList = [self loadFilterRelationshipList];
    cellModle.dataListIndex = [self loadFilterRelationshipIndex];
    [self.section2List addObject:cellModle];
}

#pragma mark - UI
- (void)loadSubViews {
    self.defaultTitle = self.protocol.pageTitle;
    [self.rightButton setImage:LOADICON(@"MKFilterPagesModule", @"MKFilterByOtherController", @"mk_filterPages_slotSaveIcon.png") forState:UIControlStateNormal];
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
