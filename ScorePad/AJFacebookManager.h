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

@interface AJFacebookManager : NSObject

@property (nonatomic, assign, readonly) BOOL            isStarted;
@property (nonatomic, assign, readonly) BOOL            isFacebookConfigured;
@property (nonatomic, assign, readonly) BOOL            isUsingNativeFacebookAccount;
@property (nonatomic, strong, readonly) FBSession       *facebookSession;

- (void)startWithUserDefaultTokenInformationKeyName:(NSString*)keyName;
- (void)stop;
- (void)clearSession;

- (void)facebookLogin;
- (void)facebookLogin:(NSDictionary*)options;
- (void)facebookLogout;
- (void)reauthorizeWithPublishPermissions:(NSArray *)permissions;
- (BOOL)hasPermissions:(NSArray *)permissions;

- (BOOL)handleFacebookURL:(NSURL*)URL;
- (void)handleDidBecomeActive;

- (void)publishPhotoWithDelegate:(id)delegate andParameters:(NSDictionary*)params;

- (BOOL)isInvalidSessionError:(NSError *)error;

@end
