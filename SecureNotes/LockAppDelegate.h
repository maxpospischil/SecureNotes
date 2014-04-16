//
//  LockAppDelegate.h
//  SecureNotes
//
//  Created by Maxwell Pospischil on 4/4/14.
//  Copyright (c) 2014 Max's Awesome App House. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LockAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property(strong, nonatomic) NSString *currentUsername;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
