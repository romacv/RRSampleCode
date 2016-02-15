//
//  WALocalData.m
//  WeightAnalyze
//
//  Created by ROMAN RESENCHUK.
//

#import "WALocalData.h"
#import "WAFormulas.h"
#import "WAHealth.h"

@implementation WALocalData

+ (void)save
{
    [[CoreDataManager manager] saveContext];
}
+ (UserData *)userData
{
    NSArray *arrUData = [[CoreDataManager manager] objectsForEntity:@"UserData" withPredicate:nil sortDescrKey:nil];
    if (arrUData.count == 0)
    {
        [self createUserData];
    }
    return [[[CoreDataManager manager] objectsForEntity:@"UserData" withPredicate:nil sortDescrKey:nil] objectAtIndex:0];
}

+ (void)createUserData
{
    [NSEntityDescription insertNewObjectForEntityForName:@"UserData" inManagedObjectContext:[[CoreDataManager manager] managedObjectContext]];
    [[CoreDataManager manager] saveContext];
}

+ (void)addMeasureWeight:(NSNumber *)weight date:(NSDate *)date inHealth:(BOOL)inHealth
{
    UserData *userDataOne = [WALocalData userData];
    
    Measures *measure = [NSEntityDescription insertNewObjectForEntityForName:@"Measures" inManagedObjectContext:[[CoreDataManager manager] managedObjectContext]];
    measure.weight = weight;
    measure.timeStamp = date;
    measure.fat = [WAFormulas fatMassFromWeight:weight];
    measure.bmi = [WAFormulas bmiFromWeight:weight];
    measure.water = [WAFormulas waterFromWeight:weight];
    // database model version 2
    measure.user_birthdate = userDataOne.birthdate;
    measure.user_height = userDataOne.height;
    measure.user_hips = userDataOne.hips;
    measure.user_neck = userDataOne.neck;
    measure.user_sex = userDataOne.sex;
    measure.user_waist = userDataOne.waist;
    //
    NSLog(@"%@", measure.fat);
    [[CoreDataManager manager] saveContext];
    
    // Syncronize new value to HealthKit if enabled
    if (inHealth)
    {
        [[WAHealth sharedHealth] addWeight:measure.weight];
    }
}

+ (NSArray *)arrMeasures
{
    return [[CoreDataManager manager] objectsForEntity:@"Measures" withPredicate:nil sortDescrKey:@"timeStamp"];
}

+ (void)deleteMeasure:(Measures *)measure
{
    [[[CoreDataManager manager] managedObjectContext] deleteObject:measure];
    [[CoreDataManager manager] saveContext];
}

+ (void)setIsFirstWizardSetupProfile:(BOOL)isFirstWizardSetupProfile
{
    [[NSUserDefaults standardUserDefaults] setObject:@(isFirstWizardSetupProfile) forKey:@"isFirstWizardSetupProfile"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+ (BOOL)isFirstWizardSetupProfile
{
    return  [[[NSUserDefaults standardUserDefaults] objectForKey:@"isFirstWizardSetupProfile"] boolValue];
}

+ (WAUnitSystem)currentUnitSystem
{
    return [[[NSUserDefaults standardUserDefaults] objectForKey:@"unitSystem"] integerValue] == 1 ? WAUnitSystemEnglish : WAUnitSystemMetric;
}

+ (NSString *)currentUnitSystemStringDistance
{
    return [self currentUnitSystem] == WAUnitSystemEnglish ? NSLocalizedString(@"inch",) : NSLocalizedString(@"cm",);
}

+ (NSString *)currentUnitSystemStringWeight
{
    return [self currentUnitSystem] == WAUnitSystemEnglish ? NSLocalizedString(@"lbs",) : NSLocalizedString(@"kg",);
}
@end
