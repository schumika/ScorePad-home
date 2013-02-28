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

@property (nonatomic, strong) NSString * color;
@property (nonatomic, strong) NSData * imageData;
@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSNumber * rowId;
@property (nonatomic, strong) NSNumber * sortOrder;
@property (nonatomic, strong) NSSet *players;
@end

@interface AJGame (CoreDataGeneratedAccessors)

- (void)addPlayersObject:(AJPlayer *)value;
- (void)removePlayersObject:(AJPlayer *)value;
- (void)addPlayers:(NSSet *)values;
- (void)removePlayers:(NSSet *)values;
@end
