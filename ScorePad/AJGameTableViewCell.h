//
//  AJGameTableViewCell.h
//  ScorePad
//
//  Created by Anca Calugar on 10/11/12.
//  Copyright (c) 2012 Anca Julean. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AJPanDeleteTableViewCell.h"

@interface AJGameTableViewCell : AJPanDeleteTableViewCell

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *color;
@property (nonatomic, strong) UIImage *picture;
@property (nonatomic, assign) int numberOfPlayers;

@end
