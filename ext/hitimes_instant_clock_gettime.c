#include "hitimes.h"

#include <sys/time.h>

VALUE hitimes_instant_nano_resolution( ) 
{
    struct timespec resolution;
    int rc ;

    rc = clock_getres( CLOCK_MONOTONIC, &resolution );
    if ( 0 != rc ) {
        char* e = strerror( rc );
        rb_raise(eH_Error, "Unable to retrieve resolution for CLOCK_MONOTONIC :  %s", e );
    }
    return LONG2FIX( resolution.tv_nsec );
}

hitimes_instant_t hitimes_instant_get_value( )
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

