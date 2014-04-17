//
//  RegistrationViewController.m
//  SecureNotes
//
//  Created by Maxwell Pospischil on 4/7/14.
//  Copyright (c) 2014 Max's Awesome App House. All rights reserved.
//

#import "RegistrationViewController.h"

@interface RegistrationViewController ()

@end

@implementation RegistrationViewController

- (NSManagedObjectContext *)managedObjectContext {
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}

- (IBAction)usernameReturnPressed:(id)sender {
    [self resignFirstResponder];
}

- (IBAction)createUser:(id)sender {
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setObject:[NSString stringWithFormat:@"%@",self.usernameTextField.text] forKey:@"username"];
    
    NSManagedObjectContext *context = [self managedObjectContext];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Login" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    // Specify criteria for filtering which objects to fetch
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"username == %@", self.usernameTextField.text];
    [fetchRequest setPredicate:predicate];
    NSError *error = nil;
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    if (fetchedObjects == nil) {
        NSLog(@"fetched objects nil, fetch failed");
    }
    
    
    if(![fetchedObjects count]){
        // NSManagedObject *newUser = [NSEntityDescription insertNewObjectForEntityForName:@"Login" inManagedObjectContext:context];
        _tryAgainLabel.text = @"";
        Login *newUser = (Login*)[NSEntityDescription insertNewObjectForEntityForName:@"Login" inManagedObjectContext:context];
        // [newUser setValue:self.usernameTextField.text forKey:@"username"];
        newUser.username = self.usernameTextField.text;
        
        error = nil;
        // Save the object to persistent store
        if (![context save:&error]) {
            NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
        }
        
        [self performSegueWithIdentifier:@"Set PicturePass" sender:sender];
    } else {
        _tryAgainLabel.text = @"Username taken. Try Again!";
    }
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _tryAgainLabel.text = @"";
    /* Take away back arrow text */
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] init];
    barButton.title = @"";
    self.navigationController.navigationBar.topItem.backBarButtonItem = barButton;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Set PicturePass"]) {
        if ([segue.destinationViewController isKindOfClass:[LockViewController class]]) {
            [segue.destinationViewController setKindOfLock:@"NEW"];
            [segue.destinationViewController setUsername:self.usernameTextField.text];
        }
    }
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
@end
