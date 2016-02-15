//
//  WANeckVC.m
//  WeightAnalyze
//
//  Created by ROMAN RESENCHUK.
//

#import "WANeckVC.h"
#import "WALocalData.h"

@interface WANeckVC () {}
- (IBAction)tapNeck:(id)sender;
- (IBAction)tapUnits:(id)sender;
@property (weak, nonatomic) UIButton *nextBtn;
@property (weak, nonatomic) UITextField *tfNeck;
@property (weak, nonatomic) UILabel *labelNeck;

@end

@implementation WANeckVC

#pragma mark - lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initUI];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self loadValues];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"pushNextNeckSeg"])
    {
        UserData *ud = [WALocalData userData];
        ud.neck = @([_tfNeck.text intValue]);
        [WALocalData save];
    }
}

#pragma mark - tf delegates
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    //limit the size of text
    int limit = 5;
    return !([textField.text length] >= limit && [string length] > range.length);
}

#pragma mark - actions
- (void)initUI
{
    self.title = [NSLocalizedString(@"yourneck", nil) uppercaseString];
    [nextBtn setTitle:[NSLocalizedString(@"nexttext", nil) uppercaseString] forState:UIControlStateNormal];
}

- (void)loadValues
{
    UserData *ud = [WALocalData userData];
    _tfNeck.text = [ud.neck floatValue] > 0 ? [NSString stringWithFormat:@"%@", ud.neck] : nil;
}

- (IBAction)tapNeck:(id)sender
{
    if ([WALocalData isFirstWizardSetupProfile])
    {
        [self performSegueWithIdentifier:@"pushNextNeckSeg" sender:nil];
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (IBAction)tapUnits:(id)sender
{
    [WALocalData setCurrentUnitSystem:![WALocalData currentUnitSystem]];
    // localised text
    _labelNeck.text = [WALocalData currentUnitSystemStringDistance];
    [self loadValues];
}
@end
