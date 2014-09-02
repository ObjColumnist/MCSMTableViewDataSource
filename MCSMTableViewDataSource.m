//
//  MCSMTableViewDataSource.m
//  MCSMUIKit
//
//  Created by Spencer MacDonald on 17/05/2012.
//  Copyright (c) 2012 Square Bracket Software. All rights reserved.
//

#import "MCSMTableViewDataSource.h"
#import "MCSMTableViewDataSourceSection.h"
#import "MCSMTableViewDataSourceRow.h"

#pragma mark -
#pragma mark MCSMTableViewDataSourceUpdatedSection

@interface MCSMTableViewDataSourceUpdatedSection : MCSMTableViewDataSourceSection

@property (nonatomic, strong) MCSMTableViewDataSourceSection *originalSection;
@property (nonatomic, assign) NSUInteger index;
@property (nonatomic, assign) UITableViewRowAnimation rowAnimation;

@end

@implementation MCSMTableViewDataSourceUpdatedSection

@end


@interface MCSMTableViewDataSourceInsertedSection : MCSMTableViewDataSourceUpdatedSection

+ (instancetype)tableViewDataSourceInsertedSectionWithSection:(MCSMTableViewDataSourceSection *)originalSection
                                                        index:(NSUInteger)index
                                             withRowAnimation:(UITableViewRowAnimation)animation;

@end

@implementation MCSMTableViewDataSourceInsertedSection

+ (instancetype)tableViewDataSourceInsertedSectionWithSection:(MCSMTableViewDataSourceSection *)originalSection
                                                        index:(NSUInteger)index
                                             withRowAnimation:(UITableViewRowAnimation)animation{
    MCSMTableViewDataSourceInsertedSection *insertedSection = [[self alloc] init];
    insertedSection.originalSection = originalSection;
    insertedSection.index = index;
    insertedSection.rowAnimation = animation;
    return insertedSection;
}

@end


@interface MCSMTableViewDataSourceDeletedSection : MCSMTableViewDataSourceUpdatedSection

+ (instancetype)tableViewDataSourceDeletedSectionWithSection:(MCSMTableViewDataSourceSection *)originalSection
                                                       index:(NSUInteger)index
                                            withRowAnimation:(UITableViewRowAnimation)animation;

@end

@implementation MCSMTableViewDataSourceDeletedSection

+ (instancetype)tableViewDataSourceDeletedSectionWithSection:(MCSMTableViewDataSourceSection *)originalSection
                                                       index:(NSUInteger)index
                                            withRowAnimation:(UITableViewRowAnimation)animation{
    MCSMTableViewDataSourceDeletedSection *deletedSection = [[self alloc] init];
    deletedSection.originalSection = originalSection;
    deletedSection.index = index;
    deletedSection.rowAnimation = animation;
    return deletedSection;
}

@end


#pragma mark -
#pragma mark MCSMTableViewDataSourceUpdatedRow

@interface MCSMTableViewDataSourceUpdatedRow : MCSMTableViewDataSourceRow

@property (nonatomic, strong) MCSMTableViewDataSourceRow *originalRow;
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, assign) UITableViewRowAnimation rowAnimation;

@end

@implementation MCSMTableViewDataSourceUpdatedRow

@end

@interface MCSMTableViewDataSourceInsertedRow : MCSMTableViewDataSourceUpdatedRow

+ (instancetype)tableViewDataSourceInsertedRowWithRow:(MCSMTableViewDataSourceRow *)originalRow
                                            indexPath:(NSIndexPath *)indexPath
                                     withRowAnimation:(UITableViewRowAnimation)animation;

@end

@implementation MCSMTableViewDataSourceInsertedRow

+ (instancetype)tableViewDataSourceInsertedRowWithRow:(MCSMTableViewDataSourceRow *)originalRow
                                            indexPath:(NSIndexPath *)indexPath
                                     withRowAnimation:(UITableViewRowAnimation)animation{
    MCSMTableViewDataSourceInsertedRow *insertedRow = [[self alloc] init];
    insertedRow.originalRow = originalRow;
    insertedRow.indexPath = indexPath;
    insertedRow.rowAnimation = animation;
    return insertedRow;
}

