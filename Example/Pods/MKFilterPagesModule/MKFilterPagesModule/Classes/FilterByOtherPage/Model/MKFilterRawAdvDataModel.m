//
//  MKFilterRawAdvDataModel.m
//  MKFilterPagesModule_Example
//
//  Created by aa on 2025/5/12.
//  Copyright © 2025 lovexiaoxia. All rights reserved.
//

#import "MKFilterRawAdvDataModel.h"

#import "MKMacroDefines.h"
#import "NSString+MKAdd.h"


@implementation MKFilterRawAdvDataModel

- (BOOL)validParams {
    if (!ValidStr(self.dataType)) {
        //新需求，DataType为空等同于00，
        self.dataType = @"00";
    }
    if ([self.dataType isEqualToString:@"00"]) {
        self.minIndex = 0;
        self.maxIndex = 0;
    }
    if (!ValidStr(self.dataType) || self.dataType.length != 2 || ![self.dataType regularExpressions:isHexadecimal]) {
        return NO;
    }
    if (self.minIndex == 0 && self.maxIndex == 0) {
        if (!ValidStr(self.rawData) || self.rawData.length > 58 || ![self.rawData regularExpressions:isHexadecimal] || (self.rawData.length % 2 != 0)) {
            return NO;
        }
        return YES;
    }
    if (self.minIndex < 0 || self.minIndex > 29 || self.maxIndex < 0 || self.maxIndex > 29) {
        return NO;
    }
    if (self.minIndex == 0 && self.maxIndex != 0) {
        return NO;
    }
    if (self.maxIndex < self.minIndex) {
        return NO;
    }
    if (!ValidStr(self.rawData) || self.rawData.length > 58 || ![self.rawData regularExpressions:isHexadecimal]) {
        return NO;
    }
    NSInteger totalLen = (self.maxIndex - self.minIndex + 1) * 2;
    if (totalLen > 58 || self.rawData.length != totalLen) {
        return NO;
    }
    return YES;
}

@end
