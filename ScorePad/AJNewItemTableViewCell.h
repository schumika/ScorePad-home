//
//  AJNewItemTableViewCell.h
//  ScorePad
//
//  Created by Anca Calugar on 10/12/12.
//  Copyright (c) 2012 Anca Julean. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AJNewItemTableViewCell : UITableViewCell {
    UITextField *_textField;
}

@property (nonatomic, readonly) UITextField *textField;

@end