@end

@interface MCSMTableViewDataSourceDeletedRow : MCSMTableViewDataSourceUpdatedRow

+ (instancetype)tableViewDataSourceDeletedRowWithRow:(MCSMTableViewDataSourceRow *)originalRow
                                           indexPath:(NSIndexPath *)indexPath
                                    withRowAnimation:(UITableViewRowAnimation)animation;

@end

@implementation MCSMTableViewDataSourceDeletedRow

+ (instancetype)tableViewDataSourceDeletedRowWithRow:(MCSMTableViewDataSourceRow *)originalRow
                                           indexPath:(NSIndexPath *)indexPath
                                    withRowAnimation:(UITableViewRowAnimation)animation{
    MCSMTableViewDataSourceDeletedRow *deletedRow = [[self alloc] init];
    deletedRow.originalRow = originalRow;
    deletedRow.indexPath = indexPath;
    deletedRow.rowAnimation = animation;
    return deletedRow;
}

@end


@interface MCSMTableViewDataSource ()

@property (nonatomic, strong, readwrite) UITableView *tableView;
@property (nonatomic, assign, getter = isUpdating, readwrite) BOOL updating;

@end

@implementation MCSMTableViewDataSource{
    NSMutableArray *_sections;
}

- (instancetype)init{
    
    if((self = [super init])){
    }
    
    return self;
}

- (instancetype)initWithTableView:(UITableView *)tableView{
    
    if((self = [self init])){
        self.tableView = tableView;
    }
    return self;
}

- (NSString *)description{
    return [NSString stringWithFormat:@"<%@: %p> numberOfSections:%lu",NSStringFromClass([self class]),self,(unsigned long)[self numberOfSections]];
}

#pragma mark -
#pragma mark Updates

- (void)beginUpdates{
    [CATransaction begin];
    
    [self.tableView beginUpdates];
    
    self.updating = YES;
}

- (void)commitUpdates{
    
    NSUInteger sectionIndex = 0;
    NSUInteger rowIndex = 0;
    
    NSMutableArray *sections = [NSMutableArray arrayWithArray:_sections];
    
    NSMutableArray *sectionsToEnumerate = nil;
    
    for(MCSMTableViewDataSourceSection *tableViewSection in sections){
        
        if([tableViewSection isKindOfClass:[MCSMTableViewDataSourceSection class]])
        {
            rowIndex = 0;
            NSMutableArray *rows = [NSMutableArray arrayWithArray:tableViewSection.rows];
            
            for(MCSMTableViewDataSourceUpdatedRow *row in tableViewSection.rows){
                
                if([row isKindOfClass:[MCSMTableViewDataSourceDeletedRow class]])
                {
                    [self.tableView deleteRowsAtIndexPaths:@[[row indexPath]]
                                          withRowAnimation:[row rowAnimation]];
                    
                    [rows removeObject:row];
                    
                }
                else if([row isKindOfClass:[MCSMTableViewDataSourceInsertedRow class]])
                {
                    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[rows indexOfObject:row] inSection:sectionIndex];
                    
                    [self.tableView insertRowsAtIndexPaths:@[indexPath]
                                          withRowAnimation:[row rowAnimation]];
                    
                    rows[[rows indexOfObject:row]] = [row originalRow];
                }
                
                
                rowIndex++;
            }
            
            tableViewSection.rows = rows;
        }
        
        sectionIndex++;
    }
    
    sectionIndex = 0;
    
    sectionsToEnumerate = [NSMutableArray arrayWithArray:sections];
    
    for(MCSMTableViewDataSourceSection *tableViewSection in sectionsToEnumerate){
        
        if([tableViewSection isKindOfClass:[MCSMTableViewDataSourceSection class]])
        {
            if(self.allowsEmptySections == NO)
            {
                NSUInteger numberOfDeletedRows = 0;
                
                for(NSObject *object in [tableViewSection rows]){
                    if([object isKindOfClass:[MCSMTableViewDataSourceDeletedRow class]])
                    {
                        numberOfDeletedRows++;
                    }
                }
                
                if([[tableViewSection rows] count] == 0 || (numberOfDeletedRows == [[tableViewSection rows] count]))
                {
                    sections[sectionIndex] = [MCSMTableViewDataSourceDeletedSection tableViewDataSourceDeletedSectionWithSection:sections[sectionIndex] index:sectionIndex withRowAnimation:UITableViewRowAnimationAutomatic];
                }
            }
            
        }
        
        sectionIndex++;
    }
    
    sectionsToEnumerate = [NSMutableArray arrayWithArray:sections];
    
    sectionIndex = 0;
    
    for(MCSMTableViewDataSourceUpdatedSection *tableViewSection in sectionsToEnumerate){
        
        if([tableViewSection isKindOfClass:[MCSMTableViewDataSourceDeletedSection class]])
        {
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex]
                          withRowAnimation:[tableViewSection rowAnimation]];
            [sections removeObject:tableViewSection];
            
        }
        else if([tableViewSection isKindOfClass:[MCSMTableViewDataSourceInsertedSection class]])
        {
            
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex]
                          withRowAnimation:[tableViewSection rowAnimation]];
            
            sections[[sections indexOfObject:tableViewSection]] = [tableViewSection originalSection];
        }
        
        sectionIndex++;
    }
    
    _sections = [[NSMutableArray alloc] initWithArray:sections];
}

