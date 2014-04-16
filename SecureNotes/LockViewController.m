//
//  SetLockViewController.m
//  SecureNotes
//
//  Created by Maxwell Pospischil on 4/4/14.
//  Copyright (c) 2014 Max's Awesome App House. All rights reserved.
//

#import "LockViewController.h"
#import "NoteNavigationController.h"
#import "Login.h"
#import <AudioToolbox/AudioToolbox.h> 
#import "ImagePickerViewController.h"

@interface LockViewController ()
@property (strong, nonatomic) NSMutableArray *confirmArrayX;
@property (strong, nonatomic) NSMutableArray *confirmArrayY;
@property (nonatomic, readwrite) NSInteger seqIndex;
@property (nonatomic, readwrite) NSInteger confIndex;
@property (weak, nonatomic) IBOutlet UIView *instructionView;
@property (weak, nonatomic) IBOutlet UITextView *instructionText;
@property (weak, nonatomic) IBOutlet UIImageView *picturePassImage;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *editButton;




@end

@implementation LockViewController

- (IBAction)instructionDismissed:(id)sender {
    self.instructionView.hidden = YES;
    [self.editButton setEnabled:NO];
}

- (NSManagedObjectContext *)managedObjectContext {
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}

- (void)setUsername:(NSString *)username
{
    _username = username;
}

-(void)displayInstruction
{
    if ([self.kindOfLock isEqualToString:@"NEW"]){
        self.instructionText.text = @"Tap 4 spots on the picture to create your PicturePass";
    } else if ([self.kindOfLock isEqualToString:@"LOGIN"]){
        self.instructionText.text = @"Please enter your PicturePass";
    } else if ([self.kindOfLock isEqualToString:@"CHANGE PICTUREPASS"]){
        self.instructionText.text = @"Please confirm your old PicturePass";
    }
}

- (NSMutableArray *)confirmArrayX
{
    if (!_confirmArrayX){
        _confirmArrayX = [[NSMutableArray alloc] init];
    }
    return _confirmArrayX;
}

- (NSMutableArray *)confirmArrayY
{
    if (!_confirmArrayY){
        _confirmArrayY = [[NSMutableArray alloc] init];
    }
    return _confirmArrayY;
}

- (Lock *)lock
{
    if (!_lock){
        _lock = [[Lock alloc] init];
        _seqIndex = 0;
        _confIndex = 0;
    }
    return _lock;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self displayInstruction];
    
    if ([self.kindOfLock isEqualToString:@"CHANGE PICTUREPASS"]){
        [self.editButton setEnabled:NO];
    }
    
    if ([self.kindOfLock isEqualToString:@"LOGIN"]){
        [self.editButton setEnabled:NO];
        self.editButton.title = @"";
        self.navigationItem.title = @"Login";
    }

}

- (void)viewWillAppear:(BOOL)animated{
    Lock *fetchlock = [[Lock alloc] init];
    NSManagedObjectContext *context = [self managedObjectContext];
    Login *user = [fetchlock fetchUser:self.username
                               context:context];
    if (user.picture){
        UIImage *image = [UIImage imageWithData:user.picture];
        [self.picturePassImage setImage:image];
    }
    context = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    if (self.isMovingFromParentViewController) {
        if ([self.kindOfLock isEqualToString:@"NEW"]){
            [self.lock deleteUser:self.username];
        }
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Success"]) {
        if ([segue.destinationViewController isKindOfClass:[NoteNavigationController class]]) {
            [segue.destinationViewController setUsername:self.username];
        }
    }
    if ([segue.identifier isEqualToString:@"Edit Picture"]) {
        NSLog(@"%@",self.username);
        [segue.destinationViewController setUsername:self.username];
    }
}

- (void)createNewLock:(CGPoint)point
{
    if (self.seqIndex < MAXSEQUENCE){
        [self.lock setLockWithPointandName:point
                                  username:self.username];
        self.seqIndex ++;
        if (self.seqIndex == MAXSEQUENCE){
            self.instructionText.text = @"Please Confirm Your PicturePass";
            self.instructionView.hidden = NO;
        }
    } else {
        if (self.confIndex < MAXSEQUENCE){
            self.confirmArrayX[self.confIndex] = [NSNumber numberWithInteger:(int) point.x];
            self.confirmArrayY[self.confIndex] = [NSNumber numberWithInteger:(int) point.y];
            self.confIndex++;
        }
        if (self.confIndex == MAXSEQUENCE){
            if ([self.lock confirmLock:self.confirmArrayX
                                yArray:self.confirmArrayY
                              username:self.username]){
                [self performSegueWithIdentifier:@"Success" sender:nil];
            } else {
                self.instructionText.text = @"PicturePass Mismatch! Please try again!";
                [self.editButton setEnabled:YES];
                [self.lock eraseLockFromUser:self.username];
                self.lock = nil;
                self.seqIndex = 0;
                self.confIndex = 0;
                self.confirmArrayX = nil;
                self.confirmArrayY = nil;
                self.instructionView.hidden = NO;
            }
        }
    }
}

- (void)confirmUserLock:(CGPoint)point
{
    if (self.confIndex < MAXSEQUENCE){
        self.confirmArrayX[self.confIndex] = [NSNumber numberWithInteger:(int) point.x];
        self.confirmArrayY[self.confIndex] = [NSNumber numberWithInteger:(int) point.y];
        self.confIndex++;
    }
    if (self.confIndex == MAXSEQUENCE){
        if ([self.lock confirmLock:self.confirmArrayX
                            yArray:self.confirmArrayY
                          username:self.username]){
            if ([self.kindOfLock isEqualToString:@"CHANGE PICTUREPASS"])
            {
                self.navigationItem.hidesBackButton = YES;
                self.kindOfLock = @"NEW";
                [self.editButton setEnabled:YES];
                self.instructionText.text = @"Tap 4 spots on the picture to create your new PicturePass";
                self.instructionView.hidden = NO;
                return;
            } else {
                [self performSegueWithIdentifier:@"Success" sender:nil];
            }
        } else {
            self.instructionText.text = @"Invalid PicturePass! Please try again!";
            self.lock = nil;
            self.seqIndex = 0;
            self.confIndex = 0;
            self.confirmArrayX = nil;
            self.confirmArrayY = nil;
            self.instructionView.hidden = NO;
        }
    }
}

- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event
{
    // Retrieve the touch point
    
    if (self.instructionView.hidden){
        UITouch *touch=[[event allTouches]anyObject];
        CGPoint point= [touch locationInView:touch.view];
        AudioServicesPlaySystemSound (kSystemSoundID_Vibrate);
        
        if ([self.kindOfLock isEqualToString:@"NEW"]){
            [self createNewLock:point];
        }
        if ([self.kindOfLock isEqualToString:@"LOGIN"]){
            [self confirmUserLock:point];
        }
        if ([self.kindOfLock isEqualToString:@"CHANGE PICTUREPASS"])
        {
            [self confirmUserLock:point];
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
