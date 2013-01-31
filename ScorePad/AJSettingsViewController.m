//
//  AJSettingsViewController.m
//  ScorePad
//
//  Created by Anca Julean on 9/13/12.
//  Copyright (c) 2012 Anca Julean. All rights reserved.
//

#import "AJSettingsViewController.h"
#import "AJBrownUnderlinedView.h"
#import "AJPlayer+Additions.h"
#import "AJGame+Additions.h"
#import "AJSettingsInfo.h"

#import "UIFont+Additions.h"
#import "UIColor+Additions.h"
#import "UIImage+Additions.h"

static CGFloat kHeaderViewHeight = 35.0;

#define COLORS_TABLE_VIEW_TAG (1)
#define NAME_TABLE_VIEW_TAG (2)

#define CLEAR_ONE_PLAYER_SCORES_ALERT_TAG   (10)
#define CLEAR_ALL_PLAYER_SCORES_ALERT_TAG   (11)
#define DELETE_ALL_PLAYERS_ALERT_TAG        (12)

#define SELECT_PICTURE_WITH_CAMERA_ACTION_SHEET_TAG (3)
#define SELECT_PICTURE_WITHOUT_CAMERA_ACTION_SHEET_TAG (4)


@interface AJSettingsViewController () {
    UIView *_colorsContainerView;
    NSArray *_pencilsArray;
    NSArray *_colorsArray;
    
    UIButton *_pictureButton;
    UITextField *_nameTextField;
}

@property (nonatomic, retain) NSArray *pencilsArray;

- (IBAction)selectPictureButtonClicked;
- (IBAction)takePictureButtonClicked;
- (IBAction)setDefaultButtonClicked;

- (void)loadSelectedPencil;

@end


@implementation AJSettingsViewController

@synthesize settingsInfo = _settingsInfo;
@synthesize itemType = _itemType;
@synthesize delegate = _delegate;
@synthesize pencilsArray = _pencilsArray;

- (id)initWithSettingsInfo:(AJSettingsInfo *)settingsInfo andItemType:(AJItemType)itemType {
    self = [super initWithNibName:nil bundle:nil];
    
    if (!self) return nil;
    
    self.settingsInfo = settingsInfo;
    self.itemType = itemType;
    _colorsArray = [[NSArray alloc] initWithObjects:[UIColor blackColor], [UIColor AJBlueColor], [UIColor AJBrownColor],
                    [UIColor AJGreenColor], [UIColor AJOrangeColor], [UIColor AJPinkColor], [UIColor AJPurpleColor],
                    [UIColor AJRedColor], [UIColor AJYellowColor], [UIColor whiteColor], nil];
    
    _pencilsArray = @[@"pencil_black.png", @"pencil_blue.png", @"pencil_brown.png", @"pencil_green.png", @"pencil_orange.png",
                        @"pencil_pink.png", @"pencil_purple.png", @"pencil_red.png", @"pencil_yellow.png", @"pencil_white.png"];

    
    return self;
}

