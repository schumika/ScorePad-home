//
//  AJScoresTableViewController.m
//  ScorePad
//
//  Created by Anca Julean on 9/12/12.
//  Copyright (c) 2012 Anca Julean. All rights reserved.
//

#import "AJScoresTableViewController.h"
#import "AJScoresManager.h"
#import "AJSettingsInfo.h"


#import "NSString+Additions.h"

@interface AJScoresTableViewController ()

- (void)updateRoundsForScores;

@end


@implementation AJScoresTableViewController

@synthesize player = _player;
@synthesize scoresArray = _scoresArray;

- (void)dealloc {
    [_player release];
    [_scoresArray release];
    
    [super dealloc];
}

- (void)loadDataAndUpdateUI:(BOOL)updateUI {
     self.scoresArray = [[AJScoresManager sharedInstance] getAllScoresForPlayer:self.player];
    [self reloadTitleView];
    if (updateUI) {
        [self.tableView reloadData];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.rowHeight = 35.0;
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem clearBarButtonItemWithTitle:@"Settings" target:self action:@selector(settingsButtonClicked:)];
    self.navigationItem.leftBarButtonItem = [self backButtonItem];
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
    
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
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
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NewScoreCellIdentifier];
        
        if (!cell) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:NewScoreCellIdentifier] autorelease];
            
            cell.accessoryType = UITableViewCellAccessoryNone;
            _newScoreTextField = [[UITextField alloc] initWithFrame:cell.contentView.bounds];
            _newScoreTextField.borderStyle = UITextBorderStyleNone;
            _newScoreTextField.backgroundColor = [UIColor clearColor];
            _newScoreTextField.font = [UIFont boldSystemFontOfSize:20.0];
            _newScoreTextField.textColor = [UIColor blueColor];
            _newScoreTextField.placeholder = @"Add New Score ...";
            _newScoreTextField.text = @"";
            _newScoreTextField.delegate = self;
            _newScoreTextField.textAlignment = UITextAlignmentCenter;
            _newScoreTextField.returnKeyType = UIReturnKeyDone;
            _newScoreTextField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
            [cell.contentView addSubview:_newScoreTextField];
            [_newScoreTextField release];
        }
        
        aCell = cell;
    } else if (indexPath.section == 0) {
        AJPanDeleteTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ScoreCellIdentifier];
        
        if (!cell) {
            cell = [[[AJPanDeleteTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ScoreCellIdentifier] autorelease];
            cell.delegate = self;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        AJScore *score = [self.scoresArray objectAtIndex:indexPath.row];
        cell.textLabel.text = [NSString stringWithFormat:@"%g", score.value.doubleValue];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%d", score.round.intValue];
        
        aCell = cell;
    }
    
    return aCell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 1) {
        [_newScoreTextField becomeFirstResponder];
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectZero];
    
    if (section == 0) {
        CGFloat tableWidth = CGRectGetWidth(tableView.bounds);
        headerView.frame = CGRectMake(0.0, 0.0, tableWidth, 20.0);
        headerView.backgroundColor = [UIColor lightGrayColor];
        UILabel *scoreLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, ceil(tableWidth / 2.0), 20.0)];
        scoreLabel.text = @"Score";
        scoreLabel.backgroundColor = [UIColor clearColor];
        [headerView addSubview:scoreLabel];
        [scoreLabel release];
        UILabel *roundLabel = [[UILabel alloc] initWithFrame:CGRectMake(ceil(tableWidth / 2.0), 0.0, ceil(tableWidth / 2.0), 20.0)];
        roundLabel.text = @"Round";
        roundLabel.backgroundColor = [UIColor clearColor];
        roundLabel.textAlignment = UITextAlignmentRight;
        [headerView addSubview:roundLabel];
        [roundLabel release];
    }
    
    return [headerView autorelease];
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    if (section == 0) {
        return [NSString stringWithFormat:@"Total: %g", [self.player totalScore]];
    }
    
    return nil;
}

#pragma mark - UITextFieldDelegate methods

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1] atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [_newScoreTextField resignFirstResponder];
    
    NSString *text = textField.text;
    if (![NSString isNilOrEmpty:text]) {
        [[AJScoresManager sharedInstance] createScoreWithValue:text.doubleValue inRound:([self.scoresArray count] +1) forPlayer:self.player];
        [_newScoreTextField setText:nil];
        
        [self loadDataAndUpdateUI:YES];
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]
                              atScrollPosition:UITableViewScrollPositionTop animated:NO];
    }
    
    return YES;
}

#pragma mark - Private methods

- (void)updateRoundsForScores {
    NSMutableArray *mutableArray = [[NSMutableArray alloc] init];
    for (AJScore *score in self.scoresArray) {
        score.round = [NSNumber numberWithInt:([self.scoresArray indexOfObject:score]+1)];
        [mutableArray addObject:score];
    }
    [self setScoresArray:mutableArray];
    [mutableArray release];
    
    [[AJScoresManager sharedInstance] saveContext];
}

#pragma mark - Actions
- (IBAction)settingsButtonClicked:(id)sender {
    AJSettingsViewController *settingsViewController = [[AJSettingsViewController alloc] initWithSettingsInfo:[self.player settingsInfo] andItemType:AJPlayerItem];
    settingsViewController.delegate = self;
    [self.navigationController pushViewController:settingsViewController animated:YES];
    [settingsViewController release];
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

#pragma mark - AJPanDeleteTableViewCellDelegate methods

- (void)panDeleteCellDraggedToDelete:(AJPanDeleteTableViewCell *)cell {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
    [self.tableView beginUpdates];
    [[AJScoresManager sharedInstance] deleteScore:[self.scoresArray objectAtIndex:indexPath.row]];
    [self loadDataAndUpdateUI:YES];
    [self updateRoundsForScores];
    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    [self.tableView endUpdates];
    
    //[self loadDataAndUpdateUI:YES];
}


@end
