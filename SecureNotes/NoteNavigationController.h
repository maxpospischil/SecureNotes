//
//  NoteNavigationController.h
//  SecureNotes
//
//  Created by Maxwell Pospischil on 4/13/14.
//  Copyright (c) 2014 Max's Awesome App House. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NoteNavigationController : UINavigationController <UINavigationControllerDelegate>

@property (nonatomic, strong) NSString *username;

- (UIViewController *) popViewControllerAnimated:(BOOL) animated completion:(void (^)()) completion;

@end
