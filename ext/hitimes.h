/**
 * Copyright (c) 2008 Jeremy Hinegardner
 * All rights reserved.  See LICENSE and/or COPYING for details.
 *
 * vim: shiftwidth=4 
 */ 

#ifndef __HITIMES_H_
#define __HITIMES_H_

#ifdef USE_INSTANCE_CLOCK_GETTIME
  #include "hitimes_instant_clock_gettime.h"
#elif USE_INSTANCE_OSX 
  #include "hitimes_instant_osx.h"
#elif USE_INSTANCE_WINDOWS
  #include "hitimes_instant_windows.h"
#else
  #error "Unable to build hitimes, no Instance backend available"
#endif

/* an alias for a 64bit unsigned integer.  The various sytem dependenent
 * files must define hitimes_u64int_t 
 */
typedef hitimes_u64int_t hitimes_instant_t;

/* all the backends must define this method */
hitimes_instant_t hitimes_instant_get_value( );

#define HITIMES_INSTANT_2NUM( x )     ( LL2NUM( x ) )

#endif
