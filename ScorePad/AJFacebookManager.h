//
//  AJFacebookManager.h
//  ScorePad
//
//  Created by Anca Calugar on 4/8/13.
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
// This is used in AJFacebookDidNotLoginNotification when the user doesn't allow Facebook access after login
extern NSString * const AJFacebookPermissionsDeniedKey;
// This is used in AJFacebookDidNotLoginNotification when the user exits the Login page in Safari
extern NSString * const AJFacebookFailedWithoutErrorKey;
extern NSString * const AJFacebookOptionsKey;

@interface AJFacebookManager : NSObject {
    FBSession                   *_facebookSession;
	BOOL                        _isStarted;
}

@property (nonatomic, readonly) BOOL		isStarted;
@property (nonatomic, readonly) BOOL		isFacebookConfigured;

+ (AJFacebookManager*)sharedInstance;

- (void)start;
- (void)stop;
- (void)clearSession;

- (void)facebookLogin:(NSDictionary *)options;
- (void)facebookLogout;
- (void)reauthorizeWithPublishPermissions:(NSArray *)permissions;

- (BOOL)handleFacebookURL:(NSURL*)URL;
- (void)handleDidBecomeActive;

- (void)publishPhotoWithDelegate:(id)delegate andParameters:(NSDictionary*)params;
- (BOOL)hasPermissions:(NSArray *)permissions;

- (BOOL)isInvalidSessionError:(NSError *)error;
- (BOOL)isUsingNativeFacebookAccount;



@end
