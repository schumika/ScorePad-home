//
//  AJSettingsInfo.m
//  ScorePad
//
//  Created by Anca Calugar on 9/27/12.
//  Copyright (c) 2012 Anca Julean. All rights reserved.
//

#import "AJSettingsInfo.h"

@implementation AJSettingsInfo

@synthesize imageData = _imageData;
@synthesize name = _name;
@synthesize colorString = _colorString;

- (id)initWithImageData:(NSData *)imageData andName:(NSString *)name andColorString:(NSString *)colorString {
    self = [super init];
    
    if (!self) return nil;
    
    self.imageData = imageData;
    self.name = name;
    self.colorString = colorString;
    
    return self;
}

+ (id)createSettingsInfoWithImageData:(NSData *)imageData andName:(NSString *)name andColorString:(NSString *)colorString {
    return [[[self alloc] initWithImageData:imageData andName:name andColorString:colorString] autorelease];
}

- (void)dealloc {
    [_imageData release];
    [_name release];
    [_colorString release];
    
    [super dealloc];
}

@end
