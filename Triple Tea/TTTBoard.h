//
//  TTTBoard.h
//  Triple Tea
//
//  Created by Saurabh Sikka on 2019. 06. 12..
//  Copyright © 2019. Saurabh Sikka. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TTTPlayer.h"

const static NSInteger TTTCountToWin = 5;

@interface TTTBoard : NSObject

@property TTTPlayer *currentPlayer;

+(NSInteger) width;
+(NSInteger) height;

- (TTTChip)chipInColumn:(NSInteger)column row:(NSInteger)row;
//- (BOOL)canMoveInColumn:(NSInteger)column;
//- (void)addChip:(TTTChip)chip inColumn:(NSInteger)column;

- (void)addChip: (TTTChip)chip inColumn:(NSInteger)column row:(NSInteger)row;
- (BOOL)isFull;

- (NSArray<NSNumber *> *)runCountsForPlayer:(TTTPlayer *)player;

- (void)updateChipsFromBoard:(TTTBoard *)otherBoard;

@end
