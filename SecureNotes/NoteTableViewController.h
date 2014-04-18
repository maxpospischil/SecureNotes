//
//  NoteTableViewController.h
//  SecureNotes
//
//  Created by Maxwell Pospischil on 4/13/14.
//  Copyright (c) 2014 Max's Awesome App House. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Login.h"

@interface NoteTableViewController : UITableViewController <NSFetchedResultsControllerDelegate >

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSString *username;



@end
