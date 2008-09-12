#ifdef USE_INSTANCE_OSX

#include "hitimes.h"


#include <CoreServices/CoreServices.h>

VALUE hitimes_instant_nano_resolution( ) 
{
    return INT2FIX( 1 );
}

hitimes_instant_t hitimes_instant_get_value( )
{
    Nanoseconds  nano    = AbsoluteToNanoseconds( UpTime() );

    return *( hitimes_instant_t *)&nano;
}

#endif
