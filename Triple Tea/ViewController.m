//
//  ViewController.m
//  Triple Tea
//
//  Created by Saurabh Sikka on 2019. 06. 12..
//  Copyright © 2019. Saurabh Sikka. All rights reserved.
//

@import GameplayKit;

#import "ViewController.h"
#import "TTTBoard.h"
#import "TTTPlayer.h"
#import "TTTAIStrategy.h"

// Switch this off to manually make moves for the blue (O) player.
#define USE_AI_PLAYER 1



@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.strategist = [[GKMinmaxStrategist alloc] init];
    
    // 4 AI turns + 3 human turns in between = 7 turns for dominant AI (if heuristic good).
    self.strategist.maxLookAheadDepth = 7;
    self.strategist.randomSource = [[GKARC4RandomSource alloc] init];
    
    NSMutableArray *columns = [NSMutableArray arrayWithCapacity:TTTBoard.width];
    for (NSInteger column = 0; column < TTTBoard.width; column++) {
        columns[column] = [NSMutableArray arrayWithCapacity:TTTBoard.height];
    }
    self.chipLayers = [columns copy];
    
    [self resetBoard];
}

- (void)viewDidLayoutSubviews {
    NSButton *button = self.columnButtons[0];
    CGFloat length = MIN(button.frame.size.width - 10, button.frame.size.height / 6 - 10);
    CGRect rect = CGRectMake(0, 0, length, length);
    self.chipPath = [NSBezierPath bezierPathWithOvalInRect:rect];
    
    [self.chipLayers enumerateObjectsUsingBlock:^(NSArray<CAShapeLayer *> *columnLayers, NSUInteger column, BOOL *stop) {
       [columnLayers enumerateObjectsUsingBlock:^(CAShapeLayer *chip, NSUInteger row, BOOL *stop) {
            chip.path = (__bridge CGPathRef _Nullable)(self.chipPath.bezierPathByFlatteningPath);
            chip.frame = self.chipPath.bounds;
            chip.position = [self positionForChipLayerAtColumn:column row:row];
        }];
    }];
}


- (IBAction)makeMove:(NSButton *)sender {
    NSInteger column = sender.tag;
    
    if ([self.board canMoveInColumn:column]) {
        [self.board addChip:self.board.currentPlayer.chip inColumn:column];
        [self updateButton:sender];
        [self updateGame];
    }
}

- (void)updateButton:(NSButton *)button {
    NSInteger column = button.tag;
    button.enabled = [self.board canMoveInColumn:column];
    
    NSInteger row = TTTBoard.height;
    TTTChip chip = TTTChipNone;
    while (chip == TTTChipNone && row > 0) {
        chip = [self.board chipInColumn:column row:--row];
    }
    
    if (chip != TTTChipNone) {
        [self addChipLayerAtColumn:column row:row color:[TTTPlayer playerForChip:chip].color];
    }
}

- (CGPoint)positionForChipLayerAtColumn:(NSInteger)column row:(NSInteger)row {
    NSButton *columnButton = self.columnButtons[column];
    CGFloat xOffset = CGRectGetMidX(columnButton.frame);
    CGFloat yStride = self.chipPath.bounds.size.height + 10;
    CGFloat yOffset = CGRectGetMaxY(columnButton.frame) - yStride / 2;
    return CGPointMake(xOffset, yOffset - yStride * row);
}

- (void)addChipLayerAtColumn:(NSInteger)column row:(NSInteger)row color:(CIColor *)color {
    if (self.chipLayers[column].count < row + 1) {
        // Create and position a layer for the new chip.
        CAShapeLayer *newChip = [CAShapeLayer layer];
       // newChip.path = self.chipPath.CGPath;
        newChip.frame = self.chipPath.bounds;
       // newChip.fillColor = color.CGColor;
        newChip.position = [self positionForChipLayerAtColumn:column row:row];
        
        // Animate the chip falling into place.
//        [self.view.layer addSublayer:newChip];
//        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position.y"];
//        animation.fromValue = @(-newChip.frame.size.height);
//        animation.toValue = @(newChip.position.y);
//        animation.duration = 0.5;
//        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
//        [newChip addAnimation:animation forKey:nil];
        self.chipLayers[column][row] = newChip;
    }
}

- (void)resetBoard {
    self.board = [[TTTBoard alloc] init];
    for (NSButton *button in self.columnButtons) {
        [self updateButton:button];
    }
    [self updateUI];
    
    self.strategist.gameModel = self.board;
    
    for (NSMutableArray<CAShapeLayer *> *column in self.chipLayers) {
        for (CAShapeLayer *chip in column) {
            [chip removeFromSuperlayer];
        }
        [column removeAllObjects];
    }
}

- (void)updateGame {
    NSString *gameOverTitle = nil;
    if ([self.board isWinForPlayer:self.board.currentPlayer]) {
        gameOverTitle = [NSString stringWithFormat:@"%@ Wins!", self.board.currentPlayer.name];
    }
    else if (self.board.isFull) {
        gameOverTitle = @"Draw!";
    }
    
    if (gameOverTitle) {
    
    [self updateUI];
    }
}



- (void)updateUI {
    
    self.displayLabel.stringValue = [NSString stringWithFormat:@"%@ Turn", self.board.currentPlayer.name];
    // #if USE_AI_PLAYER
    if (self.board.currentPlayer.chip == TTTChipBlue) {
        NSInteger column = [self columnForAIMove];
        [self makeAIMoveInColumn:column];
    }
}



- (NSInteger)columnForAIMove {
    NSInteger column;
    
    TTTMove *aiMove = [self.strategist bestMoveForPlayer:self.board.currentPlayer];
    
    NSAssert(aiMove != nil, @"AI should always be able to move (detect endgame before invoking AI)");
    
    column = aiMove.column;
    
    return column;
}

- (void)makeAIMoveInColumn:(NSInteger)column {
    
    [self.board addChip:self.board.currentPlayer.chip inColumn:column];
    for (NSButton *button in self.columnButtons) {
        [self updateButton:button];
    }
    
    [self updateGame];
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}


@end
