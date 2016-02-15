#import <CoreData/CoreData.h>

@interface NSManagedObject (RRHelpers)

// Create new
+ (instancetype)insertObject;

// Find existing
+ (instancetype)findObject:(NSPredicate *)predicate;
+ (instancetype)findObjectOrCreate:(NSPredicate *)predicate;

// Fetch array
+ (NSArray *)fetchWithPredicate:(NSPredicate *)predicate;

// Delete
+ (void)deleteWithPredicate:(NSPredicate *)predicate;

@end
