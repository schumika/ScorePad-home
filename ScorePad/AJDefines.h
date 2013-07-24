//
//  AJDefines.h
//  ScorePad
//
//  Created by Anca Calugar on 2/1/13.
//  Copyright (c) 2013 Anca Julean. All rights reserved.
//

#import <Foundation/Foundation.h>

#define IS_TALLSCREEN (fabs((double)[[UIScreen mainScreen]bounds].size.height - (double)568) < DBL_EPSILON)

#define AJLog(message) CLSNSLog(message)

typedef enum {
    AJGameItem,
    AJPlayerItem
} AJItemType;

extern NSString const * kAJPlayerNameKey;
extern NSString const * kAJPlayerColorStringKey;
extern NSString const * kAJPlayerPictureDataKey;
extern NSString const * kAJPlayerTotalScoresKey;
extern NSString const * kAJPlayerNumberOfRoundsKey;