- (void)dealloc {
    [_settingsInfo release];
    [_colorsArray release];
    
    [_pictureButton release];
    [_nameTextField setDelegate:nil];
    [_nameTextField release];
    
    [_colorsContainerView release];
    
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background.png"]];
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem clearBarButtonItemWithTitle:@"Cancel" target:self action:@selector(cancelButtonClicked:)];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem clearBarButtonItemWithTitle:@"Done" target:self action:@selector(doneButtonClicked:)];
    
    
    _pictureButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
    _pictureButton.frame = CGRectMake(20.0, 5.0, 70.0, 70.0);
    UIImage *itemImage = [UIImage imageWithData:self.settingsInfo.imageData];
    [_pictureButton setImage:itemImage forState:UIControlStateNormal];
    [_pictureButton addTarget:self action:@selector(pictureButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *label = [[UILabel alloc] initWithFrame:_pictureButton.bounds];
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = UITextAlignmentCenter;
    label.font = [UIFont LDBrushFontWithSize:40.0];
    label.textColor = [UIColor AJBrownColor];
    label.text = @"edit\npicture";
    label.numberOfLines = 2;
    [_pictureButton addSubview:label];
    [label release];
    
    _nameTextField = [[UITextField alloc] initWithFrame:CGRectMake(120.0, 30.0, 190.0, 40.0)];
    _nameTextField.borderStyle = UITextBorderStyleNone;
    _nameTextField.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    _nameTextField.background = [UIImage roundTextFieldImage];
    _nameTextField.backgroundColor = [UIColor clearColor];
    _nameTextField.delegate = self;
    _nameTextField.placeholder = @"Enter the Name";
    _nameTextField.font = [UIFont LDBrushFontWithSize:44.0];
    _nameTextField.textAlignment = UITextAlignmentCenter;
    _nameTextField.adjustsFontSizeToFitWidth = YES;
    _nameTextField.textColor = [UIColor AJBrownColor];
    _nameTextField.returnKeyType = UIReturnKeyDone;
    _nameTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _nameTextField.text = self.settingsInfo.name;
    
    _colorsContainerView = [[UIView alloc] initWithFrame:CGRectMake(10.0, 40.0, 300.0, 100.0)];
    _colorsContainerView.backgroundColor = [UIColor clearColor];
    UIImageView *containerFrameImageView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"round.png"] stretchableImageWithLeftCapWidth:10.0 topCapHeight:10.0]];
    containerFrameImageView.frame = _colorsContainerView.bounds;
    [_colorsContainerView addSubview:containerFrameImageView];
    [containerFrameImageView release];
    
    CGSize pencilSize = CGSizeMake(40.0, 40.0);
    CGFloat pencilOffset = (_colorsContainerView.frame.size.width) / (_pencilsArray.count);
    CGFloat xOffset = 10.0;
    CGFloat yOffset = 10.0;
    
    for (NSString *pencilImageName in _pencilsArray) {
        UIButton *pencilButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [pencilButton setFrame:CGRectMake(xOffset, yOffset, pencilSize.width, pencilSize.height)];
        
        if (xOffset + (pencilSize.width - 15.0) > _colorsContainerView.frame.size.width - 2 * pencilOffset) {
            xOffset = pencilSize.width - 15.0 + ceil(pencilOffset / 2.0);
            yOffset += pencilSize.height + 5.0;
        } else {
            xOffset += pencilSize.width - 15.0 + pencilOffset;
        }
        
        [pencilButton setTag:[_pencilsArray indexOfObject:pencilImageName]];
        [pencilButton setImageEdgeInsets:UIEdgeInsetsMake(5.0, 5.0, 5.0, 5.0)];
        
        UIImage *pencilImage = [UIImage imageNamed:pencilImageName];
        [pencilButton setImage:pencilImage forState:UIControlStateNormal];
        
        [pencilButton addTarget:self action:@selector(pencilButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_colorsContainerView addSubview:pencilButton];
    }
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self loadSelectedPencil];
}

- (void)loadSelectedPencil {
    for (UIView *pencilButton in _colorsContainerView.subviews) {
        if ([pencilButton isKindOfClass:[UIButton class]]) {
            int colorIndex = pencilButton.tag;
            
            UIColor *pencilColor = [_colorsArray objectAtIndex:colorIndex];
            if ([self.settingsInfo.colorString isEqualToString:[pencilColor toHexString:YES]]) {
                [(UIButton *)pencilButton setBackgroundImage:[[UIImage imageNamed:@"round.png"] stretchableImageWithLeftCapWidth:10.0 topCapHeight:10.0]
                                                    forState:UIControlStateNormal];
            } else {
                [(UIButton *)pencilButton setBackgroundImage:nil forState:UIControlStateNormal];
            }
        }
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (NSString *)titleViewText {
    return self.settingsInfo.name;
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
                aCell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:photoAndNameCellIdentifier] autorelease];
                aCell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                [aCell.contentView addSubview:_pictureButton];
                
                CGRect tfFrame = _nameTextField.frame;
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(tfFrame.origin.x, tfFrame.origin.y - 20.0, tfFrame.size.width, 20.0)];
                label.backgroundColor = [UIColor clearColor];
                label.font = [UIFont LDBrushFontWithSize:30.0];
                label.textColor = [UIColor AJBrownColor];
                label.text = @"Name :";
                [aCell.contentView addSubview:label];
                [label release];
                
                [aCell.contentView addSubview:_nameTextField];
            }
            
            cell = aCell;
        } else {
            UITableViewCell *aCell = [tableView dequeueReusableCellWithIdentifier:colorCellIdentifier];
            
            if (aCell == nil) {
                aCell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:colorCellIdentifier] autorelease];
                aCell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                CGRect containerFrame = _colorsContainerView.frame;
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(containerFrame.origin.x, containerFrame.origin.y - 25.0, containerFrame.size.width, 25.0)];
                label.backgroundColor = [UIColor clearColor];
                label.font = [UIFont LDBrushFontWithSize:30.0];
                label.textColor = [UIColor AJBrownColor];
                label.text = [NSString stringWithFormat:@"%@ color :", (self.itemType == AJGameItem) ? @"Game" : @"Player"];
                [aCell.contentView addSubview:label];
                [label release];
                
                [aCell.contentView addSubview:_colorsContainerView];
            }
            
            cell = aCell;
        }
    } else {
        UITableViewCell *aCell = [tableView dequeueReusableCellWithIdentifier:otherCellIdentifier];
        
        if (aCell == nil) {
            aCell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:otherCellIdentifier] autorelease];
            aCell.selectionStyle = UITableViewCellSelectionStyleGray;
            
            AJBrownUnderlinedView *backView = [[AJBrownUnderlinedView alloc] initWithFrame:CGRectZero];
            backView.frame = aCell.contentView.bounds;
            backView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
            [aCell.contentView addSubview:backView];
            [backView release];
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
        [appearanceLabel release];
        
        return [headerView autorelease];
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
        [appearanceLabel release];
        
        return [headerView autorelease];
    }
    
    return [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
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
        alertMessage = @"TBD";
    }
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:alertTitle
                                                        message:alertMessage
                                                       delegate:self
                                              cancelButtonTitle:@"Cancel" otherButtonTitles:alertOKButtonText, nil];
    alertView.tag = alertTag;
    
    [alertView show];
    [alertView release];
}

