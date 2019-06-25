//
//  TTTAIStrategy.m
//  Triple Tea
//
//  Created by Saurabh Sikka on 2019. 06. 12..
//  Copyright © 2019. Saurabh Sikka. All rights reserved.
//

#import "TTTAIStrategy.h"

@implementation TTTMove

- (instancetype)initWithColumn:(NSInteger)column {
    self = [super init];
    
    if (self) {
        _column = column;
    }
    
    return self;
}

+ (TTTMove *)moveInColumn:(NSInteger)column {
    return [[self alloc] initWithColumn:column];
}

@end

@implementation TTTPlayer (AIStrategy)

- (NSInteger)playerId {
    return self.chip;
}

@end

@implementation TTTBoard (AIStrategy)

#pragma mark - Managing players

- (NSArray<TTTPlayer *> *)players {
    return [TTTPlayer allPlayers];
}

- (TTTPlayer *)activePlayer {
    return self.currentPlayer;
}

#pragma mark - Copying board state

- (__nonnull id)copyWithZone:(nullable NSZone *)zone {
    TTTBoard *copy = [[[self class] allocWithZone:zone] init];
    [copy setGameModel:self];
    return copy;
}

- (void)setGameModel:(TTTBoard *)gameModel {
    [self updateChipsFromBoard:gameModel];
    self.currentPlayer = gameModel.currentPlayer;
}

#pragma mark - Finding & applying moves

- (NSArray<TTTMove *> *)gameModelUpdatesForPlayer:(TTTPlayer *)player {
    NSMutableArray<TTTMove *> *moves = [NSMutableArray arrayWithCapacity:TTTBoard.width];
    for (NSInteger column = 0; column < TTTBoard.width; column++) {
        if ([self canMoveInColumn:column]) {
            [moves addObject:[TTTMove moveInColumn:column]];
        }
    }
    
    // Will be empty if isFull.
    return moves;
}

- (void)applyGameModelUpdate:(TTTMove *)gameModelUpdate {
    [self addChip:self.currentPlayer.chip inColumn:gameModelUpdate.column];
    self.currentPlayer = self.currentPlayer.opponent;
}

#pragma mark - Evaluating board state

- (BOOL)isWinForPlayer:(TTTPlayer *)player {
    NSArray<NSNumber *> *runCounts = [self runCountsForPlayer:player];
    
    // The player wins if there are any runs of 4 (or more, but that shouldn't happen in a regular game).
    NSNumber *longestRun = [runCounts valueForKeyPath:@"@max.self"];
    return longestRun.integerValue >= TTTCountToWin;
}

- (BOOL)isLossForPlayer:(TTTPlayer *)player {
    // This is a two-player game, so a win for the opponent is a loss for the player.
    return [self isWinForPlayer:player.opponent];
}

- (NSInteger)scoreForPlayer:(TTTPlayer *)player {
    /*
     Heuristic: the chance of winning soon is related to the number and length
     of N-in-a-row runs of chips. For example, a player with two runs of two chips each
     is more likely to win soon than a player with no runs.
     
     Scoring should weigh the player's chance of success against that of failure,
     which in a two-player game means success for the opponent. Sum the player's number
     and size of runs, and subtract from it the same score for the opponent.
     
     This is not the best possible heuristic for Four-In-A-Row, but it produces
     moderately strong gameplay. Try these improvements:
     - Account for "broken runs"; e.g. a row of two chips, then a space, then a third chip.
     - Weight the run lengths; e.g. two runs of three is better than three runs of two.
     */
    
    // Use TTTBoard's utility method to find all runs of the player's chip and sum their length.
    NSArray<NSNumber *> *playerRunCounts = [self runCountsForPlayer:player];
    NSNumber *playerTotal = [playerRunCounts valueForKeyPath:@"@sum.self"];
    
    // Repeat for the opponent's chip.
    NSArray<NSNumber *> *opponentRunCounts = [self runCountsForPlayer:player.opponent];
    NSNumber *opponentTotal = [opponentRunCounts valueForKeyPath:@"@sum.self"];
    
    // Return the sum of player runs minus the sum of opponent runs.
    return playerTotal.integerValue - opponentTotal.integerValue;
}

@end
