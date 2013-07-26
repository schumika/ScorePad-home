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
    player.sortOrder = @(AJScoresSortingByRoundASC);
    
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
    NSMutableArray *values = [NSMutableArray array];
    
    for (AJScore *score in self.scores) {
        [values addObject:score.value];
    }
    
    return values;
}

- (NSArray *)orderedScoresArray {
    return [self orderedScoresArraySortedAscending:(self.sortOrder.intValue == AJScoresSortingByRoundASC)];
    
}

- (NSArray *)orderedScoresArraySortedAscending:(BOOL)ascending {
    NSMutableArray *orderedArray = [NSMutableArray arrayWithArray:[self.scores allObjects]];
    
    [orderedArray sortUsingComparator:^NSComparisonResult(AJScore *score1, AJScore *score2) {
        if (score1.round.intValue < score2.round.intValue) {
            return ascending ? NSOrderedAscending : NSOrderedDescending;
        } else {
            return ascending ? NSOrderedDescending : NSOrderedAscending;
        }
    }];
        
    return orderedArray;

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

- (double)intermediateTotalAtRound:(int)row {
    double total = 0.0;
    
    NSArray *scores = [self orderedScoresArraySortedAscending:YES];
    int currentRow = row;
    for (int rowIndex = 0; rowIndex < currentRow; rowIndex++) {
            AJScore *score = scores[rowIndex];
            total += [score.value doubleValue];
    }
    
    return total;
}

- (void)updateRoundsForScores {
    NSArray *orderedArray = [NSArray arrayWithArray:self.orderedScoresArray];
    
    int rounds = self.orderedScoresArray.count;
    int scoresSortingType = self.sortOrder.intValue;
    
    [orderedArray enumerateObjectsUsingBlock:^(AJScore *score, NSUInteger scoreIndex, BOOL *stop) {
        if (scoresSortingType == AJScoresSortingByRoundDESC) {
            score.round = @(rounds - scoreIndex);
        } else {
            score.round = @(scoreIndex + 1);
        }
    }];
    
    [self.managedObjectContext save:nil];
}

@end
