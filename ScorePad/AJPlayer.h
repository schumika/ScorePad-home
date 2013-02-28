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

@property (nonatomic, strong) NSString * color;
@property (nonatomic, strong) NSData * imageData;
@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSDate * time;
@property (nonatomic, strong) NSNumber * sortOrder;
@property (nonatomic, strong) AJGame *game;
@property (nonatomic, strong) NSSet *scores;
@end

@interface AJPlayer (CoreDataGeneratedAccessors)

- (void)addScoresObject:(AJScore *)value;
- (void)removeScoresObject:(AJScore *)value;
- (void)addScores:(NSSet *)values;
- (void)removeScores:(NSSet *)values;
@end
