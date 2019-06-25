//
//  TTTBoard.m
//  Triple Tea
//
//  Created by Saurabh Sikka on 2019. 06. 12..
//  Copyright © 2019. Saurabh Sikka. All rights reserved.
//

#import "TTTBoard.h"

const static NSInteger TTTBoardWidth = 5;
const static NSInteger TTTBoardHeight = 5;

@implementation TTTBoard {
    TTTChip _cells[TTTBoardWidth * TTTBoardHeight];
}

+(NSInteger) width {
    return TTTBoardWidth;
}

+(NSInteger) height {
    return TTTBoardHeight;
}

- (instancetype)init {
    self = [super init];
    
    if (self) {
        _currentPlayer = [TTTPlayer greenPlayer];
    }
    
    return self;
}

- (void)updateChipsFromBoard:(TTTBoard *)otherBoard {
    memcpy(_cells, otherBoard->_cells, sizeof(_cells));
}

- (TTTChip)chipInColumn:(NSInteger)column row:(NSInteger)row {
    return _cells[row + column * TTTBoardHeight];
}

- (void)setChip:(TTTChip)chip inColumn:(NSInteger)column row:(NSInteger)row {
    _cells[row + column * TTTBoardHeight] = chip;
}

- (NSString *)debugDescription {
    NSMutableString *output = [NSMutableString string];
    
    for (NSInteger row = TTTBoardHeight - 1; row >= 0; row--) {
        for (NSInteger column = 0; column < TTTBoardWidth; column++) {
            TTTChip chip = [self chipInColumn:column row:row];
            
            NSString *playerDescription = [TTTPlayer playerForChip:chip].debugDescription ?: @" ";
            [output appendString:playerDescription];
            
            NSString *cellDescription = (column + 1 < TTTBoardWidth) ? @"." : @"";
            [output appendString:cellDescription];
        }
        
        [output appendString:((row > 0) ? @"\n" : @"")];
    }
    
    return output;
}

- (NSInteger)nextEmptySlotInColumn:(NSInteger)column {
    for (NSInteger row = 0; row < TTTBoardHeight; row++) {
        if ([self chipInColumn:column row:row] == TTTChipNone) {
            return row;
        }
    }
    
    return -1;
}


- (BOOL)canMoveInColumn:(NSInteger)column {
    return [self nextEmptySlotInColumn:column] >= 0;
}

- (void)addChip:(TTTChip)chip inColumn:(NSInteger)column {
    NSInteger row = [self nextEmptySlotInColumn:column];
    
    if (row >= 0) {
        [self setChip:chip inColumn:column row:row];
    }
}

- (BOOL)isFull {
    for (NSInteger column = 0; column < TTTBoardWidth; column++) {
        if ([self canMoveInColumn:column]) {
            return NO;
        }
    }
    
    return YES;
}

- (NSArray<NSNumber *> *)runCountsForPlayer:(TTTPlayer *)player {
    TTTChip chip = player.chip;
    NSMutableArray<NSNumber *> *counts = [NSMutableArray array];
    
    // Detect horizontal runs.
    for (NSInteger row = 0; row < TTTBoardHeight; row++) {
        NSInteger runCount = 0;
        for (NSInteger column = 0; column < TTTBoardWidth; column++) {
            if ([self chipInColumn:column row:row] == chip) {
                ++runCount;
            }
            else {
                // Run isn't continuing, note it and reset counter.
                if (runCount > 0) {
                    [counts addObject:@(runCount)];
                }
                runCount = 0;
            }
        }
        if (runCount > 0) {
            // Note the run if still on one at the end of the row.
            [counts addObject:@(runCount)];
        }
    }
    
    // Detect vertical runs.
    for (NSInteger column = 0; column < TTTBoardWidth; column++) {
        NSInteger runCount = 0;
        for (NSInteger row = 0; row < TTTBoardHeight; row++) {
            if ([self chipInColumn:column row:row] == chip) {
                ++runCount;
            }
            else {
                // Run isn't continuing, note it and reset counter.
                if (runCount > 0) {
                    [counts addObject:@(runCount)];
                }
                runCount = 0;
            }
        }
        if (runCount > 0) {
            // Note the run if still on one at the end of the column.
            [counts addObject:@(runCount)];
        }
    }
    
    // Detect diagonal (northeast) runs
    for (NSInteger startColumn = -TTTBoardHeight; startColumn < TTTBoardWidth; startColumn++) {
        // Start from off the edge of the board to catch all the diagonal lines through it.
        NSInteger runCount = 0;
        for (NSInteger offset = 0; offset < TTTBoardHeight; offset++) {
            NSInteger column = startColumn + offset;
            if (column < 0 || column > TTTBoardWidth) {
                continue; // Ignore areas that aren't on the board.
            }
            if ([self chipInColumn:column row:offset] == chip) {
                ++runCount;
            }
            else {
                // Run isn't continuing, note it and reset counter.
                if (runCount > 0) {
                    [counts addObject:@(runCount)];
                }
                runCount = 0;
            }
        }
        if (runCount > 0) {
            // Note the run if still on one at the end of the line.
            [counts addObject:@(runCount)];
        }
    }
    
    // Detect diagonal (northwest) runs
    for (NSInteger startColumn = 0; startColumn < TTTBoardWidth + TTTBoardHeight; startColumn++) {
        // Iterate through areas off the edge of the board to catch all the diagonal lines through it.
        NSInteger runCount = 0;
        for (NSInteger offset = 0; offset < TTTBoardHeight; offset++) {
            NSInteger column = startColumn - offset;
            if (column < 0 || column > TTTBoardWidth) {
                continue; // Ignore areas that aren't on the board.
            }
            if ([self chipInColumn:column row:offset] == chip) {
                ++runCount;
            }
            else {
                // Run isn't continuing, note it and reset counter.
                if (runCount > 0) {
                    [counts addObject:@(runCount)];
                }
                runCount = 0;
            }
        }
        if (runCount > 0) {
            // Note the run if still on one at the end of the line.
            [counts addObject:@(runCount)];
        }
    }
    
    return counts;
}



@end
