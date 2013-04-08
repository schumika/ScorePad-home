//
//  AJFacebookManager.m
//  ScorePad
//
//  Created by Anca Calugar on 4/8/13.
//  Copyright (c) 2013 Anca Julean. All rights reserved.
//

#import "AJFacebookManager.h"
#import "UIDevice-Additions.h"

#import <FacebookSDK/FacebookSDK.h>
#import <FacebookSDK/FBSession.h>
#import <FacebookSDK/FBSessionTokenCachingStrategy.h>

#import <Accounts/ACError.h>
#import <Accounts/Accounts.h>

NSString * const AJFacebookDidLoginNotification					= @"AJFacebookDidLoginNotification";
NSString * const AJFacebookDidNotLoginNotification				= @"AJFacebookDidNotLoginNotification";
NSString * const AJFacebookDidLogoutNotification				= @"AJFacebookDidLogoutNotification";
NSString * const AJFacebookDidAuthorizeWithPublishPermissions   = @"AJFacebookDidAuthorizeWithPublishPermissions";

NSString * const AJFacebookErrorKey								= @"AJFacebookErrorKey";
NSString * const AJFacebookCancelledKey							= @"AJFacebookCancelledKey";
NSString * const AJFacebookPermissionsDeniedKey                 = @"AJFacebookPermissionsDeniedKey";
NSString * const AJFacebookFailedWithoutErrorKey                = @"AJFacebookFailedWithoutErrorKey";
NSString * const AJFacebookOptionsKey                           = @"AJFacebookOptionsKey";

NSString *const FBSessionDidAuthWithSuccessViaSingleSignOn = @"com.facebook.sdk:FBSessionDidAuthWithSuccessViaSingleSignOn";

@protocol AJFacebookManagerPhotoShareDelegate <NSObject>

- (void)didFinishPostingPhotoToFacebookWithSucces:(id)result;
- (void)didFinishPostingPhotoToFacebookWithError:(NSError *)error;

@end


@implementation AJFacebookManager

@synthesize isStarted = _isStarted;
@dynamic	isFacebookConfigured;

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
    if (!_isStarted) {
        NSLog(@"Starting FacebookManager...");
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(facebookSessionDidAuthWithSuccessViaSingleSignOn:)
													 name:FBSessionDidAuthWithSuccessViaSingleSignOn object:nil];
        
        _isStarted			 = YES;
        
		NSString *tokenInformationKey = [[NSUserDefaults standardUserDefaults] valueForKey:@"AJFacebookTokenInformation"];
		FBSessionTokenCachingStrategy *tcs = [[FBSessionTokenCachingStrategy alloc] initWithUserDefaultTokenInformationKeyName:tokenInformationKey];
		_facebookSession = [[FBSession alloc] initWithAppID:@"445278418835986" permissions:nil
											urlSchemeSuffix:@"scorepad" tokenCacheStrategy:tcs];
		[FBSession setActiveSession:_facebookSession];
		
		if ([_facebookSession state] == FBSessionStateCreatedTokenLoaded) {
			[_facebookSession openWithCompletionHandler:nil];
		}

    }
}

- (void)stop {
	if (_isStarted == YES) {
		NSLog(@"Stopping FacebookChatManager...");
		
		[[NSNotificationCenter defaultCenter] removeObserver:self name:FBSessionDidAuthWithSuccessViaSingleSignOn object:nil];
        
        _isStarted = NO;
        [_facebookSession closeAndClearTokenInformation];
		_facebookSession = nil;
    }
}

- (void)clearSession {
    if(_facebookSession) {
        [_facebookSession closeAndClearTokenInformation];
		_facebookSession = nil;
    }
}

