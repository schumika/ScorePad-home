//
//  AJSettingsViewController.m
//  ScorePad
//
//  Created by Anca Julean on 9/13/12.
//  Copyright (c) 2012 Anca Julean. All rights reserved.
//

#import "AJSettingsViewController.h"

#import "AJExportScoresViewController.h"
#import "AJBrownUnderlinedView.h"
#import "AJPlayer+Additions.h"
#import "AJGame+Additions.h"
#import "AJScoresManager.h"

#import "UIFont+Additions.h"
#import "UIColor+Additions.h"
#import "UIImage+Additions.h"

static CGFloat kHeaderViewHeight = 35.0;

#define COLORS_TABLE_VIEW_TAG (1)
#define NAME_TABLE_VIEW_TAG (2)

#define CLEAR_ONE_PLAYER_SCORES_ALERT_TAG   (10)
#define CLEAR_ALL_PLAYER_SCORES_ALERT_TAG   (11)
#define DELETE_ALL_PLAYERS_ALERT_TAG        (12)
#define EXPORT_PLAYERS_SCORES_ALERT_TAG     (13)

#define SELECT_PICTURE_WITH_CAMERA_ACTION_SHEET_TAG (3)
#define SELECT_PICTURE_WITHOUT_CAMERA_ACTION_SHEET_TAG (4)


@interface AJSettingsViewController ()

@property (nonatomic, assign) AJItemType itemType;
@property (nonatomic, strong) NSMutableDictionary *itemProperties;

@property (nonatomic, strong) UIView *colorsContainerView;
@property (nonatomic, strong) NSArray *colorsArray;
@property (nonatomic, strong) UIButton *pictureButton;
@property (nonatomic, strong) UITextField *nameTextField;
@property (nonatomic, strong) NSArray *pencilsArray;

- (IBAction)selectPictureButtonClicked;
- (IBAction)takePictureButtonClicked;
- (IBAction)setDefaultButtonClicked;

- (void)loadSelectedPencil;

@end


@implementation AJSettingsViewController

- (id)initWithItemProperties:(NSDictionary *)itemProperties andItemType:(AJItemType)itemType {
    self = [super initWithNibName:nil bundle:nil];
    
    if (!self) return nil;
    
    self.itemProperties = [NSMutableDictionary dictionaryWithDictionary:itemProperties];
    self.itemType = itemType;
    self.colorsArray = [[NSArray alloc] initWithObjects:[UIColor blackColor], [UIColor AJBlueColor], [UIColor AJBrownColor],
                        [UIColor AJGreenColor], [UIColor AJOrangeColor], [UIColor AJPinkColor], [UIColor AJPurpleColor],
                        [UIColor AJRedColor], [UIColor AJYellowColor], [UIColor whiteColor], nil];
    
    self.pencilsArray = @[@"pencil_black.png", @"pencil_blue.png", @"pencil_brown.png", @"pencil_green.png", @"pencil_orange.png",
                          @"pencil_pink.png", @"pencil_purple.png", @"pencil_red.png", @"pencil_yellow.png", @"pencil_white.png"];
    
    
    return self;
}

