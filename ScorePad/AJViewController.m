//
//  AJViewController.m
//  ScorePad
//
//  Created by Anca Calugar on 10/9/12.
//  Copyright (c) 2012 Anca Julean. All rights reserved.
//

#import "AJViewController.h"

@implementation UINavigationBar (UINavigationBarCustomDraw)

- (void)drawRect:(CGRect)rect
{
    [[UIImage imageNamed:@"nav-bar.png"] drawInRect:rect];
}

@end


@interface AJViewController ()

@end

@implementation AJViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

@end
