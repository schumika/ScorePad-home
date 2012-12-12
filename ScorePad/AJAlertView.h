//
//  AJAlertView.h
//  ScorePad
//
//  Created by Anca Calugar on 12/12/12.
//  Copyright (c) 2012 Anca Julean. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AJAlertView : UIAlertView {
    NSDictionary *_userInfo;
}

@property (nonatomic, retain) NSDictionary *userInfo;

@end
