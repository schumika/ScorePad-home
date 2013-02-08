//
//  AJExportScoresViewController.h
//  ScorePad
//
//  Created by Anca Calugar on 2/1/13.
//  Copyright (c) 2013 Anca Julean. All rights reserved.
//

#import <MessageUI/MessageUI.h>

@interface AJExportScoresViewController : UIViewController <UIActionSheetDelegate, UIScrollViewDelegate,
                                        UIGestureRecognizerDelegate, MFMailComposeViewControllerDelegate> {
    int _itemRowId;
    int _itemType;
}

@property (nonatomic, assign) int itemRowId;
@property (nonatomic, assign) int itemType;

@end
