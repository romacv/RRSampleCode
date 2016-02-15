#import "CDVC.h"
/**
 *  ViewController for Smart Socket Adapter
 */
@interface CDVCSmartSocketAdapter : CDVC

// Public properties

@end

#pragma mark - Protocol constants

/**
 *  Parameters
 */
#define DEVICE_OFF 0
#define DEVICE_ON 1

/**
 *  Programs
 */
typedef NS_ENUM(int, CDSmartSocketProgram){
    /**
     *  Switch off socket adapter
     */
    CDSmartSocketStopProgram = 4,
    /**
     *  Switch on socket adapter
     */
    CDSmartSocketRunProgram = 3
};

/**
 *  States
 */
typedef NS_ENUM(int, CDSmartSocketState)
{
    /**
     *  Socket adapter off state
     */
    CDSmartSocketStateOff = 0,
    /**
     *  Socket adapter on state
     */
    CDSmartSocketStateOn = 2,
    /**
     *  Socket adapter have error states
     */
    CDSmartSocketStateError = 255
};