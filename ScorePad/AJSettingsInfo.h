//
//  AJSettingsInfo.h
//  ScorePad
//
//  Created by Anca Calugar on 9/27/12.
//  Copyright (c) 2012 Anca Julean. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AJSettingsInfo : NSObject

@property (nonatomic, strong) NSData *imageData;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *colorString;
@property (nonatomic, assign) int rowId;

+ (id)createSettingsInfoWithImageData:(NSData *)imageData andName:(NSString *)name andColorString:(NSString *)colorString andRowId:(int)rowId;

@end
