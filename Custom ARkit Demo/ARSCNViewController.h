//
//  ARSCNViewController.h
//  Custom ARkit Demo
//
//  Created by chenxi on 2017/8/1.
//  Copyright © 2017年 BaiZe. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_OPTIONS(NSInteger, ReturnType) {
    Unknown = 0,
    ARTypeStart = 1 << 1,
    ARTypePlane = 1 << 2,
    ARTypeMove = 1 << 3,
    ARTypeMoon = 1 << 4,
};

@interface ARSCNViewController : UIViewController
{
    NSInteger _arType;
}

@property (nonatomic, assign) NSInteger arType;

@end
