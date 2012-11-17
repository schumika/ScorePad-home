//
//  AJSettingsViewController.h
//  ScorePad
//
//  Created by Anca Julean on 9/13/12.
//  Copyright (c) 2012 Anca Julean. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AJSettingsViewControllerDelegate;

@class AJImageAndNameView;
@class AJSettingsInfo;

typedef enum {
    AJGameItem,
    AJPlayerItem
} AJItemType;

@interface AJSettingsViewController : AJTableViewController <UITextFieldDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate> {
    AJItemType _itemType;
    AJSettingsInfo *_settingsInfo;
    NSArray *_colorsArray;
    UITextField *_nameTextField;
    
    AJImageAndNameView *_headerView;
    
    id<AJSettingsViewControllerDelegate> _delegate;
}

@property (nonatomic, assign) AJItemType itemType;
@property (nonatomic, retain) AJSettingsInfo *settingsInfo;
@property (nonatomic, assign) id<AJSettingsViewControllerDelegate> delegate;

- (id)initWithSettingsInfo:(AJSettingsInfo *)settingsInfo andItemType:(AJItemType)itemType;

@end


@protocol AJSettingsViewControllerDelegate<NSObject>

- (void)settingsViewControllerDidFinishEditing:(AJSettingsViewController *)settingsViewController withSettingsInfo:(AJSettingsInfo *)settingsInfo;

@end