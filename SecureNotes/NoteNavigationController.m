//
//  NoteNavigationController.m
//  SecureNotes
//
//  Created by Maxwell Pospischil on 4/13/14.
//  Copyright (c) 2014 Max's Awesome App House. All rights reserved.
//

#import "NoteNavigationController.h"
#import "NoteTableViewController.h"

@interface NoteNavigationController ()

@property NoteTableViewController *tview;

@end

@implementation NoteNavigationController {
    void (^_completion)();
}


- (void) navigationController:(UINavigationController *) navigationController didShowViewController:(UIViewController *) viewController animated:(BOOL) animated {
    if (_completion) {
        _completion();
        _completion = nil;
    }
}

- (UIViewController *) popViewControllerAnimated:(BOOL) animated completion:(void (^)()) completion {
    _completion = completion;
    return [super popViewControllerAnimated:animated];
}

- (id) initWithRootViewController:(UIViewController *) rootViewController {
    self = [super initWithRootViewController:rootViewController];
    if (self) {
        self.delegate = self;
    }
    return self;
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
    self.tview = (NoteTableViewController *)[self topViewController];
    self.tview.username = self.username;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