- (void)endUpdatesWithCompletionHandler:(void (^)())completionHandler{
    
    [CATransaction setCompletionBlock: ^{
        
        if(completionHandler != NULL)
        {
            completionHandler();
        }
    }];
    
    [self commitUpdates];
    
    [self.tableView endUpdates];
    
    [CATransaction commit];
    self.updating = NO;
}

#pragma mark -
#pragma mark Sections

- (NSArray *)sections{
    return [NSArray arrayWithArray:_sections];
}

- (void)setSections:(NSArray *)sections{
    [self willChangeValueForKey:@"sections"];    
    _sections = [[NSMutableArray alloc] initWithArray:sections];
    [self didChangeValueForKey:@"sections"];
}

- (NSUInteger)numberOfSections{
    return [self.sections count];
}

- (MCSMTableViewDataSourceSection *)sectionAtIndex:(NSUInteger)index{
    return self.sections[index];
}

- (MCSMTableViewDataSourceSection *)sectionForRow:(MCSMTableViewDataSourceRow *)row{
    
    MCSMTableViewDataSourceSection *sectionForRow = nil;
    
    for(MCSMTableViewDataSourceSection *tableViewSection in self.sections){
        
        for (MCSMTableViewDataSourceRow *tableViewRow in tableViewSection.rows) {
            
            if([tableViewRow isEqual:row])
            {
                sectionForRow = tableViewSection;
                break;
            }
        }
    }
    
    return sectionForRow;
}

- (MCSMTableViewDataSourceSection *)sectionForObject:(id)object{
    
    MCSMTableViewDataSourceSection *sectionForRow = nil;

    MCSMTableViewDataSourceRow *row = [self rowForObject:object];
    
    if(row)
    {
        sectionForRow = [self sectionForRow:row];
    }
    
    return sectionForRow;
}

- (NSUInteger)indexForSection:(MCSMTableViewDataSourceSection *)section{
    
    __block NSUInteger index = NSNotFound;
    
    [self.sections enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        if([obj isEqual:section])
        {
            index = idx;
            *stop = YES;
        }
        else if([obj isKindOfClass:[MCSMTableViewDataSourceInsertedRow class]])
        {
            if([[obj object] isEqual:section])
            {
                index = idx;
                *stop = YES;
            }
        }
    }];
    
    return index;
}

