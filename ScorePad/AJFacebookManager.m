//
//  AJFacebookManager.m
//  ScorePad
//
//  Created by Anca Calugar on 3/22/13.
//  Copyright (c) 2013 Anca Julean. All rights reserved.
//

#import "AJFacebookManager.h"

#import <Accounts/ACError.h>
#import <Accounts/Accounts.h>

#import <FacebookSDK/FBSession.h>
#import <FacebookSDK/FBSessionTokenCachingStrategy.h>

NSString * const AJFacebookDidLoginNotification = @"AJFacebookDidLoginNotification";
NSString * const AJFacebookDidNotLoginNotification = @"AJFacebookDidNotLoginNotification";
NSString * const AJFacebookDidLogoutNotification = @"AJFacebookDidLogoutNotification";
NSString * const AJFacebookDidAuthorizeWithPublishPermissions = @"AJFacebookDidAuthorizeWithPublishPermissions";

NSString * const AJFacebookErrorKey = @"AJFacebookErrorKey";
NSString * const AJFacebookCancelledKey = @"AJFacebookCancelledKey";
NSString * const AJFacebookPermissionsDeniedKey = @"AJFacebookPermissionsDeniedKey";
NSString * const AJFacebookFailedWithoutErrorKey = @"AJFacebookFailedWithoutErrorKey";
NSString * const AJFacebookOptionsKey = @"AJFacebookOptionsKey";

@protocol AJFacebookManagerPhotoShareDelegate <NSObject>

- (void)didFinishPostingPhotoToFacebookWithSuccess:(id)result;
- (void)didFinishPostingPhotoToFacebookWithError:(NSError*)error;

@end


@implementation AJFacebookManager

@synthesize isStarted = _isStarted;
@dynamic isFacebookConfigured;

static AJFacebookManager *sharedAJFacebookManager = nil;

#pragma mark - Singleton methods

+ (AJFacebookManager *)sharedAJFacebookManager {
    @synchronized(self) {
        if (sharedAJFacebookManager == nil) {
            sharedAJFacebookManager = [[self alloc] init];
        }
    }
    
    return sharedAJFacebookManager;
}

+ (AJFacebookManager *)sharedInstance {
    return [self sharedAJFacebookManager];
}

- (id)copyWithZone:(NSZone *)zone {
    return self;
}

- (void)start {
    if (_isStarted == NO) {
        NSLog(@"Starting FacebookManager");
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(facebookSessionDidAuthWithSuccessViaSingleSignOn:)
                                                     name:@"com.facebook.sdk:FBSessionDidAuthWithSuccessViaSingleSignOn" object:nil];
        
        _isStarted = YES;
        
        NSString *tokenInformationKey = [[NSUserDefaults standardUserDefaults] objectForKey:@"FacebookAppID"];
        FBSessionTokenCachingStrategy *tcs = [[FBSessionTokenCachingStrategy alloc] initWithUserDefaultTokenInformationKeyName:tokenInformationKey];
        _facebookSession = [[FBSession alloc] initWithAppID:AJGetFacebookAppId() permissions:nil urlSchemeSuffix:AJGetFacebookLocAppId() tokenCacheStrategy:tcs];
        [FBSession setActiveSession:_facebookSession];
        
        if (_facebookSession.state == FBSessionStateCreatedTokenLoaded) {
            [_facebookSession openWithCompletionHandler:nil];
        }
    }
}

- (void)stop {
    if (_isStarted == YES) {
        NSLog(@"stopping facebookmanager");
        
        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"com.facebook.sdk:FBSessionDidAuthWithSuccessViaSingleSignOn" object:nil];
        
        _isStarted = NO;
        
        [_facebookSession closeAndClearTokenInformation];
        _facebookSession = nil;
    }
}

- (void)clearSession {
    if (_facebookSession) {
        [_facebookSession closeAndClearTokenInformation];
        _facebookSession = nil;
    }
}

- (void)facebookLogin:(NSDictionary *)options {
    if (!self.isStarted) {
        NSLog(@"facebook manager not started! start it before calling this method");
        return;
    }
    
    if ([_facebookSession isOpen] == NO) {
        NSLog(@"login started");
        
        [_facebookSession close];
        _facebookSession = nil;
        
        NSString *tokenInformationKey = [[NSUserDefaults standardUserDefaults] objectForKey:@"FacebookAppID"];
        FBSessionTokenCachingStrategy *tcs = [[FBSessionTokenCachingStrategy alloc] initWithUserDefaultTokenInformationKeyName:tokenInformationKey];
        _facebookSession = [[FBSession alloc] initWithAppID:AJGetFacebookAppId() permissions:nil urlSchemeSuffix:AJGetFacebookLocAppId() tokenCacheStrategy:tcs];
        [FBSession setActiveSession:_facebookSession];
        
//        [_facebookSession openWithBehavior:FBSessionLoginBehaviorUseSystemAccountIfPresent
//                         completionHandler:^(FBSession *session, FBSessionState status, NSError *error)];
    }
}

NSString * AJGetFacebookAppId() {
    return @"445278418835986";
}

NSString * AJGetFacebookLocAppId() {
    return @"fb";
}

@end
