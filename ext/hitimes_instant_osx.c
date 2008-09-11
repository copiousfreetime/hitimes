#include "hitimes.h"

#include <CoreServices/CoreServices.h>

hitimes_instant_t hitimes_instant_get_value( )
{
    AbsoluteTime now_raw = UpTime();
    Nanoseconds  nano;  

    nano = AbsoluteToNanoseconds( now_raw );

    return *( hitimes_instant_t *)&nano;
}

