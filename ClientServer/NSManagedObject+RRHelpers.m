#import "NSManagedObject+RRHelpers.h"
#import "NSManagedObjectContext+RRHelpers.h"
#import "RRCoreData.h"



@implementation NSManagedObject (RRHelpers)

+ (instancetype)insertObject {
    return [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass(self) inManagedObjectContext:[RRCoreData db].managedObjectContext];
}

+ (instancetype)findObject:(NSPredicate *)predicate {
    NSFetchRequest *fr = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass(self)];
    fr.predicate = predicate;
    fr.fetchLimit = 1;
    return [[RRCoreData db].managedObjectContext executeFetchRequest:fr error:nil].firstObject;
}

+ (instancetype)findObjectOrCreate:(NSPredicate *)predicate {
    NSManagedObject *mo = [self findObject:predicate];
    return mo ? mo : [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass(self) inManagedObjectContext:[RRCoreData db].managedObjectContext];
}

+ (NSArray *)fetchWithPredicate:(NSPredicate *)predicate {
    return [[RRCoreData db].managedObjectContext fetchObjects:NSStringFromClass(self) withPredicate:predicate];
}

+ (void)deleteWithPredicate:(NSPredicate *)predicate {
    [[RRCoreData db].managedObjectContext deleteObjects:NSStringFromClass(self) withPredicate:predicate];
}

@end
