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
#import "UIFont+Additions.h"

@interface AJGameTableViewCell ()
@property (nonatomic, strong)    UIImageView *pictureView;
@property (nonatomic, strong)    UILabel *nameLabel;
@property (nonatomic, strong)    UILabel *playersLabel;
    
@property (nonatomic, strong)    UIImageView *lineSeparatorView;
@property (nonatomic, strong)    UIImageView *disclosureView;
@end

@implementation AJGameTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (!self)  return  nil;
    
    self.pictureView = [[UIImageView alloc] initWithFrame:CGRectMake(5.0, 5.0, 50.0, 50.0)];
    self.pictureView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
    [self.contentView addSubview:self.pictureView];
    
    self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(70.0, 3.0, 240.0, 40.0)];
    self.nameLabel.backgroundColor = [UIColor clearColor];
    self.nameLabel.textColor = [UIColor brownColor];
    //self.nameLabel.font = [UIFont fontWithName:@"Zapfino" size:20.0];
    //self.nameLabel.font = [UIFont handwritingBoldFontWithSize:40.0];
    self.nameLabel.font = [UIFont LDBrushFontWithSize:55.0];
    //self.nameLabel.font = [UIFont chalkdusterFontWithSize:25.0];
    self.nameLabel.adjustsFontSizeToFitWidth = YES;
    self.nameLabel.minimumFontSize = 20.0;
    self.nameLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [self.contentView addSubview:self.nameLabel];
    
    self.playersLabel = [[UILabel alloc] initWithFrame:CGRectMake(70.0, 40.0, 240.0, 20.0)];
    self.playersLabel.backgroundColor = [UIColor clearColor];
    self.playersLabel.textColor = [UIColor grayColor];
    self.playersLabel.font = [UIFont fontWithName:@"Thonburi" size:15.0];
    //self.playersLabel.font = [UIFont chalkdusterFontWithSize:15.0];
    self.playersLabel.adjustsFontSizeToFitWidth = YES;
    self.playersLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [self.contentView addSubview:self.playersLabel];
    
    self.lineSeparatorView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"separator_new2.png"]];
    [self.contentView addSubview:self.lineSeparatorView];
    
    self.disclosureView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"disclosure.png"]];
    [self.contentView addSubview:self.disclosureView];
    
    return self;
}


- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat cellHeight = self.contentView.bounds.size.height, cellWidth = self.contentView.bounds.size.width;
    self.pictureView.frame = CGRectMake(5.0, ceil((cellHeight - 50.0) / 2.0), 50.0, 50.0);
    CGFloat pictureMaxX = CGRectGetMaxX(self.pictureView.frame) + 10.0;
    //self.nameLabel.frame = CGRectMake(pictureMaxX, 5.0, cellWidth - pictureMaxX, 58.0);
    self.nameLabel.frame = CGRectMake(pictureMaxX, 2.0, cellWidth - pictureMaxX - 30.0, 45.0);
    self.playersLabel.frame = CGRectMake(pictureMaxX, cellHeight - 18.0, cellWidth - pictureMaxX, 15.0);

    self.lineSeparatorView.frame = CGRectMake(0.0, cellHeight - 2.0, cellWidth, 2.0);
    self.disclosureView.frame = CGRectMake(cellWidth - 30.0, ceil((cellHeight - 20.0) / 2.0), 20.0, 20.0);
}

- (void)setDisplayDictionary:(NSDictionary *)displayDictionary {
    if (displayDictionary != _displayDictionary) {
        self.nameLabel.text = displayDictionary[kAJNameKey];
        self.nameLabel.textColor = [UIColor colorWithHexString:displayDictionary[kAJColorStringKey]];
        
        UIImage *gameImage = [UIImage imageWithData:displayDictionary[kAJPictureDataKey]];
        [self.pictureView setImage:[[gameImage resizeToNewSize:CGSizeMake(50.0, 50.0)] applyMask:[UIImage imageNamed:@"mask.png"]]];
        
        int numberOfPlayers = [(NSNumber *)displayDictionary[kAJGameNumberOfPlayersKey] intValue];
        self.playersLabel.text = [NSString stringWithFormat:@"%d %@", numberOfPlayers, (numberOfPlayers == 1) ? @"player" : @"players"];;
    }
}

@end
