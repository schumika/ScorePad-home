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


@interface AJSettingsViewController ()

- (IBAction)selectPictureButtonClicked;
- (IBAction)takePictureButtonClicked;
- (IBAction)setDefaultButtonClicked;

@end


@interface AJColorTableViewCell : UITableViewCell {
    UIColor *_color;
    UIView *_colorView;
}

@property (nonatomic, retain) UIColor *color;

@end



@interface AJImageAndNameView : UIView {
    UIImage *_image;
    NSString *_name;
    
    UIButton *_pictureButton;
    UITableView *_tableView;
}

@property (nonatomic, retain) UIImage *image;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) UIButton *pictureButton;

- (id)initWithFrame:(CGRect)frame andImage:(UIImage *)image andName:(NSString *)name;

@end


@implementation AJSettingsViewController

@synthesize settingsInfo = _settingsInfo;
@synthesize itemType = _itemType;
@synthesize delegate = _delegate;

- (id)initWithSettingsInfo:(AJSettingsInfo *)settingsInfo andItemType:(AJItemType)itemType {
    self = [super initWithStyle:UITableViewStyleGrouped];
    
    if (!self) return nil;
    
    self.settingsInfo = settingsInfo;
    self.itemType = itemType;
    _colorsArray = [[NSArray alloc] initWithObjects:[UIColor blackColor], [UIColor darkGrayColor], [UIColor lightGrayColor], [UIColor whiteColor], [UIColor grayColor], [UIColor redColor],
                    [UIColor greenColor], [UIColor blueColor], [UIColor cyanColor], [UIColor yellowColor], [UIColor magentaColor], [UIColor orangeColor], [UIColor purpleColor], [UIColor brownColor], nil];
    
    return self;
}

- (void)dealloc {
    [_settingsInfo release];
    [_colorsArray release];
    
    [_nameTextField setDelegate:nil];
    _headerView.tableView.dataSource = nil;
    _headerView.tableView.delegate = nil;
    
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem clearBarButtonItemWithTitle:@"Cancel" target:self action:@selector(cancelButtonClicked:)];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem clearBarButtonItemWithTitle:@"Done" target:self action:@selector(doneButtonClicked:)];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self reloadTitleView];
    self.tableView.tag = COLORS_TABLE_VIEW_TAG;
    
    CGRect bounds = self.view.bounds;
    _headerView = [[AJImageAndNameView alloc] initWithFrame:CGRectMake(0.0, 0.0, CGRectGetWidth(bounds), 95.0)
                                                   andImage:[UIImage imageWithData:self.settingsInfo.imageData]
                                                    andName:self.settingsInfo.name];
    _headerView.tableView.dataSource = self;
    _headerView.tableView.delegate = self;
    _headerView.tableView.tag = NAME_TABLE_VIEW_TAG;
    [_headerView.pictureButton addTarget:self action:@selector(pictureButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.tableView.tableHeaderView = _headerView;
    [_headerView release];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (NSString *)titleViewText {
    return self.settingsInfo.name;
}

#pragma mark - Keyboard notifications

- (void)keyboardWillShow:(NSNotification *)aNotif {
    [super keyboardWillShow:aNotif];
    
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return (tableView.tag == COLORS_TABLE_VIEW_TAG) ? [_colorsArray count] : 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ColorCellIdentifier = @"ColorCell";
    static NSString *NameCellIdentifier = @"NameCell";
    
    UITableViewCell *aCell = nil;
    
    if (tableView.tag == COLORS_TABLE_VIEW_TAG) {
        AJColorTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ColorCellIdentifier];
        
        if (!cell) {
            cell = [[[AJColorTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ColorCellIdentifier] autorelease];
        }
        
        UIColor *rowColor = [_colorsArray objectAtIndex:indexPath.row];
        [cell setColor:rowColor];
        cell.accessoryType = ([self.settingsInfo.colorString isEqualToString:[rowColor toHexString:YES]]) ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
        
        aCell = cell;
    } else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NameCellIdentifier];
        
        if (!cell) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NameCellIdentifier] autorelease];
            
            CGRect cellBounds = cell.contentView.bounds;
            _nameTextField = [[UITextField alloc] initWithFrame:CGRectMake(10.0, ceil((CGRectGetHeight(cellBounds) - 31.0) / 2.0), 190.0, 31.0)];
            _nameTextField.delegate = self;
            _nameTextField.borderStyle = UITextBorderStyleNone;
            _nameTextField.placeholder = @"Enter the Name";
            _nameTextField.returnKeyType = UIReturnKeyDone;
            _nameTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
            [cell.contentView addSubview:_nameTextField];
            [_nameTextField release];
        }
        
         _nameTextField.text = self.settingsInfo.name;
        
        aCell = cell;
    }
    
    return aCell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return  (tableView.tag == COLORS_TABLE_VIEW_TAG) ? @"Name Color" : @"Name";
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (tableView.tag == COLORS_TABLE_VIEW_TAG) {
        [self.settingsInfo setColorString:[(UIColor *)[_colorsArray objectAtIndex:indexPath.row] toHexString:YES]];
        [tableView reloadData];
    } else {
        [_nameTextField becomeFirstResponder];
    }
}

#pragma mark - Buttons Actions

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
    [self.settingsInfo  setName:[textField text]];
    
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
    
    [_headerView setImage:editedImage];
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
    
    [_headerView setImage:defaultImage];
    [self.settingsInfo setImageData:UIImagePNGRepresentation(defaultImage)];
}


@end


@implementation AJColorTableViewCell

@synthesize color = _color;

- (void)setColor:(UIColor *)color {
    if (color != _color) {
        if (!_colorView) {
            CGRect cellBounds = self.contentView.bounds;
            _colorView = [[UIView alloc] initWithFrame:CGRectMake(10.0, 3.0, 250.0, CGRectGetHeight(cellBounds) - 6.0)];
            [self.contentView addSubview:_colorView];
            [_colorView release];
        }
        [_colorView setBackgroundColor:color];
        [_color release];
        _color = [color retain];
    }
}

- (void)dealloc {
    [_color release];
    
    [super dealloc];
}

@end


@implementation AJImageAndNameView

@synthesize image = _image, name = _name, tableView = _tableView;

- (id)initWithFrame:(CGRect)frame andImage:(UIImage *)image andName:(NSString *)name {
    self = [super initWithFrame:frame];
    
    if (!self) return nil;
    
    self.image = image;
    self.name = name;
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(100.0, 0.0, frame.size.width - 100.0, frame.size.height) style:UITableViewStyleGrouped];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.scrollEnabled = NO;
    [self addSubview:_tableView];
    
    _pictureButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
    _pictureButton.frame = CGRectMake(20.0, 20.0, 70.0, 70.0);
    [_pictureButton setImage:self.image forState:UIControlStateNormal];
    [self addSubview:_pictureButton];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 70.0, 20.0)];
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = UITextAlignmentCenter;
    label.font = [UIFont boldSystemFontOfSize:16.0];
    label.text = @"edit";
    [_pictureButton addSubview:label];
    [label release];
    
    return self;
}

- (void)setImage:(UIImage *)image {
    if (image != _image) {
        [_image release];
        _image = [image retain];
        
        [_pictureButton setImage:image forState:UIControlStateNormal];
    }
}

- (void)dealloc {
    [_image release];
    [_name release];
    [_tableView release];
    [_pictureButton release];
    
    [super dealloc];
}

@end
