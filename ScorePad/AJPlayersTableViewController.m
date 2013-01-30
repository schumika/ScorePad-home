//
//  AJPlayersTableViewController.m
//  ScorePad
//
//  Created by Anca Julean on 9/11/12.
//  Copyright (c) 2012 Anca Julean. All rights reserved.
//

#import "AJPlayersTableViewController.h"
#import "AJScoresTableViewController.h"
#import "AJSettingsViewController.h"
#import "AJNewItemTableViewCell.h"
#import "AJBrownUnderlinedView.h"
#import "AJScoresManager.h"
#import "AJSettingsInfo.h"
#import "AJAlertView.h"

#import "UIFont+Additions.h"
#import "NSString+Additions.h"
#import "UIColor+Additions.h"
#import "UIImage+Additions.h"

static CGFloat kHeaderViewHeight = 30.0;

@interface AJPlayersTableViewController () {
    UIImageView *_backView;
    NSIndexPath *_indexPathOfSelectedTextField;
    NSIndexPath *_indexPathOfCellShowingLeftSide;
    
    BOOL _addScoreViewIsDisplayed;
}

@property (nonatomic, assign) BOOL addScoreViewIsDisplayed;
@property (nonatomic, retain) NSIndexPath *indexPathOfSelectedTextField;
@property (nonatomic, retain) NSIndexPath *indexPathOfCellShowingLeftSide;

- (void)prepareUIForInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation;

- (BOOL)addScoreViewIsDisplayed;

- (NSArray *)playersArrayOrderedByTotalScoreAscending:(BOOL)ascending;

@end


@implementation AJPlayersTableViewController

@synthesize game = _game;
@synthesize playersArray = _playersArray;
@synthesize indexPathOfSelectedTextField = _indexPathOfSelectedTextField;
@synthesize indexPathOfCellShowingLeftSide = _indexPathOfCellShowingLeftSide;

- (void)loadDataAndUpdateUI:(BOOL)updateUI {
    //self.playersArray = [[AJScoresManager sharedInstance] getAllPlayersForGame:self.game];
    self.playersArray = [self playersArrayOrderedByTotalScoreAscending:NO];
    [self reloadTitleView];
    if (updateUI) {
        if (self.tableView.hidden == NO) {
            [self.tableView reloadData];
            //self.tableView.contentInset = UIEdgeInsetsMake(-100.0, 0.0, 0.0, 0.0);
            if (self.playersArray.count > 0) {
                [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
            }
        } else {
            // remove old vertical columns
            for (UIView *subView in [_scrollView subviews]) {
                [subView removeFromSuperview];
            }
            
            CGFloat playerViewWidth = (self.playersArray.count == 0) ? 0.0 : MAX(100.0, 480.0 / (self.playersArray.count));
            CGFloat maxScrollViewContentHeight = 60.0 + 30.0 * [self.game maxNumberOfScores];
            for (int playerIndex = 0; playerIndex < self.playersArray.count; playerIndex++) {
                AJPlayer *player = (AJPlayer *)[self.playersArray objectAtIndex:playerIndex];
                AJVerticalPlayerView *verticalPlayerView = [[AJVerticalPlayerView alloc] initWithFrame:CGRectMake(playerIndex * playerViewWidth, 0.0, playerViewWidth, maxScrollViewContentHeight)
                                                            andName:player.name andScores:[player scoreValues] andColor:player.color];
                verticalPlayerView.isFirstColumn = (playerIndex == 0);
                [verticalPlayerView setDelegate:self];
                [_scrollView addSubview:verticalPlayerView];
                [verticalPlayerView release];
            }
            _scrollView.contentSize = CGSizeMake(self.playersArray.count * 100.0, maxScrollViewContentHeight + 40.0);
        }
    }
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Landscape
    _backView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"landscape_background.png"]];
    [self.view addSubview:_backView];
    [_backView release];
    [_backView setHidden:YES];
    
    CGRect bounds = self.view.bounds;
    _scrollView = [[AJScrollView alloc] initWithFrame:CGRectMake(0.0, 0.0, bounds.size.height + 20.0, bounds.size.width)];
    _scrollView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_scrollView];
    [_scrollView setHidden:YES];
    [_scrollView release];
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem clearBarButtonItemWithTitle:@"Settings" target:self action:@selector(settingsButtonClicked:)];
    self.navigationItem.leftBarButtonItem = [self backButtonItem];
    
