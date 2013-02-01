//
//  AJExportHandler.h
//  ScorePad
//
//  Created by Anca Calugar on 2/1/13.
//  Copyright (c) 2013 Anca Julean. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AJGame+Additions.h"

@interface AJExportHandler : NSObject {
    AJGame *_game;
}

@property (nonatomic, retain) AJGame *game;

- (id)initWithGame:(AJGame *)game;

- (UIImage *)createPlayersImage;

@end
