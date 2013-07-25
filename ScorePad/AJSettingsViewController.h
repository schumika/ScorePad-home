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

@interface AJSettingsViewController : AJTableViewController <UITextFieldDelegate, UIActionSheetDelegate, UIAlertViewDelegate,
                                                        UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, weak) id<AJSettingsViewControllerDelegate> delegate;

- (id)initWithItemProperties:(NSDictionary *)itemProperties andItemType:(AJItemType)itemType;

@end


@protocol AJSettingsViewControllerDelegate<NSObject>

- (void)settingsViewController:(AJSettingsViewController *)settingsViewController didFinishEditingItemProperties:(NSDictionary *)itemProperties;

@optional
- (void)settingsViewControllerDidSelectClearAllScoresForCurrentPlayer:(AJSettingsViewController *)settingsViewController;
- (void)settingsViewControllerDidSelectClearAllScoresForAllPlayers:(AJSettingsViewController *)settingsViewController;
- (void)settingsViewControllerDidSelectDeleteAllPlayersForCurrentGame:(AJSettingsViewController *)settingsViewController;

@end