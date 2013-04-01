//
//  AJFacebookManager.h
//  ScorePad
//
//  Created by Anca Calugar on 3/22/13.
//  Copyright (c) 2013 Anca Julean. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FacebookSDK/FacebookSDK.h>

extern NSString * const AJFacebookDidLoginNotification;
extern NSString * const AJFacebookDidNotLoginNotification;
extern NSString * const AJFacebookDidLogoutNotification;
extern NSString * const AJFacebookDidAuthorizeWithPublishPermissions;

extern NSString * const AJFacebookErrorKey;
extern NSString * const AJFacebookCancelledKey;
extern NSString * const AJFacebookPermissionsDeniedKey;
extern NSString * const AJFacebookFailedWithoutErrorKey;
extern NSString * const AJFacebookOptionsKey;

@interface AJFacebookManager : NSObject {
    FBSession   *_facebookSession;
    BOOL        _isStarted;
}

@property (nonatomic, readonly) BOOL    isStarted;
@property (nonatomic, readonly) BOOL    isFacebookConfigured;

+ (AJFacebookManager*)sharedInstance;

- (void)start;
- (void)stop;
- (void)clearSession;

- (void)facebookLogin:(NSDictionary*)options;
- (void)facebookLogout;
- (void)reauthorizeWithPublishPermissions:(NSArray*)permissions;

- (void)handleFacebookURL:(NSURL*)URL;
- (void)handleDidBecomeActive;

- (void)publishPhotoWithDelegate:(id)delegate andParameters:(NSDictionary*)params;
- (BOOL)hasPermissions;

- (BOOL)isInvalidSessionError:(NSError*)error;
- (BOOL)isUsingNativeFacebookAccount;

@end
