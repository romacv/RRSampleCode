#import "RRCoreData.h"

@interface RRCoreData ()

@property (nonatomic) NSManagedObjectModel *managedObjectModel;
@property (nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property NSManagedObjectContext *mainMOC;
@property NSManagedObjectContext *privateMOC;

@end

@implementation RRCoreData

#pragma mark - initializer
+ (instancetype)db {
    static RRCoreData *instance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        if (instance == nil){
            instance = [RRCoreData new];
        }
    });
    
    return instance;
}

#pragma mark - Core data Stack
- (NSManagedObjectModel *)managedObjectModel {
	if (_managedObjectModel) { return _managedObjectModel; }
    
    NSURL *momFile = [[NSBundle mainBundle] URLForResource:self.name withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:momFile];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    if (_persistentStoreCoordinator) return _persistentStoreCoordinator;
    
    NSURL *docDir = [[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask].firstObject;
    NSURL *dbFile = [docDir URLByAppendingPathComponent:[NSString stringWithFormat:@"%@.sqlite", self.name]];
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.managedObjectModel];
    [_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:dbFile options:nil error:nil];
    return _persistentStoreCoordinator;
}

- (NSManagedObjectContext *)managedObjectContext {
    if ([[NSThread currentThread] isMainThread]) {
        if (_mainMOC) return _mainMOC;
        
        _mainMOC = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        _mainMOC.persistentStoreCoordinator = self.persistentStoreCoordinator;
        return _mainMOC;
    }
    else {
        if (_privateMOC) return _privateMOC;
        
        _privateMOC = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
        _privateMOC.persistentStoreCoordinator = self.persistentStoreCoordinator;
        _privateMOC.mergePolicy = NSOverwriteMergePolicy;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(mocDidSave:) name:NSManagedObjectContextDidSaveNotification object:_privateMOC];
        return _privateMOC;
    }
}

- (void)mocDidSave:(NSNotification *)note {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.managedObjectContext mergeChangesFromContextDidSaveNotification:note];
    });
}

@end
