//
//  RegistrationViewController.h
//  SecureNotes
//
//  Created by Maxwell Pospischil on 4/7/14.
//  Copyright (c) 2014 Max's Awesome App House. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LockViewController.h"
#import "Login.h"

@interface RegistrationViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UIButton *createUser;
@property (weak, nonatomic) IBOutlet UILabel *tryAgainLabel;


@end
