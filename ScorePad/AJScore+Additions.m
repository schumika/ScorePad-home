//
//  AJScore+Additions.m
//  ScorePad
//
//  Created by Anca Julean on 9/12/12.
//  Copyright (c) 2012 Anca Julean. All rights reserved.
//

#import "AJScore+Additions.h"

#import "AJPlayer+Additions.h"

@implementation AJScore (Additions)

+ (AJScore *)createScoreWithValue:(double)value inRound:(int)round forPlayer:(AJPlayer *)player {
    AJScore *score = nil;
    
    score = [NSEntityDescription insertNewObjectForEntityForName:@"AJScore" inManagedObjectContext:player.managedObjectContext];
    score.value = [NSNumber numberWithDouble:value];
    score.round = [NSNumber numberWithInt:round];
    score.player = player;
    
    return score;
}

@end
