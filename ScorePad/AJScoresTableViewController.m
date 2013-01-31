//
//  AJScoresTableViewController.m
//  ScorePad
//
//  Created by Anca Julean on 9/12/12.
//  Copyright (c) 2012 Anca Julean. All rights reserved.
//

#import "AJScoresTableViewController.h"
#import "AJNewItemTableViewCell.h"
#import "AJBrownUnderlinedView.h"
#import "AJScoresManager.h"
#import "AJSettingsInfo.h"

#import "UIFont+Additions.h"
#import "UIColor+Additions.h"
#import "NSString+Additions.h"

static CGFloat kHeaderViewHeight = 40.0;
static CGFloat kFooterViewHeight = 40.0;

@interface AJScoresTableViewController () {
    BOOL _leftScoreViewIsDisplayed;
    NSIndexPath *_indexPathOfSelectedTextField;
    NSIndexPath *_indexPathOfCellShowingLeftSide;
}

@property (nonatomic, assign) BOOL leftScoreViewIsDisplayed;
@property (nonatomic, retain) NSIndexPath *indexPathOfSelectedTextField;
@property (nonatomic, retain) NSIndexPath *indexPathOfCellShowingLeftSide;

- (void)updateRoundsForScores;
- (double)intermediateTotalAtRow:(int)round;
- (NSArray *)getOrderedScoresArray;

@end


@implementation AJScoresTableViewController

@synthesize player = _player;
@synthesize scoresArray = _scoresArray;

@synthesize indexPathOfSelectedTextField = _indexPathOfSelectedTextField;
@synthesize indexPathOfCellShowingLeftSide = _indexPathOfCellShowingLeftSide;

@synthesize scoresSortingType = _scoresSortingType;

- (void)dealloc {
    [_player release];
    [_scoresArray release];
    [_indexPathOfSelectedTextField release];
    [_indexPathOfCellShowingLeftSide release];
    
    [super dealloc];
}

- (void)loadDataAndUpdateUI:(BOOL)updateUI {
    self.scoresArray = [self getOrderedScoresArray];
    
    [self reloadTitleView];
    if (updateUI) {
        [self.tableView reloadData];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem clearBarButtonItemWithTitle:@"Settings" target:self action:@selector(settingsButtonClicked:)];
    self.navigationItem.leftBarButtonItem = [self backButtonItem];
    
    self.indexPathOfSelectedTextField = nil;
    
    self.scoresSortingType = self.player.sortOrder.intValue;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self loadDataAndUpdateUI:YES];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

#pragma mark - Keyboard notifications

