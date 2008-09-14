/**
 * Copyright (c) 2008 Jeremy Hinegardner
 * All rights reserved.  See LICENSE and/or COPYING for details.
 *
 * vim: shiftwidth=4 
 */ 

#ifndef __HITIMES_H__
#define __HITIMES_H__

#include <ruby.h>

extern VALUE eH_Error;     /* class  HiTimes::Error     */

#define NANOSECONDS_PER_SECOND  1e9

#ifdef USE_INSTANT_CLOCK_GETTIME
#    define HITIMES_U64INT unsigned long long int
#    define HITIMES_INSTANT_CONVERSION_FACTOR 1e9
#elif USE_INSTANT_OSX
#    define HITIMES_U64INT unsigned long long int
#    define HITIMES_INSTANT_CONVERSION_FACTOR 1e9
#elif USE_INSTANT_WINDOWS
#    include "hitimes_instant_windows.h"
#else
#    error "Unable to build hitimes, no Instance backend available"
#endif


/* an alias for a 64bit unsigned integer.  The various sytem dependenent
 * files must define hitimes_u64int_t 
 */
typedef HITIMES_U64INT hitimes_instant_t;

typedef struct hitimes_interval {
    hitimes_instant_t start_instant;
    hitimes_instant_t stop_instant;
    VALUE             duration;
} hitimes_interval_t;

/* all the backends must define this method */
hitimes_instant_t hitimes_get_current_instant( );
double hitimes_instant_conversion_factor( );
#endif
