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

#import "UIFont+Additions.h"
#import "UIColor+Additions.h"
#import "NSString+Additions.h"

static CGFloat kHeaderViewHeight = 40.0;
static CGFloat kFooterViewHeight = 40.0;

@interface AJScoresTableViewController ()

@property (nonatomic, assign) BOOL leftScoreViewIsDisplayed;
@property (nonatomic, assign) BOOL shouldShowAddScoreCell;
@property (nonatomic, strong) NSIndexPath *indexPathOfSelectedTextField;
@property (nonatomic, strong) NSIndexPath *indexPathOfCellShowingLeftSide;

- (void)updateRoundsForScores;

@end


@implementation AJScoresTableViewController

- (void)setLeftScoreViewIsDisplayed:(BOOL)leftScoreViewIsDisplayed {
    _leftScoreViewIsDisplayed = leftScoreViewIsDisplayed;
    
    NSLog(@"setting leftScoreViewIsDisplayed to %@", leftScoreViewIsDisplayed ? @"YES" : @"NO");
}


- (void)loadDataAndUpdateUI:(BOOL)updateUI {
    self.scoresArray = self.player.orderedScoresArray;
    
    self.titleViewText = self.player.name;
    self.titleViewColor = [UIColor colorWithHexString:self.player.color];
    
    if (updateUI) {
        [self.tableView reloadData];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem simpleBarButtonItemWithImage:[UIImage imageNamed:@"plus.png"] target:self action:@selector(plusButtonClicked:)];
    self.toolbarItems  = @[[UIBarButtonItem simpleBarButtonItemWithTitle:@"Options" target:self action:@selector(settingsButtonClicked:)],
                           [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                           [UIBarButtonItem simpleBarButtonItemWithTitle:@"Clear all" target:self action:@selector(clearAllButtonClicked:)],
                           [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                           [UIBarButtonItem simpleBarButtonItemWithTitle:@"Edit" target:self action:@selector(editButtonClicked:)]];
    
    self.indexPathOfSelectedTextField = nil;
    
    self.scoresSortingType = self.player.sortOrder.intValue;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self loadDataAndUpdateUI:YES];
    
    if (UIInterfaceOrientationIsPortrait(self.interfaceOrientation)) {
        [self.navigationController setToolbarHidden:NO animated:NO];
    }
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
    [self.tableView reloadData];
    
    if (UIInterfaceOrientationIsPortrait(toInterfaceOrientation)) {
        [self.navigationController setToolbarHidden:NO animated:YES];
    } else {
        [self.navigationController setToolbarHidden:YES animated:YES];
    }
}

#pragma mark - Keyboard notifications

- (void)keyboardWillShow:(NSNotification *)aNotif {
    [super keyboardWillShow:aNotif];
    
    if (self.indexPathOfSelectedTextField != nil) {
        [self performSelector:@selector(scrollAtIndexPath:) withObject:self.indexPathOfSelectedTextField afterDelay:0.1];
    }
    
    [self.navigationController setToolbarHidden:YES animated:YES];
}

- (void)keyboardWillHide:(NSNotification *)aNotif {
    [super keyboardWillHide:aNotif];
    
    if (UIInterfaceOrientationIsPortrait(self.interfaceOrientation)) {
        [self.navigationController setToolbarHidden:NO animated:YES];
    }
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return (section == 0) ? (self.shouldShowAddScoreCell ? 1 : 0) : self.scoresArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ScoreCellIdentifier = @"ScoreCell";
    static NSString *NewScoreCellIdentifier = @"NewScoreCell";
    
    UITableViewCell *aCell = nil;
    
    if (indexPath.section == 0) {
        AJNewItemTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NewScoreCellIdentifier];
        if (!cell) {
            cell = [[AJNewItemTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NewScoreCellIdentifier];
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.textField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
            cell.textField.placeholder = @"Add New Score ...";
            cell.textField.text = @"";
            cell.textField.delegate = self;
            cell.textField.font = [UIFont LDBrushFontWithSize:43.0];
        }
        
        aCell = cell;
    } else if (indexPath.section == 1) {
        AJScoreTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ScoreCellIdentifier];
        
        if (!cell) {
            cell = [[AJScoreTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ScoreCellIdentifier];
            cell.panGestureDelegate = self;
            cell.delegate = self;
            cell.selectionStyle = UITableViewCellSelectionStyleGray;
        }
        AJScore *score = [self.scoresArray objectAtIndex:indexPath.row];
        cell.scoreDictionary = score.toDictionary;
        
        aCell = cell;
    }
    
    return aCell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    AJScoreTableViewCell *scoreCell = ((AJScoreTableViewCell *)[tableView cellForRowAtIndexPath:indexPath]);
    if (self.indexPathOfCellShowingLeftSide == indexPath) {
        [scoreCell setDisplaysLeftSide:NO];
        [scoreCell hideLeftView];
    } else {
        [scoreCell setDisplaysLeftSide:YES];
        [UIView animateWithDuration:0.5 animations:^{
            [scoreCell showLeftView];
        }];
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        AJBrownUnderlinedView *headerView = [[AJBrownUnderlinedView alloc] initWithFrame:CGRectZero];
        headerView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        headerView.backgroundImage = [UIImage imageNamed:@"background.png"];
        CGFloat thirdOfTableWidth = ceil(CGRectGetWidth(tableView.bounds) / 3.0);
        headerView.frame = CGRectMake(0.0, 0.0, CGRectGetWidth(tableView.bounds), kHeaderViewHeight);
        
        UIButton *roundButton = [UIButton buttonWithType:UIButtonTypeCustom];
        BOOL isSortedAsc = self.scoresSortingType == AJScoresSortingByRoundASC;
        [roundButton setTitle:[NSString stringWithFormat:@"Round%@", isSortedAsc ? [NSString upArrow] : [NSString downArrow]] forState:UIControlStateNormal];
        roundButton.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin;
        [roundButton setTitleColor:[UIColor AJPurpleColor] forState:UIControlStateNormal];
        roundButton.titleLabel.font = [UIFont LDBrushFontWithSize:40.0];
        roundButton.backgroundColor = [UIColor clearColor];
        [headerView addSubview:roundButton];
        CGSize fitSize = [roundButton.titleLabel sizeThatFits:CGSizeMake(0.0, kHeaderViewHeight)];
        roundButton.frame = CGRectMake(15.0, 3.0, fitSize.width, kHeaderViewHeight);
        [roundButton addTarget:self action:@selector(roundButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        
//        if (self.scoresSortingType == AJScoresSortingByRoundASC || self.scoresSortingType == AJScoresSortingByRoundDESC) {
//            UILabel *roundArrow = [[UILabel alloc] initWithFrame:CGRectZero];
//            roundArrow.text = self.scoresSortingType == AJScoresSortingByRoundDESC ? [NSString upArrow] : [NSString downArrow];
//            roundArrow.textColor = [UIColor AJPurpleColor];
//            roundArrow.font = [UIFont LDBrushFontWithSize:20.0];
//            roundArrow.backgroundColor = [UIColor clearColor];
//            [headerView addSubview:roundArrow];
//            roundArrow.frame = CGRectMake(CGRectGetMaxX(roundButton.frame), 13.0, 20.0, 23.0);
//        }
        
        UILabel *scoreLabel = [[UILabel alloc] initWithFrame:CGRectMake(thirdOfTableWidth, 0.0, thirdOfTableWidth, kHeaderViewHeight)];
        scoreLabel.text = @"Score";
        scoreLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        scoreLabel.textColor = [UIColor AJPurpleColor];
        scoreLabel.font = [UIFont LDBrushFontWithSize:45.0];
        scoreLabel.backgroundColor = [UIColor clearColor];
        scoreLabel.textAlignment = UITextAlignmentCenter;
        [headerView addSubview:scoreLabel];
        
        UILabel *intemediateLabel = [[UILabel alloc] initWithFrame:CGRectMake(2 * thirdOfTableWidth, 0.0, thirdOfTableWidth, kHeaderViewHeight)];
        intemediateLabel.text = @"Intermediate";
        intemediateLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleLeftMargin;
        intemediateLabel.textColor = [UIColor AJPurpleColor];
        intemediateLabel.font = [UIFont LDBrushFontWithSize:35.0];
        intemediateLabel.backgroundColor = [UIColor clearColor];
        intemediateLabel.textAlignment = UITextAlignmentCenter;
        intemediateLabel.adjustsFontSizeToFitWidth = YES;
        [headerView addSubview:intemediateLabel];
        
        return headerView;
    }
    
    return [[UIView alloc] initWithFrame:CGRectZero];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return (section == 1) ? kHeaderViewHeight : 0.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return (section == 1) ? kFooterViewHeight : 0.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == 1) {
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
        
        return footerView;
    }
    
    return [[UIView alloc] initWithFrame:CGRectZero];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return (indexPath.section == 1) ? 40.0 : 60.0;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
    NSMutableArray *mutableArray = [[NSMutableArray alloc] initWithArray:self.scoresArray];
    AJScore *scoreToMove = [mutableArray objectAtIndex:fromIndexPath.row];
    [mutableArray removeObjectAtIndex:fromIndexPath.row];
    [mutableArray insertObject:scoreToMove atIndex:toIndexPath.row];
    [self setScoresArray:mutableArray];
    
    [self updateRoundsFromRowsIndex];
    [self loadDataAndUpdateUI:YES];
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return (indexPath.section == 1);
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return (indexPath.section == 1);
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView.editing == UITableViewCellEditingStyleDelete) {
        [self deleteScoreAtRow:indexPath.row];
    }
}


#pragma mark - UITextFieldDelegate methods

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (self.leftScoreViewIsDisplayed) return NO;
    
    self.indexPathOfSelectedTextField = nil;
    
    AJNewItemTableViewCell *cell = (AJNewItemTableViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    if (cell.textField == textField) {
        self.indexPathOfSelectedTextField = [NSIndexPath indexPathForRow:0 inSection:0];
    } else {
        for (int cellIndex = 0; cellIndex < [self.player.scores count]; cellIndex++) {
            AJScoreTableViewCell *cell = (AJScoreTableViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:cellIndex inSection:1]];
            if (cell.scoreTextField == textField) {
                self.indexPathOfSelectedTextField = [NSIndexPath indexPathForRow:cellIndex inSection:1];
                return YES;
            }
        }
    }
    
    if (self.indexPathOfSelectedTextField != nil) {
        [self.tableView scrollToRowAtIndexPath:self.indexPathOfSelectedTextField atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    self.shouldShowAddScoreCell = NO;
    [textField resignFirstResponder];
    
    NSString *text = textField.text;
    if (![NSString isNilOrEmpty:text]) {
        [[AJScoresManager sharedInstance] createScoreWithValue:text.doubleValue inRound:([self.scoresArray count] +1) forPlayer:self.player];
        [textField setText:nil];
        
        [self loadDataAndUpdateUI:YES];
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]
                              atScrollPosition:UITableViewScrollPositionTop animated:NO];
    } else {
        [self.tableView reloadData];
    }
    
    return YES;
}