- (void)dealloc {
    [self.nameTextField setDelegate:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background.png"]];
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem simpleBarButtonItemWithTitle:@"Cancel" target:self action:@selector(cancelButtonClicked:)];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem simpleBarButtonItemWithTitle:@"Done" target:self action:@selector(doneButtonClicked:)];
    
    
    self.pictureButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.pictureButton.frame = CGRectMake(20.0, 5.0, 70.0, 70.0);
    UIImage *itemImage = [UIImage imageWithData:self.itemProperties[kAJPictureDataKey]];
    [self.pictureButton setImage:itemImage forState:UIControlStateNormal];
    [self.pictureButton addTarget:self action:@selector(pictureButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *label = [[UILabel alloc] initWithFrame:self.pictureButton.bounds];
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = UITextAlignmentCenter;
    label.font = [UIFont LDBrushFontWithSize:40.0];
    label.textColor = [UIColor AJBrownColor];
    label.text = @"edit\npicture";
    label.numberOfLines = 2;
    [self.pictureButton addSubview:label];
    
    self.nameTextField = [[UITextField alloc] initWithFrame:CGRectMake(120.0, 30.0, 190.0, 40.0)];
    self.nameTextField.borderStyle = UITextBorderStyleNone;
    self.nameTextField.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.nameTextField.background = [UIImage roundTextFieldImage];
    self.nameTextField.backgroundColor = [UIColor clearColor];
    self.nameTextField.delegate = self;
    self.nameTextField.placeholder = @"Enter the Name";
    self.nameTextField.font = [UIFont LDBrushFontWithSize:44.0];
    self.nameTextField.textAlignment = UITextAlignmentCenter;
    self.nameTextField.adjustsFontSizeToFitWidth = YES;
    self.nameTextField.textColor = [UIColor AJBrownColor];
    self.nameTextField.returnKeyType = UIReturnKeyDone;
    self.nameTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.nameTextField.text = self.itemProperties[kAJNameKey];
    
    self.colorsContainerView = [[UIView alloc] initWithFrame:CGRectMake(10.0, 40.0, 300.0, 100.0)];
    self.colorsContainerView.backgroundColor = [UIColor clearColor];
    UIImageView *containerFrameImageView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"round.png"] stretchableImageWithLeftCapWidth:10.0 topCapHeight:10.0]];
    containerFrameImageView.frame = self.colorsContainerView.bounds;
    [self.colorsContainerView addSubview:containerFrameImageView];
    
    CGSize pencilSize = CGSizeMake(40.0, 40.0);
    CGFloat pencilOffset = (self.colorsContainerView.frame.size.width) / (self.pencilsArray.count);
    CGFloat xOffset = 10.0;
    CGFloat yOffset = 10.0;
    
    for (NSString *pencilImageName in self.pencilsArray) {
        UIButton *pencilButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [pencilButton setFrame:CGRectMake(xOffset, yOffset, pencilSize.width, pencilSize.height)];
        
        if (xOffset + (pencilSize.width - 15.0) > self.colorsContainerView.frame.size.width - 2 * pencilOffset) {
            xOffset = pencilSize.width - 15.0 + ceil(pencilOffset / 2.0);
            yOffset += pencilSize.height + 5.0;
        } else {
            xOffset += pencilSize.width - 15.0 + pencilOffset;
        }
        
        [pencilButton setTag:[self.pencilsArray indexOfObject:pencilImageName]];
        [pencilButton setImageEdgeInsets:UIEdgeInsetsMake(5.0, 5.0, 5.0, 5.0)];
        
        UIImage *pencilImage = [UIImage imageNamed:pencilImageName];
        [pencilButton setImage:pencilImage forState:UIControlStateNormal];
        
        [pencilButton addTarget:self action:@selector(pencilButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.colorsContainerView addSubview:pencilButton];
    }
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.titleViewText  = self.itemProperties[kAJNameKey];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self loadSelectedPencil];
}

- (void)loadSelectedPencil {
    for (UIView *pencilButton in self.colorsContainerView.subviews) {
        if ([pencilButton isKindOfClass:[UIButton class]]) {
            int colorIndex = pencilButton.tag;
            
            UIColor *pencilColor = [self.colorsArray objectAtIndex:colorIndex];
            if ([self.itemProperties[kAJColorStringKey] isEqualToString:[pencilColor toHexString:YES]]) {
                [(UIButton *)pencilButton setBackgroundImage:[[UIImage imageNamed:@"round.png"] stretchableImageWithLeftCapWidth:10.0 topCapHeight:10.0]
                                                    forState:UIControlStateNormal];
            } else {
                [(UIButton *)pencilButton setBackgroundImage:nil forState:UIControlStateNormal];
            }
        }
    }
}

