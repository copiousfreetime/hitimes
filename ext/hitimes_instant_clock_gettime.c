#ifdef USE_INSTANT_CLOCK_GETTIME

#include "hitimes.h"

#include <sys/time.h>

/*
 * conversion factors is number of nanoseconds in a second
 */
double hitimes_instant_conversion_factor( )
{
  return 1e9;
}

hitimes_instant_t hitimes_get_current_instant( )
{
    struct timespec time;
    int rc;

    rc = clock_gettime( CLOCK_MONOTONIC, &time);
    if ( 0 != rc )  {
        char* e = strerror( rc );
        rb_raise(eH_Error, "Unable to retrieve time for CLOCK_MONOTONIC :  %s", e );
    }

    return ( ( NANOSECONDS_PER_SECOND * (long)time.tv_sec ) + time.tv_nsec );
}
#endif
