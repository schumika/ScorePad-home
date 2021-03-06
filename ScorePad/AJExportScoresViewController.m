//
//  AJExportScoresViewController.m
//  ScorePad
//
//  Created by Anca Calugar on 2/1/13.
//  Copyright (c) 2013 Anca Julean. All rights reserved.
//

#import "AJExportScoresViewController.h"
#import "UIDevice-Additions.h"

#import "AJExportHandler.h"
#import "AJScoresManager.h"
#import "AJFacebookManager.h"

#define PORTRAIT_TOOLBAR_HEIGHT			(44.0)
#define LANDSCAPE_TOOLBAR_HEIGHT		(33.0)

@interface AJExportScoresViewController () {
    UIImageView *_imageView;
    UIToolbar	*_toolbar;
}

@property (nonatomic, strong) UIImage *exportedImage;

- (void)checkFacebookStateAndPermissions;
- (void)postImageToFacebook:(UIImage *)image withDescription:(NSString *)description;

@end


@implementation AJExportScoresViewController

@synthesize itemRowId = _itemRowId;
@synthesize itemType = _itemType;
@synthesize exportedImage = _exportedImage;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	if (!self) return nil;
	
	self.wantsFullScreenLayout = YES;
	self.hidesBottomBarWhenPushed = YES;
    
	return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CGRect screenBounds = self.view.bounds;
    
    _imageView = [[UIImageView alloc] initWithFrame:screenBounds];
    _imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _imageView.backgroundColor = [UIColor blackColor];
    _imageView.userInteractionEnabled = YES;
    [self.view addSubview:_imageView];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureHandler:)];
    tapGestureRecognizer.delegate = self;
    [_imageView addGestureRecognizer:tapGestureRecognizer];
    
    if (self.itemType == AJGameItem) {
        AJGame *game = [[AJScoresManager sharedInstance] getGameWithRowId:self.itemRowId];
        
        if (game != nil) {
            AJExportHandler *exportHandler = [[AJExportHandler alloc] initWithGame:game];
            self.exportedImage = [exportHandler createPlayersImage];
        }
    } else {
        NSLog(@"TBD..");
    }
    
    UIBarButtonItem* optionsButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self
                                                                                    action:@selector(optionsAction)];
    
    _toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, screenBounds.size.height - PORTRAIT_TOOLBAR_HEIGHT,
														   screenBounds.size.width, PORTRAIT_TOOLBAR_HEIGHT)];
	_toolbar.barStyle = UIBarStyleBlackTranslucent;
	_toolbar.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
	_toolbar.items = [NSArray arrayWithObjects:optionsButton, nil];
	[self.view addSubview:_toolbar];
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    [self dismissModalViewControllerAnimated:YES];
    
    NSString *alertMessage = nil;
    if (result == MFMailComposeResultSent) {
        alertMessage = @"Message sent";
    } else {
        alertMessage = @"Message was not sent. Try again.";
    }
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:alertMessage delegate:nil
                                              cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alertView show];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
    self.navigationController.navigationBar.tintColor = nil;
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackTranslucent animated:YES];
    
    if ([self.navigationController.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)]){
        [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    }
    
	[self.navigationController setNavigationBarHidden:NO animated:animated];
	//[self updateToolbarWithOrientation:self.interfaceOrientation];
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	
	//[_scrollView cancelTouches];
    
	//[self showBars:YES animated:NO];
	
	[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:NO];
    
    if ([self.navigationController.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)]){
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav-bar.png"] forBarMetrics:UIBarMetricsDefault];
    }
    
	[self.navigationController setNavigationBarHidden:NO animated:animated];
    [self.navigationController.navigationBar setBarStyle:UIBarStyleDefault];
	[self.navigationController.navigationBar setTranslucent:NO];
	[self.navigationController.navigationBar setOpaque:YES];
}

#pragma mark - Properties

- (void)setExportedImage:(UIImage *)exportedImage {
    if (exportedImage != _exportedImage) {
        _exportedImage = exportedImage;
        
        _imageView.image = _exportedImage;
        if ((_exportedImage.size.width > _imageView.frame.size.width) || (_exportedImage.size.height > _imageView.frame.size.height)) {
            _imageView.contentMode = UIViewContentModeScaleAspectFit;
        } else {
            _imageView.contentMode = UIViewContentModeCenter;
        }
    }
}

#pragma mark - Buttons actions

- (void)optionsAction {
	UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"cancel"
											  destructiveButtonTitle:nil otherButtonTitles:@"share on Facebook", @"send email", @"save image", nil];
	[actionSheet setActionSheetStyle:UIActionSheetStyleBlackTranslucent];
	[actionSheet showInView:self.view];
}

#pragma mark - UITapGestureRecognizer methods

