//
//  MKMUTabBarController.m
//  MKLoRaWAN-MTE_Example
//
//  Created by aa on 2024/7/2.
//  Copyright © 2024 aadyx2007@163.com. All rights reserved.
//

#import "MKMUTabBarController.h"

#import "MKMacroDefines.h"
#import "MKBaseNavigationController.h"

#import "MKAlertView.h"

#import "MKMULoRaController.h"
#import "MKMUPositionController.h"
#import "MKMUGeneralController.h"
#import "MKMUDeviceSettingController.h"

#import "MKMUCentralManager.h"

@interface MKMUTabBarController ()

/// 当触发
/// 01:表示连接成功后，1分钟内没有通过密码验证（未输入密码，或者连续输入密码错误）认为超时，返回结果， 然后断开连接
/// 02:修改密码成功后，返回结果，断开连接
/// 03:连续三分钟设备没有数据通信断开，返回结果，断开连接
/// 04:重启设备，就不需要显示断开连接的弹窗了，只需要显示对应的弹窗
/// 05:设备恢复出厂设置
@property (nonatomic, assign)BOOL disconnectType;

/// 产品要求，进入debugger模式之后，设备断开连接也要停留在当前页面，只有退出debugger模式才进行正常模式通信
@property (nonatomic, assign)BOOL isDebugger;

@end

@implementation MKMUTabBarController

- (void)dealloc {
    NSLog(@"MKMUTabBarController销毁");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    if (![[self.navigationController viewControllers] containsObject:self]){
        [[MKMUCentralManager shared] disconnect];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadSubPages];
    [self addNotifications];
}

- (void)addNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(gotoScanPage)
                                                 name:@"mk_mu_popToRootViewControllerNotification"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(dfuUpdateComplete)
                                                 name:@"mk_mu_centralDeallocNotification"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(centralManagerStateChanged)
                                                 name:mk_mu_centralManagerStateChangedNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(disconnectTypeNotification:)
                                                 name:mk_mu_deviceDisconnectTypeNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(deviceConnectStateChanged)
                                                 name:mk_mu_peripheralConnectStateChangedNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(deviceEnterDebuggerMode)
                                                 name:@"mk_mu_startDebuggerMode"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(deviceStopDebuggerMode)
                                                 name:@"mk_mu_stopDebuggerMode"
                                               object:nil];
}

#pragma mark - notes
- (void)gotoScanPage {
    @weakify(self);
    [self dismissViewControllerAnimated:YES completion:^{
        @strongify(self);
        if ([self.delegate respondsToSelector:@selector(mk_mu_needResetScanDelegate:)]) {
            [self.delegate mk_mu_needResetScanDelegate:NO];
        }
    }];
}

- (void)dfuUpdateComplete {
    @weakify(self);
    [self dismissViewControllerAnimated:YES completion:^{
        @strongify(self);
        if ([self.delegate respondsToSelector:@selector(mk_mu_needResetScanDelegate:)]) {
            [self.delegate mk_mu_needResetScanDelegate:YES];
        }
    }];
}

- (void)disconnectTypeNotification:(NSNotification *)note {
    NSString *type = note.userInfo[@"type"];
    /// 02:连续三分钟设备没有数据通信断开，返回结果，断开连接
    /// 03:修改密码成功后，返回结果，断开连接
    /// 04:重启设备，就不需要显示断开连接的弹窗了，只需要显示对应的弹窗
    /// 05:设备恢复出厂设置
    self.disconnectType = YES;
    if ([type isEqualToString:@"02"]) {
        [self showAlertWithMsg:@"Password changed successfully! Please reconnect the device." title:@"Change Password"];
        return;
    }
    if ([type isEqualToString:@"03"]) {
        [self showAlertWithMsg:@"No data communication for 3 minutes, the device is disconnected." title:@""];
        return;
    }
    if ([type isEqualToString:@"04"]) {
        [self showAlertWithMsg:@"Reboot successfully!Please reconnect the device." title:@"Dismiss"];
        return;
    }
    if ([type isEqualToString:@"05"]) {
        [self showAlertWithMsg:@"Factory reset successfully!Please reconnect the device." title:@"Factory Reset"];
        return;
    }
    //异常断开
    NSString *msg = [NSString stringWithFormat:@"Device disconnected for unknown reason.(%@)",type];
    [self showAlertWithMsg:msg title:@"Dismiss"];
}