- (void)facebookLogin:(NSDictionary*)options {
	if (!self.isStarted) {
		NSLog(@"FacebookManager not started! Start it before calling this method.");
		return;
	}
	
	if ([_facebookSession isOpen] == NO) {
		NSLog(@"Facebook login started...");
        
        [_facebookSession close];
        _facebookSession = nil;
        
        NSString *tokenInformationKey = [[NSUserDefaults standardUserDefaults] valueForKey:@"AJFacebookTokenInformation"];
		FBSessionTokenCachingStrategy *tcs = [[FBSessionTokenCachingStrategy alloc] initWithUserDefaultTokenInformationKeyName:tokenInformationKey];
        
        _facebookSession = [[FBSession alloc] initWithAppID:@"445278418835986" permissions:nil
                                            urlSchemeSuffix:@"scorepad" tokenCacheStrategy:tcs];
        [FBSession setActiveSession:_facebookSession];
        [_facebookSession openWithBehavior:FBSessionLoginBehaviorUseSystemAccountIfPresent
						 completionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
                             NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithObject:options forKey:@"AJFacebookOptionsKey"];
							 if (FB_ISSESSIONSTATETERMINAL(status)) {
								 BOOL cancelled = NO;
                                 
                                 if ([[error domain] isEqualToString:FacebookSDKDomain]) {
									 cancelled = [[error.userInfo valueForKey:FBErrorLoginFailedReason] isEqualToString:FBErrorLoginFailedReasonInlineCancelledValue];
								 }
                                 [userInfo setValue:[NSNumber numberWithBool:cancelled] forKey:@"AJFacebookCancelledKey"];
                                 
                                 if ([UIDevice isOS60OrGreater]) {
                                     BOOL denied = NO;
                                     NSError *innerError = [[error userInfo] objectForKey:FBErrorInnerErrorKey];
                                     if ((ACErrorDomain != nil) && [[innerError domain] isEqualToString:ACErrorDomain]) {
                                         denied = ([innerError code] == ACErrorPermissionDenied);
                                     }
                                     [userInfo setValue:[NSNumber numberWithBool:denied] forKey:@"AJFacebookPermissionsDeniedKey"];
                                 }
                                 
                                 [userInfo setValue:[NSNumber numberWithBool:(error == nil)] forKey:@"AJFacebookFailedWithoutErrorKey"];
                                 
								 [[NSNotificationCenter defaultCenter] postNotificationName:AJFacebookDidNotLoginNotification
																					 object:self userInfo:userInfo];
                                 
							 } else if (FB_ISSESSIONOPENWITHSTATE(status)) {
                                 if (status == FBSessionStateOpenTokenExtended) {
                                     [[NSNotificationCenter defaultCenter] postNotificationName:AJFacebookDidAuthorizeWithPublishPermissions object:self];
                                 } else {
                                     [[NSNotificationCenter defaultCenter] postNotificationName:AJFacebookDidLoginNotification object:self userInfo:userInfo];
                                 }
							 }
						 }];
        
	} else {
		NSLog(@"Facebook user is already logged in. Nothing else to do...");
	}
}

- (void)facebookLogout {
	if (!self.isStarted) {
		NSLog(@"FacebookManager not started! Start it before calling this method.");
		return;
	}
	
	[_facebookSession closeAndClearTokenInformation];
	
	[[NSNotificationCenter defaultCenter] postNotificationName:AJFacebookDidLogoutNotification object:self];
}

- (void)reauthorizeWithPublishPermissions:(NSArray *)permissions {
    
    // alexs - prevents app from crashing on exception: "FBSession: It is not valid to reauthorize while a
    // previous reauthorize call has not yet completed." and picture post flow continues as expected.
    @try {
        [_facebookSession reauthorizeWithPublishPermissions:permissions
                                            defaultAudience:FBSessionDefaultAudienceFriends
                                          completionHandler:^(FBSession *session, NSError *error) {
                                              if(error) {
                                                  [self clearSession];
                                              }
                                          }];
    }
    @catch (NSException *exception) {
        NSLog(@"%@",exception.reason);
    }
}

- (BOOL)handleFacebookURL:(NSURL*)URL {
	if (!self.isStarted) {
		NSLog(@"AJFacebookManager not started! Start it before calling this method.");
		return NO;
	}
	
	return [_facebookSession handleOpenURL:URL];
}

- (void)handleDidBecomeActive {
   	if (!self.isStarted) {
		NSLog(@"AJFacebookManager not started! Start it before calling this method.");
        return;
	}
    
    [_facebookSession handleDidBecomeActive];
}