- (void)keyboardWillShow:(NSNotification *)aNotif {
    [super keyboardWillShow:aNotif];
    
    if (self.indexPathOfSelectedTextField != nil) {
        [self.tableView scrollToRowAtIndexPath:self.indexPathOfSelectedTextField atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
}

- (NSString*)titleViewText {
    return self.player.name;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return (section == 0) ? self.scoresArray.count : 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ScoreCellIdentifier = @"ScoreCell";
    static NSString *NewScoreCellIdentifier = @"NewScoreCell";
    
    UITableViewCell *aCell = nil;
    
    if (indexPath.section == 1) {
        AJNewItemTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NewScoreCellIdentifier];
        if (!cell) {
            cell = [[[AJNewItemTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NewScoreCellIdentifier] autorelease];
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.textField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
            cell.textField.placeholder = @"Tap to add New Score ...";
            cell.textField.text = @"";
            cell.textField.delegate = self;
            cell.textField.font = [UIFont LDBrushFontWithSize:43.0];
        }
        
        aCell = cell;
    } else if (indexPath.section == 0) {
        AJScoreTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ScoreCellIdentifier];
        
        if (!cell) {
            cell = [[[AJScoreTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ScoreCellIdentifier] autorelease];
            cell.panGestureDelegate = self;
            cell.delegate = self;
            cell.selectionStyle = UITableViewCellSelectionStyleGray;
        }
        AJScore *score = [self.scoresArray objectAtIndex:indexPath.row];
        cell.round = score.round.intValue;
        cell.score = score.value.doubleValue;
        cell.intermediateTotal = [self intermediateTotalAtRow:indexPath.row];
        
        aCell = cell;
    }
    
    return aCell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 1) {
        [((AJNewItemTableViewCell *)[tableView cellForRowAtIndexPath:indexPath]).textField becomeFirstResponder];
    } else {
        AJScoreTableViewCell *scoreCell = ((AJScoreTableViewCell *)[tableView cellForRowAtIndexPath:indexPath]);
        if (self.indexPathOfCellShowingLeftSide == indexPath) {
            [scoreCell setDisplaysLeftSide:NO];
            [scoreCell hideLeftView];
        } else {
            [scoreCell setDisplaysLeftSide:YES];
            [scoreCell showLeftView];
        }
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        AJBrownUnderlinedView *headerView = [[AJBrownUnderlinedView alloc] initWithFrame:CGRectZero];
        headerView.backgroundImage = [UIImage imageNamed:@"background.png"];
        CGFloat thirdOfTableWidth = ceil(CGRectGetWidth(tableView.bounds) / 3.0);
        headerView.frame = CGRectMake(0.0, 0.0, CGRectGetWidth(tableView.bounds), kHeaderViewHeight);
        
        UIButton *roundButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [roundButton setTitle:@"Round" forState:UIControlStateNormal];
        [roundButton setTitleColor:[UIColor AJBrownColor] forState:UIControlStateNormal];
        roundButton.titleLabel.font = [UIFont LDBrushFontWithSize:35.0];
        roundButton.backgroundColor = [UIColor clearColor];
        [headerView addSubview:roundButton];
        CGSize fitSize = [roundButton.titleLabel sizeThatFits:CGSizeMake(0.0, kHeaderViewHeight)];
        roundButton.frame = CGRectMake(15.0, 3.0, fitSize.width, kHeaderViewHeight);
        [roundButton addTarget:self action:@selector(roundButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        if (self.scoresSortingType == AJScoresSortingByRoundASC || self.scoresSortingType == AJScoresSortingByRoundDESC) {
            UILabel *roundArrow = [[UILabel alloc] initWithFrame:CGRectZero];
            roundArrow.text = self.scoresSortingType == AJScoresSortingByRoundDESC ? [NSString upArrow] : [NSString downArrow];
            roundArrow.textColor = [UIColor AJBrownColor];
            roundArrow.font = [UIFont LDBrushFontWithSize:20.0];
            roundArrow.backgroundColor = [UIColor clearColor];
            [headerView addSubview:roundArrow];
            [roundArrow release];
            roundArrow.frame = CGRectMake(CGRectGetMaxX(roundButton.frame), 13.0, 20.0, 23.0);
        }
        
        UILabel *scoreLabel = [[UILabel alloc] initWithFrame:CGRectMake(thirdOfTableWidth, 0.0, thirdOfTableWidth, kHeaderViewHeight)];
        scoreLabel.text = @"Score";
        scoreLabel.textColor = [UIColor AJBrownColor];
        scoreLabel.font = [UIFont LDBrushFontWithSize:45.0];
        scoreLabel.backgroundColor = [UIColor clearColor];
        scoreLabel.textAlignment = UITextAlignmentCenter;
        [headerView addSubview:scoreLabel];
        [scoreLabel release];
        
        UILabel *intemediateLabel = [[UILabel alloc] initWithFrame:CGRectMake(2 * thirdOfTableWidth, 0.0, thirdOfTableWidth, kHeaderViewHeight)];
        intemediateLabel.text = @"Intermediate";
        intemediateLabel.textColor = [UIColor AJBrownColor];
        intemediateLabel.font = [UIFont LDBrushFontWithSize:35.0];
        intemediateLabel.backgroundColor = [UIColor clearColor];
        intemediateLabel.textAlignment = UITextAlignmentCenter;
        intemediateLabel.adjustsFontSizeToFitWidth = YES;
        [headerView addSubview:intemediateLabel];
        [intemediateLabel release];
        
        return [headerView autorelease];
    }
    
    return [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return (section == 0) ? kHeaderViewHeight : 0.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return (section == 0) ? kFooterViewHeight : 0.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == 0) {
        AJBrownUnderlinedView *footerView = [[AJBrownUnderlinedView alloc] initWithFrame:CGRectZero];
        footerView.backgroundImage = [UIImage imageNamed:@"background.png"];
        footerView.frame = CGRectMake(0.0, 0.0, CGRectGetWidth(tableView.bounds), kFooterViewHeight);
        
        UILabel *totalLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0, 0.0, CGRectGetWidth(tableView.bounds) - 20.0, kFooterViewHeight)];
        totalLabel.text = [NSString stringWithFormat:@"Total: %g", [self.player totalScore]];
        totalLabel.textColor = [UIColor AJBrownColor];
        totalLabel.font = [UIFont LDBrushFontWithSize:45.0];
        totalLabel.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
        totalLabel.backgroundColor = [UIColor clearColor];
        [footerView addSubview:totalLabel];
        [totalLabel release];
        
        return [footerView autorelease];
    }
    
    return [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return (indexPath.section == 0) ? 35.0 : 60.0;
}

#pragma mark - UITextFieldDelegate methods

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (self.leftScoreViewIsDisplayed) return NO;
    
    self.indexPathOfSelectedTextField = nil;
    
    for (int cellIndex = 0; cellIndex < [self.player.scores count]; cellIndex++) {
        AJScoreTableViewCell *cell = (AJScoreTableViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:cellIndex inSection:0]];
        if (cell.scoreTextField == textField) {
            self.indexPathOfSelectedTextField = [NSIndexPath indexPathForRow:cellIndex inSection:0];
            //break;
            return !self.tableView.editing;
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
        [[AJScoresManager sharedInstance] createScoreWithValue:text.doubleValue inRound:([self.scoresArray count] +1) forPlayer:self.player];
        [textField setText:nil];
        
        [self loadDataAndUpdateUI:YES];
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]
                              atScrollPosition:UITableViewScrollPositionTop animated:NO];
    }
    
    return YES;
}

