/**
 * Copyright (c) 2008 Jeremy Hinegardner
 * All rights reserved.  See LICENSE and/or COPYING for details.
 *
 * vim: shiftwidth=4 
 */ 

#include "hitimes.h"

/* Module and Classes */
VALUE mH;           /* module HiTimes            */
VALUE cH_Stopwatch; /* class  HiTimes::Stopwatch */
VALUE cH_Instant;   /* class  HiTimes::Instant   */
VALUE cH_Interval;  /* class  HiTimes::Interval  */
VALUE eH_Error;     /* class  HiTimes::Error     */

/**
 * Allocator and Deallocator for Instant classes
 */

VALUE hitimes_instant_free(hitimes_instant_t* now) 
{
    xfree( now );
}

VALUE hitimes_instant_alloc(VALUE klass)
{
    VALUE obj;
    hitimes_instant_t* now = xmalloc( sizeof( hitimes_instant_t ) );

    *now = hitimes_instant_get_value( );

    obj = Data_Wrap_Struct(klass, NULL, hitimes_instant_free, now);
    return obj;
}


/**
 * call-seq:
 *    instant.to_i -> Integer
 *
 * Returns an Integer value of the instant, which is just a point in time.
 */
VALUE hitimes_instant_to_i( VALUE self )
{
    hitimes_instant_t *now;

    Data_Get_Struct( self, hitimes_instant_t, now );

    return HITIMES_INSTANT_2NUM( *now );
}

/**
 * call-seq:
 *    instant.to_seconds -> Float
 *
 * Returns the Float value of the instant, the value is in seconds
 */
VALUE hitimes_instant_to_seconds( VALUE self )
{
    hitimes_instant_t *now;
    double             d;
    VALUE              f;

    Data_Get_Struct( self, hitimes_instant_t, now );

    /* convert now value to seconds */
    d = ( (double)(*now) ) / NANOSECOND_PER_SECOND;

    return rb_float_new( d );
}


/**
 * The HiTimes Ruby Extension
 */
void Init_libhitimes()
{
    /*
     * Top level module encapsulating the entire HiTimes library
     */
    mH = rb_define_module("HiTimes");
   
    /* Error class */
    eH_Error = rb_define_class_under(mH, "Error", rb_eStandardError);

    /* Instant class */
    cH_Instant = rb_define_class_under( mH, "Instant", rb_cObject );
    rb_define_const( cH_Instant, "NANO_RESOLUTION", hitimes_instant_nano_resolution( ) );
    rb_define_alloc_func( cH_Instant, hitimes_instant_alloc );
    rb_define_method( cH_Instant, "to_i", hitimes_instant_to_i, 0 );
    rb_define_method( cH_Instant, "to_f", hitimes_instant_to_seconds, 0 );
    rb_define_method( cH_Instant, "to_seconds", hitimes_instant_to_seconds, 0 );
 
    /* Stopwatch Class */
    cH_Stopwatch = rb_define_class_under( mH, "Stopwatch", rb_cObject );
    /*rb_define_alloc_func( cH_Stopwatch, hitimes_stopwatch_alloc );
    rb_define_method( cH_Stopwatch, "start", hitimes_stopwatch_start, 0 );
    rb_define_method( cH_Stopwatch, "stop", hitimes_stopwatch_stop, 0 );
    rb_define_method( cH_Stopwatch, "split", hitimes_stopwatch_stop, 0 );
    rb_define_method( cH_Stopwatch, "intervals", hitimes_stopwatch_intervals, 0 );
    rb_define_method( cH_Stopwatch, "elapsed_time", hitimes_stopwatch_elapsed_time, 0);
    */

}
