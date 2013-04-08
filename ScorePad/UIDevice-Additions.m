//
//  UIDevice-Additions.m
//

#import "UIDevice-Additions.h"
#import <AVFoundation/AVAudioSession.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>
#import <sys/types.h>
#import <sys/sysctl.h>

#import "NSString+Additions.h"

NSString * const kPiPhone3GSPlatformKey             = @"iPhone2,1";
NSString * const kPiPhone4PlatformKey               = @"iPhone3,1";
NSString * const kPiPhone4VerizonPlatformKey        = @"iPhone3,3";
NSString * const kPiPhone4SPlatformKey              = @"iPhone4,1";
NSString * const kPiPhone5GSMPlatformKey            = @"iPhone5,1";
NSString * const kPiPhone5CDMAPlatformKey           = @"iPhone5,2";
NSString * const kPiPod3GPlatformKey                = @"iPod3,1";
NSString * const kPiPod4GPlatformKey                = @"iPod4,1";
NSString * const kPiPod5GPlatformKey                = @"iPod5,1";
NSString * const kPiPadPlatformKey                  = @"iPad1,1";
NSString * const kPiPad2WiFiPlatformKey             = @"iPad2,1";
NSString * const kPiPad2GSMPlatformKey              = @"iPad2,2";
NSString * const kPiPad2CDMAPlatformKey             = @"iPad2,3";
NSString * const kPiPad3WiFiPlatformKey             = @"iPad3,1";
NSString * const kPiPad3GSMPlatformKey              = @"iPad3,2";
NSString * const kPiPad3CDMAPlatformKey             = @"iPad3,3";
NSString * const kPiPad4WiFiPlatformKey             = @"iPad3,4";
NSString * const kPiPad4GSMPlatformKey              = @"iPad3,5";
NSString * const kPiPad4CDMAPlatformKey             = @"iPad3,6";
NSString * const kPiPadMiniWiFiPlatformKey          = @"iPad2,5";
NSString * const kPiPadMiniGSMPlatformKey           = @"iPad2,6";
NSString * const kPiPadMiniCDMAPlatformKey          = @"iPad2,7";
NSString * const kPiOSSimulatori386PlatformKey      = @"i386";
NSString * const kPiOSSimulatorx86_64PlatformKey    = @"x86_64";

NSString * const kPiPhone3GSPlatformDescription                  = @"iPhone 3GS";
NSString * const kPiPhone4PlatformDescription                    = @"iPhone 4";
NSString * const kPiPhone4SPlatformDescription                    = @"iPhone 4S";
NSString * const kPiPhone5PlatformDescription                    = @"iPhone 5";
NSString * const kPiPodThirdGenerationPlatformDescription        = @"iPod touch gen 3";
NSString * const kPiPodFourthGenerationPlatformDescription       = @"iPod touch gen 4";
NSString * const kPiPodFifthGenerationPlatformDescription        = @"iPod touch gen 5";
NSString * const kPiPadFirstGenerationPlatformDescription        = @"iPad gen 1";
NSString * const kPiPadSecondGenerationPlatformDescription       = @"iPad gen 2";
NSString * const kPiPadThirdGenerationPlatformDescription        = @"iPad gen 3";
NSString * const kPiPadFourthGenerationPlatformDescription       = @"iPad gen 4";
NSString * const kPiPadMiniFirstGenerationPlatformDescription    = @"iPad Mini gen 1";
NSString * const kPiOSSimulatorPlatformDescription               = @"iOS Simulator";

NSString * const kPiPhoneDeviceModel            = @"iPhone";
NSString * const kPiPodTouchDeviceModel         = @"iPod touch";
NSString * const kPiPadDeviceModel              = @"iPad";
NSString * const kPiPhoneSimulatorDeviceModel   = @"iPhone Simulator";
NSString * const kPiPadSimulatorDeviceModel     = @"iPad Simulator";



@implementation UIDevice (Additions)

+ (BOOL)isOS4 {
    CGFloat currentSystemVersion = [[[UIDevice currentDevice] systemVersion] floatValue];
	return currentSystemVersion >= 4.0f && currentSystemVersion < 5.0f;
}

+ (BOOL)isOS5 {
    CGFloat currentSystemVersion = [[[UIDevice currentDevice] systemVersion] floatValue];
	return currentSystemVersion >= 5.0f && currentSystemVersion < 6.0f; 
}

+ (BOOL)isOS50OrGreater {
	return [[[UIDevice currentDevice] systemVersion] floatValue] >= 5.0f;
}

+ (BOOL)isOS6 {
    CGFloat currentSystemVersion = [[[UIDevice currentDevice] systemVersion] floatValue];
	return currentSystemVersion >=6.0f && currentSystemVersion < 7.0f;
}