#pragma mark -
#pragma mark Enumaration

- (void)enumerateSectionsUsingBlock:(void (^)(MCSMTableViewDataSourceSection *section, NSUInteger sectionIndex, BOOL *stop))block {
    [self.sections enumerateObjectsUsingBlock:^(id section, NSUInteger sectionIndex, BOOL *stop) {
        block(section,sectionIndex,stop);
    }];
}

#pragma mark -
#pragma mark Header/Footer Titles

- (NSString *)titleForHeaderInSectionAtIndex:(NSUInteger)index{
    MCSMTableViewDataSourceSection *section = [self sectionAtIndex:index];
    return section.headerTitle;
}

- (NSString *)titleForFooterInSectionAtIndex:(NSUInteger)index{
    MCSMTableViewDataSourceSection *section = [self sectionAtIndex:index];
    return section.footerTitle;
}

#pragma mark -
#pragma mark Insertion/Deletion/Reloading

- (void)insertSection:(MCSMTableViewDataSourceSection *)section atIndex:(NSUInteger)index withRowAnimation:(UITableViewRowAnimation)animation{
    MCSMTableViewDataSourceInsertedSection *insertSectionObject = [MCSMTableViewDataSourceInsertedSection tableViewDataSourceInsertedSectionWithSection:section index:index withRowAnimation:animation];
    [_sections insertObject:insertSectionObject atIndex:index];
}

- (void)insertSection:(MCSMTableViewDataSourceSection *)section beforeSection:(MCSMTableViewDataSourceSection *)beforeSection withRowAnimation:(UITableViewRowAnimation)animation{
    NSUInteger beforeSectionIndex = [self indexForSection:beforeSection];
    
    if(beforeSectionIndex != NSNotFound)
    {
        [self insertSection:section atIndex:beforeSectionIndex withRowAnimation:animation];
    }
}

- (void)insertSection:(MCSMTableViewDataSourceSection *)section afterSection:(MCSMTableViewDataSourceSection *)afterSection withRowAnimation:(UITableViewRowAnimation)animation{
    
    NSUInteger afterSectionIndex = [self indexForSection:afterSection];
    
    if(afterSectionIndex != NSNotFound)
    {
        [self insertSection:section atIndex:afterSectionIndex + 1 withRowAnimation:animation];
    }
}

- (void)deleteSection:(MCSMTableViewDataSourceSection *)section withRowAnimation:(UITableViewRowAnimation)animation{
    
    NSUInteger sectionIndex = [self indexForSection:section];
    
    if(sectionIndex != NSNotFound)
    {
        [self deleteSectionAtIndex:sectionIndex withRowAnimation:animation];
    }
}

- (void)deleteSectionAtIndex:(NSUInteger)index withRowAnimation:(UITableViewRowAnimation)animation{
    MCSMTableViewDataSourceSection *section = _sections[index];
    
    MCSMTableViewDataSourceDeletedSection *removeSectionObject = [MCSMTableViewDataSourceDeletedSection tableViewDataSourceDeletedSectionWithSection:section
                                                                                                                                               index:index
                                                                                                                                    withRowAnimation:animation];
    _sections[index] = removeSectionObject;
}

- (void)deleteSectionsAtIndexes:(NSIndexSet *)indexes withRowAnimation:(UITableViewRowAnimation)animation{
    
    [indexes enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
        [self deleteSectionAtIndex:idx withRowAnimation:animation];
    }];
}

#pragma mark -
#pragma mark Rows

- (NSUInteger)numberOfRowsInSectionAtIndex:(NSUInteger)index{
    return [[[self sectionAtIndex:index] rows] count];
}

- (id)rowAtIndexPath:(NSIndexPath *)indexPath{
    return [[self sectionAtIndex:indexPath.section] rows][indexPath.row];
}

- (id)objectAtIndexPath:(NSIndexPath *)indexPath{
    return [[[self sectionAtIndex:indexPath.section] rows][indexPath.row] object];
}


