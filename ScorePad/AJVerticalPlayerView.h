//
//  AJVerticalPlayerView.h
//  ScorePad
//
//  Created by Anca Calugar on 10/9/12.
//  Copyright (c) 2012 Anca Julean. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AJVerticalPlayerViewDelegate;


@interface AJVerticalPlayerView : UIView

@property (nonatomic, assign) BOOL isFirstColumn;
@property (nonatomic, weak) id<AJVerticalPlayerViewDelegate> delegate;

- (id)initWithFrame:(CGRect)frame andName:(NSString *)name andScores:(NSArray *)scores andColor:(NSString *)color;

@end


@protocol AJVerticalPlayerViewDelegate <NSObject>

- (void)verticalPlayerViewDidClickName:(AJVerticalPlayerView *)verticalPlayerView;

@end
