#include "hitimes.h"

#include <CoreServices/CoreServices.h>

hitimes_instant_t hitimes_instant_get_value( )
{
    Nanoseconds  nano    = AbsoluteToNanoseconds( UpTime() );

    return *( hitimes_instant_t *)&nano;
}

