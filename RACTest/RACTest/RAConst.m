//
//  RAConst.m
//  RACTest
//
//  Created by KnowChat03 on 2019/10/8.
//  Copyright © 2019 KnowChat03. All rights reserved.
//

#import "RAConst.h"

UIEdgeInsets IPHONEX_INSETS() {
    if (@available(iOS 11.0, *)) {
        return (UIApplication.sharedApplication.keyWindow == nil || UIApplication.sharedApplication.keyWindow.safeAreaInsets.top == 0)? UIEdgeInsetsMake(UIApplication.sharedApplication.statusBarFrame.size.height, 0, 0, 0):UIApplication.sharedApplication.keyWindow.safeAreaInsets;
    } else {
        return UIEdgeInsetsMake(UIApplication.sharedApplication.statusBarFrame.size.height, 0, 0, 0);
    }
}

@implementation RAConst

@end
