//
//  MCSMTableViewDataSourceRow.h
//  MCSMUIKit 
//
//  Created by Spencer MacDonald on 17/11/2012.
//  Copyright (c) 2012 Square Bracket Software. All rights reserved.
//

@import UIKit;
#import "MCSMTableViewDataSourceObject.h"

@interface MCSMTableViewDataSourceRow : MCSMTableViewDataSourceObject

@property (nonatomic,retain) UITableViewCell *cell;

@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGFloat estimatedHeight;

@property (nonatomic, copy) NSIndexPath * (^willSelectHandler)(MCSMTableViewDataSourceRow *row, NSIndexPath *indexPath);
@property (nonatomic, copy) void (^didSelectHandler)(MCSMTableViewDataSourceRow *row, NSIndexPath *indexPath);

@property (nonatomic, copy) NSIndexPath *(^willDeselectHandler)(MCSMTableViewDataSourceRow *row, NSIndexPath *indexPath);
@property (nonatomic, copy) void (^didDeselectHandler)(MCSMTableViewDataSourceRow *row, NSIndexPath *indexPath);

@property (nonatomic, copy) BOOL (^shouldHighlightHandler)(MCSMTableViewDataSourceRow *row, NSIndexPath *indexPath);
@property (nonatomic, copy) void (^didHighlightHandler)(MCSMTableViewDataSourceRow *row, NSIndexPath *indexPath);
@property (nonatomic, copy) void (^didUnhighlightHandler)(MCSMTableViewDataSourceRow *row, NSIndexPath *indexPath);

+ (NSArray *)rowsWithObjects:(NSArray *)objects;

+ (NSArray *)rowsWithRowsOrObjects:(NSArray *)objects;

+ (instancetype)rowWithObject:(id)object;

+ (instancetype)rowWithObject:(id)object
             didSelectHandler:(void (^)(MCSMTableViewDataSourceRow *row, NSIndexPath *indexPath))didSelectHandler;

- (instancetype)initWithObject:(id)object;

- (instancetype)initWithObject:(id)object
              didSelectHandler:(void (^)(MCSMTableViewDataSourceRow *row, NSIndexPath *indexPath))didSelectHandler;

@end
