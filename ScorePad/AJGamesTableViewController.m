//
//  AJGamesTableViewController.m
//  ScorePad
//
//  Created by Anca Julean on 9/10/12.
//  Copyright (c) 2012 Anca Julean. All rights reserved.
//

#import "AJGamesTableViewController.h"
#import "AJPlayersTableViewController.h"
#import "AJScoresManager.h"
#import "AJTableViewController.h"
#import "AJGameTableViewCell.h"
#import "AJNewItemTableViewCell.h"

#import "AJGame+Additions.h"
#import "NSString+Additions.h"
#import "UIColor+Additions.h"
#import "UIImage+Additions.h"

@interface AJGamesTableViewController () {
    UILabel *_draggToAddLabel;
    BOOL _pullDownInProgress;
    BOOL _shouldAddNewGameCell;
}

- (void)updateRowIdsForGames;

@end


@implementation AJGamesTableViewController

@synthesize gamesArray = _gamesArray;

- (void)dealloc {
    [_gamesArray release];
    [_draggToAddLabel release];
    
    [_editBarButton release];
    [_doneBarButton release];
    
    [super dealloc];
}

- (void)loadDataAndUpdateUI:(BOOL)updateUI {
    self.gamesArray = [[AJScoresManager sharedInstance] getGamesArray];
    if (updateUI) {
        [self.tableView reloadData];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _editBarButton = [[UIBarButtonItem clearBarButtonItemWithTitle:@"Edit" target:self action:@selector(editButtonClicked:)] retain];
    _doneBarButton = [[UIBarButtonItem clearBarButtonItemWithTitle:@"Done" target:self action:@selector(doneButtonClicked:)] retain];
    
    _draggToAddLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.bounds.size.width, -50.0)];
    _draggToAddLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    _draggToAddLabel.backgroundColor = [UIColor clearColor];
    _draggToAddLabel.textAlignment = UITextAlignmentCenter;
    _draggToAddLabel.textColor = [UIColor lightGrayColor];
    _draggToAddLabel.text = @"Dragg to add new game...";
    _draggToAddLabel.font = [UIFont fontWithName:@"Thonburi-Bold" size:20.0];
    
    _shouldAddNewGameCell = NO;
    
    self.navigationItem.rightBarButtonItem = _editBarButton;
    self.navigationItem.leftBarButtonItem = nil;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.tableView.rowHeight = 60.0;
    [self loadDataAndUpdateUI:YES];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (NSString*)titleViewText {
	return @"Score Pad";
}

#pragma mark - Keyboard notifications

- (void)keyboardWillShow:(NSNotification *)aNotif {
    [super keyboardWillShow:aNotif];
    
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger numberOfCells = 0;
    switch (section) {
        case 0:
            numberOfCells = _shouldAddNewGameCell ? 1 : 0;
            break;
        case 1:
            numberOfCells = [self.gamesArray count];
            break;
        case 2:
            numberOfCells = 1;
            break;
        default:
            numberOfCells = 0;
            break;
    }
    return numberOfCells;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *addNewGameCellIdentifier = @"AddGameCell";
    static NSString *gameCellIdentifier = @"GameCell";
    static NSString *newGameCellIdentifier = @"NewGameCell";
    
    UITableViewCell *aCell = nil;
    
    if (indexPath.section == 0) {
        AJNewItemTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:addNewGameCellIdentifier];
        
        if (cell == nil) {
            cell = [[[AJNewItemTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:addNewGameCellIdentifier] autorelease];
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.textField.placeholder = @"game name";
            cell.textField.text = @"";
            cell.textField.delegate = self;
        }
        aCell = cell;
    } else if (indexPath.section == 1) {
        AJGameTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:gameCellIdentifier];
        
        if (cell == nil) {
            cell = [[[AJGameTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:gameCellIdentifier] autorelease];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.panGestureDelegate = self;
        }
        
        AJGame *game = (AJGame *)[self.gamesArray objectAtIndex:indexPath.row];
        cell.name = game.name;
        cell.color = game.color;
        int playersNumber = [[game players] count];
        cell.numberOfPlayers = playersNumber;
        
        if (game.imageData == nil) {
            cell.picture = [[UIImage defaultGamePicture] resizeToNewSize:CGSizeMake(50.0, 50.0)];
        } else {
            cell.picture = [[UIImage imageWithData:game.imageData] resizeToNewSize:CGSizeMake(50.0, 50.0)];
        }
        
        aCell = cell;
    } else {
        AJNewItemTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:newGameCellIdentifier];
        
        if (cell == nil) {
            cell = [[[AJNewItemTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:newGameCellIdentifier] autorelease];
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.textField.placeholder = @"Add New Game ...";
            cell.textField.text = @"";
            cell.textField.delegate = self;
        }
        aCell = cell;
    }
    
    aCell.selectionStyle = UITableViewCellSelectionStyleGray;
    return aCell;
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return (indexPath.section == 1);
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
    NSMutableArray *mutableArray = [[NSMutableArray alloc] initWithArray:self.gamesArray];
    AJGame *gameToMove = [[mutableArray objectAtIndex:fromIndexPath.row] retain];
    [mutableArray removeObjectAtIndex:fromIndexPath.row];
    [mutableArray insertObject:gameToMove atIndex:toIndexPath.row];
    [gameToMove release];
    [self setGamesArray:mutableArray];
    
    [self updateRowIdsForGames];
    [self loadDataAndUpdateUI:YES];
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return (indexPath.section == 1);
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (self.tableView.editing) return;
    
    if (indexPath.section == 2) {
        [((AJNewItemTableViewCell *)[tableView cellForRowAtIndexPath:indexPath]).textField becomeFirstResponder];
    } else {        
        AJPlayersTableViewController *playersViewController = [[AJPlayersTableViewController alloc] initWithStyle:UITableViewStylePlain];
        playersViewController.game = (AJGame *)[self.gamesArray objectAtIndex:indexPath.row];
        [self.navigationController pushViewController:playersViewController animated:YES];
        [playersViewController release];
    }
}