- (NSIndexPath *)indexPathForRow:(MCSMTableViewDataSourceRow *)object{
    
    NSIndexPath *indexPathForObject = nil;
    
    if(object)
    {
        NSUInteger section = 0;
        
        for(MCSMTableViewDataSourceSection *tableViewSection in self.sections){
            
            NSUInteger row = 0;
            
            for (id tableViewSectionObject in tableViewSection.rows) {
                
                if([tableViewSectionObject isEqual:object])
                {
                    indexPathForObject = [NSIndexPath indexPathForRow:row inSection:section];
                    break;
                }
                else if([tableViewSectionObject isKindOfClass:[MCSMTableViewDataSourceInsertedRow class]])
                {
                    if([[tableViewSectionObject originalRow] isEqual:object])
                    {
                        indexPathForObject = [NSIndexPath indexPathForRow:row inSection:section];
                        break;
                    }
                }
                row++;
            }
            section++;
        }
    }
    
    return indexPathForObject;
}

- (NSIndexPath *)indexPathForObject:(id)object{
    NSIndexPath *indexPathForObject = nil;
    
    if (object)
    {
        NSUInteger sectionIndex = 0;
        
        for(MCSMTableViewDataSourceSection *tableViewSection in self.sections){
            
            NSUInteger rowIndex = 0;
            
            for (MCSMTableViewDataSourceUpdatedRow *row in tableViewSection.rows) {
                
                if([[row object] isEqual:object])
                {
                    indexPathForObject = [NSIndexPath indexPathForRow:rowIndex inSection:sectionIndex];
                    break;
                }
                else if([row isKindOfClass:[MCSMTableViewDataSourceInsertedRow class]])
                {
                    if([[[row originalRow] object] isEqual:object])
                    {
                        indexPathForObject = [NSIndexPath indexPathForRow:rowIndex inSection:sectionIndex];
                        break;
                    }
                }
                rowIndex++;
            }
            sectionIndex++;
        }
    }
    
    return indexPathForObject;
}

- (MCSMTableViewDataSourceRow *)rowForObject:(id)object{
    
    MCSMTableViewDataSourceRow *rowForObject = nil;
    
    if (object)
    {
        for(MCSMTableViewDataSourceSection *tableViewSection in self.sections){
            
            for (MCSMTableViewDataSourceUpdatedRow *row in tableViewSection.rows) {
                
                if([[row object] isEqual:object])
                {
                    rowForObject = row;
                    break;
                }
                else if([row isKindOfClass:[MCSMTableViewDataSourceInsertedRow class]])
                {
                    if([[[row originalRow] object] isEqual:object])
                    {
                        rowForObject = [row originalRow];
                        break;
                    }
                }
            }
        }
        
    }
    
    return rowForObject;
}

#pragma mark -
#pragma mark Enumaration

- (void)enumerateRowsUsingBlock:(void (^)(MCSMTableViewDataSourceSection *section, MCSMTableViewDataSourceRow *row, NSIndexPath *indexPath, BOOL *stop))block{
    
    [self enumerateSectionsUsingBlock:^(MCSMTableViewDataSourceSection *section, NSUInteger sectionIndex, BOOL *stop) {
        
        [section.rows enumerateObjectsUsingBlock:^(id row, NSUInteger rowIndex, BOOL *stop) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:rowIndex inSection:sectionIndex];
            block(section,row,indexPath,stop);
        }];
        
    }];
}

#pragma mark -
#pragma mark Cell

- (UITableViewCell *)cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [[self rowAtIndexPath:indexPath] cell];
}

#pragma mark -
#pragma mark Cell Height

- (CGFloat)heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MCSMTableViewDataSourceRow *row = [self rowAtIndexPath:indexPath];
    
    if(row.height >= 0)
    {
        return row.height;
    }
    else if(self.tableView)
    {
        return self.tableView.rowHeight;
    }
    else
    {
        return -1;
    }
}

