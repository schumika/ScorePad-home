//
//  AJScoreTableViewCell.h
//  ScorePad
//
//  Created by Anca Calugar on 11/20/12.
//  Copyright (c) 2012 Anca Julean. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AJPanDeleteTableViewCell.h"

@interface AJScoreTableViewCell : AJPanDeleteTableViewCell

@property (nonatomic, assign) int round;
@property (nonatomic, assign) double score;
@property (nonatomic, assign) double intermediateTotal;

@end
