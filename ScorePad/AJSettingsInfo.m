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
@synthesize rowId = _rowId;

- (id)initWithImageData:(NSData *)imageData andName:(NSString *)name andColorString:(NSString *)colorString andRowId:(int)rowId {
    self = [super init];
    
    if (!self) return nil;
    
    self.imageData = imageData;
    self.name = name;
    self.colorString = colorString;
    self.rowId = rowId;
    
    return self;
}

+ (id)createSettingsInfoWithImageData:(NSData *)imageData andName:(NSString *)name andColorString:(NSString *)colorString andRowId:(int)rowId {
    return [[self alloc] initWithImageData:imageData andName:name andColorString:colorString andRowId:rowId];
}


@end