- (CGFloat)estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MCSMTableViewDataSourceRow *row = [self rowAtIndexPath:indexPath];
    
    if(row.height >= 0)
    {
        return row.estimatedHeight;
    }
    else if(self.tableView)
    {
        return self.tableView.estimatedRowHeight;
    }
    else
    {
        return -1;
    }
}

#pragma mark -
#pragma mark Selection

- (NSArray *)selectedRows{
    
    NSArray *selectedIndexPaths = [self.tableView indexPathsForSelectedRows];
    NSMutableArray *selectedRows = [NSMutableArray array];
    
    for(NSIndexPath *indexPath in selectedIndexPaths){
        [selectedRows addObject:[self rowAtIndexPath:indexPath]];
    }
    
    return selectedRows;
}

- (void)setSelectedRow:(NSArray *)selectedRows{
    [self selectRows:selectedRows byExtendingSelection:NO animated:YES];
}

- (NSArray *)selectedObjects{
    
    NSArray *selectedIndexPaths = [self.tableView indexPathsForSelectedRows];
    NSMutableArray *selectedObjects = [NSMutableArray array];
    
    for(NSIndexPath *indexPath in selectedIndexPaths){
        id object = [self objectAtIndexPath:indexPath];
        
        if(object)
        {
            [selectedObjects addObject:object];
        }
    }
    
    return selectedObjects;
}

- (void)setSelectedObjects:(NSArray *)selectedObjects{
    [self selectObjects:selectedObjects byExtendingSelection:NO animated:YES];
}

- (void)selectRow:(MCSMTableViewDataSourceRow *)selectedRow animated:(BOOL)animated scrollPosition:(UITableViewScrollPosition)scrollPosition{
    
    NSIndexPath *indexPath = [self indexPathForRow:selectedRow];
    
    if(indexPath)
    {
        [self.tableView selectRowAtIndexPath:indexPath animated:animated scrollPosition:scrollPosition];
    }
}

- (void)selectObject:(id)selectedObject animated:(BOOL)animated scrollPosition:(UITableViewScrollPosition)scrollPosition{
    
    NSIndexPath *indexPath = [self indexPathForObject:selectedObject];
    
    if(indexPath)
    {
        [self.tableView selectRowAtIndexPath:indexPath animated:animated scrollPosition:UITableViewScrollPositionNone];
    }
}

- (void)selectRows:(NSArray *)selectedRows byExtendingSelection:(BOOL)extendingSelection animated:(BOOL)animated{
    
    if(!extendingSelection)
    {
        [self deselectAllRowsAnimated:animated];
    }
    
    for(MCSMTableViewDataSourceRow *selectedRow in selectedRows){
        [self selectRow:selectedRow animated:animated scrollPosition:UITableViewScrollPositionNone];
    }
}

- (void)selectObjects:(NSArray *)selectedObjects byExtendingSelection:(BOOL)extendingSelection animated:(BOOL)animated{
    
    if(!extendingSelection)
    {
        [self deselectAllRowsAnimated:animated];
    }
    
    for(id selectedObject in selectedObjects){
        [self selectObject:selectedObject animated:animated scrollPosition:UITableViewScrollPositionNone];
    }
}

- (void)deselectRow:(MCSMTableViewDataSourceRow *)selectedRow animated:(BOOL)animated {
    
    NSIndexPath *indexPath = [self indexPathForRow:selectedRow];
    
    if(indexPath)
    {
        [self.tableView deselectRowAtIndexPath:indexPath animated:animated];
    }
}

- (void)deselectObject:(id)selectedObject animated:(BOOL)animated{
    
    NSIndexPath *indexPath = [self indexPathForObject:selectedObject];
    
    if(indexPath)
    {
        [self.tableView deselectRowAtIndexPath:indexPath animated:animated];
    }
}

- (void)deselectRows:(NSArray *)selectedRows animated:(BOOL)animated{
    
    for(MCSMTableViewDataSourceRow *selectedRow in selectedRows){
        [self deselectRow:selectedRow animated:animated];
    }
}

