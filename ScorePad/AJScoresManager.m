//
//  AJScoresManager.m
//  ScorePad
//
//  Created by Anca Julean on 9/11/12.
//  Copyright (c) 2012 Anca Julean. All rights reserved.
//

#import "AJScoresManager.h"
#import "UIColor+Additions.h"
#import "AJSettingsInfo.h"

@interface AJScoresManager()

- (NSURL *)applicationDocumentsDirectory;

- (void)insertDummyData;

@end


@implementation AJScoresManager

@synthesize managedObjectModel = __managedObjectModel;
@synthesize managedObjectContext = __managedObjectContext;
@synthesize persistentStoreCoordinator = __persistentStoreCoordinator;

static AJScoresManager *sharedAJScoresManager = nil;

#pragma mark - Singleton methods

+ (AJScoresManager *)sharedAJScoresManager {
    if (sharedAJScoresManager == nil) {
        sharedAJScoresManager = [self alloc];
        [sharedAJScoresManager init];
    }
    
    return sharedAJScoresManager;
}

+ (AJScoresManager *)sharedInstance {
    return [self sharedAJScoresManager];
}

- (id)copyWithZone:(NSZone *)zone {
    return self;
}

- (id)retain {
    return self;
}

- (NSUInteger)retainCount {
    return NSUIntegerMax;
}

- (oneway void)release {
    
}

- (id)autorelease {
    return self;
}

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext {
    if (__managedObjectContext != nil) {
        return __managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        __managedObjectContext = [[NSManagedObjectContext alloc] init];
        [__managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    
    return __managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel {
    if (__managedObjectModel != nil) {
        return __managedObjectModel;
    }
    
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"ScorePad" withExtension:@"momd"];
    __managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return __managedObjectModel;
}


// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    if (__persistentStoreCoordinator != nil) {
        return __persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"ScorePadModel.sqlite"];
    
    NSError *error = nil;
    __persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    
    if (![__persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        NSLog(@"Unresolved error %@ %@", error, error.userInfo);
        abort();
    }
    
    return __persistentStoreCoordinator;
}

#pragma mark - Public methods

- (NSArray *)getGamesArray {        
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"AJGame"];
    fetchRequest.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"rowId" ascending:NO]];
    
    return [self.managedObjectContext executeFetchRequest:fetchRequest error:nil];
}

- (void)addGameWithName:(NSString *)name andRowId:(int)rowId {
    AJGame *game = [AJGame createGameWithName:name inManagedObjectContext:self.managedObjectContext];
    game.color = [[UIColor colorWithRed:0.6 green:0.2 blue:0.8 alpha:1.0] toHexString:YES];
    game.rowId = [NSNumber numberWithInt:rowId];
    
    [self saveContext];
}

- (void)deleteGame:(AJGame *)game {
    [[self managedObjectContext] deleteObject:game];
    
    [self saveContext];
}

- (NSArray *)getAllPlayersForGame:(AJGame *)game {
    NSError *error = nil;
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"AJPlayer"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"game.name = %@ AND game.rowId = %@", game.name, game.rowId];
    fetchRequest.predicate = predicate;
    fetchRequest.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"time" ascending:YES]];
    
    return [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
}

- (AJPlayer *)createPlayerWithName:(NSString *)playerName forGame:(AJGame *)game {
    AJPlayer *player = [AJPlayer createPlayerWithName:playerName forGame:game];
    player.color = [[UIColor colorWithRed:0.3 green:0.6 blue:0.2 alpha:1.0] toHexString:YES];
    
    if (![self saveContext]) return nil;
    
    return player;
}

- (void)deletePlayer:(AJPlayer *)player {
    [[self managedObjectContext] deleteObject:player];
    
    [self saveContext];
}

- (NSArray *)getAllScoresForPlayer:(AJPlayer *)player {
    NSError *error = nil;
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"AJScore"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"player.name = %@ AND player.time = %@", player.name, player.time];
    fetchRequest.predicate = predicate;
    fetchRequest.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"round" ascending:YES]];
    
    return [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
}

