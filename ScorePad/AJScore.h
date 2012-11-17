//
//  AJScore.h
//  ScorePad
//
//  Created by Anca Calugar on 10/9/12.
//  Copyright (c) 2012 Anca Julean. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class AJPlayer;

@interface AJScore : NSManagedObject

@property (nonatomic, retain) NSNumber * round;
@property (nonatomic, retain) NSNumber * value;
@property (nonatomic, retain) AJPlayer *player;

@end
