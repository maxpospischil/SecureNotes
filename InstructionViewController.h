//
//  InstructionViewController.h
//  SecureNotes
//
//  Created by Maxwell Pospischil on 4/10/14.
//  Copyright (c) 2014 Max's Awesome App House. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InstructionViewController : UIViewController

@property (weak, nonatomic) NSString* instruction;
@property (weak, nonatomic) IBOutlet UITextView *instructionField;

- (void) setInstruction:(NSString *)instruction;


@end
