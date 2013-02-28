//
//  AJScore.h
//  ScorePad
//
//  Created by Anca Calugar on 10/9/12.
//  Copyright (c) 2012 Anca Julean. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class AJPlayer;

@interface AJScore : NSManagedObject

@property (nonatomic, strong) NSNumber * round;
@property (nonatomic, strong) NSNumber * value;
@property (nonatomic, strong) AJPlayer *player;

@end
