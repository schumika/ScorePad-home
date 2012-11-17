//
//  AJGameTableViewCell.h
//  ScorePad
//
//  Created by Anca Calugar on 10/11/12.
//  Copyright (c) 2012 Anca Julean. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AJGameTableViewCell : UITableViewCell {
    NSString *_name;
    NSString *_color;
    UIImage *_picture;
    int _numberOfPlayers;
}

@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *color;
@property (nonatomic, retain) UIImage *picture;
@property (nonatomic, assign) int numberOfPlayers;

@end