#pragma mark - UITableViewDataSource and Delegate methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return (self.itemType == AJGameItem) ? 2 : 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return (section == 0) ? 2 : ((self.itemType == AJGameItem) ? 3 : 1);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *photoAndNameCellIdentifier = @"PhotoAndNameCellIdentifier";
    static NSString *colorCellIdentifier = @"ColorCellIdentifier";
    static NSString *otherCellIdentifier = @"OtherCellIdentifier";
    
    UITableViewCell *cell = nil;
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            UITableViewCell *aCell = [tableView dequeueReusableCellWithIdentifier:photoAndNameCellIdentifier];
            
            if (aCell == nil) {
                aCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:photoAndNameCellIdentifier];
                aCell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                [aCell.contentView addSubview:self.pictureButton];
                
                CGRect tfFrame = self.nameTextField.frame;
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(tfFrame.origin.x, tfFrame.origin.y - 20.0, tfFrame.size.width, 20.0)];
                label.backgroundColor = [UIColor clearColor];
                label.font = [UIFont LDBrushFontWithSize:30.0];
                label.textColor = [UIColor AJBrownColor];
                label.text = @"Name :";
                [aCell.contentView addSubview:label];
                
                [aCell.contentView addSubview:self.nameTextField];
            }
            
            cell = aCell;
        } else {
            UITableViewCell *aCell = [tableView dequeueReusableCellWithIdentifier:colorCellIdentifier];
            
            if (aCell == nil) {
                aCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:colorCellIdentifier];
                aCell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                CGRect containerFrame = self.colorsContainerView.frame;
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(containerFrame.origin.x, containerFrame.origin.y - 25.0, containerFrame.size.width, 25.0)];
                label.backgroundColor = [UIColor clearColor];
                label.font = [UIFont LDBrushFontWithSize:30.0];
                label.textColor = [UIColor AJBrownColor];
                label.text = [NSString stringWithFormat:@"%@ color :", (self.itemType == AJGameItem) ? @"Game" : @"Player"];
                [aCell.contentView addSubview:label];
                
                [aCell.contentView addSubview:self.colorsContainerView];
            }
            
            cell = aCell;
        }
    } else {
        UITableViewCell *aCell = [tableView dequeueReusableCellWithIdentifier:otherCellIdentifier];
        
        if (aCell == nil) {
            aCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:otherCellIdentifier];
            aCell.selectionStyle = UITableViewCellSelectionStyleGray;
            
            AJBrownUnderlinedView *backView = [[AJBrownUnderlinedView alloc] initWithFrame:CGRectZero];
            backView.frame = aCell.contentView.bounds;
            backView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
            [aCell.contentView addSubview:backView];
            [aCell.contentView sendSubviewToBack:backView];
            
            aCell.textLabel.backgroundColor = [UIColor clearColor];
            aCell.textLabel.font = [UIFont LDBrushFontWithSize:40.0];
            aCell.textLabel.textColor = [UIColor AJBrownColor];
        }
        
        NSString *cellString = nil;
        switch (indexPath.row) {
            case 0:
                cellString = (self.itemType == AJGameItem) ? @"Clear all scores for this game" : @"Clear all scores for this player";
                break;
            case 1:
                cellString = @"Delete all players for this game";
                break;
            case 2:
                cellString = @"Share scores for this game";
                break;
            default:
                cellString = @"";
                break;
        }
        
        aCell.textLabel.text = cellString;
        
        cell = aCell;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return (indexPath.section == 0) ? ((indexPath.row == 0) ? 80.0 : 160.0) : 45.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        AJBrownUnderlinedView *headerView = [[AJBrownUnderlinedView alloc] initWithFrame:CGRectZero];
        headerView.backgroundImage = [UIImage imageNamed:@"background.png"];
        headerView.frame = CGRectMake(0.0, 0.0, CGRectGetWidth(tableView.bounds), kHeaderViewHeight);
        
        UILabel *appearanceLabel = [[UILabel alloc] initWithFrame:CGRectMake(5.0, 2.0, CGRectGetWidth(tableView.bounds), kHeaderViewHeight - 2.0)];
        appearanceLabel.text = [NSString stringWithFormat:@"%@ appearance", (self.itemType == AJGameItem) ? @"Game" : @"Player"];
        appearanceLabel.textColor = [UIColor AJGreenColor];
        appearanceLabel.font = [UIFont LDBrushFontWithSize:37.0];
        appearanceLabel.backgroundColor = [UIColor clearColor];
        [headerView addSubview:appearanceLabel];
        
        return headerView;
    } else if (section == 1) {
        AJBrownUnderlinedView *headerView = [[AJBrownUnderlinedView alloc] initWithFrame:CGRectZero];
        headerView.backgroundImage = [UIImage imageNamed:@"background.png"];
        headerView.frame = CGRectMake(0.0, 0.0, CGRectGetWidth(tableView.bounds), kHeaderViewHeight);
        
        UILabel *appearanceLabel = [[UILabel alloc] initWithFrame:CGRectMake(5.0, 0.0, CGRectGetWidth(tableView.bounds), kHeaderViewHeight)];
        appearanceLabel.text = @"Other game options";
        appearanceLabel.textColor = [UIColor AJGreenColor];
        appearanceLabel.font = [UIFont LDBrushFontWithSize:37.0];
        appearanceLabel.backgroundColor = [UIColor clearColor];
        [headerView addSubview:appearanceLabel];
        
        return headerView;
    }
    
    return [[UIView alloc] initWithFrame:CGRectZero];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return (section <= 1) ? kHeaderViewHeight : 0.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section != 1) return;
    
    NSString *alertTitle = nil;
    NSString *alertMessage = nil;
    NSString *alertOKButtonText = nil;
    int alertTag = -1;
    
    
    if (indexPath.row == 0) {
        if (self.itemType == AJPlayerItem) {
            alertTitle = @"Are you sure?";
            alertMessage = @"All scores for this player will be deleted.";
            alertOKButtonText = @"Delete";
            alertTag = CLEAR_ONE_PLAYER_SCORES_ALERT_TAG;
        } else {
            alertTitle = @"Are you sure?";
            alertMessage = @"The scores for all players in this game will be deleted.";
            alertOKButtonText = @"Delete";
            alertTag = CLEAR_ALL_PLAYER_SCORES_ALERT_TAG;
        }
    } else if (indexPath.row == 1) {
        alertTitle = @"Are you sure?";
        alertMessage = @"All players in this game will be deleted.";
        alertOKButtonText = @"Delete";
        alertTag = DELETE_ALL_PLAYERS_ALERT_TAG;
    } else {
        alertMessage = @"This option allows you to share the scores of this game.";
        alertOKButtonText = @"Continue";
        alertTag = EXPORT_PLAYERS_SCORES_ALERT_TAG;
    }
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:alertTitle
                                                        message:alertMessage
                                                       delegate:self
                                              cancelButtonTitle:@"Cancel" otherButtonTitles:alertOKButtonText, nil];
    alertView.tag = alertTag;
    
    [alertView show];
}

