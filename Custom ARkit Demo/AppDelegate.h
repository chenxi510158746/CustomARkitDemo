//
//  AppDelegate.h
//  Custom ARkit Demo
//
//  Created by chenxi on 2017/8/1.
//  Copyright © 2017年 BaiZe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

