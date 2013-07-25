//
//  AJPlayer+Additions.m
//  ScorePad
//
//  Created by Anca Julean on 9/11/12.
//  Copyright (c) 2012 Anca Julean. All rights reserved.
//

#import "AJPlayer+Additions.h"

#import "UIImage+Additions.h"

@implementation AJPlayer (Additions)

+ (AJPlayer *)createPlayerWithName:(NSString *)name forGame:(AJGame *)game {
    AJPlayer *player = nil;
    
    player = [NSEntityDescription insertNewObjectForEntityForName:@"AJPlayer" inManagedObjectContext:game.managedObjectContext];
    player.name = name;
    player.game = game;
    player.time = [NSDate date];
    player.sortOrder = AJScoresSortingNone;
    
    return player;
}


#pragma mark - Public properties

- (double)totalScore {
    double total = 0.0;
    
    for (AJScore *score in self.scores) {
        total += [[score value] doubleValue];
    }
    
    return total;
}

- (NSArray *)scoreValues {
    NSMutableArray *values = [[NSMutableArray alloc] init];
    
    for (AJScore *score in self.scores) {
        [values addObject:score.value];
    }
    
    return values;
}

#pragma mark - Public methods

- (NSDictionary *)toDictionary {
    NSMutableDictionary *displayDictionary = [NSMutableDictionary dictionary];
    
    displayDictionary[kAJNameKey] = self.name;
    displayDictionary[kAJColorStringKey] = self.color;
    
    NSData *data = self.imageData;
    if (!data) {
        data = UIImagePNGRepresentation([UIImage defaultPlayerPicture]);
    }
    displayDictionary[kAJPictureDataKey] = data;
    
    displayDictionary[kAJRowIdKey] = [NSNumber numberWithInt:-1];
    displayDictionary[kAJPlayerTotalScoresKey] = @([self totalScore]);
    displayDictionary[kAJPlayerNumberOfRoundsKey] = @([self.scores count]);
    
    return displayDictionary;
}

- (void)setPropertiesFromDictionary:(NSDictionary *)dictionary {
    self.name = dictionary[kAJNameKey];
    self.color = dictionary[kAJColorStringKey];
    self.imageData = dictionary[kAJPictureDataKey];
}

@end
