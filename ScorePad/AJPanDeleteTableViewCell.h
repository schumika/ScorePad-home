//
//  AJPanDeleteTableViewCell.h
//  ScorePad
//
//  Created by Anca Calugar on 11/17/12.
//  Copyright (c) 2012 Anca Julean. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AJPanDeleteTableViewCellDelegate;


@interface AJPanDeleteTableViewCell : UITableViewCell

@property (nonatomic, assign) id<AJPanDeleteTableViewCellDelegate> panGesturedelegate;

@end


@protocol AJPanDeleteTableViewCellDelegate <NSObject>

- (void)panDeleteCellDraggedToDelete:(AJPanDeleteTableViewCell *)cell;

@end
