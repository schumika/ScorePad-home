//
//  UIDevice-Additions.h
//

#import <Foundation/Foundation.h>


@interface UIDevice (Additions)

+ (BOOL)isOS4;
+ (BOOL)isOS5;
+ (BOOL)isOS50OrGreater;
+ (BOOL)isOS6;
+ (BOOL)isOS60OrGreater;

+ (BOOL)isIPhone;
+ (BOOL)isIPhone3GS;
+ (BOOL)isIPhone4;
+ (BOOL)isIPhone4S;
+ (BOOL)isIPhone5;
+ (BOOL)isIPod;
+ (BOOL)isIPodThirdGeneration;
+ (BOOL)isIPodFourthGeneration;
+ (BOOL)isIPodFifthGeneration;
+ (BOOL)isIPad;
+ (BOOL)isIPadFirstGeneration;
+ (BOOL)isIPadSecondGeneration;
+ (BOOL)isIPadThirdGeneration;
+ (BOOL)isIPadFourthGeneration;
+ (BOOL)isIPadMiniFirstGeneration;
+ (BOOL)isIOSSimulator;
+ (BOOL)isIPhoneSimulator;
+ (BOOL)isIPadSimulator;

+ (NSString *)model;
+ (NSString *)platform;
+ (NSString *)devicePlatformDescription;

+ (BOOL)isMicPresent;
+ (NSString *)pingerUniqueIdentifier;

@end
