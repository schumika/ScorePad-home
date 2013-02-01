//
//  AJExportScoresViewController.h
//  ScorePad
//
//  Created by Anca Calugar on 2/1/13.
//  Copyright (c) 2013 Anca Julean. All rights reserved.
//

#import "AJViewController.h"

@interface AJExportScoresViewController : AJViewController {
    int _itemRowId;
    int _itemType;
}

@property (nonatomic, assign) int itemRowId;
@property (nonatomic, assign) int itemType;

@end