#pragma mark - Private methods

- (void)updateRoundsForScores {
    NSMutableArray *mutableArray = [[NSMutableArray alloc] init];
    int rounds = self.scoresArray.count;
    
    [self.scoresArray enumerateObjectsUsingBlock:^(AJScore *score, NSUInteger idx, BOOL *stop) {
        if (self.scoresSortingType == AJScoresSortingByRoundDESC) {
            score.round = @(rounds - idx);
        } else {
            score.round = @(idx + 1);
        }
        [mutableArray addObject:score];
    }];
    
    [self setScoresArray:mutableArray];
    
    [[AJScoresManager sharedInstance] saveContext];
}

- (void)scrollAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}


#pragma mark - Actions
- (IBAction)settingsButtonClicked:(id)sender {
    AJSettingsViewController *settingsViewController = [[AJSettingsViewController alloc] initWithItemProperties:[self.player toDictionary] andItemType:AJPlayerItem];
    settingsViewController.delegate = self;
    [self.navigationController pushViewController:settingsViewController animated:YES];
}

- (IBAction)roundButtonClicked:(id)sender {
    if (self.scoresSortingType == AJScoresSortingByRoundASC) {
        self.scoresSortingType = AJScoresSortingByRoundDESC;
    } else {
        self.scoresSortingType = AJScoresSortingByRoundASC;
    }
    
   self.player.sortOrder = @(self.scoresSortingType);
   [[AJScoresManager sharedInstance] saveContext];
    
    [self loadDataAndUpdateUI:YES];
}

