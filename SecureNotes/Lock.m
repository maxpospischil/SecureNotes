//
//  Lock.m
//  SecureNotes
//
//  Created by Maxwell Pospischil on 4/4/14.
//  Copyright (c) 2014 Max's Awesome App House. All rights reserved.
//

#import "Lock.h"
#import <CommonCrypto/CommonDigest.h>
#define RVALUE 15



@interface Lock()

@property (nonatomic, readwrite) NSInteger seqIndex;
@property (nonatomic, strong) NSMutableArray *passSequence;
@property (nonatomic, strong) NSMutableArray *regionSequence;

@end

@implementation Lock

- (NSManagedObjectContext *)managedObjectContext {
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}

- (NSMutableArray *)passSequence
{
    if (!_passSequence) {
        _passSequence = [NSMutableArray array];
    }
    return _passSequence;
}

- (NSMutableArray *)regionSequence
{
    if (!_regionSequence) {
        _regionSequence = [NSMutableArray array];
    }
    return _regionSequence;
}

- (instancetype)init
{
    self = [super init];
    
    if(self){
        _seqIndex = 0;
    }
    return self;
}

- (Login*)fetchUser:(NSString*)username
            context:(NSManagedObjectContext*)context
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Login" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    // Specify criteria for filtering which objects to fetch
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"username == %@", username];
    [fetchRequest setPredicate:predicate];
    NSError *error = nil;
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    if (fetchedObjects == nil) {
        NSLog(@"fetched objects nil, fetch failed");
        abort();
    }
    if ([fetchedObjects count] > 1){
        NSLog(@"Multiple matching usernames!!!!");
        abort();
    }
    if (![fetchedObjects count]){
        NSLog(@"Username not found");
        abort();
    }
    Login *userContext = (Login *)fetchedObjects[0];
    return userContext;
}

- (void)setLock:(NSString *)encryptedPasswordString
     saferegion:(NSInteger)saferegion
       username:(NSString *)username
{
    NSManagedObjectContext *context = [self managedObjectContext];
    Login *newUser = [self fetchUser:username
                             context:context];
    
    if (self.seqIndex < MAXSEQUENCE){
        self.passSequence[self.seqIndex] = encryptedPasswordString;
        self.regionSequence[self.seqIndex] = [NSNumber numberWithInteger:saferegion];
        self.seqIndex ++;
    }
    if ([self.passSequence count] == MAXSEQUENCE){
        
        newUser.point1 = self.passSequence[0];
        newUser.point1region = self.regionSequence[0];
        newUser.point2 = self.passSequence[1];
        newUser.point2region = self.regionSequence[1];
        newUser.point3 = self.passSequence[2];
        newUser.point3region = self.regionSequence[2];
        newUser.point4 = self.passSequence[3];
        newUser.point4region = self.regionSequence[3];
        
        NSError *error = nil;
        // Save the object to persistent store
        if (![context save:&error]) {
            NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
        }
    }
}

- (BOOL)confirmLock:(NSArray *)confirmArrayX
             yArray:(NSArray *)confirmArrayY
            username:(NSString *)username
{
    if (![confirmArrayX count]){
        NSLog(@"empty confirm array");
        abort();
    }
    NSManagedObjectContext *context = [self managedObjectContext];
    Login *user = [self fetchUser:username
                          context:context];
    CGPoint point1;
    CGPoint point2;
    CGPoint point3;
    CGPoint point4;
    point1.x = [confirmArrayX[0] integerValue];
    point1.y = [confirmArrayY[0] integerValue];
    point2.x = [confirmArrayX[1] integerValue];
    point2.y = [confirmArrayY[1] integerValue];
    point3.x = [confirmArrayX[2] integerValue];
    point3.y = [confirmArrayY[2] integerValue];
    point4.x = [confirmArrayX[3] integerValue];
    point4.y = [confirmArrayY[3] integerValue];
    
    NSMutableArray *confirmArray = [[NSMutableArray alloc] init];
    confirmArray[0] = [self getEncryptedPointString:point1 saferegion:[user.point1region integerValue]];
    confirmArray[1] = [self getEncryptedPointString:point2 saferegion:[user.point2region integerValue]];
    confirmArray[2] = [self getEncryptedPointString:point3 saferegion:[user.point3region integerValue]];
    confirmArray[3] = [self getEncryptedPointString:point4 saferegion:[user.point4region integerValue]];
    
    if ([user.point1 isEqualToString:confirmArray[0]] && [user.point2 isEqualToString:confirmArray[1]] && [user.point3 isEqualToString:confirmArray[2]] && [user.point4 isEqualToString:confirmArray[3]]){
        return YES;
    }
    return NO;
}

