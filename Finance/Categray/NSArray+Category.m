//
//  NSMutableArray+Category.m
//  Finance
//
//  Created by changxicao on 16/1/13.
//  Copyright © 2016年 HuMin. All rights reserved.
//

#import "NSArray+Category.h"

@implementation NSArray (Category)


- (NSArray *)arrayWithObjectsPassingTest:(BOOL (^)(id obj, NSUInteger idx, BOOL *stop))predicate
{
    NSIndexSet *indexes = [self indexesOfObjectsPassingTest:predicate];
    return [self objectsAtIndexes:indexes];
}


- (NSArray *)arrayByRemovingObjectsOfClass:(Class)aClass
{
    NSMutableArray *array = [NSMutableArray arrayWithArray:self];
    [array removeObjectsPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass:aClass]) {
            return YES;
        }
        else return NO;
    }];
    return [[NSArray alloc] initWithArray:array];
}


- (NSArray *)arrayByKeepingObjectsOfClass:(Class)aClass
{
    NSMutableArray *array = [NSMutableArray arrayWithArray:self];
    [array removeObjectsPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass:aClass]) {
            return NO;
        }
        else return YES;
    }];
    return [[NSArray alloc] initWithArray:array];
}


- (NSArray *)arrayByRemovingObjectsFromArray:(NSArray *)otherArray
{
    NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        return ![otherArray containsObject:evaluatedObject];
    }];
    return [self filteredArrayUsingPredicate:predicate];
}


- (NSArray *)transformedArrayUsingHandler:(id (^)(id originalObject, NSUInteger index))handler
{
    NSMutableArray *tempArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSInteger i = 0; i < [self count]; i++) {
        id resultObject = handler(self[i], i);
        [tempArray addObject:resultObject];
    }
    return [NSArray arrayWithArray:tempArray];
}

- (NSArray *)reverseArray
{
    if ([self count] < 2) {
        return self;
    }

    NSMutableArray *mutableArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSInteger i = [self count] - 1; i >= 0; i--) {
        [mutableArray addObject:[self objectAtIndex:i]];
    }

    return [NSArray arrayWithArray:mutableArray];
}
@end


@implementation NSMutableArray (Category)

+ (NSMutableArray *)nullArrayWithCapacity:(NSUInteger)capacity
{
    NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:capacity];
    for (NSInteger i = 0; i < capacity; i++) {
        [array addObject:[NSNull null]];
    }
    return array;
}


- (void)removeObjectsPassingTest:(BOOL (^)(id obj, NSUInteger idx, BOOL *stop))predicate
{
    NSIndexSet *indexes = [self indexesOfObjectsPassingTest:predicate];
    [self removeObjectsAtIndexes:indexes];
}


- (void)removeLatterObjectsToKeepObjectsNoMoreThan:(NSInteger)maxCount
{
    if ([self count] > maxCount) {
        [self removeObjectsInRange:NSMakeRange(maxCount, [self count] - maxCount)];
    }
}


- (void)replaceObject:(id)anObject withObject:(id)anotherObject
{
    NSInteger index = [self indexOfObject:anObject];
    if (index != NSNotFound) {
        [self replaceObjectAtIndex:index withObject:anotherObject];
    }
}


- (void)insertUniqueObject:(id)anObject
{
    [self insertUniqueObject:anObject atIndex:[self count]];
}


- (void)insertUniqueObject:(id)anObject atIndex:(NSInteger)index
{
    for (id object in self) {
        if ([object isEqual:anObject]) {
            return;
        }
    }
    if (index < 0 || index > [self count]) {
        return;
    }
    [self insertObject:anObject atIndex:index];
}


- (void)insertUniqueObjectsFromArray:(NSArray *)otherArray
{
    NSArray *objectsToInsert = [otherArray arrayByRemovingObjectsFromArray:self];
    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, [objectsToInsert count])];
    [self insertObjects:objectsToInsert atIndexes:indexSet];
}


- (void)appendUniqueObjectsFromArray:(NSArray *)otherArray
{
    NSArray *objectsToAppend = [otherArray arrayByRemovingObjectsFromArray:self];
    [self addObjectsFromArray:objectsToAppend];
}
@end
