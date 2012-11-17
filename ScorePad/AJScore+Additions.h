//
//  AJScore+Additions.h
//  ScorePad
//
//  Created by Anca Julean on 9/12/12.
//  Copyright (c) 2012 Anca Julean. All rights reserved.
//

#import "AJScore.h"
#import "AJPlayer+Additions.h"

@interface AJScore (Additions)

+ (AJScore *)createScoreWithValue:(double)value inRound:(int)round forPlayer:(AJPlayer *)player;

@end