#pragma mark - Buttons Actions


- (IBAction)editButtonClicked:(id)sender {
    [self.tableView setEditing:YES animated:YES];
    self.navigationItem.rightBarButtonItem = _doneBarButton;
}

- (IBAction)doneButtonClicked:(id)sender {
    [self.tableView setEditing:NO animated:YES];
    self.navigationItem.rightBarButtonItem = _editBarButton;
}

#pragma mark - UITextFieldDelegate methods

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    return !self.tableView.editing;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    _shouldAddNewGameCell = NO;
    
    NSString *text = textField.text;
    if (![NSString isNilOrEmpty:text]) {
        int maxNo = [self.tableView numberOfRowsInSection:1];
        [[AJScoresManager sharedInstance] addGameWithName:text andRowId:maxNo+1];
        [textField setText:nil];

        [self loadDataAndUpdateUI:YES];
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]
                              atScrollPosition:UITableViewScrollPositionTop animated:NO];
    } else {
         [self loadDataAndUpdateUI:YES];
    }
    
    return YES;
}

#pragma mark - Private methods

- (void)updateRowIdsForGames {
    int numberOfGames = [self.gamesArray count];
    NSMutableArray *mutableArray = [[NSMutableArray alloc] init];
    for (AJGame *game in self.gamesArray) {
        game.rowId = [NSNumber numberWithInt:numberOfGames - [self.gamesArray indexOfObject:game]];
        [mutableArray addObject:game];
    }
    [self setGamesArray:mutableArray];
    
    [[AJScoresManager sharedInstance] saveContext];
}

#pragma mark - AJPanDeleteTableViewCellDelegate methods
- (void)panDeleteCellDraggedToDelete:(AJPanDeleteTableViewCell *)cell {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
    [self.tableView beginUpdates];
    [[AJScoresManager sharedInstance] deleteGame:[self.gamesArray objectAtIndex:indexPath.row]];
    [self loadDataAndUpdateUI:NO];
    [self updateRowIdsForGames];
    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationMiddle];
    [self.tableView endUpdates];
    
    [self.tableView performSelector:@selector(reloadData) withObject:nil afterDelay:0.3];
}

#pragma mark - UIScrollViewDelegate methods

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    _pullDownInProgress = scrollView.contentOffset.y <= 0.0f;
    if (_pullDownInProgress) {
        [_tableView insertSubview:_draggToAddLabel atIndex:0];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (_pullDownInProgress && self.tableView.contentOffset.y <= 0.0f) {
        // maintain the location of the placeholder
        _draggToAddLabel.text = (scrollView.contentOffset.y > -60.0) ? @"Dragg to add new game..." : @"Release to add new game...";
        _draggToAddLabel.alpha = MIN(1.0f, - _tableView.contentOffset.y / 60.0);
    } else {
        _pullDownInProgress = false;
    }
}


- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (_pullDownInProgress && -_tableView.contentOffset.y > 60.0) {
        _shouldAddNewGameCell = YES;
        [self.tableView reloadData];
        [[(AJNewItemTableViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]] textField] becomeFirstResponder];
    }
    _pullDownInProgress = false;
    [_draggToAddLabel removeFromSuperview];
}

@end
