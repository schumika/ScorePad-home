//
//  AJGame+Additions.h
//  ScorePad
//
//  Created by Anca Julean on 9/11/12.
//  Copyright (c) 2012 Anca Julean. All rights reserved.
//

#import "AJGame.h"

@class AJSettingsInfo;

@interface AJGame (Additions)

+ (AJGame *)createGameWithName:(NSString *)name inManagedObjectContext:(NSManagedObjectContext *)context;

- (AJSettingsInfo *)settingsInfo;
- (int)maxNumberOfScores;

@end
