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
    game.rowId = [NSNumber numberWithInt:0];
    game.sortOrder = AJPlayersSortingNone;
    
    CLSNSLog(@"a game was created with name %@", name);
    
    return game;
}

- (AJSettingsInfo *)settingsInfo {
    return [AJSettingsInfo createSettingsInfoWithImageData:self.imageData ? self.imageData : UIImagePNGRepresentation([UIImage defaultGamePicture])
                                                   andName:self.name
                                            andColorString:self.color
                                                  andRowId:self.rowId.intValue];
}

- (int)maxNumberOfScores; {
    int maxNumber = 0;
    
    for (AJPlayer *player in self.players) {
        maxNumber = MAX(maxNumber, [player.scores count]);
    }
    
    return maxNumber;
}

- (NSDictionary *)toDictionary {
    NSMutableDictionary *displayDictionary = [NSMutableDictionary dictionary];
    
    displayDictionary[kAJNameKey] = self.name;
    displayDictionary[kAJColorStringKey] = self.color;
    
    NSData *data = self.imageData;
    if (!data) {
        data = UIImagePNGRepresentation([UIImage defaultGamePicture]);
    }
    displayDictionary[kAJPictureDataKey] = data;
    
    displayDictionary[kAJRowIdKey] = self.rowId;
    displayDictionary[kAJGameNumberOfPlayersKey] = @([self.players count]);
    
    return displayDictionary;
}

@end