- (void)deselectObjects:(NSArray *)selectedObjects animated:(BOOL)animated{
    
    for(id selectedObject in selectedObjects){
        [self deselectObject:selectedObject animated:animated];
    }
}

- (void)deselectAllRowsAnimated:(BOOL)animated{
    for (NSInteger sectionIndex = 0; sectionIndex < self.numberOfSections; sectionIndex++) {
        for (NSInteger rowIndex = 0; rowIndex < [self numberOfRowsInSectionAtIndex:sectionIndex]; rowIndex++) {
            
            [self.tableView deselectRowAtIndexPath:[NSIndexPath indexPathForRow:rowIndex inSection:sectionIndex]
                                          animated:animated];
        }
    }
}

#pragma mark -
#pragma mark Insertion/Deletion/Reloading

- (void)insertRow:(MCSMTableViewDataSourceRow *)row atIndexPath:(NSIndexPath *)indexPath withRowAnimation:(UITableViewRowAnimation)animation{
    
    MCSMTableViewDataSourceSection *tableViewSection = [self sectionAtIndex:indexPath.section];
    NSMutableArray *rows = [NSMutableArray arrayWithArray:tableViewSection.rows];
    
    MCSMTableViewDataSourceInsertedRow *insertUpdateObject = [MCSMTableViewDataSourceInsertedRow tableViewDataSourceInsertedRowWithRow:row
                                                                                                                             indexPath:indexPath
                                                                                                                      withRowAnimation:animation];
    [rows insertObject:insertUpdateObject
               atIndex:indexPath.row];
    
    tableViewSection.rows = rows;
}

- (void)insertRow:(MCSMTableViewDataSourceRow *)row beforeRow:(MCSMTableViewDataSourceRow *)beforeRow withRowAnimation:(UITableViewRowAnimation)animation{
    NSIndexPath *indexPathForBeforeObject = [self indexPathForRow:beforeRow];
    
    if(indexPathForBeforeObject)
    {
        [self insertRow:row atIndexPath:indexPathForBeforeObject withRowAnimation:animation];
    }
}

- (void)insertRow:(MCSMTableViewDataSourceRow *)object afterRow:(MCSMTableViewDataSourceRow *)afterRow withRowAnimation:(UITableViewRowAnimation)animation{
    NSIndexPath *indexPathForAfterObject = [self indexPathForRow:afterRow];
    
    if(indexPathForAfterObject)
    {
        [self insertRow:object atIndexPath:[NSIndexPath indexPathForRow:indexPathForAfterObject.row + 1 inSection:indexPathForAfterObject.section] withRowAnimation:animation];
    }
}

- (void)insertObject:(id)object atIndexPath:(NSIndexPath *)indexPath withRowAnimation:(UITableViewRowAnimation)animation{
    MCSMTableViewDataSourceRow *row = [[MCSMTableViewDataSourceRow alloc] init];
    row.object = object;
    [self insertRow:row atIndexPath:indexPath withRowAnimation:animation];
}

- (void)insertObject:(id)object beforeObject:(id)beforeObject withRowAnimation:(UITableViewRowAnimation)animation{
    
    MCSMTableViewDataSourceRow *row = [[MCSMTableViewDataSourceRow alloc] init];
    row.object = object;
    
    MCSMTableViewDataSourceRow *beforeRow = [self rowForObject:beforeObject];
    
    [self insertRow:row beforeRow:beforeRow withRowAnimation:animation];
}

- (void)insertObject:(id)object afterObject:(id)afterObject withRowAnimation:(UITableViewRowAnimation)animation{
    
    MCSMTableViewDataSourceRow *row = [[MCSMTableViewDataSourceRow alloc] init];
    row.object = object;
    
    MCSMTableViewDataSourceRow *afterRow = [self rowForObject:afterObject];
    
    [self insertRow:row afterRow:afterRow withRowAnimation:animation];
}


