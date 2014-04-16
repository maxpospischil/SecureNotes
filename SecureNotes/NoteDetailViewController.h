//
//  NoteDetailViewController.h
//  SecureNotes
//
//  Created by Maxwell Pospischil on 4/13/14.
//  Copyright (c) 2014 Max's Awesome App House. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Notes.h"

@interface NoteDetailViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextView *noteText;

@property (strong, nonatomic) Notes* noteDetail;
@property (nonatomic) NSManagedObjectContext *context;
@property (nonatomic) NSEntityDescription *entity;

@end