#pragma mark - Buttons Actions

-(IBAction)pencilButtonClicked:(UIButton *)sender {
    self.itemProperties[kAJColorStringKey] = [(UIColor *)[self.colorsArray objectAtIndex:sender.tag] toHexString:YES];
    
    [self loadSelectedPencil];
}

- (IBAction)cancelButtonClicked:(id)sender {
    if ([self.delegate respondsToSelector:@selector(settingsViewController:didFinishEditingItemProperties:)]) {
        [self.delegate settingsViewController:self didFinishEditingItemProperties:nil];
    }
}

- (IBAction)doneButtonClicked:(id)sender {
    self.itemProperties[kAJNameKey] = [self.nameTextField text];
    
    if ([self.delegate respondsToSelector:@selector(settingsViewController:didFinishEditingItemProperties:)]) {
        [self.delegate settingsViewController:self didFinishEditingItemProperties:self.itemProperties];
    }
}

#pragma mark - UITextFieldDelegate methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.nameTextField resignFirstResponder];
    self.itemProperties[kAJNameKey] = textField.text;
    
    return YES;
}

#pragma mark - Buttons Actions

- (IBAction)pictureButtonClicked:(id)sender {
    UIActionSheet *actionSheet = nil;
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
		actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self
                                         cancelButtonTitle:@"cancel" destructiveButtonTitle:nil
                                         otherButtonTitles:@"take photo", @"choose photo", @"set default", nil];
		actionSheet.tag = SELECT_PICTURE_WITH_CAMERA_ACTION_SHEET_TAG;
	} else {
		actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self
                                         cancelButtonTitle:@"cancel" destructiveButtonTitle:nil
                                         otherButtonTitles:@"choose photo", @"set default", nil];
		actionSheet.tag = SELECT_PICTURE_WITHOUT_CAMERA_ACTION_SHEET_TAG;
	}
	[actionSheet showInView:self.view];
}

