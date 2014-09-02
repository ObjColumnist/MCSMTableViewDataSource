//
//  MCSMTableViewSection.m
//  MCSMUIKit
//
//  Created by Spencer MacDonald on 23/01/2012.
//  Copyright (c) 2012 Square Bracket Software. All rights reserved.
//

#import "MCSMTableViewDataSourceSection.h"
#import "MCSMTableViewDataSourceRow.h"

@implementation MCSMTableViewDataSourceSection

+ (instancetype)sectionWithRows:(NSArray *)rows{
    return [[MCSMTableViewDataSourceSection alloc] initWithRows:rows];
}

+ (instancetype)sectionWithObjects:(NSArray *)objects{
    return [[MCSMTableViewDataSourceSection alloc] initWithObjects:objects];
}

- (instancetype)init{
    
    if ((self = [super init])) {
    }
    return self;
}

- (instancetype)initWithRows:(NSArray *)rows{
    
    if ((self = [self init])) {
        self.rows = rows;
    }
    
    return self;
}

- (instancetype)initWithObjects:(NSArray *)objects{
    
    if ((self = [self init])) {
        self.rows = [MCSMTableViewDataSourceRow rowsWithObjects:objects];
    }
    
    return self;
}

- (instancetype)initWithHeaderTitle:(NSString *)headerTitle
                         indexTitle:(NSString *)indexTitle
                               rows:(NSArray *)rows{
    
    if ((self = [self init])) {
        self.headerTitle = headerTitle;
        self.indexTitle = indexTitle;
        self.rows = rows;
    }
    
    return self;
}

- (instancetype)initWithHeaderTitle:(NSString *)headerTitle
                         indexTitle:(NSString *)indexTitle
                            objects:(NSArray *)objects{
    
    if ((self = [self init])) {
        self.headerTitle = headerTitle;
        self.indexTitle = indexTitle;
        self.rows = [MCSMTableViewDataSourceRow rowsWithObjects:objects];
    }
    
    return self;
}

- (instancetype)initWithIdentifier:(NSString *)identifier
                       headerTitle:(NSString *)headerTitle
                       footerTitle:(NSString *)footerTitle
                        indexTitle:(NSString *)indexTitle
                              rows:(NSArray *)rows{
    
    if ((self = [self init])) {
        self.identifier = identifier;
        self.headerTitle = headerTitle;
        self.footerTitle = footerTitle;
        self.indexTitle = indexTitle;
        self.rows = rows;
    }
    
    return self;
}

- (instancetype)initWithIdentifier:(NSString *)identifier
                       headerTitle:(NSString *)headerTitle
                       footerTitle:(NSString *)footerTitle
                        indexTitle:(NSString *)indexTitle
                           objects:(NSArray *)objects{
    
    if ((self = [self init])) {
        self.identifier = identifier;
        self.headerTitle = headerTitle;
        self.footerTitle = footerTitle;
        self.indexTitle = indexTitle;
        self.rows = [MCSMTableViewDataSourceRow rowsWithObjects:objects];
    }
    
    return self;
}

- (NSUInteger)numberOfRows{
    return [self.rows count];
}

- (MCSMTableViewDataSourceRow *)rowAtIndex:(NSUInteger)index{
    return (self.rows)[index];
}

- (id)objectAtIndex:(NSUInteger)index{
    return [(self.rows)[index] object];
}

- (void)addRow:(MCSMTableViewDataSourceRow *)row{
    self.rows = [self.rows arrayByAddingObject:row];
}

- (void)addObject:(id)object{
    self.rows = [self.rows arrayByAddingObject:[MCSMTableViewDataSourceRow rowWithObject:object]];
}

- (void)addRows:(NSArray *)rows{
    self.rows = [self.rows arrayByAddingObjectsFromArray:rows];
}

- (void)addObjects:(NSArray *)objects{
    self.rows = [self.rows arrayByAddingObjectsFromArray:[MCSMTableViewDataSourceRow rowsWithObjects:objects]];
}

- (void)removeRow:(MCSMTableViewDataSourceRow *)row{
    
    NSUInteger indexOfRow = [self indexOfRow:row];
    
    if(indexOfRow != NSNotFound)
    {
        NSMutableArray *rows = [NSMutableArray arrayWithArray:self.rows];
        [rows removeObjectAtIndex:indexOfRow];
        
        self.rows = [NSArray arrayWithArray:rows];
    }
}

- (void)removeObject:(id)object{
    
    NSUInteger indexOfRow = [self indexOfObject:object];
    
    if(indexOfRow != NSNotFound)
    {
        NSMutableArray *rows = [NSMutableArray arrayWithArray:self.rows];
        [rows removeObjectAtIndex:indexOfRow];
        
        self.rows = [NSArray arrayWithArray:rows];
    }
}

- (void)removeRows:(NSArray *)rows{
    
    for(MCSMTableViewDataSourceRow *row in rows){
        [self removeRow:row];
    }
}

- (void)removeObjects:(NSArray *)objects{
    
    for(id object in objects){
        [self removeRow:object];
    }
}

- (NSUInteger)indexOfRow:(MCSMTableViewDataSourceRow *)row{
    
    NSUInteger index = NSNotFound;
    NSUInteger currentIndex = 0;
    for(MCSMTableViewDataSourceRow *tableViewRow in self.rows){
        
        if([tableViewRow isEqual:row])
        {
            index = currentIndex;
            break;
        }
        
        currentIndex++;
    }
    
    return index;
}

- (NSUInteger)indexOfObject:(id)object{
    
    NSUInteger index = NSNotFound;
    NSUInteger currentIndex = 0;
    for(MCSMTableViewDataSourceRow *tableViewRow in self.rows){
        
        if([tableViewRow.object isEqual:object])
        {
            index = currentIndex;
            break;
        }
        
        currentIndex++;
    }
    
    return index;
}

- (BOOL)containsRow:(MCSMTableViewDataSourceRow *)row{
    return ([self indexOfRow:row] != NSNotFound);
}

- (BOOL)containsObject:(id)object{
    return ([self indexOfObject:object] != NSNotFound);
}

- (BOOL)containsRows:(NSArray *)rows{
    
    BOOL containsRows = ([rows count] > 0);
    
    for(MCSMTableViewDataSourceRow *row in rows){
        
        if(![self containsRow:row])
        {
            containsRows = NO;
            break;
        }
    }
    
    return containsRows;
}

- (BOOL)containsObjects:(NSArray *)objects{
    
    BOOL containsObjects = ([objects count] > 0);
    
    for(id object in objects){
        
        if(![self containsObject:object])
        {
            containsObjects = NO;
            break;
        }
    }
    
    return containsObjects;
}

- (void)enumerateRowsUsingBlock:(void (^)(MCSMTableViewDataSourceRow *row, NSUInteger rowIndex, BOOL *stop))block{
    
    [self.rows enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        block(obj,idx,stop);
    }];
}

- (NSString *)description{
    return [NSString stringWithFormat:@"<%@ :%p> - %lu Rows",[self class],self,(unsigned long)[self numberOfRows]];
}

- (NSUInteger)hash{
    
    if(self.identifier)
    {
        return [self.identifier hash];
    }
    else
    {
        return [self.rows hash];
    }
}

- (BOOL)isEqual:(id)object{
    
    BOOL isEqual = NO;
    
    if([object isKindOfClass:[MCSMTableViewDataSourceSection class]])
    {
        MCSMTableViewDataSourceSection *section = (MCSMTableViewDataSourceSection *)object;
        
        if([self.identifier isEqualToString:section.identifier])
        {
            isEqual = YES;
        }
    }
    
    return isEqual;
}

@end
