//
//  AJExportScoresViewController.m
//  ScorePad
//
//  Created by Anca Calugar on 2/1/13.
//  Copyright (c) 2013 Anca Julean. All rights reserved.
//

#import "AJExportScoresViewController.h"

#import "AJExportHandler.h"
#import "AJScoresManager.h"

@interface AJExportScoresViewController () {
    UIImageView *_imageView;
}

@property (nonatomic, retain) UIImage *exportedImage;

@end


@implementation AJExportScoresViewController

@synthesize itemRowId = _itemRowId;
@synthesize itemType = _itemType;
@synthesize exportedImage = _exportedImage;

- (void)dealloc {
    [_exportedImage release];
    
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    _imageView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:_imageView];
    [_imageView release];
    
    if (self.itemType == AJGameItem) {
        AJGame *game = [[AJScoresManager sharedInstance] getGameWithRowId:self.itemRowId];
        AJExportHandler *exportHandler = [[AJExportHandler alloc] initWithGame:game];
        self.exportedImage = [[exportHandler createPlayersImage] retain];
        [exportHandler release];
    } else {
        NSLog(@"TBD..");
    }
}

- (void)setExportedImage:(UIImage *)exportedImage {
    if (exportedImage != _exportedImage) {
        [_exportedImage release];
        _exportedImage = [exportedImage retain];
        
        _imageView.image = _exportedImage;
    }
}

@end