- (void)publishPhotoWithDelegate:(id<AJFacebookManagerPhotoShareDelegate>)delegate andParameters:(NSDictionary *)params{
    NSString *description = [params valueForKey:@"description"];
    NSArray *tags = [params valueForKey:@"tags"];
    UIImage *photo = [params valueForKey:@"photo"];
    
    FBRequest *publishPhotoRequest = [FBRequest requestWithGraphPath:@"me/photos"
                                                          parameters:@{@"name":description, @"source":photo}
                                                          HTTPMethod:@"POST"];
    
    FBRequestConnection *connection = [[FBRequestConnection alloc] init];
    [connection addRequest:publishPhotoRequest completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        if(error) {
            [self handlePhotoPostResult:result withDlegate:delegate error:error];
        } else {
            if(tags && [tags count]) {
                FBRequest *tagPhotoRequest = [FBRequest requestWithGraphPath:[NSString stringWithFormat:@"%@/tags?to=%@", [result valueForKey:@"id"] , [tags objectAtIndex:0][@"uid"]]
                                                                  parameters:nil
                                                                  HTTPMethod:@"POST"];
                [connection cancel];
                connection = [[FBRequestConnection alloc] init];
                
                [connection addRequest:tagPhotoRequest completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                    [self handlePhotoPostResult:result withDlegate:delegate error:error];
                }];
                
                [connection start];
            } else {
                [self handlePhotoPostResult:result withDlegate:delegate error:error];
            }
        }
    }];
    
    [connection start];
}

- (void)handlePhotoPostResult:(id)result withDlegate:(id<AJFacebookManagerPhotoShareDelegate>)delegate error:(NSError *)error {
    if(!error) {
        if ([delegate respondsToSelector:@selector(didFinishPostingPhotoToFacebookWithSucces:)]) {
            [delegate didFinishPostingPhotoToFacebookWithSucces:result];
        }
    } else {
        if ([delegate respondsToSelector:@selector(didFinishPostingPhotoToFacebookWithError:)]) {
            [delegate didFinishPostingPhotoToFacebookWithError:error];
        }
    }
}

- (BOOL)hasPermissions:(NSArray *)permissions {
    for (NSString *obj in  permissions) {
        if([[[FBSession activeSession] permissions] indexOfObject:obj] == NSNotFound) {
            return NO;
        }
    }
    
    return YES;
}

#pragma mark - Dynamic methods

- (BOOL)isFacebookConfigured {
    return [_facebookSession isOpen];
}

#pragma mark FBSession notifications

- (void)facebookSessionDidAuthWithSuccessViaSingleSignOn:(NSNotification*)aNotif {
	NSLog(@"acebookSessionDidAuthWithSuccessViaSingleSignOn");
}

#pragma mark - Helpers

- (BOOL)isInvalidSessionError:(NSError *)error {
    id response = [error.userInfo objectForKey:FBErrorParsedJSONResponseKey];
    if (response && [response isKindOfClass:[NSDictionary class]]) {
        id  body, error, code;
        if ((body = [response objectForKey:@"body"]) &&
            [body isKindOfClass:[NSDictionary class]] &&
            (error = [body objectForKey:@"error"]) &&
            [error isKindOfClass:[NSDictionary class]] &&
            (code = [error objectForKey:@"code"]) &&
            [code isKindOfClass:[NSNumber class]]) {
            return [code intValue] == 190;
        }
    }
    return NO;
}

- (BOOL)isUsingNativeFacebookAccount {
    BOOL userLogedWithNativeFacebookAccount = NO;
    
	// vbadea - We check the availablility of ACAccountTypeIdentifierFacebook constant. If this is available then it means
	// we're running on an iOS version which supports Facebook account. This approach is better than checking for minimum iOS version.
    if(&ACAccountTypeIdentifierFacebook != NULL) {
        ACAccountStore *accountStore = [[ACAccountStore alloc] init];
        ACAccountType *accountTypeFB = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierFacebook];
        
        if (accountTypeFB != nil) {
			userLogedWithNativeFacebookAccount = ([[accountStore accountsWithAccountType:accountTypeFB] count] > 0);
        }
    }
    
    return userLogedWithNativeFacebookAccount;
}


//NSString * AJGetFacebookAppId() {
//	return @"445278418835986";
//}
//
//NSString * AJGetFacebookLocAppId() {
//    return @"scorepad"; //com.AJ.ScorePad
//	
//}

@end
