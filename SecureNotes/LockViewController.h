//
//  SetLockViewController.h
//  SecureNotes
//
//  Created by Maxwell Pospischil on 4/4/14.
//  Copyright (c) 2014 Max's Awesome App House. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Lock.h"
#import "InstructionViewController.h"

@interface LockViewController : UIViewController

@property (strong, nonatomic) Lock *lock;
@property (nonatomic) NSString *kindOfLock;
@property (nonatomic) NSString *username;

@end