#pragma mark - Private methods

- (void)updateRoundsForScores {
    NSMutableArray *mutableArray = [[NSMutableArray alloc] init];
    int rounds = self.scoresArray.count;
    for (AJScore *score in self.scoresArray) {
        if (self.scoresSortingType == AJScoresSortingByRoundDESC) {
            score.round = [NSNumber numberWithInt:(rounds - [self.scoresArray indexOfObject:score])];
        } else {
            score.round = [NSNumber numberWithInt:([self.scoresArray indexOfObject:score]+1)];
        }
        [mutableArray addObject:score];
    }
    [self setScoresArray:mutableArray];
    [mutableArray release];
    
    [[AJScoresManager sharedInstance] saveContext];
}

- (double)intermediateTotalAtRow:(int)row {
    double total = 0.0;
    int rounds = self.scoresArray.count;
    if (self.scoresSortingType == AJScoresSortingByRoundDESC) {
        for (int rowIndex = rounds; rowIndex > row; rowIndex--) {
            AJScore *score = [self.scoresArray objectAtIndex:(rowIndex - 1)];
            total += [[score value] doubleValue];
        }
    } else {
        for (int rowIndex = 0; rowIndex <= row; rowIndex++) {
            AJScore *score = [self.scoresArray objectAtIndex:rowIndex];
            total += [[score value] doubleValue];
        }
    }
    
    return total;
}

- (NSArray *)getOrderedScoresArray {
    NSMutableArray *orderedArray = [NSMutableArray arrayWithArray:[[AJScoresManager sharedInstance] getAllScoresForPlayer:self.player]];
    
    if (self.scoresSortingType == AJScoresSortingNone) return orderedArray;
    
    [orderedArray sortUsingComparator:^NSComparisonResult(AJScore *score1, AJScore *score2) {
        if (score1.round.intValue < score2.round.intValue) {
            return (self.scoresSortingType == AJScoresSortingByRoundASC) ? NSOrderedAscending : NSOrderedDescending;
        } else {
            return (self.scoresSortingType == AJScoresSortingByRoundDESC) ? NSOrderedDescending : NSOrderedAscending;
        }
    }];
    
    return orderedArray;
}

#pragma mark - Actions
- (IBAction)settingsButtonClicked:(id)sender {
    AJSettingsViewController *settingsViewController = [[AJSettingsViewController alloc] initWithSettingsInfo:[self.player settingsInfo] andItemType:AJPlayerItem];
    settingsViewController.delegate = self;
    [self.navigationController pushViewController:settingsViewController animated:YES];
    [settingsViewController release];
}