#pragma mark - Buttons Actions

-(IBAction)pencilButtonClicked:(UIButton *)sender {
    [self.settingsInfo setColorString:[(UIColor *)[_colorsArray objectAtIndex:sender.tag] toHexString:YES]];
    
    [self loadSelectedPencil];
}

- (IBAction)cancelButtonClicked:(id)sender {
    if ([self.delegate respondsToSelector:@selector(settingsViewControllerDidFinishEditing:withSettingsInfo:)]) {
        [self.delegate settingsViewControllerDidFinishEditing:self withSettingsInfo:nil];
    }
}

- (IBAction)doneButtonClicked:(id)sender {
    [self.settingsInfo  setName:[_nameTextField text]];
    
    if ([self.delegate respondsToSelector:@selector(settingsViewControllerDidFinishEditing:withSettingsInfo:)]) {
        [self.delegate settingsViewControllerDidFinishEditing:self withSettingsInfo:self.settingsInfo];
    }
}

#pragma mark - UITextFieldDelegate methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [_nameTextField resignFirstResponder];
    [self.settingsInfo setName:[textField text]];
    
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
	[actionSheet release];
}

#pragma mark - UIAlertViewDelegate methods

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == CLEAR_ONE_PLAYER_SCORES_ALERT_TAG) {
        if (buttonIndex != alertView.cancelButtonIndex) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(settingsViewControllerDidSelectClearAllScoresForCurrentPlayer:)]) {
                [self.delegate settingsViewControllerDidSelectClearAllScoresForCurrentPlayer:self];
            }
        }
    } else if (alertView.tag == CLEAR_ALL_PLAYER_SCORES_ALERT_TAG) {
        if (buttonIndex != alertView.cancelButtonIndex) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(settingsViewControllerDidSelectClearAllScoresForAllPlayers:)]) {
                [self.delegate settingsViewControllerDidSelectClearAllScoresForAllPlayers:self];
            }
        }
    } else if (alertView.tag == DELETE_ALL_PLAYERS_ALERT_TAG) {
        if (buttonIndex != alertView.cancelButtonIndex) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(settingsViewControllerDidSelectDeleteAllPlayersForCurrentGame:)]) {
                [self.delegate settingsViewControllerDidSelectDeleteAllPlayersForCurrentGame:self];
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
    
    [_pictureButton setImage:[editedImage applyMask:[UIImage imageNamed:@"mask.png"]] forState:UIControlStateNormal];
    [self.settingsInfo setImageData:UIImagePNGRepresentation(editedImage)];
}

#pragma mark - Private Actions

- (IBAction)selectPictureButtonClicked {
	UIImagePickerController *controller = [[UIImagePickerController alloc] init];
	controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
	controller.allowsEditing = YES;
	controller.delegate = self;
	[self.navigationController presentModalViewController:controller animated:YES];
	[controller release];
}

- (IBAction)takePictureButtonClicked {
	if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
		UIImagePickerController *controller = [[UIImagePickerController alloc] init];
		controller.sourceType = UIImagePickerControllerSourceTypeCamera;
		controller.allowsEditing = YES;
		controller.delegate = self;
		[self.navigationController presentModalViewController:controller animated:YES];
		[controller release];
	}
}

- (IBAction)setDefaultButtonClicked {
    UIImage *defaultImage = (_itemType == AJGameItem) ? [UIImage defaultGamePicture] : [UIImage defaultPlayerPicture];
    
    [_pictureButton setImage:[defaultImage applyMask:[UIImage imageNamed:@"mask.png"]] forState:UIControlStateNormal];
    [self.settingsInfo setImageData:UIImagePNGRepresentation(defaultImage)];
}

@end
