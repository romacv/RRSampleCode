#import <CoreData/CoreData.h>

@interface NSManagedObjectContext (Helpers)

// Interface should be used by NSManagedObject+Helpers
- (NSArray *)fetchObjects:(NSString *)entityName withPredicate:(NSPredicate *)predicate;
- (void)deleteObjects:(NSString *)entityName withPredicate:(NSPredicate *)predicate;

@end
