#import <Foundation/Foundation.h>
@import CoreData;

@interface RRCoreData : NSObject

// Initialize database model name in AppDelegate
// For example: [[RRCoreData db] setName:@"DBModel"];

+ (instancetype)db;
@property (nonatomic) NSString *name;

- (NSManagedObjectModel *)managedObjectModel;
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator;
- (NSManagedObjectContext *)managedObjectContext;

@end
