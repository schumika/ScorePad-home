//
//  AJScrollView.m
//  ScorePad
//
//  Created by Anca Calugar on 10/10/12.
//  Copyright (c) 2012 Anca Julean. All rights reserved.
//

#import "AJScrollView.h"

@implementation AJScrollView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.directionalLockEnabled = YES;
    }
    return self;
}

@end
