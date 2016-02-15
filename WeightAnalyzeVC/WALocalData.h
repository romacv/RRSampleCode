//
//  WALocalData.h
//  WeightAnalyze
//
//  Created by ROMAN RESENCHUK.
//

#import <Foundation/Foundation.h>
#import "UserData.h"
#import "Measures.h"
#import "CoreDataManager.h"

@interface WALocalData : NSObject

+ (UserData *)userData;
+ (void)save;
+ (void)addMeasureWeight:(NSNumber *)weight date:(NSDate *)date inHealth:(BOOL)inHealth;
+ (NSArray *)arrMeasures;
+ (void)deleteMeasure:(Measures *)measure;

+ (void)setIsFirstWizardSetupProfile:(BOOL)isFirstWizardSetupProfile;
+ (BOOL)isFirstWizardSetupProfile;

typedef NS_ENUM(NSUInteger, WAUnitSystem)
{
    WAUnitSystemMetric = 0,
    WAUnitSystemEnglish = 1
};

+ (WAUnitSystem)currentUnitSystem;
+ (NSString *)currentUnitSystemStringDistance;
+ (NSString *)currentUnitSystemStringWeight;

@end
