//
//  AJPlayer.h
//  ScorePad
//
//  Created by Anca Calugar on 1/31/13.
//  Copyright (c) 2013 Anca Julean. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class AJGame, AJScore;

@interface AJPlayer : NSManagedObject

@property (nonatomic, retain) NSString * color;
@property (nonatomic, retain) NSData * imageData;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSDate * time;
@property (nonatomic, retain) NSNumber * sortOrder;
@property (nonatomic, retain) AJGame *game;
@property (nonatomic, retain) NSSet *scores;
@end

@interface AJPlayer (CoreDataGeneratedAccessors)

- (void)addScoresObject:(AJScore *)value;
- (void)removeScoresObject:(AJScore *)value;
- (void)addScores:(NSSet *)values;
- (void)removeScores:(NSSet *)values;
@end