+ (BOOL)isOS60OrGreater {
	return [[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0f;
}

#pragma mark -
#pragma mark Device Platform Related

+ (NSString *)model {
    static NSString *model = nil;
    if (model == nil) {
        model = [[UIDevice currentDevice] model];
    }
    return model;
}

+ (NSString *)platform {
	static NSString *platform = nil;
	if (!platform) {
		size_t size;
		sysctlbyname("hw.machine", NULL, &size, NULL, 0);
		char *machine = malloc(size);
		sysctlbyname("hw.machine", machine, &size, NULL, 0);
		platform = [NSString stringWithUTF8String:machine];
		free(machine);		
	}
    return platform;
}

+ (BOOL)isIPhone {
    return [[self model] isEqualToString:kPiPhoneDeviceModel];
}

+ (BOOL)isIPhone3GS {
	return [[self platform] isEqualToString:kPiPhone3GSPlatformKey];
}

+ (BOOL)isIPhone4 {
    NSString *platform = [self platform];
    return [platform isEqualToString:kPiPhone4PlatformKey] || [platform isEqualToString:kPiPhone4VerizonPlatformKey];
}

+ (BOOL)isIPhone4S {
	return [[self platform] isEqualToString:kPiPhone4SPlatformKey];
}

+ (BOOL)isIPhone5 {
    NSString *platform = [self platform];
    return [platform isEqualToString:kPiPhone5GSMPlatformKey] || [platform isEqualToString:kPiPhone5CDMAPlatformKey];
}

+ (BOOL)isIPod {
    return [[self model] isEqualToString:kPiPodTouchDeviceModel];
}

+ (BOOL)isIPodThirdGeneration {
	return [[self platform] isEqualToString:kPiPod3GPlatformKey];
}

+ (BOOL)isIPodFourthGeneration {
	return [[self platform] isEqualToString:kPiPod4GPlatformKey];
}

+ (BOOL)isIPodFifthGeneration {
	return [[self platform] isEqualToString:kPiPod5GPlatformKey];
}

+ (BOOL)isIPad {
    return [[self model] isEqualToString:kPiPadDeviceModel];
}

+ (BOOL)isIPadFirstGeneration {
	return [[self platform] isEqualToString:kPiPadPlatformKey];	
}

+ (BOOL)isIPadSecondGeneration {
    NSString *platform = [self platform];
    return [platform isEqualToString:kPiPad2WiFiPlatformKey] || [platform isEqualToString:kPiPad2GSMPlatformKey] || [platform isEqualToString:kPiPad2CDMAPlatformKey];
}

+ (BOOL)isIPadThirdGeneration {
    NSString *platform = [self platform];
    return [platform isEqualToString:kPiPad3WiFiPlatformKey] || [platform isEqualToString:kPiPad3GSMPlatformKey] || [platform isEqualToString:kPiPad3CDMAPlatformKey];
}

+ (BOOL)isIPadFourthGeneration {
    NSString *platform = [self platform];
    return [platform isEqualToString:kPiPad4WiFiPlatformKey] || [platform isEqualToString:kPiPad4GSMPlatformKey] || [platform isEqualToString:kPiPad4CDMAPlatformKey];
}

+ (BOOL)isIPadMiniFirstGeneration {
    NSString *platform = [self platform];
    return [platform isEqualToString:kPiPadMiniWiFiPlatformKey] || [platform isEqualToString:kPiPadMiniGSMPlatformKey] || [platform isEqualToString:kPiPadMiniCDMAPlatformKey];
}

+ (BOOL)isIOSSimulator {
    NSString *platform = [self platform];
    return [platform isEqualToString:kPiOSSimulatori386PlatformKey] || [platform isEqualToString:kPiOSSimulatorx86_64PlatformKey];
}

+ (BOOL)isIPhoneSimulator {
    return [[self model] isEqualToString:kPiPhoneSimulatorDeviceModel];
}

+ (BOOL)isIPadSimulator {
    return [[self model] isEqualToString:kPiPadSimulatorDeviceModel];
}

+ (NSString *)devicePlatformDescription {
	NSString *description = nil;
    if ([self isIPodThirdGeneration]) {
		description = kPiPodThirdGenerationPlatformDescription;
	} else if ([self isIPodFourthGeneration]) {
		description = kPiPodFourthGenerationPlatformDescription;
	} else if ([self isIPodFifthGeneration]) {
		description = kPiPodFifthGenerationPlatformDescription;
	} else if ([self isIPhone3GS]) {
		description = kPiPhone3GSPlatformDescription;		
	} else if ([self isIPhone4]) {
		description = kPiPhone4PlatformDescription;		
	} else if ([self isIPhone4S]) {
		description = kPiPhone4SPlatformDescription;
	} else if ([self isIPhone5]) {
		description = kPiPhone5PlatformDescription;
	} else if ([self isIPadFirstGeneration]) {
		description = kPiPadFirstGenerationPlatformDescription;		
	} else if ([self isIPadSecondGeneration]) {
		description = kPiPadSecondGenerationPlatformDescription;
	} else if ([self isIPadThirdGeneration]) {
		description = kPiPadThirdGenerationPlatformDescription;
	} else if ([self isIPadFourthGeneration]) {
		description = kPiPadFourthGenerationPlatformDescription;
	} else if ([self isIPadMiniFirstGeneration]) {
		description = kPiPadMiniFirstGenerationPlatformDescription;
	} else if ([self isIOSSimulator]) {
		description = kPiOSSimulatorPlatformDescription;
	} else {
		description = [[UIDevice currentDevice] model];
	}
	return description;
}

+ (BOOL)isMicPresent {
    AVAudioSession *session = [AVAudioSession sharedInstance];
    if ([session inputIsAvailable]) {
        return YES;
    }
    return NO;
}

#pragma mark - UDID

+ (NSString *)pingerUniqueIdentifier {
    static NSString *uniqueId = nil;
    
    if (uniqueId == nil) {
        uniqueId = [UIDevice currentDevice].uniqueIdentifier;
    }
    
    return uniqueId;
}

@end


@interface PDummyClassToFixLoadingOfCategory17 : NSObject {
}
@end

@implementation PDummyClassToFixLoadingOfCategory17
@end