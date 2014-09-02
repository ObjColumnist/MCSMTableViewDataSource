//
//  MCSMTableViewDataSource.h
//  MCSMUIKit
//
//  Created by Spencer MacDonald on 17/05/2012.
//  Copyright (c) 2012 Square Bracket Software. All rights reserved.
//

@import UIKit;

@class MCSMTableViewDataSourceSection;
@class MCSMTableViewDataSourceRow;

@interface MCSMTableViewDataSource : NSObject <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong, readonly) UITableView *tableView;
@property (nonatomic, assign, getter = isUpdating, readonly) BOOL updating;

- (instancetype)initWithTableView:(UITableView *)tableView;

#pragma mark -
#pragma mark Updates

- (void)beginUpdates;
- (void)commitUpdates;
- (void)endUpdatesWithCompletionHandler:(void (^)())completionHandler;

#pragma mark -
#pragma mark Sections

@property (nonatomic, copy) NSArray *sections;
@property (nonatomic, assign, readonly) NSUInteger numberOfSections;

@property (nonatomic, assign) BOOL allowsEmptySections; // Default is NO.

- (MCSMTableViewDataSourceSection *)sectionAtIndex:(NSUInteger)index;

- (NSUInteger)indexForSection:(MCSMTableViewDataSourceSection *)section;

- (MCSMTableViewDataSourceSection *)sectionForRow:(MCSMTableViewDataSourceRow *)row;
- (MCSMTableViewDataSourceSection *)sectionForObject:(id)object;

#pragma mark -
#pragma mark Enumaration

- (void)enumerateSectionsUsingBlock:(void (^)(MCSMTableViewDataSourceSection *section, NSUInteger sectionIndex, BOOL *stop))block;

#pragma mark -
#pragma mark Header/Footer Titles

- (NSString *)titleForHeaderInSectionAtIndex:(NSUInteger)index;
- (NSString *)titleForFooterInSectionAtIndex:(NSUInteger)index;

#pragma mark -
#pragma mark Insertion/Deletion/Reloading

- (void)insertSection:(MCSMTableViewDataSourceSection *)section atIndex:(NSUInteger)index withRowAnimation:(UITableViewRowAnimation)animation;
- (void)insertSection:(MCSMTableViewDataSourceSection *)section beforeSection:(MCSMTableViewDataSourceSection *)beforeSection withRowAnimation:(UITableViewRowAnimation)animation;
- (void)insertSection:(MCSMTableViewDataSourceSection *)section afterSection:(MCSMTableViewDataSourceSection *)afterSection withRowAnimation:(UITableViewRowAnimation)animation;

- (void)deleteSection:(MCSMTableViewDataSourceSection *)section withRowAnimation:(UITableViewRowAnimation)animation;
- (void)deleteSectionAtIndex:(NSUInteger)index withRowAnimation:(UITableViewRowAnimation)animation;
- (void)deleteSectionsAtIndexes:(NSIndexSet *)indexes withRowAnimation:(UITableViewRowAnimation)animation;

#pragma mark -
#pragma mark Rows

- (NSUInteger)numberOfRowsInSectionAtIndex:(NSUInteger)index;

- (MCSMTableViewDataSourceRow *)rowAtIndexPath:(NSIndexPath *)indexPath;
- (id)objectAtIndexPath:(NSIndexPath *)indexPath;

- (NSIndexPath *)indexPathForRow:(MCSMTableViewDataSourceRow *)row;
- (NSIndexPath *)indexPathForObject:(id)object;
- (MCSMTableViewDataSourceRow *)rowForObject:(id)object;

#pragma mark -
#pragma mark Enumaration

- (void)enumerateRowsUsingBlock:(void (^)(MCSMTableViewDataSourceSection *section, MCSMTableViewDataSourceRow *row, NSIndexPath *indexPath, BOOL *stop))block;

#pragma mark -
#pragma mark Cell

- (UITableViewCell *)cellForRowAtIndexPath:(NSIndexPath *)indexPath;

#pragma mark -
#pragma mark Cell Height

- (CGFloat)heightForRowAtIndexPath:(NSIndexPath *)indexPath;
- (CGFloat)estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath;

#pragma mark -
#pragma mark Selection

@property (nonatomic,retain) NSArray *selectedRows;
@property (nonatomic,retain) NSArray *selectedObjects;

- (void)selectRow:(MCSMTableViewDataSourceRow *)selectedRow animated:(BOOL)animated scrollPosition:(UITableViewScrollPosition)scrollPosition;
- (void)selectObject:(id)selectedObject animated:(BOOL)animated scrollPosition:(UITableViewScrollPosition)scrollPosition;

- (void)selectRows:(NSArray *)selectedRows byExtendingSelection:(BOOL)extendingSelection animated:(BOOL)animated;
- (void)selectObjects:(NSArray *)selectedObjects byExtendingSelection:(BOOL)extendingSelection animated:(BOOL)animated;

- (void)deselectRow:(MCSMTableViewDataSourceRow *)selectedRow animated:(BOOL)animated;
- (void)deselectObject:(id)selectedObject animated:(BOOL)animated;

- (void)deselectRows:(NSArray *)selectedRows animated:(BOOL)animated;
- (void)deselectObjects:(NSArray *)selectedObjects animated:(BOOL)animated;

- (void)deselectAllRowsAnimated:(BOOL)animated;

#pragma mark -
#pragma mark Insertion/Deletion/Reloading

- (void)insertRow:(MCSMTableViewDataSourceRow *)row atIndexPath:(NSIndexPath *)indexPath withRowAnimation:(UITableViewRowAnimation)animation;
- (void)insertRow:(MCSMTableViewDataSourceRow *)row beforeRow:(MCSMTableViewDataSourceRow *)beforeRow withRowAnimation:(UITableViewRowAnimation)animation;
- (void)insertRow:(MCSMTableViewDataSourceRow *)row afterRow:(MCSMTableViewDataSourceRow *)afterRow withRowAnimation:(UITableViewRowAnimation)animation;

- (void)insertObject:(id)object atIndexPath:(NSIndexPath *)indexPath withRowAnimation:(UITableViewRowAnimation)animation;
- (void)insertObject:(id)object beforeObject:(id)beforeObject withRowAnimation:(UITableViewRowAnimation)animation;
- (void)insertObject:(id)object afterObject:(id)afterObject withRowAnimation:(UITableViewRowAnimation)animation;

- (void)deleteRow:(MCSMTableViewDataSourceRow *)row withRowAnimation:(UITableViewRowAnimation)animation;
- (void)deleteRowAtIndexPath:(NSIndexPath *)indexPath withRowAnimation:(UITableViewRowAnimation)animation;
- (void)deleteRowsAtIndexPaths:(NSArray *)indexPaths withRowAnimation:(UITableViewRowAnimation)animation;

- (void)deleteObject:(id)object withRowAnimation:(UITableViewRowAnimation)animation;

#pragma mark -
#pragma mark - UITableViewDelegate

#pragma mark - Highlight

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)tableView:(UITableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)tableView:(UITableView *)tableView didUnhighlightRowAtIndexPath:(NSIndexPath *)indexPath;

#pragma mark - Selection
            
- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath;
- (NSIndexPath *)tableView:(UITableView *)tableView willDeselectRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath;

#pragma mark -
#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section;
- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section;
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;

@end
