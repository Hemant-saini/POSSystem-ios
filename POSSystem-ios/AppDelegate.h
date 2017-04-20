//
//  AppDelegate.h
//  POSSystem-ios
//
//  Created by Hemant Saini on 14/04/17.
//  Copyright © 2017 Hemant Saini. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

