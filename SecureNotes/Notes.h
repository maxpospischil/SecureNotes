//
//  Notes.h
//  SecureNotes
//
//  Created by Maxwell Pospischil on 4/15/14.
//  Copyright (c) 2014 Max's Awesome App House. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Login;

@interface Notes : NSManagedObject

@property (nonatomic, retain) NSString * noteText;
@property (nonatomic, retain) NSDate * timeStamp;
@property (nonatomic, retain) Login *user;

@end