#pragma mark - UIAlertViewDelegate methods

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex != alertView.cancelButtonIndex) {
        if (alertView.tag == CLEAR_ONE_PLAYER_SCORES_ALERT_TAG) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(settingsViewControllerDidSelectClearAllScoresForCurrentPlayer:)]) {
                [self.delegate settingsViewControllerDidSelectClearAllScoresForCurrentPlayer:self];
            }
            
        } else if (alertView.tag == CLEAR_ALL_PLAYER_SCORES_ALERT_TAG) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(settingsViewControllerDidSelectClearAllScoresForAllPlayers:)]) {
                [self.delegate settingsViewControllerDidSelectClearAllScoresForAllPlayers:self];
            }
            
        } else if (alertView.tag == DELETE_ALL_PLAYERS_ALERT_TAG) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(settingsViewControllerDidSelectDeleteAllPlayersForCurrentGame:)]) {
                [self.delegate settingsViewControllerDidSelectDeleteAllPlayersForCurrentGame:self];
            }
            
        } else if (alertView.tag == EXPORT_PLAYERS_SCORES_ALERT_TAG) {
            int gameRowId = [(NSNumber *)self.itemProperties[kAJRowIdKey] intValue];
            AJGame *game = [[AJScoresManager sharedInstance] getGameWithRowId:gameRowId];
            if (game != nil) {
                AJExportScoresViewController *exportViewController = [[AJExportScoresViewController alloc] initWithNibName:nil bundle:nil];
                exportViewController.itemType = self.itemType;
                exportViewController.itemRowId = gameRowId;
                [self.navigationController pushViewController:exportViewController animated:YES];
            }
        }
    }
}

#pragma mark - UIActionSheetDelegate methods

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (actionSheet.tag == SELECT_PICTURE_WITH_CAMERA_ACTION_SHEET_TAG) {
		if (buttonIndex == 0) {
			[self takePictureButtonClicked];
		} else if (buttonIndex == 1) {
			[self selectPictureButtonClicked];
		} else if (buttonIndex == 2) {
            [self setDefaultButtonClicked];
        }
	} else if (actionSheet.tag == SELECT_PICTURE_WITHOUT_CAMERA_ACTION_SHEET_TAG) {
		if (buttonIndex == 0) {
			[self selectPictureButtonClicked];
		} else if (buttonIndex == 1) {
            [self setDefaultButtonClicked];
        }
	}
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [self dismissModalViewControllerAnimated:YES];
    
    UIImage *originalImage = [info objectForKey:UIImagePickerControllerOriginalImage];
	UIImage *editedImage = [info objectForKey:UIImagePickerControllerEditedImage];
	
	if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
		UIImageWriteToSavedPhotosAlbum(originalImage, nil, NULL, NULL);
	}
    
    [self.pictureButton setImage:[[editedImage resizeToNewSize:CGSizeMake(50.0, 50.0)] applyMask:[UIImage imageNamed:@"mask.png"]] forState:UIControlStateNormal];
    self.itemProperties[kAJPictureDataKey] = UIImagePNGRepresentation(editedImage);
}

#pragma mark - Private Actions

- (IBAction)selectPictureButtonClicked {
	UIImagePickerController *controller = [[UIImagePickerController alloc] init];
	controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
	controller.allowsEditing = YES;
	controller.delegate = self;
	[self.navigationController presentModalViewController:controller animated:YES];
}

- (IBAction)takePictureButtonClicked {
	if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
		UIImagePickerController *controller = [[UIImagePickerController alloc] init];
		controller.sourceType = UIImagePickerControllerSourceTypeCamera;
		controller.allowsEditing = YES;
		controller.delegate = self;
		[self.navigationController presentModalViewController:controller animated:YES];
	}
}

- (IBAction)setDefaultButtonClicked {
    UIImage *defaultImage = (_itemType == AJGameItem) ? [UIImage defaultGamePicture] : [UIImage defaultPlayerPicture];
    
    [self.pictureButton setImage:[defaultImage applyMask:[UIImage imageNamed:@"mask.png"]] forState:UIControlStateNormal];
    self.itemProperties[kAJPictureDataKey] = UIImagePNGRepresentation(defaultImage);
}

@end
