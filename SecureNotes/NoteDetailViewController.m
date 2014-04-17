//
//  NoteDetailViewController.m
//  SecureNotes
//
//  Created by Maxwell Pospischil on 4/13/14.
//  Copyright (c) 2014 Max's Awesome App House. All rights reserved.
//

#import "NoteDetailViewController.h"
#import "NoteTableViewController.h"

@interface NoteDetailViewController ()

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *doneButton;
- (void)configureView;

@end

@implementation NoteDetailViewController

#pragma mark - Managing the detail item

- (IBAction)deleteNote:(id)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Delete" otherButtonTitles:nil, nil];
    
    [actionSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"Delete"]){
        [self.context deleteObject:self.noteDetail];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (IBAction)doneEditing:(id)sender {
    [self saveNote];
    [self disableButton];
}

- (void)disableButton {
    [self.doneButton setEnabled:NO];
    [self.doneButton setTitle: @""];
}

- (void)enableButton {
    [self.doneButton setEnabled:YES];
    [self.doneButton setTitle: @"Done"];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self saveNote];
    if ([self.noteDetail.noteText isEqualToString:@""]){
        [self.context deleteObject:self.noteDetail];
    }
}

- (void)saveNote
{
    [self.noteText resignFirstResponder];
    if (![self.noteDetail.noteText isEqualToString:self.noteText.text]){
        self.noteDetail.timeStamp = [NSDate date];
        self.noteDetail.noteText = self.noteText.text;
        NSError *error = nil;
        if (![_context save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

- (void)setContext:(NSManagedObjectContext *)context
{
    _context = context;
}

- (void)setEntity:(NSEntityDescription *)entity
{
    _entity = entity;
}

- (void)setNoteDetail:(Notes*)newNoteDetail
{
    if (_noteDetail != newNoteDetail) {
        _noteDetail = newNoteDetail;
        
        // Update the view.
        [self configureView];
    }
}

- (void)configureView
{
    // Update the user interface for the detail item.
    
    if (self.noteDetail) {
        NSDateFormatter *format = [[NSDateFormatter alloc] init];
        [format setDateFormat:@"MMM dd, yyyy, hh:mm a"];
        
        NSString *dateString = [format stringFromDate:self.noteDetail.timeStamp];
        self.dateLabel.text = dateString;
        self.noteText.text = [[self.noteDetail valueForKey:@"noteText"] description];
    }
    if ([self.noteText.text isEqualToString:@""]){
        [self.noteText becomeFirstResponder];
    } else {
        [self disableButton];
    }
        
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(editingDidBegin:)
                                                 name:UITextViewTextDidBeginEditingNotification
                                               object:nil];
    [self configureView];
}

- (void)editingDidBegin:(NSNotification *)notification {
    [self enableButton];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