- (void)centralManagerStateChanged{
    if (self.disconnectType) {
        return;
    }
    if ([MKMUCentralManager shared].centralStatus != mk_mu_centralManagerStatusEnable) {
        [self showAlertWithMsg:@"The current system of bluetooth is not available!" title:@"Dismiss"];
    }
}

- (void)deviceConnectStateChanged {
     if (self.disconnectType) {
        return;
    }
    [self showAlertWithMsg:@"The device is disconnected." title:@"Dismiss"];
    return;
}

- (void)deviceEnterDebuggerMode {
    self.isDebugger = YES;
}

- (void)deviceStopDebuggerMode {
    self.isDebugger = NO;
}

#pragma mark - private method
- (void)showAlertWithMsg:(NSString *)msg title:(NSString *)title{
    //让setting页面推出的alert消失
    [[NSNotificationCenter defaultCenter] postNotificationName:@"mk_mu_needDismissAlert" object:nil];
    //让所有MKPickView消失
    [[NSNotificationCenter defaultCenter] postNotificationName:@"mk_customUIModule_dismissPickView" object:nil];
    
    @weakify(self);
    MKAlertViewAction *confirmAction = [[MKAlertViewAction alloc] initWithTitle:@"OK" handler:^{
        @strongify(self);
        if (!self.isDebugger) {
            [self gotoScanPage];
        }
    }];
    MKAlertView *alertView = [[MKAlertView alloc] init];
    [alertView addAction:confirmAction];
    [alertView showAlertWithTitle:title message:msg notificationName:@"mk_mu_needDismissAlert"];
}

- (void)loadSubPages {
    MKMULoRaController *loraPage = [[MKMULoRaController alloc] init];
    loraPage.tabBarItem.title = @"LORA";
    loraPage.tabBarItem.image = LOADICON(@"MKLoRaWAN-MTE", @"MKMUTabBarController", @"mu_lora_tabBarUnselected.png");
    loraPage.tabBarItem.selectedImage = LOADICON(@"MKLoRaWAN-MTE", @"MKMUTabBarController", @"mu_lora_tabBarSelected.png");
    MKBaseNavigationController *advNav = [[MKBaseNavigationController alloc] initWithRootViewController:loraPage];

    MKMUPositionController *positionPage = [[MKMUPositionController alloc] init];
    positionPage.tabBarItem.title = @"POSITION";
    positionPage.tabBarItem.image = LOADICON(@"MKLoRaWAN-MTE", @"MKMUTabBarController", @"mu_position_tabBarUnselected.png");
    positionPage.tabBarItem.selectedImage = LOADICON(@"MKLoRaWAN-MTE", @"MKMUTabBarController", @"mu_position_tabBarSelected.png");
    MKBaseNavigationController *positionNav = [[MKBaseNavigationController alloc] initWithRootViewController:positionPage];

    MKMUGeneralController *settingPage = [[MKMUGeneralController alloc] init];
    settingPage.tabBarItem.title = @"GENERAL";
    settingPage.tabBarItem.image = LOADICON(@"MKLoRaWAN-MTE", @"MKMUTabBarController", @"mu_setting_tabBarUnselected.png");
    settingPage.tabBarItem.selectedImage = LOADICON(@"MKLoRaWAN-MTE", @"MKMUTabBarController", @"mu_setting_tabBarSelected.png");
    MKBaseNavigationController *settingNav = [[MKBaseNavigationController alloc] initWithRootViewController:settingPage];
    
    MKMUDeviceSettingController *deviceInfo = [[MKMUDeviceSettingController alloc] init];
    deviceInfo.tabBarItem.title = @"DEVICE";
    deviceInfo.tabBarItem.image = LOADICON(@"MKLoRaWAN-MTE", @"MKMUTabBarController", @"mu_device_tabBarUnselected.png");
    deviceInfo.tabBarItem.selectedImage = LOADICON(@"MKLoRaWAN-MTE", @"MKMUTabBarController", @"mu_device_tabBarSelected.png");
    MKBaseNavigationController *deviceInfoPage = [[MKBaseNavigationController alloc] initWithRootViewController:deviceInfo];
    
    self.viewControllers = @[advNav,positionNav,settingNav,deviceInfoPage];
}

@end
