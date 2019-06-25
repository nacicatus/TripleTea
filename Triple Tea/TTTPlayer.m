//
//  TTTPlayer.m
//  Triple Tea
//
//  Created by Saurabh Sikka on 2019. 06. 12..
//  Copyright © 2019. Saurabh Sikka. All rights reserved.
//

#import "TTTPlayer.h"

@interface TTTPlayer ()
@property (readwrite) TTTChip chip;
@property (nonatomic, readwrite, copy) NSString *name;
@end


@implementation TTTPlayer

- (instancetype)initWithChip:(TTTChip)chip {
    self = [super init];
    
    if (self) {
        _chip = chip;
    }
    
    return self;
}

+ (TTTPlayer *)greenPlayer {
    return [self playerForChip:TTTChipGreen];
}

+ (TTTPlayer *)bluePlayer {
    return [self playerForChip:TTTChipBlue];
}

+ (TTTPlayer *)playerForChip:(TTTChip)chip {
    if (chip == TTTChipNone) {
        return nil;
    }
    
    // Chip enum is 0/1/2, array is 0/1.
    return [self allPlayers][chip - 1];
}

+ (NSArray<TTTPlayer *> *)allPlayers {
    static NSArray<TTTPlayer *> *allPlayers = nil;
    
    if (allPlayers == nil) {
        allPlayers = @[
                       [[TTTPlayer alloc] initWithChip:TTTChipGreen],
                       [[TTTPlayer alloc] initWithChip:TTTChipBlue],
                       ];
    }
    
    return allPlayers;
}

- (CIColor *)color {
    switch (self.chip) {
        case TTTChipGreen:
            return [CIColor greenColor];
            
        case TTTChipBlue:
            return [CIColor blueColor];
            
        default:
            return nil;
    }
}

- (NSString *)name {
    switch (self.chip) {
        case TTTChipGreen:
            return @"Green";
            
        case TTTChipBlue:
            return @"Blue";
            
        default:
            return nil;
    }
}
- (NSString *)debugDescription {
    switch (self.chip) {
        case TTTChipGreen:
            return @"X";
            
        case TTTChipBlue:
            return @"O";
            
        default:
            return @" ";
    }
}

- (TTTPlayer *)opponent {
    switch (self.chip) {
        case TTTChipGreen:
            return [TTTPlayer bluePlayer];
            
        case TTTChipBlue:
            return [TTTPlayer greenPlayer];
            
        default:
            return nil;
    }
}
@end
