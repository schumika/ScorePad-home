//
//  AJSettingsInfo.h
//  ScorePad
//
//  Created by Anca Calugar on 9/27/12.
//  Copyright (c) 2012 Anca Julean. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AJSettingsInfo : NSObject

@property (nonatomic, retain) NSData *imageData;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *colorString;

+ (id)createSettingsInfoWithImageData:(NSData *)imageData andName:(NSString *)name andColorString:(NSString *)colorString;

@end
