//
//  LoginUsernameViewController.m
//  SecureNotes
//
//  Created by Maxwell Pospischil on 4/7/14.
//  Copyright (c) 2014 Max's Awesome App House. All rights reserved.
//

#import "LoginUsernameViewController.h"

@interface LoginUsernameViewController ()
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextView *tryAgainLabel;

@end

@implementation LoginUsernameViewController

- (NSManagedObjectContext *)managedObjectContext {
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}

- (IBAction)usernameReturned:(UITextField *)sender{
    [self resignFirstResponder];
}

- (IBAction)enterPicturePass:(id)sender {
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
        self.tryAgainLabel.text = [NSString stringWithFormat: @"Username \"%@\" does not exist. Please try again!", self.usernameTextField.text];
        
    } else {
        [self performSegueWithIdentifier:@"Enter PicturePass" sender:sender];
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
    self.tryAgainLabel.text = @"";
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue
                 sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Enter PicturePass"]) {
        if ([segue.destinationViewController isKindOfClass:[LockViewController class]]) {
            [segue.destinationViewController setKindOfLock:@"LOGIN"];
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
