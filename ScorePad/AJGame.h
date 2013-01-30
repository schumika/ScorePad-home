//
//  AJGame.h
//  ScorePad
//
//  Created by Anca Calugar on 1/30/13.
//  Copyright (c) 2013 Anca Julean. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class AJPlayer;

@interface AJGame : NSManagedObject

@property (nonatomic, retain) NSString * color;
@property (nonatomic, retain) NSData * imageData;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * rowId;
@property (nonatomic, retain) NSNumber * sortOrder;
@property (nonatomic, retain) NSSet *players;
@end

@interface AJGame (CoreDataGeneratedAccessors)

- (void)addPlayersObject:(AJPlayer *)value;
- (void)removePlayersObject:(AJPlayer *)value;
- (void)addPlayers:(NSSet *)values;
- (void)removePlayers:(NSSet *)values;
@end
