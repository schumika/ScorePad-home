//
//  AJGame+Additions.m
//  ScorePad
//
//  Created by Anca Julean on 9/11/12.
//  Copyright (c) 2012 Anca Julean. All rights reserved.
//

#import "AJGame+Additions.h"
#import "AJSettingsInfo.h"
#import "AJPlayer+Additions.h"

#import "UIImage+Additions.h"

@implementation AJGame (Additions)

+ (AJGame *)createGameWithName:(NSString *)name inManagedObjectContext:(NSManagedObjectContext *)context {
    AJGame *game = nil;
    
    game = [NSEntityDescription insertNewObjectForEntityForName:@"AJGame" inManagedObjectContext:context];
    game.name = name;
    game.rowId = 0;
    
    return game;
}

- (AJSettingsInfo *)settingsInfo {
    return [AJSettingsInfo createSettingsInfoWithImageData:self.imageData ? self.imageData : UIImagePNGRepresentation([UIImage defaultGamePicture])
                                                   andName:self.name
                                            andColorString:self.color];
}

- (int)maxNumberOfScores; {
    int maxNumber = 0;
    
    for (AJPlayer *player in self.players) {
        maxNumber = MAX(maxNumber, [player.scores count]);
    }
    
    return maxNumber;
}

@end
