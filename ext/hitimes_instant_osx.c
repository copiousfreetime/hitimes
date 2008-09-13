#ifdef USE_INSTANT_OSX

#include "hitimes_interval.h"
#include <CoreServices/CoreServices.h>

/* 
 * returns the number of nanoseconds since the machine was booted
 */
hitimes_instant_t hitimes_get_current_instant( )
{
    Nanoseconds  nano    = AbsoluteToNanoseconds( UpTime() );

    return *( hitimes_instant_t *)&nano;
}

#endif
