//
//  UIFont+Additions.m
//  FontTrial
//
//  Created by Anca Calugar on 1/24/13.
//  Copyright (c) 2013 Anca Julean. All rights reserved.
//

#import "UIFont+Additions.h"

static NSString *handwritingFontFamilyName = @"HandWriting53";
static NSString *LDBrushFontFamilyName = @"LD Brush Stroke";
static NSString *DKCrayonFontFamilyName = @"DK Crayon Crumble";


@implementation UIFont (Additions)

+ (NSArray *)fontNamesForHandwritingFamilyName {
    static NSArray *fontNames;
    
//    NSString *family, *font;
//    for (family in [UIFont familyNames])
//    {
//        NSLog(@"\nFamily: %@", family);
//        
//        for (font in [UIFont fontNamesForFamilyName:family])
//            NSLog(@"\tFont: %@\n", font);
//    }
    
    if (fontNames == nil) {
        fontNames = [[UIFont fontNamesForFamilyName:handwritingFontFamilyName] retain];
    }
    
    return fontNames;
}

+ (NSArray *)fontNamesForLDBrushFamilyName {
    static NSArray *fontNames;
    
    if (fontNames == nil) {
        fontNames = [[UIFont fontNamesForFamilyName:LDBrushFontFamilyName] retain];
    }
    
    return fontNames;
}

+ (UIFont *)LDBrushFontWithSize:(CGFloat)size {
    static UIFont *font = nil;
    
    if (font == nil) {
        if ([[self fontNamesForLDBrushFamilyName] lastObject] != nil) {
            font = [[UIFont fontWithName:[self fontNamesForLDBrushFamilyName][0] size:size] retain];
        }
        
        if (font == nil) {
            font = [[UIFont fontWithName:@"Thonburi-Bold" size:size] retain];
        }
    }
    
    return font;
}

+ (NSArray *)fontNamesForDKCrayonFamilyName {
    static NSArray *fontNames;
    
    if (fontNames == nil) {
        fontNames = [[UIFont fontNamesForFamilyName:DKCrayonFontFamilyName] retain];
    }
    
    return fontNames;
}

+ (UIFont *)DKCrayonFontWithSize:(CGFloat)size {
    static UIFont *font = nil;
    
    if (font == nil) {
        if ([[self fontNamesForDKCrayonFamilyName] lastObject] != nil) {
            font = [[UIFont fontWithName:[self fontNamesForDKCrayonFamilyName][0] size:size] retain];
        }
        
        if (font == nil) {
            font = [[UIFont fontWithName:@"Thonburi-Bold" size:size] retain];
        }
    }
    
    return font;
}

+ (UIFont *)handwritingBoldFontWithSize:(CGFloat)size {
    static UIFont *font = nil;
    
    if (font == nil) {
        for (NSString *fontName in [self fontNamesForHandwritingFamilyName]) {
            if ([fontName rangeOfString:@"Bold"].location != NSNotFound) {
                font = [[UIFont fontWithName:fontName size:size] retain];
                break;
            }
        }

        if (font == nil) {
            font = [[UIFont fontWithName:@"Thonburi-Bold" size:size] retain];
        }
    }

    return font;
}

+ (UIFont *)handwritingFontWithSize:(CGFloat)size {
    static UIFont *font = nil;
    
    if (font == nil) {
        for (NSString *fontName in [self fontNamesForHandwritingFamilyName]) {
            if ([fontName rangeOfString:@"Ext"].location != NSNotFound) {
                font = [[UIFont fontWithName:fontName size:size] retain];
                break;
            }
        }
        
        if (font == nil) {
            font = [[UIFont fontWithName:@"Thonburi" size:size] retain];
        }
    }
    
    return font;
}

@end
