//
//  AJSettingsViewController.m
//  ScorePad
//
//  Created by Anca Julean on 9/13/12.
//  Copyright (c) 2012 Anca Julean. All rights reserved.
//

#import "AJSettingsViewController.h"
#import "AJGame+Additions.h"
#import "AJPlayer+Additions.h"
#import "AJSettingsInfo.h"

#import "UIColor+Additions.h"
#import "UIImage+Additions.h"


#define COLORS_TABLE_VIEW_TAG (1)
#define NAME_TABLE_VIEW_TAG (2)

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
    
    [_nameTextField setDelegate:nil];
    
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background.png"]];
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem clearBarButtonItemWithTitle:@"Cancel" target:self action:@selector(cancelButtonClicked:)];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem clearBarButtonItemWithTitle:@"Done" target:self action:@selector(doneButtonClicked:)];
    
    _pictureButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _pictureButton.frame = CGRectMake(20.0, 20.0, 70.0, 70.0);
    [_pictureButton setImage:[UIImage imageWithData:self.settingsInfo.imageData] forState:UIControlStateNormal];
    [self.view addSubview:_pictureButton];
    [_pictureButton addTarget:self action:@selector(pictureButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 70.0, 20.0)];
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = UITextAlignmentCenter;
    label.font = [UIFont boldSystemFontOfSize:16.0];
    label.text = @"edit";
    [_pictureButton addSubview:label];
    [label release];
    
    _nameTextField = [[UITextField alloc] initWithFrame:CGRectMake(120.0, 40.0, 190.0, 31.0)];
    _nameTextField.borderStyle = UITextBorderStyleRoundedRect;
    _nameTextField.backgroundColor = [UIColor clearColor];
    _nameTextField.delegate = self;
    _nameTextField.placeholder = @"Enter the Name";
    _nameTextField.returnKeyType = UIReturnKeyDone;
    _nameTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _nameTextField.text = self.settingsInfo.name;
    [self.view addSubview:_nameTextField];
    [_nameTextField release];

    _colorsContainerView = [[UIView alloc] initWithFrame:CGRectMake(10.0, 95.0, 300.0, 100.0)];
    _colorsContainerView.backgroundColor = [UIColor clearColor];
    UIImageView *containerFrameImageView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"round.png"] stretchableImageWithLeftCapWidth:10.0 topCapHeight:10.0]];
    containerFrameImageView.frame = _colorsContainerView.bounds;
    [_colorsContainerView addSubview:containerFrameImageView];
    [containerFrameImageView release];
    [self.view addSubview:_colorsContainerView];
    [_colorsContainerView release];
    
    CGSize pencilSize = CGSizeMake(25.0, 35.0);
    CGFloat pencilOffset = (_colorsContainerView.frame.size.width) / (_pencilsArray.count);
    CGFloat xOffset = 10.0;
    CGFloat yOffset = 10.0;
    
    for (NSString *pencilImageName in _pencilsArray) {
        UIButton *pencilButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [pencilButton setFrame:CGRectMake(xOffset, yOffset, pencilSize.width, pencilSize.height)];
        
        if (xOffset + pencilSize.width > _colorsContainerView.frame.size.width - 2 * pencilOffset) {
            xOffset = pencilSize.width + ceil(pencilOffset / 2.0);
            yOffset += pencilSize.width + 20.0;
        } else {
            xOffset += pencilSize.width + pencilOffset;
        }
        
        [pencilButton setTag:[_pencilsArray indexOfObject:pencilImageName]];
        
        UIImage *pencilImage = [UIImage imageNamed:pencilImageName];
        [pencilButton setImage:pencilImage forState:UIControlStateNormal];
        
        [pencilButton addTarget:self action:@selector(pencilButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_colorsContainerView addSubview:pencilButton];
    }

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
    
    [_pictureButton setImage:editedImage forState:UIControlStateNormal];
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
    
    [_pictureButton setImage:defaultImage forState:UIControlStateNormal];
    [self.settingsInfo setImageData:UIImagePNGRepresentation(defaultImage)];
}

@end
