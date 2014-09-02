//
//  MCSMTableViewSection.h
//  MCSMUIKit
//
//  Created by Spencer MacDonald on 23/01/2012.
//  Copyright (c) 2012 Square Bracket Software. All rights reserved.
//

@import UIKit;
#import "MCSMTableViewDataSourceObject.h"
@class MCSMTableViewDataSourceRow;

@interface MCSMTableViewDataSourceSection : MCSMTableViewDataSourceObject

@property (nonatomic, copy) NSString *headerTitle;
@property (nonatomic, copy) NSString *footerTitle;
@property (nonatomic, copy) NSString *indexTitle;
@property (nonatomic, readonly) NSUInteger numberOfRows;

@property (nonatomic, strong) NSArray *rows;

+ (instancetype)sectionWithRows:(NSArray *)rows;
+ (instancetype)sectionWithObjects:(NSArray *)objects;

- (instancetype)initWithRows:(NSArray *)rows;
- (instancetype)initWithObjects:(NSArray *)objects;

- (instancetype)initWithHeaderTitle:(NSString *)headerTitle
                         indexTitle:(NSString *)indexTitle
                               rows:(NSArray *)rows;

- (instancetype)initWithHeaderTitle:(NSString *)headerTitle
                         indexTitle:(NSString *)indexTitle
                            objects:(NSArray *)objects;

- (instancetype)initWithIdentifier:(NSString *)identifier
                       headerTitle:(NSString *)headerTitle
                       footerTitle:(NSString *)footerTitle
                        indexTitle:(NSString *)indexTitle
                              rows:(NSArray *)rows;

- (instancetype)initWithIdentifier:(NSString *)identifier
                       headerTitle:(NSString *)headerTitle
                       footerTitle:(NSString *)footerTitle
                        indexTitle:(NSString *)indexTitle
                           objects:(NSArray *)objects;

- (MCSMTableViewDataSourceRow *)rowAtIndex:(NSUInteger)index;
- (id)objectAtIndex:(NSUInteger)index;

- (void)addRow:(MCSMTableViewDataSourceRow *)row;
- (void)addObject:(id)object;

- (void)addRows:(NSArray *)rows;
- (void)addObjects:(NSArray *)objects;

- (void)removeRow:(MCSMTableViewDataSourceRow *)row;
- (void)removeObject:(id)object;

- (void)removeRows:(NSArray *)rows;
- (void)removeObjects:(NSArray *)object;

- (NSUInteger)indexOfRow:(MCSMTableViewDataSourceRow *)row;
- (NSUInteger)indexOfObject:(id)object;

- (BOOL)containsRow:(MCSMTableViewDataSourceRow *)row;
- (BOOL)containsObject:(id)object;

- (BOOL)containsRows:(NSArray *)rows;
- (BOOL)containsObjects:(NSArray *)objects;

- (void)enumerateRowsUsingBlock:(void (^)(MCSMTableViewDataSourceRow *row, NSUInteger rowIndex, BOOL *stop))block;

@end
