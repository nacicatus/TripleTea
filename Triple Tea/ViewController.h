//
//  ViewController.h
//  Triple Tea
//
//  Created by Saurabh Sikka on 2019. 06. 12..
//  Copyright © 2019. Saurabh Sikka. All rights reserved.
//

@import AppKit;
@import QuartzCore;
#import "TTTBoard.h"

@interface ViewController : NSViewController


@property TTTBoard *board;
@property GKMinmaxStrategist *strategist;
@property (nonatomic, strong) IBOutletCollection(NSButton) NSArray *columnButtons;

@property NSBezierPath *chipPath;
@property NSArray<NSMutableArray<CAShapeLayer *> *> *chipLayers;

@property (nonatomic, strong) IBOutlet NSTextField * displayLabel;

@end

