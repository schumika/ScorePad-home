//
//  AJPlayer+Additions.m
//  ScorePad
//
//  Created by Anca Julean on 9/11/12.
//  Copyright (c) 2012 Anca Julean. All rights reserved.
//

#import "AJPlayer+Additions.h"
#import "AJSettingsInfo.h"

#import "UIImage+Additions.h"

@implementation AJPlayer (Additions)

+ (AJPlayer *)createPlayerWithName:(NSString *)name forGame:(AJGame *)game {
    AJPlayer *player = nil;
    
    player = [NSEntityDescription insertNewObjectForEntityForName:@"AJPlayer" inManagedObjectContext:game.managedObjectContext];
    player.name = name;
    player.game = game;
    player.time = [NSDate date];
    
    return player;
}

- (double)totalScore {
    double total = 0.0;
    
    for (AJScore *score in self.scores) {
        total += [[score value] doubleValue];
    }
    
    return total;
}

- (AJSettingsInfo *)settingsInfo {
    return [AJSettingsInfo createSettingsInfoWithImageData:self.imageData ? self.imageData : UIImagePNGRepresentation([UIImage defaultPlayerPicture])
                                                   andName:self.name
                                            andColorString:self.color];
}

- (NSArray *)scoreValues {
    NSMutableArray *values = [[NSMutableArray alloc] init];
    
    for (AJScore *score in self.scores) {
        [values addObject:score.value];
    }
    
    return [values autorelease];
}

@end
