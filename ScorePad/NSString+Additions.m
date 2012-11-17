//
//  NSString+Additions.m
//  ScoreTracker
//
//  Created by Anca Julean on 5/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NSString+Additions.h"

@implementation NSString (Additions)

+ (BOOL)isNilOrEmpty:(NSString *)string {
    BOOL nilOrEmpty = NO;
    
    if (!string || [string isEqualToString:@""]) {
        nilOrEmpty = YES;
    }
    
    return nilOrEmpty;
}

@end
