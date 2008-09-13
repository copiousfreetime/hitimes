#ifdef USE_INSTANT_OSX

#include "hitimes.h"
#include <CoreServices/CoreServices.h>

/*
 * 64bit int type 
 */
typedef unsigned long long int hitimes_u64int_t;

/*
 * conversion factors is number of nanoseconds in a second
 */
double hitimes_instant_conversion_factor( )
{
  return 1e9;
}

/* 
 * returns the number of nanoseconds since the machine was booted
 */
hitimes_instant_t hitimes_get_current_instant( )
{
    Nanoseconds  nano    = AbsoluteToNanoseconds( UpTime() );

    return *( hitimes_instant_t *)&nano;
}

#endif
