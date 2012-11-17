//
//  AJGameTableViewCell.m
//  ScorePad
//
//  Created by Anca Calugar on 10/11/12.
//  Copyright (c) 2012 Anca Julean. All rights reserved.
//

#import "AJGameTableViewCell.h"

#import "UIImage+Additions.h"
#import "UIColor+Additions.h"

@interface AJGameTableViewCell () {
    UIImageView *_pictureView;
    UILabel *_nameLabel;
    UILabel *_playersLabel;
}

@end

@implementation AJGameTableViewCell

@synthesize name = _name;
@synthesize color = _color;
@synthesize picture = _picture;
@synthesize numberOfPlayers = _numberOfPlayers;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (!self)  return  nil;
    
    _pictureView = [[UIImageView alloc] initWithFrame:CGRectMake(5.0, 5.0, 50.0, 50.0)];
    _pictureView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
    [self.contentView addSubview:_pictureView];
    [_pictureView release];
    
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(70.0, 3.0, 240.0, 40.0)];
    _nameLabel.backgroundColor = [UIColor clearColor];
    _nameLabel.textColor = [UIColor brownColor];
    _nameLabel.font = [UIFont fontWithName:@"Thonburi-Bold" size:30.0];
    _nameLabel.adjustsFontSizeToFitWidth = YES;
    _nameLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [self.contentView addSubview:_nameLabel];
    [_nameLabel release];
    
    _playersLabel = [[UILabel alloc] initWithFrame:CGRectMake(70.0, 40.0, 240.0, 20.0)];
    _playersLabel.backgroundColor = [UIColor clearColor];
    _playersLabel.textColor = [UIColor grayColor];
    _playersLabel.font = [UIFont fontWithName:@"Thonburi" size:15.0];
    _playersLabel.adjustsFontSizeToFitWidth = YES;
    _playersLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [self.contentView addSubview:_playersLabel];
    [_playersLabel release];
    
    return self;
}

- (void)dealloc {
    [_name release];
    [_color release];
    [_picture release];
    
    [super dealloc];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat cellHeight = self.contentView.bounds.size.height, cellWidth = self.contentView.bounds.size.width;
    _pictureView.frame = CGRectMake(5.0, ceil((cellHeight - 50.0) / 2.0), 50.0, 50.0);
    CGFloat pictureMaxX = CGRectGetMaxX(_pictureView.frame) + 10.0;
    _nameLabel.frame = CGRectMake(pictureMaxX, 3.0, cellWidth - pictureMaxX, 40.0);
    _playersLabel.frame = CGRectMake(pictureMaxX, cellHeight - 17.0, cellWidth - pictureMaxX, 15.0);
}

- (void)setName:(NSString *)name {
    if (name != _name) {
        [_name release];
        _name = [name retain];
        
        _nameLabel.text = _name;
    }
}

- (void)setColor:(NSString *)color {
    if (color != _color) {
        [_color release];
        _color = [color retain];
        
        _nameLabel.textColor = [UIColor colorWithHexString:_color];
    }
}

- (void)setPicture:(UIImage *)picture {
    if (picture != _picture) {
        [_picture release];
        _picture = [picture retain];
        
        [_pictureView setImage:[_picture applyMask:[UIImage imageNamed:@"mask.png"]]];
    }
}

- (void)setNumberOfPlayers:(int)numberOfPlayers {
    _numberOfPlayers = numberOfPlayers;
        
    _playersLabel.text = [NSString stringWithFormat:@"%d %@", _numberOfPlayers, (_numberOfPlayers == 1) ? @"player" : @"players"];;
}

@end