//    UIView *tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, bounds.size.width, 100.0)];
//    tableHeaderView.backgroundColor = [UIColor clearColor];
//    [self.tableView setTableHeaderView:tableHeaderView];
//    [tableHeaderView release];
//    
//    UIButton *doneButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    [doneButton setTitle:@"done" forState:UIControlStateNormal];
//    [doneButton setFrame:CGRectMake(200.0, 60.0, 60.0, 35.0)];
//    [doneButton addTarget:self action:@selector(doneButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
//    [tableHeaderView addSubview:doneButton];
    
    self.indexPathOfSelectedTextField = nil;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.tableView.rowHeight = 70.0;
    
    [self prepareUIForInterfaceOrientation:self.interfaceOrientation];
    [self loadDataAndUpdateUI:YES];
    
    if (self.playersArray.count > 0) {
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
}

- (void)dealloc {
    [_game release];
    [_playersArray release];
    [_indexPathOfSelectedTextField release];
    [_indexPathOfCellShowingLeftSide release];
    
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (NSString*)titleViewText {
	return self.game.name;
}

#pragma mark - Rotation methods

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [self prepareUIForInterfaceOrientation:toInterfaceOrientation];
    [self loadDataAndUpdateUI:YES];
}

#pragma mark - Keyboard notifications

