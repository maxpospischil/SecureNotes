//
//  ImagePickerViewController.h
//  SecureNotes
//
//  Created by Maxwell Pospischil on 4/15/14.
//  Copyright (c) 2014 Max's Awesome App House. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImagePickerViewController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic) NSString *username;

@end
