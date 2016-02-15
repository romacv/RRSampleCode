#import "CDVCSmartSocketAdapter.h"
#import "UserDevice.h"
#import "CDComSSAdapterSetState.h"

@interface CDVCSmartSocketAdapter ()
{
    // System
    UserDevice *_device;
    
    // UI
    // Enough IBOutlets
    //
    
    // KVO
    NSArray *_kvoKeyPaths;
}

@property (weak, nonatomic) IBOutlet UIImageView *bgImgView;
@property (weak, nonatomic) IBOutlet UIButton *buttonOffOn;
@property CDSmartSocketState state;
@property CDSmartSocketProgram program;

@end

@implementation CDVCSmartSocketAdapter

#pragma mark - Actions

- (void)clickNavLeftButton
{
    // Dismiss after presentation viewcontroller
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)tapOnOff:(UIButton *)sender
{
    // Select - Deselect switcher on/off
    sender.selected = !sender.selected;
}

#pragma mark - Protocols delegates

- (void)reloadState
{
    // Delegate implementation on CDComFullProgramm
    self.program = [_device.history.mode.programm.programmId intValue];
    self.state = _device.state;
    NSLog(@"smart socket adapter program ----- %i", self.program);
    NSLog(@"smart socket adapter state ----- %i", self.state);
}


- (void)command:(CDCommand *)command finishedWithAnswer:(id)answer
{
    NSLog(@"smart socket %@ answer ----- %@", command, answer);
}


#pragma mark - View controller

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self kvoInit];
    [self ivarInit];
    [self cmdInit];
    [self uiInit];
}

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationItem.title = _device.name;
    [super viewWillAppear:animated];
}

- (void)dealloc
{
    [self kvoDeinit];
}

#pragma mark - UI

- (void)uiInit
{
    // Left navigation bar item
    [self setLeftButton:[CDButtonLeftMenu buttonWithTarget:self selector:@selector(clickNavLeftButton)]];
}

#pragma mark - Ivars

- (void)ivarInit
{
    _device = [CDSender sender].currentDevice;
}

#pragma mark - KVO

- (void)kvoInit
{
    _kvoKeyPaths = @[// Device
                     @"state", @"program",
                     // UI outlets
                     @"buttonOffOn.selected"];
    
    for (NSString *keyPath in _kvoKeyPaths)
    {
        [self addObserver:self forKeyPath:keyPath options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:NULL];
    }
}

- (void)kvoDeinit
{
    for (NSString *keyPath in _kvoKeyPaths)
    {
        [self removeObserver:self forKeyPath:keyPath];
    }
}

// Observe keypaths
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([@"buttonOffOn.selected" isEqualToString:keyPath])
    {
        // Check is changed new value is not equal old value
        if (change[NSKeyValueChangeNewKey] != change[NSKeyValueChangeOldKey])
        {
            /**
             *  Choose, which programm need to set
             */
            CDSmartSocketProgram prog = _buttonOffOn.isSelected ? CDSmartSocketRunProgram : CDSmartSocketStopProgram;
            [self cmdSetProgram:prog];
        }
    }
}

// Observe keys
- (void)didChangeValueForKey:(NSString *)key
{
    if ([@"state" isEqualToString:key])
    {
        // Change Background image depending on the state
        _bgImgView.image = (self.state == CDSmartSocketStateOn) ? [UIImage imageNamed:@"power_outlet_on"] : [UIImage imageNamed:@"power_outlet_off"];
        
        // Change selection state depending on the state
        _buttonOffOn.selected = (self.state == CDSmartSocketStateOn);
    }
}

#pragma mark - Commands

// Prepare to sending commands
- (void)cmdInit
{
    [CDSender sender].stateDelegate = self;
}

// Methods to send required commands
- (void)cmdSetProgram:(CDSmartSocketProgram)program
{
    CDComSSAdapterSetState *comm = [CDComSSAdapterSetState new];
    comm.parent = self;
    comm.comm = program;
    [comm start];
}

#pragma mark - Other

@end