- (void)eraseLockFromUser:(NSString *)username
{
    NSManagedObjectContext *context = [self managedObjectContext];
    Login *user = [self fetchUser:username
                          context:context];
    user.point1 = nil;
    user.point1region = nil;
    user.point2 = nil;
    user.point2region = nil;
    user.point3 = nil;
    user.point3region = nil;
    user.point4 = nil;
    user.point4region = nil;
    
    NSError *error = nil;
    // Save the object to persistent store
    if (![context save:&error]) {
        NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
    }
    
}

- (void)deleteUser:(NSString *)username
{
    NSManagedObjectContext *context = [self managedObjectContext];
    Login *user = [self fetchUser:username
                          context:context];
    
    [context deleteObject:user];
}

- (Login *)returnUserLogin:(NSString *)username
{
    NSManagedObjectContext *context = [self managedObjectContext];
    Login *user = [self fetchUser:username
                          context:context];
    return user;
}

- (NSInteger)findSafeRegionGraph:(CGPoint) point
{
    int xregion = -1;
    int yregion = -1;
    NSInteger saferegion = -1;
    int r = RVALUE;
    int q = 6*r;
    if (0 <= ((int)point.y % q) && ((int)point.y % q) < 2*r){
        yregion = 0;
    } else if (2*r <= ((int)point.y % q) && ((int)point.y % q) < 4*r){
        yregion = 1;
    } else if (4*r <= ((int)point.y % q) && ((int)point.y % q) < q){
        yregion = 2;
    }
    if (0 <= ((int)point.x % q) && ((int)point.x % q) < 2*r){
        xregion = 0;
    } else if (2*r <= ((int)point.x % q) && ((int)point.x % q) < 4*r){
        xregion = 1;
    } else if (4*r <= ((int)point.x % q) && ((int)point.x % q)< q){
        xregion = 2;
    }
    if (yregion != 2 && xregion != 2){
        saferegion = 2;
    } else if (yregion != 1 && xregion !=1){
        saferegion = 1;
    } else if (yregion != 0 && xregion != 0){
        saferegion = 0;
    }
    if (xregion == -1 || yregion == -1){
        NSLog(@"Error in finding region of point!");
        abort();
    }
    return saferegion;
    
}

- (NSString*)getEncryptedPointString:(CGPoint)point
                          saferegion:(NSInteger)sregion
{
    int r = RVALUE;
    int q = 6*r;
    int saferegion = (int)sregion;
    CGPoint gridPoint;
    if (saferegion == 0){
        gridPoint.x = (int)point.x - ((int)point.x % q);
        gridPoint.y = (int)point.y - ((int)point.y % q);
    } else if (saferegion == 1){
        gridPoint.x = (int)point.x - ((int)point.x % q) + 2*r;
        gridPoint.y = (int)point.y - ((int)point.y % q) + 2*r;
    } else if (saferegion == 2){
        gridPoint.x = (int)point.x - ((int)point.x % q) + 4*r;
        gridPoint.y = (int)point.y - ((int)point.y % q) + 4*r;
    }
    NSString *myPasswordString = [NSString stringWithFormat:@"x: %d, y: %d", (int)gridPoint.x, (int)gridPoint.y];
    //NSLog(@"%@", myPasswordString);
    NSString *encrpytedPassword = [self md5Encrypt:myPasswordString];
    return encrpytedPassword;
    
}

- (NSString *)md5Encrypt:(NSString*)password
{
    const char *cStr = [password UTF8String];
    unsigned char result[16];
    CC_MD5( cStr, (int)strlen(cStr), result ); // This is the md5 call
    NSString *passwordAfterEncrypt = [NSString stringWithFormat:
                                      @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                                      result[0], result[1], result[2], result[3],
                                      result[4], result[5], result[6], result[7],
                                      result[8], result[9], result[10], result[11],
                                      result[12], result[13], result[14], result[15]];
    return passwordAfterEncrypt;
}

- (void)setLockWithPointandName:(CGPoint)point
                       username:(NSString*)username
{
    NSInteger saferegion = [self findSafeRegionGraph:point];
    NSString *encryptedString =  [self getEncryptedStringFromPoint:point];
    [self setLock:encryptedString
            saferegion:saferegion
              username:username];
}

- (NSString*)getEncryptedStringFromPoint:(CGPoint)point
{
    NSInteger saferegion = [self findSafeRegionGraph:point];
    NSString *encryptedString = [self getEncryptedPointString:point
                                                   saferegion:saferegion];
    return encryptedString;
    
}

@end
