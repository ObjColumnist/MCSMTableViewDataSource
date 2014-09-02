//
//  MCSMTableViewDataSourceRow.m
//  MCSMUIKit 
//
//  Created by Spencer MacDonald on 17/11/2012.
//  Copyright (c) 2012 Square Bracket Software. All rights reserved.
//

#import "MCSMTableViewDataSourceRow.h"

@implementation MCSMTableViewDataSourceRow

+ (NSArray *)rowsWithObjects:(NSArray *)objects{
    NSMutableArray *rowObjects = [NSMutableArray array];
    
    for(id object in objects){
        [rowObjects addObject:[self rowWithObject:object]];
    }
    
    return rowObjects;
}

+ (NSArray *)rowsWithRowsOrObjects:(NSArray *)objects{
    
    NSMutableArray *rowObjects = [NSMutableArray array];
    
    for(id object in objects){
        
        if([object isKindOfClass:[self class]])
        {
            [rowObjects addObject:object];
        }
        else
        {
            [rowObjects addObject:[self rowWithObject:object]];
        }
    }
    
    return rowObjects;
}

+ (instancetype)rowWithObject:(id)object{
    return [[[self class] alloc] initWithObject:object];
}

+ (instancetype)rowWithObject:(id)object
             didSelectHandler:(void (^)(MCSMTableViewDataSourceRow *row, NSIndexPath *indexPath))didSelectHandler{
    return [[[self class] alloc] initWithObject:object didSelectHandler:didSelectHandler];
}

- (instancetype)initWithObject:(id)object{
    
    if(self = [self init]){
        self.object = object;
    }
    
    return self;
}

- (instancetype)initWithObject:(id)object
              didSelectHandler:(void (^)(MCSMTableViewDataSourceRow *row, NSIndexPath *indexPath))didSelectHandler{
    
    if(self = [self init]){
        self.object = object;
        self.didSelectHandler = didSelectHandler;
    }
    
    return self;
}

- (instancetype)init{
    
    if ((self = [super init])) {
        self.height = -1;
        self.estimatedHeight = -1;
    }
    
    return self;
}

- (NSString *)description{
    return [NSString stringWithFormat:@"<%@: %p> - object: %@",[self class],self,self.object];
}

- (BOOL)isEqual:(id)object{
    
    BOOL isEqual = NO;
    
    if([object isKindOfClass:[MCSMTableViewDataSourceRow class]])
    {
        MCSMTableViewDataSourceRow *row = object;

        if([self.identifier isEqualToString:row.identifier])
        {
            isEqual = YES;
        }
        else if([self.object isEqual:row.object])
        {
            isEqual = YES;
        }
        
    }
    
    return isEqual;
}

- (NSUInteger)hash{
    return [self.identifier hash] + [self.object hash];
}

@end