- (void)deleteRow:(MCSMTableViewDataSourceRow *)row withRowAnimation:(UITableViewRowAnimation)animation{
    NSIndexPath *indexPath = [self indexPathForRow:row];
    
    if(indexPath)
    {
        [self deleteRowAtIndexPath:indexPath withRowAnimation:animation];
    }
}

- (void)deleteRowAtIndexPath:(NSIndexPath *)indexPath withRowAnimation:(UITableViewRowAnimation)animation{
    
    MCSMTableViewDataSourceSection *tableViewSection = [self sectionAtIndex:indexPath.section];
    NSMutableArray *rows = [NSMutableArray arrayWithArray:tableViewSection.rows];
    
    MCSMTableViewDataSourceDeletedRow *removeUpdateObject = [MCSMTableViewDataSourceDeletedRow tableViewDataSourceDeletedRowWithRow:rows[indexPath.row]
                                                                                                                          indexPath:indexPath
                                                                                                                   withRowAnimation:animation];
    rows[indexPath.row] = removeUpdateObject;
    
    tableViewSection.rows = rows;
}

- (void)deleteRowsAtIndexPaths:(NSArray *)indexPaths withRowAnimation:(UITableViewRowAnimation)animation{
    
    for(NSIndexPath *indexPath in indexPaths){
        [self deleteRowAtIndexPath:indexPath withRowAnimation:animation];
    }
}

- (void)deleteObject:(id)object withRowAnimation:(UITableViewRowAnimation)animation{
    MCSMTableViewDataSourceRow *row = [self rowForObject:object];
    [self deleteRow:row withRowAnimation:animation];
}

#pragma mark -
#pragma mark - UITableViewDelegate

#pragma mark - Highlight

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath{
    
    BOOL shouldHighlightRowAtIndexPath = YES;
    
    MCSMTableViewDataSourceRow *row = [self rowAtIndexPath:indexPath];
    
    if(row.didUnhighlightHandler)
    {
        shouldHighlightRowAtIndexPath = row.shouldHighlightHandler(row,indexPath);
    }
    
    return shouldHighlightRowAtIndexPath;
}

- (void)tableView:(UITableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MCSMTableViewDataSourceRow *row = [self rowAtIndexPath:indexPath];
    
    if(row.didUnhighlightHandler)
    {
        row.didHighlightHandler(row,indexPath);
    }
}

- (void)tableView:(UITableView *)tableView didUnhighlightRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MCSMTableViewDataSourceRow *row = [self rowAtIndexPath:indexPath];
    
    if(row.didUnhighlightHandler)
    {
        row.didUnhighlightHandler(row,indexPath);
    }
}

#pragma mark - Selection

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSIndexPath *proposedIndexPath = indexPath;
    
    MCSMTableViewDataSourceRow *row = [self rowAtIndexPath:indexPath];
    
    if(row.willSelectHandler)
    {
        proposedIndexPath = row.willSelectHandler(row,indexPath);
    }
    
    return proposedIndexPath;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSIndexPath *proposedIndexPath = indexPath;
    
    MCSMTableViewDataSourceRow *row = [self rowAtIndexPath:indexPath];
    
    if(row.willDeselectHandler)
    {
        proposedIndexPath = row.willDeselectHandler(row,indexPath);
    }
    
    return proposedIndexPath;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MCSMTableViewDataSourceRow *row = [self rowAtIndexPath:indexPath];
    
    if(row.didSelectHandler)
    {
        row.didSelectHandler(row,indexPath);
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    MCSMTableViewDataSourceRow *row = [self rowAtIndexPath:indexPath];
    
    if(row.didDeselectHandler)
    {
        row.didDeselectHandler(row,indexPath);
    }
}

#pragma mark -
#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [self numberOfSections];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self numberOfRowsInSectionAtIndex:section];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return [self titleForHeaderInSectionAtIndex:section];
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section{
    return [self titleForFooterInSectionAtIndex:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [self cellForRowAtIndexPath:indexPath];
}

@end