- (void)keyboardWillShow:(NSNotification *)aNotif {
    [super keyboardWillShow:aNotif];
    
    if (self.indexPathOfSelectedTextField != nil) {
        [self.tableView scrollToRowAtIndexPath:self.indexPathOfSelectedTextField atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
    //[self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return (section == 0) ? [self.playersArray count] : 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *playerCellIdentifier = @"PlayerCell";
    static NSString *newPlayerCellIdentifier = @"NewPlayerCell";
    
    UITableViewCell *cell = nil;
    
    if (indexPath.section == 0) {
        AJPlayerTableViewCell *aCell = [tableView dequeueReusableCellWithIdentifier:playerCellIdentifier];
        if (!aCell) {
            aCell = [[[AJPlayerTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:playerCellIdentifier] autorelease];
            aCell.delegate = self;
            aCell.panGestureDelegate = self;
            aCell.accessoryType = UITableViewCellAccessoryNone;
        }
        
        AJPlayer *player = (AJPlayer *)[self.playersArray objectAtIndex:indexPath.row];
        aCell.name = player.name; 
        aCell.color = player.color;
        int totalScore = [player totalScore];
        aCell.totalScores = totalScore;
        aCell.numberOfRounds = [[player scores] count];
        
        UIImage *playerImage = nil;
        if (player.imageData == nil) {
            playerImage  = [[UIImage defaultPlayerPicture] resizeToNewSize:CGSizeMake(50.0, 50.0)];
        } else {
            playerImage = [[UIImage imageWithData:player.imageData] resizeToNewSize:CGSizeMake(50.0, 50.0)];
        }
        
        aCell.picture = [playerImage applyMask:[UIImage imageNamed:@"mask.png"]];
        aCell.scoreTextField.text = @"";
        AJScore *lastPlayerScore = (AJScore *)[[[AJScoresManager sharedInstance] getAllScoresForPlayer:player] lastObject];
        aCell.scoreTextField.placeholder = [NSString stringWithFormat:@"%g", fabs(lastPlayerScore.value.doubleValue)];
        
        cell = aCell;
    } else {
        AJNewItemTableViewCell *aCell = [tableView dequeueReusableCellWithIdentifier:newPlayerCellIdentifier];
        if (!aCell) {
            aCell = [[[AJNewItemTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:newPlayerCellIdentifier] autorelease];
            aCell.accessoryType = UITableViewCellAccessoryNone;
            aCell.textField.placeholder = @"Tap to add New Player ...";
            aCell.textField.text = @"";
            aCell.textField.delegate = self;
            aCell.textField.font = [UIFont LDBrushFontWithSize:43.0];
        }
        
        cell = aCell;
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if ([self addScoreViewIsDisplayed]) return;
    
    if (self.tableView.editing) return;
    
    if (indexPath.section == 1) {
        [((AJNewItemTableViewCell *)[tableView cellForRowAtIndexPath:indexPath]).textField becomeFirstResponder];
    } else {        
        AJScoresTableViewController *scoresViewController = [[AJScoresTableViewController alloc] initWithStyle:UITableViewStylePlain];
        scoresViewController.player = [self.playersArray objectAtIndex:indexPath.row];
        [self.navigationController pushViewController:scoresViewController animated:YES];
        [scoresViewController release];
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        AJBrownUnderlinedView *headerView = [[AJBrownUnderlinedView alloc] initWithFrame:CGRectZero];
        headerView.backgroundImage = [UIImage imageNamed:@"background.png"];
        //CGFloat halfOfTableWidth = ceil(CGRectGetWidth(tableView.bounds) / 2.0);
        headerView.frame = CGRectMake(0.0, 0.0, CGRectGetWidth(tableView.bounds), kHeaderViewHeight);
        
        UILabel *playerLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        playerLabel.text = @"Player";
        playerLabel.textColor = [UIColor AJBrownColor];
        playerLabel.font = [UIFont LDBrushFontWithSize:35.0];
        playerLabel.backgroundColor = [UIColor clearColor];
        [headerView addSubview:playerLabel];
        [playerLabel release];
        CGSize fitSize = [playerLabel sizeThatFits:CGSizeMake(0.0, kHeaderViewHeight)];
        playerLabel.frame = CGRectMake(40.0, 0.0, fitSize.width, kHeaderViewHeight);
        
        UILabel *scoreLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        scoreLabel.text = @"Score";
        scoreLabel.textColor = [UIColor AJBrownColor];
        scoreLabel.font = [UIFont LDBrushFontWithSize:35.0];
        scoreLabel.backgroundColor = [UIColor clearColor];
        scoreLabel.textAlignment = UITextAlignmentRight;
        scoreLabel.adjustsFontSizeToFitWidth = YES;
        [headerView addSubview:scoreLabel];
        [scoreLabel release];
        CGSize scoreLabelSize = [scoreLabel sizeThatFits:CGSizeMake(0.0, kHeaderViewHeight)];
        scoreLabel.frame = CGRectMake(CGRectGetWidth(tableView.bounds) - scoreLabelSize.width - 40.0, 0.0, scoreLabelSize.width, kHeaderViewHeight);
        
        return [headerView autorelease];
    }
    
    return [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return (section == 0) ? kHeaderViewHeight : 0.0;
}

#pragma mark - UITextFieldDelegate methods

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if ([self addScoreViewIsDisplayed]) return NO;
    
    self.indexPathOfSelectedTextField = nil;
    
    for (int cellIndex = 0; cellIndex < [self.game.players count]; cellIndex++) {
        AJPlayerTableViewCell *cell = (AJPlayerTableViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:cellIndex inSection:0]];
        if (cell.scoreTextField == textField) {
            self.indexPathOfSelectedTextField = [NSIndexPath indexPathForRow:cellIndex inSection:0];
            break;
        }
    }
    
    AJNewItemTableViewCell *cell = (AJNewItemTableViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
    if (cell.textField == textField) {
        self.indexPathOfSelectedTextField = [NSIndexPath indexPathForRow:0 inSection:1];
    }
    
    return !self.tableView.editing;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    
    NSString *text = textField.text;
    if (![NSString isNilOrEmpty:text]) {
        [[AJScoresManager sharedInstance] createPlayerWithName:text forGame:self.game];
        [textField setText:nil];
        
        [self loadDataAndUpdateUI:YES];
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]
                              atScrollPosition:UITableViewScrollPositionTop animated:NO];
    }
    
    return YES;
}

#pragma mark - Buttons Action

- (IBAction)settingsButtonClicked:(id)sender {
    AJSettingsViewController *settingsViewController = [[AJSettingsViewController alloc] initWithSettingsInfo:[self.game settingsInfo] andItemType:AJGameItem];
    settingsViewController.delegate = self;
    [self.navigationController pushViewController:settingsViewController animated:YES];
    [settingsViewController release];
}

- (IBAction)doneButtonClicked:(id)sender {
    //self.tableView.contentOffset = CGPointMake(0, 100.0);
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

#pragma mark - AJSettingsViewControllerDelegate methods

- (void)settingsViewControllerDidFinishEditing:(AJSettingsViewController *)settingsViewController withSettingsInfo:(AJSettingsInfo *)settingsInfo {
    [settingsInfo retain];
    
    [self.navigationController popToViewController:self animated:YES];
    
    if (settingsInfo != nil) {
        [self.game setName:settingsInfo.name];
        [self.game setColor:settingsInfo.colorString];
        [self.game setImageData:settingsInfo.imageData];
        
        [[AJScoresManager sharedInstance] saveContext];
        [self loadDataAndUpdateUI:YES];
    }
    
    [settingsInfo release];
}

- (void)prepareUIForInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    if (UIInterfaceOrientationIsLandscape(interfaceOrientation)) {
        self.tableView.hidden = YES;
        _scrollView.hidden = NO;
        _backView.hidden = NO;
    } else {
        self.tableView.hidden = NO;
        _scrollView.hidden = YES;
        _backView.hidden = YES;
    }
}

#pragma mark - AJVerticalPlayerViewDelegate methods

- (void)verticalPlayerViewDidClickName:(AJVerticalPlayerView *)verticalPlayerView {
    AJScoresTableViewController *scoresViewController = [[AJScoresTableViewController alloc] initWithStyle:UITableViewStylePlain];
    scoresViewController.player = [self.playersArray objectAtIndex:[[_scrollView subviews] indexOfObject:verticalPlayerView]];
    [self.navigationController pushViewController:scoresViewController animated:YES];
    [scoresViewController release];
}

#pragma mark - AJPlayerTableViewCellDelegate methods

- (void)addScore:(double)score inCell:(AJPlayerTableViewCell *)cell {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    AJPlayer *player = [self.playersArray objectAtIndex:indexPath.row];
    
    [[AJScoresManager sharedInstance] createScoreWithValue:score
                                                   inRound:([[player scores] count] + 1) forPlayer:player];
    [cell.scoreTextField resignFirstResponder];
    [self loadDataAndUpdateUI:NO];
    [self.tableView reloadData];
}

- (void)playerCellClickedPlusButton:(AJPlayerTableViewCell *)cell {
    double scoreToAdd = 0.0;
    if ([NSString isNilOrEmpty:cell.scoreTextField.text] == NO) {
        scoreToAdd = cell.scoreTextField.text.doubleValue;
    } else {
        scoreToAdd = cell.scoreTextField.placeholder.doubleValue;
    }
    
    [self addScore:scoreToAdd inCell:cell];
}

- (void)playerCellClickedMinusButton:(AJPlayerTableViewCell *)cell {
    double scoreToAdd = 0.0;
    if ([NSString isNilOrEmpty:cell.scoreTextField.text] == NO) {
        scoreToAdd = cell.scoreTextField.text.doubleValue;
    } else {
        scoreToAdd = cell.scoreTextField.placeholder.doubleValue;
    }
    
    [self addScore:-scoreToAdd inCell:cell];
}

- (void)playerCellShouldStartEditingScore:(AJPlayerTableViewCell *)cell {
    self.indexPathOfSelectedTextField = [self.tableView indexPathForCell:cell];
}

- (void)playerCellDidShowNewScoreView:(AJPlayerTableViewCell *)cell {
    self.addScoreViewIsDisplayed = YES;
    self.indexPathOfCellShowingLeftSide = [self.tableView indexPathForCell:cell];
}

- (void)playerCellDidHideNewScoreView:(AJPlayerTableViewCell *)cell {
    NSIndexPath *cellIndexPath = [self.tableView indexPathForCell:cell];
    if (self.indexPathOfCellShowingLeftSide!= nil && (cellIndexPath.row == self.indexPathOfCellShowingLeftSide.row)) {
        self.addScoreViewIsDisplayed = NO;
     self.indexPathOfCellShowingLeftSide = nil;
    }
}

- (BOOL)playerCellShouldShowNewScoreView:(AJPlayerTableViewCell *)cell {
    if (self.addScoreViewIsDisplayed == YES) return NO;
    
    NSIndexPath *cellIndexPath = [self.tableView indexPathForCell:cell];
    if ( self.indexPathOfCellShowingLeftSide!= nil && (cellIndexPath.row != self.indexPathOfCellShowingLeftSide.row)) {
        return NO;
    }
    return !self.addScoreViewIsDisplayed;
}

#pragma mark - AJPanDeleteTableViewCellDelegate methods

- (void)panDeleteCellDraggedToDelete:(AJPanDeleteTableViewCell *)cell {
    AJAlertView *alertView = [[AJAlertView alloc] initWithTitle:nil
                                                        message:@"Are you sure you want to delete this player?"
                                                       delegate:self
                                              cancelButtonTitle:@"Cancel"
                                              otherButtonTitles:@"Delete", nil];
    alertView.userInfo = @{@"cell" : cell};
    [alertView show];
    [alertView release];
}

#pragma mark - UIAlertViewDelegate methods

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex != alertView.cancelButtonIndex) { // User clicked "delete"
        AJPlayerTableViewCell *cell = (AJPlayerTableViewCell *)[(AJAlertView *)alertView userInfo][@"cell"];
        
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        
        [self.tableView beginUpdates];
        [[AJScoresManager sharedInstance] deletePlayer:self.playersArray[indexPath.row]];
        [self loadDataAndUpdateUI:NO];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [self.tableView endUpdates];
        
        [self.tableView performSelector:@selector(reloadData) withObject:nil afterDelay:0.3];
    }
}
/*
#pragma mark - Helper methods

- (BOOL)addScoreViewIsDisplayed {
    BOOL leftSideIsDisplayed = NO;
    
    for (int playerCellIndex = 0; playerCellIndex < [self.tableView numberOfRowsInSection:0]; playerCellIndex++) {
        AJPlayerTableViewCell *playerCell = (AJPlayerTableViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:playerCellIndex inSection:0]];
        if (playerCell.displaysLeftSide) {
            leftSideIsDisplayed = YES;
            break;
        }
    }
    
    return leftSideIsDisplayed;
}

 */

- (NSArray *)playersArrayOrderedByTotalScoreAscending:(BOOL)ascending {
    NSMutableArray *orderedArray = [NSMutableArray arrayWithArray:[[AJScoresManager sharedInstance] getAllPlayersForGame:self.game]];
    [orderedArray sortUsingComparator:^NSComparisonResult(AJPlayer *player1, AJPlayer *player2) {
        if (player1.totalScore < player2.totalScore) {
            return ascending ? NSOrderedAscending : NSOrderedDescending;
        } else {
            return ascending ? NSOrderedDescending : NSOrderedAscending;
        }
    }];
    
    return orderedArray;
}
@end