- (void)tapGestureHandler:(UITapGestureRecognizer *)tapGesture {
    if (tapGesture.state == UIGestureRecognizerStateEnded) {
        
        [UIView animateWithDuration:0.3 animations:^{
            BOOL barsShowing = (self.navigationController.navigationBar.alpha != 0);
            [[UIApplication sharedApplication] setStatusBarHidden:barsShowing
                                                    withAnimation:UIStatusBarAnimationNone];
            self.navigationController.navigationBar.alpha = barsShowing ? 0.0 : 1.0;
            _toolbar.alpha = barsShowing ? 0.0 : 1.0;
        }];
    }
}

#pragma mark - UIActionSheetDelegate methods

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        NSLog(@"share on facebook button clicked");
        self.facebookManager = [[AJFacebookManager alloc] init];
        [self.facebookManager startWithUserDefaultTokenInformationKeyName:[[NSUserDefaults standardUserDefaults] valueForKey:@"AJFacebookTokenInformation"]];
        [self checkFacebookStateAndPermissions];
    } else if (buttonIndex == 1) {
        if ([MFMailComposeViewController canSendMail]) {
            MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
            picker.mailComposeDelegate = self;
            
            [picker setSubject:@"Scores"];
            [picker setMessageBody:@"Scores in the game" isHTML:NO];
            
            [picker addAttachmentData:UIImagePNGRepresentation(self.exportedImage)  mimeType:@"image/png" fileName:@"Scores"];
            
            // Show email view
            [self presentModalViewController:picker animated:YES];
        } else {
            NSMutableString *s = [NSMutableString stringWithString:@"mailto:"];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[s stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
        }
    } else if (buttonIndex == 2) {
        UIImageWriteToSavedPhotosAlbum(self.exportedImage, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    }
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    NSString *messageString = (error == nil) ? @"image saved" : @"image not saved";
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:messageString delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alertView show];
}

- (void)checkFacebookStateAndPermissions {
    // return if user doesn not have intenet connection
    
    if ([self.facebookManager isFacebookConfigured] == NO) {
        [self.facebookManager facebookLogin:@{@"photoShare" : @YES}];
    } else {
        if ([self.facebookManager hasPermissions:@[@"publish_actions"]] == NO) {
            dispatch_async(dispatch_get_current_queue(), ^{
                [self.facebookManager reauthorizeWithPublishPermissions:@[@"publish_actions"]];
            });
        } else {
            [self postImageToFacebook:self.exportedImage withDescription:@""];
        }
    }
}

- (void)postImageToFacebook:(UIImage *)image withDescription:(NSString *)description {
    NSDictionary *params = @{@"description" : description, @"photo": image};
    
    [self.facebookManager publishPhotoWithDelegate:self andParameters:params];
    //[self showProcessingAlert];
}

- (void)didFinishPostingPhotoToFacebookWithSucces:(id)result {
    //[self hideprocessingalertanimated:NO];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success"
                                                  message:@"Your scores have been posted to Facebook!"
                                                 delegate:self
                                        cancelButtonTitle:@"Done"
                                        otherButtonTitles:nil];
    [alert show];
}

#pragma mark - AJFacebookManagerDelegate

- (void)facebookDidLoginHandler:(NSNotification*)aNotif{
    if ([[[aNotif.userInfo valueForKey:@"AJFacebookOptionsKey"] objectForKey:@"photoShare"] boolValue] == YES) {
        [self checkFacebookStateAndPermissions];
    }
}

- (void)facebookDidNotLoginNotification:(NSNotification*)aNotif {
    if ([[[aNotif.userInfo valueForKey:@"AJFacebookOptionsKey"] objectForKey:@"photoShare"] boolValue] == YES) {
        if([UIDevice isOS60OrGreater]) {
            BOOL cancelled = [[[aNotif userInfo] objectForKey:@"AJFacebookCancelledKey"] boolValue];
            BOOL denied = [[[aNotif userInfo] objectForKey:@"AJFacebookPermissionsDeniedKey"] boolValue];
            BOOL withoutError = [[[aNotif userInfo] objectForKey:@"AJFacebookFailedWithoutErrorKey"] boolValue];
            // silvia.cret: Fix for PI-2790: Allow Facebook to use you information pop-up should be displayed if user set Facebook native to OFF
            if (!cancelled && !denied && !withoutError) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                                message:@"Please go to your device's Settings>Facebook and make sure Pinger is turned \"ON\" under \"Allow these apps to user your Account\""
                                                               delegate:nil
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
                [alert show];
            }
        }
    }
}

- (void)didFinishPostingPhotoToFacebookWithError:(NSError *)error {
    //[self hideProcessingAlertAnimated:YES];
    
	if ([self.facebookManager isInvalidSessionError:error]) {
        [self.facebookManager clearSession];
        
        if([self.facebookManager isUsingNativeFacebookAccount]) {
            [self performSelector:@selector(checkFacebookStateAndPermissions) withObject:nil afterDelay:1.0];
        } else {
            [self checkFacebookStateAndPermissions];
        }
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Post unsuccessful"
                                                        message:@"Your scores were not posted to Facebook! Please check your network settings and try again."
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
}
- (void)facebookDidAuthorizeWithPublishPermissionsHandler {
    NSLog(@"facebookDidAuthorizeWithPublishPermissionsHandler");
}


@end
