//
//  TTTPlayer.h
//  Triple Tea
//
//  Created by Saurabh Sikka on 2019. 06. 12..
//  Copyright © 2019. Saurabh Sikka. All rights reserved.
//

@import AppKit;

typedef NS_ENUM(NSInteger, TTTChip) {
    TTTChipNone = 0,
    TTTChipGreen,
    TTTChipBlue
};

#import <Foundation/Foundation.h>

@interface TTTPlayer : NSObject

+ (TTTPlayer *)greenPlayer;
+ (TTTPlayer *)bluePlayer;
+ (NSArray<TTTPlayer *> *)allPlayers;
+ (TTTPlayer *)playerForChip:(TTTChip)chip;

@property (nonatomic, readonly) TTTChip chip;
@property (nonatomic, readonly) CIColor *color;
@property (nonatomic, copy, readonly) NSString *name;

@property (nonatomic, readonly) TTTPlayer *opponent;

@end