- (IBAction)roundButtonClicked:(id)sender {
    if (self.scoresSortingType == AJScoresSortingByRoundASC) {
        self.scoresSortingType = AJScoresSortingByRoundDESC;
    } else {
        self.scoresSortingType = AJScoresSortingByRoundASC;
    }
    
   self.player.sortOrder = [NSNumber numberWithInt:self.scoresSortingType];
   [[AJScoresManager sharedInstance] saveContext];
    
    [self loadDataAndUpdateUI:YES];
}

#pragma mark - AJSettingsViewControllerDelegate methods

- (void)settingsViewControllerDidFinishEditing:(AJSettingsViewController *)settingsViewController withSettingsInfo:(AJSettingsInfo *)settingsInfo {
    [settingsInfo retain];
    
    [self.navigationController popToViewController:self animated:YES];
    
    if (settingsInfo != nil) {
        [self.player setName:settingsInfo.name];
        [self.player setColor:settingsInfo.colorString];
        [self.player setImageData:settingsInfo.imageData];
    }
    
    [settingsInfo release];
    
    [[AJScoresManager sharedInstance] saveContext];
    [self loadDataAndUpdateUI:YES];
}

- (void)settingsViewControllerDidSelectClearAllScoresForCurrentPlayer:(AJSettingsViewController *)settingsViewController {
    [self.navigationController popToViewController:self animated:YES];
    
    [[AJScoresManager sharedInstance] deleteAllScoresForPlayer:self.player];
    [self loadDataAndUpdateUI:YES];
}

#pragma mark - AJPanDeleteTableViewCellDelegate methods

- (void)panDeleteCellDraggedToDelete:(AJPanDeleteTableViewCell *)cell {
    self.leftScoreViewIsDisplayed =  NO;
    self.indexPathOfCellShowingLeftSide = nil;
    self.indexPathOfSelectedTextField = nil;
    
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
    [self.tableView beginUpdates];
    [[AJScoresManager sharedInstance] deleteScore:[self.scoresArray objectAtIndex:indexPath.row]];
    [self loadDataAndUpdateUI:NO];
    [self updateRoundsForScores];
    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    [self.tableView endUpdates];

    [self.tableView performSelector:@selector(reloadData) withObject:nil afterDelay:0.3];
}

#pragma mark - AJScoreTableViewCellDelegate methods

- (void)scoreCellDidEndEditingScore:(AJScoreTableViewCell *)cell {
    int scoreRound = [self.tableView indexPathForCell:cell].row;
    AJScore *modifiedScore = [self.scoresArray objectAtIndex:scoreRound];
    
    modifiedScore.value = [NSNumber numberWithDouble:[cell.scoreTextField text].doubleValue];
    [[AJScoresManager sharedInstance] saveContext];
    [self loadDataAndUpdateUI:YES];
}

- (void)scoreCellShouldStartEditingScore:(AJScoreTableViewCell *)cell {
    self.indexPathOfSelectedTextField = [self.tableView indexPathForCell:cell];
}

- (void)scoreCellDidShowLeftView:(AJScoreTableViewCell *)cell {
    self.leftScoreViewIsDisplayed = YES;
    self.indexPathOfCellShowingLeftSide = [self.tableView indexPathForCell:cell];
}

- (void)scoreCellDidHideLeftView:(AJScoreTableViewCell *)cell {
    NSIndexPath *cellIndexPath = [self.tableView indexPathForCell:cell];
    
    if (self.indexPathOfCellShowingLeftSide != nil && (cellIndexPath.row == self.indexPathOfCellShowingLeftSide.row)) {
        self.leftScoreViewIsDisplayed = NO;
        self.indexPathOfCellShowingLeftSide = nil;
    }
}

- (BOOL)scoreCellShouldShowLeftView:(AJScoreTableViewCell *)cell {
    if (self.leftScoreViewIsDisplayed) return NO;
    NSIndexPath *cellIndexPath = [self.tableView indexPathForCell:cell];
    if (self.indexPathOfCellShowingLeftSide != nil && (cellIndexPath.row != self.indexPathOfCellShowingLeftSide.row)) {
        return NO;
    }
    return !self.leftScoreViewIsDisplayed;
}


@end
