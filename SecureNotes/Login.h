//
//  Login.h
//  SecureNotes
//
//  Created by Maxwell Pospischil on 4/15/14.
//  Copyright (c) 2014 Max's Awesome App House. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Notes;

@interface Login : NSManagedObject

@property (nonatomic, retain) NSString * point1;
@property (nonatomic, retain) NSNumber * point1region;
@property (nonatomic, retain) NSString * point2;
@property (nonatomic, retain) NSNumber * point2region;
@property (nonatomic, retain) NSString * point3;
@property (nonatomic, retain) NSNumber * point3region;
@property (nonatomic, retain) NSString * point4;
@property (nonatomic, retain) NSNumber * point4region;
@property (nonatomic, retain) NSString * username;
@property (nonatomic, retain) NSData * picture;
@property (nonatomic, retain) NSSet *notes;
@end

@interface Login (CoreDataGeneratedAccessors)

- (void)addNotesObject:(Notes *)value;
- (void)removeNotesObject:(Notes *)value;
- (void)addNotes:(NSSet *)values;
- (void)removeNotes:(NSSet *)values;

@end