- (AJScore *)createScoreWithValue:(double)value inRound:(int)round forPlayer:(AJPlayer *)player {
    AJScore *score = [AJScore createScoreWithValue:value inRound:round forPlayer:player];
    
    if (![self saveContext]) return nil;
    
    return score;
}

- (void)deleteScore:(AJScore *)score {
    [[self managedObjectContext] deleteObject:score];
    
    [self saveContext];
}

- (int)maxNumberOfScoresInGame:(AJGame *)game {
   /* NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"AJPlayer"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"game.name = %@ AND game.rowId = %@", game.name, game.rowId];
    fetchRequest.predicate = predicate;
    
    [fetchRequest setResultType:NSDictionaryResultType];
    
    NSExpression *keyPathExpression = [NSExpression expressionForKeyPath:@"scores"];
    NSExpression *countExpression = [NSExpression expressionForFunction:@"count:" arguments:[NSArray arrayWithObject:keyPathExpression]];
    
    NSExpressionDescription *expressionDescription = [[NSExpressionDescription alloc] init];
    
    [expressionDescription setName:@"countScores"];
    [expressionDescription setExpression:countExpression];
    [expressionDescription setExpressionResultType:NSInteger32AttributeType];
    
    [fetchRequest setPropertiesToFetch:[NSArray arrayWithObject:expressionDescription]];
    
    NSError *error = nil;
    NSArray *objects = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    for (id object in objects ) {
        NSLog(@"object: %@", object);
    }*/
    
    return 0;
}

#pragma mark - Other public methods

- (BOOL)saveContext {
    NSError *error = nil;
    NSManagedObjectContext *mObjectContext = self.managedObjectContext;
    if (mObjectContext != nil) {
        if ([mObjectContext hasChanges] && ![mObjectContext save:&error]) {
            NSLog(@"Unresolved error %@ %@", error, error.userInfo);
            return NO;
        }
    }
    return YES;
}

+ (AJSettingsInfo *)createSettingsInfo {
    return [[[AJSettingsInfo alloc] init] autorelease];
}

#pragma mark - Private methods

// Returns the URL to the application's Document directory
- (NSURL *)applicationDocumentsDirectory {
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (void)insertDummyData {
    NSManagedObjectContext *context = self.managedObjectContext;
    /*NSManagedObject *game1 = [NSEntityDescription insertNewObjectForEntityForName:@"AJGame" inManagedObjectContext:context];
    [game1 setValue:[NSNumber numberWithInt:1] forKey:@"rowId"];
    [game1 setValue:@"Game1" forKey:@"name"];
    NSManagedObject *game2 = [NSEntityDescription insertNewObjectForEntityForName:@"AJGame" inManagedObjectContext:context];
    [game2 setValue:[NSNumber numberWithInt:2] forKey:@"rowId"];
    [game2 setValue:@"Game2" forKey:@"name"];*/
    
    /*AJGame *game1 = [AJGame createGameWithName:@"game1" inManagedObjectContext:context];
    game1.rowId = [NSNumber numberWithInt:1];*/
    AJGame *game2 = [AJGame createGameWithName:@"game test" inManagedObjectContext:context];
    game2.rowId = [NSNumber numberWithInt:7];
    
    [AJPlayer createPlayerWithName:@"player 1" forGame:game2];
    [AJPlayer createPlayerWithName:@"player 2" forGame:game2];
    [AJPlayer createPlayerWithName:@"player 3" forGame:game2];
    
    [self saveContext];
}

- (NSArray *)getDummyData {
    //[self insertDummyData];
    
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"AJGame"];
    fetchRequest.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"rowId" ascending:NO]];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name = %@", @"game test"];
    fetchRequest.predicate = predicate;
    
    AJGame *game = [[self.managedObjectContext executeFetchRequest:fetchRequest error:nil] lastObject];
    
    return [self getAllPlayersForGame:game];
}

@end
