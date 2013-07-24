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
#import "AJAlertView.h"

#import "AJGame+Additions.h"
#import "NSString+Additions.h"
#import "UIColor+Additions.h"
#import "UIImage+Additions.h"
#import "UIFont+Additions.h"

@interface AJGamesTableViewController ()

@property (nonatomic, strong) IBOutlet UIBarButtonItem *editBarButton;
@property (nonatomic, strong) IBOutlet UIBarButtonItem *doneBarButton;

@property (nonatomic, strong) NSArray *gamesArray;

- (void)loadDataAndUpdateUI:(BOOL)updateUI;
- (void)updateRowIdsForGames;
- (void)deleteGameFromCellWithIndexPath:(NSIndexPath*)indexPath;

@end


@implementation AJGamesTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.editBarButton = [UIBarButtonItem simpleBarButtonItemWithTitle:@"Edit" target:self action:@selector(editButtonClicked:)];
    self.doneBarButton = [UIBarButtonItem simpleBarButtonItemWithTitle:@"Done" target:self action:@selector(doneButtonClicked:)];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.rowHeight = 60.0;
    
    self.navigationItem.rightBarButtonItem = self.editBarButton;
    self.navigationItem.leftBarButtonItem = nil;
    
    self.titleViewText = @"ScorePad";
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self loadDataAndUpdateUI:YES];
}

#pragma mark - Keyboard notifications

- (void)keyboardWillShow:(NSNotification *)aNotif {
    [super keyboardWillShow:aNotif];
    
    if ([self.gamesArray lastObject] != nil) {
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger numberOfCells = 0;
    switch (section) {
        case 0:
            numberOfCells = [self.gamesArray count];
            break;
        case 1:
            numberOfCells = 1;
            break;
        default:
            numberOfCells = 0;
            break;
    }
    return numberOfCells;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *gameCellIdentifier = @"GameCell";
    static NSString *newGameCellIdentifier = @"NewGameCell";
    
    UITableViewCell *aCell = nil;
    
    if (indexPath.section == 0) {
        AJGameTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:gameCellIdentifier];
        
        if (cell == nil) {
            cell = [[AJGameTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:gameCellIdentifier];
            cell.panGestureDelegate = self;
        }
        
        AJGame *game = (AJGame *)[self.gamesArray objectAtIndex:indexPath.row];
        cell.displayDictionary = [game toDisplayDictionary];
        
        aCell = cell;
    } else {
        AJNewItemTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:newGameCellIdentifier];
        
        if (cell == nil) {
            cell = [[AJNewItemTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:newGameCellIdentifier];
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.textField.placeholder = @"Tap to Add new game ...";
            cell.textField.text = @"";
            cell.textField.delegate = self;
            cell.textField.font = [UIFont DKCrayonFontWithSize:30.0];
        }
        aCell = cell;
    }
    
    aCell.selectionStyle = UITableViewCellSelectionStyleGray;
    return aCell;
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return (indexPath.section == 0);
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
    NSMutableArray *mutableArray = [[NSMutableArray alloc] initWithArray:self.gamesArray];
    AJGame *gameToMove = [mutableArray objectAtIndex:fromIndexPath.row];
    [mutableArray removeObjectAtIndex:fromIndexPath.row];
    [mutableArray insertObject:gameToMove atIndex:toIndexPath.row];
    [self setGamesArray:mutableArray];
    
    [self updateRowIdsForGames];
    [self loadDataAndUpdateUI:YES];
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return (indexPath.section == 0);
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView.editing == UITableViewCellEditingStyleDelete) {
        [self deleteGameFromCellWithIndexPath:indexPath];
    }
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (self.tableView.editing) return;
    
    if (indexPath.section == 1) {
        [((AJNewItemTableViewCell *)[tableView cellForRowAtIndexPath:indexPath]).textField becomeFirstResponder];
    } else {        
        AJPlayersTableViewController *playersViewController = [[AJPlayersTableViewController alloc] initWithStyle:UITableViewStylePlain];
        playersViewController.game = (AJGame *)[self.gamesArray objectAtIndex:indexPath.row];
        [self.navigationController pushViewController:playersViewController animated:YES];
    }
}

#pragma mark - Buttons Actions

- (IBAction)editButtonClicked:(id)sender {
    [self.tableView setEditing:YES animated:YES];
    self.navigationItem.rightBarButtonItem = self.doneBarButton;
}

- (IBAction)doneButtonClicked:(id)sender {
    [self.tableView setEditing:NO animated:YES];
    self.navigationItem.rightBarButtonItem = self.editBarButton;
}

#pragma mark - UITextFieldDelegate methods

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    return !self.tableView.editing;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    
    NSString *text = textField.text;
    if (![NSString isNilOrEmpty:text]) {
        int maxNo = [self.tableView numberOfRowsInSection:0];
        [[AJScoresManager sharedInstance] addGameWithName:text andRowId:maxNo+1];
        [textField setText:nil];

        [self loadDataAndUpdateUI:YES];
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]
                              atScrollPosition:UITableViewScrollPositionTop animated:NO];
    } else {
         [self loadDataAndUpdateUI:YES];
    }
    
    return YES;
}

#pragma mark - Private methods

- (void)loadDataAndUpdateUI:(BOOL)updateUI {
    self.gamesArray = [[AJScoresManager sharedInstance] getGamesArray];
    if (updateUI) {
        [self.tableView reloadData];
    }
}

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

- (void)deleteGameFromCellWithIndexPath:(NSIndexPath*)indexPath {
    [self.tableView beginUpdates];
    [[AJScoresManager sharedInstance] deleteGame:self.gamesArray[indexPath.row]];
    [self loadDataAndUpdateUI:NO];
    [self updateRowIdsForGames];
    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationMiddle];
    [self.tableView endUpdates];
    
    [self.tableView performSelector:@selector(reloadData) withObject:nil afterDelay:0.3];
}

#pragma mark - AJPanDeleteTableViewCellDelegate methods
- (void)panDeleteCellDraggedToDelete:(AJPanDeleteTableViewCell *)cell {
    AJAlertView *alertView = [[AJAlertView alloc] initWithTitle:nil
                                                        message:@"Are you sure you want to delete this game?"
                                                       delegate:self
                                              cancelButtonTitle:@"Cancel"
                                              otherButtonTitles:@"Delete", nil];
    alertView.userInfo = @{@"cell" : cell};
    [alertView show];
}

#pragma mark - UIAlertViewDelegate methods

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex != alertView.cancelButtonIndex) { // User clicked "delete"
        AJGameTableViewCell *cell = (AJGameTableViewCell *)[(AJAlertView *)alertView userInfo][@"cell"];
        
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        [self deleteGameFromCellWithIndexPath:indexPath];
    }
}

@end