- (IBAction)plusButtonClicked:(id)sender {
    self.shouldShowAddScoreCell = YES;
    
    [self.tableView reloadData];
    [((AJNewItemTableViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]]).textField becomeFirstResponder];
}

- (IBAction)clearAllButtonClicked:(id)sender {
    [[AJScoresManager sharedInstance] deleteAllScoresForPlayer:self.player];
    [self loadDataAndUpdateUI:YES];
}

- (IBAction)editButtonClicked:(id)sender {
    if (self.tableView.isEditing) {
        self.toolbarItems  = @[[UIBarButtonItem simpleBarButtonItemWithTitle:@"Options" target:self action:@selector(settingsButtonClicked:)],
                               [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                               [UIBarButtonItem simpleBarButtonItemWithTitle:@"Clear all" target:self action:@selector(clearAllButtonClicked:)],
                               [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                               [UIBarButtonItem simpleBarButtonItemWithTitle:@"Edit" target:self action:@selector(editButtonClicked:)]];
        [self.tableView setEditing:NO animated:YES];
    } else {
        self.toolbarItems  = @[[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                               [UIBarButtonItem simpleBarButtonItemWithTitle:@"Done" target:self action:@selector(editButtonClicked:)]];
        [self.tableView setEditing:YES animated:YES];
    }
}

#pragma mark - AJSettingsViewControllerDelegate methods

- (void)settingsViewController:(AJSettingsViewController *)settingsViewController didFinishEditingItemProperties:(NSDictionary *)itemProperties {
    
    [self.navigationController popToViewController:self animated:YES];
    
    if (itemProperties != nil) {
        [self.player setPropertiesFromDictionary:itemProperties];
        
        [[AJScoresManager sharedInstance] saveContext];
        [self loadDataAndUpdateUI:YES];
    }
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
    [self deleteScoreAtRow:indexPath.row];
}

#pragma mark - AJScoreTableViewCellDelegate methods

- (void)scoreCell:(AJScoreTableViewCell *)cell didEndEditingScoreWithNewScoreValue:(NSNumber *)newScore {
    int scoreIndex = [self.tableView indexPathForCell:cell].row;
    AJScore *modifiedScore = [self.scoresArray objectAtIndex:scoreIndex];
    modifiedScore.value = newScore;
    
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

#pragma mark - Helper methods

- (void)deleteScoreAtRow:(int)row {
    [self.tableView beginUpdates];
    [[AJScoresManager sharedInstance] deleteScore:[self.scoresArray objectAtIndex:row]];
    [self loadDataAndUpdateUI:NO];
    [self.player updateRoundsForScores];
    self.scoresArray = [self.player orderedScoresArray];
    [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:row inSection:1]] withRowAnimation:UITableViewRowAnimationFade];
    [self.tableView endUpdates];
    
    [self.tableView performSelector:@selector(reloadData) withObject:nil afterDelay:0.3];
}

- (void)updateRoundsFromRowsIndex {
    int rounds = self.scoresArray.count;
    
    [self.scoresArray enumerateObjectsUsingBlock:^(AJScore *score, NSUInteger idx, BOOL *stop) {
        if (self.player.sortOrder.intValue == AJScoresSortingByRoundDESC) {
            score.round = @(rounds - idx);
        } else {
            score.round = @(idx + 1);
        }
    }];
    
    [[AJScoresManager sharedInstance] saveContext];
}

@end
