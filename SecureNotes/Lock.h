//
//  Lock.h
//  SecureNotes
//
//  Created by Maxwell Pospischil on 4/4/14.
//  Copyright (c) 2014 Max's Awesome App House. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Login.h"
#define MAXSEQUENCE 4
#define MAXSEQUENCEWITHCONFIRM 8

@interface Lock : NSObject

- (Login*)fetchUser:(NSString*)username
            context:(NSManagedObjectContext*)context;

- (BOOL)confirmLock:(NSArray *)confirmArrayX
             yArray:(NSArray *)confirmArrayY
           username:(NSString *)username;

- (void)eraseLockFromUser:(NSString *)username;

- (void)deleteUser:(NSString *)username;

- (Login *)returnUserLogin:(NSString *)username;

- (void)setLockWithPointandName:(CGPoint)point
                       username:(NSString*)username;

- (NSString*)getEncryptedStringFromPoint:(CGPoint)point;


@end
