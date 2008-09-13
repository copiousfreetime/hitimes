/**
 * Copyright (c) 2008 Jeremy Hinegardner
 * All rights reserved.  See LICENSE and/or COPYING for details.
 *
 * vim: shiftwidth=4 
 */ 

#include "hitimes.h"

/* Module and Classes */
VALUE mH;           /* module HiTimes            */
VALUE cH_Interval;  /* class  HiTimes::Interval  */
VALUE eH_Error;     /* class  HiTimes::Error     */

/**
 * Allocator and Deallocator for Interval classes
 */

VALUE hitimes_interval_free(hitimes_interval_t* i) 
{
    if ( Qnil != i->duration ) {
        rb_gc_unregister_address( &(i->duration) );
        i->duration = Qnil;
    }
    xfree( i );
}

VALUE hitimes_interval_alloc(VALUE klass)
{
    VALUE obj;
    hitimes_interval_t* i = xmalloc( sizeof( hitimes_interval_t ) );

    i->start_instant = 0L;
    i->stop_instant  = 0L;
    i->duration      = Qnil;

    obj = Data_Wrap_Struct(klass, NULL, hitimes_interval_free, i);
    return obj;
}

/**
 * call-sec:
 *    interval.split! -> Interval
 *
 * Immediately stop! the current interval and start! a new interval that has a
 * start_instant equivalent to the stop_interval of self.
 */
VALUE hitimes_interval_split_bang( VALUE self )
{
    hitimes_interval_t *first;
    hitimes_interval_t *second = xmalloc( sizeof( hitimes_interval_t ) );
    VALUE              obj;

    Data_Get_Struct( self, hitimes_interval_t, first );
    first->stop_instant = hitimes_get_current_instant( );

    second->start_instant = first->stop_instant;
    second->stop_instant  = 0L;
    second->duration      = Qnil;

    obj = Data_Wrap_Struct(cH_Interval, NULL, hitimes_interval_free, second);

    return obj;
}


/**
 * call-sec:
 *    interval.start! -> nil
 *
 * mark the start of the interval
 */
VALUE hitimes_interval_start_bang( VALUE self )
{
    hitimes_interval_t *i;

    Data_Get_Struct( self, hitimes_interval_t, i );
    i->start_instant = hitimes_get_current_instant( );
    i->stop_instant  = 0L;
    i->duration      = Qnil;

    return Qnil;
}


/**
 * call-sec:
 *    interval.stop! -> nil
 *
 * mark the start of the interval
 */
VALUE hitimes_interval_stop_bang( VALUE self )
{
    hitimes_interval_t *i;

    Data_Get_Struct( self, hitimes_interval_t, i );
    if ( 0L == i->start_instant )  {
        rb_raise(eH_Error, "Attempt to stop an interval that has not started.\n" );
    }

    i->stop_instant = hitimes_get_current_instant( );

    return Qnil;
}



/**
 * call-seq:
 *    interval.to_seconds -> Float
 *
 * Returns the Float value of the interval, the value is in seconds
 */
VALUE hitimes_interval_to_seconds( VALUE self )
{
    hitimes_interval_t *i;
    double             d;

    Data_Get_Struct( self, hitimes_interval_t, i );
    if ( Qnil == i->duration ) {
        d = ( i->stop_instant - i->start_instant ) / hitimes_instant_conversion_factor( );
        i->duration = rb_float_new( d );
        rb_gc_register_address( &(i->duration) );
    }

    return i->duration;
}


/**
 * The HiTimes Ruby Extension
 */
void Init_interval()
{
    /*
     * Top level module encapsulating the entire HiTimes library
     */
    mH = rb_define_module("HiTimes");
   
    /* Error class */
    eH_Error = rb_define_class_under(mH, "Error", rb_eStandardError);

    /* Interval class */
    cH_Interval = rb_define_class_under( mH, "Interval", rb_cObject );
    rb_define_alloc_func( cH_Interval, hitimes_interval_alloc );
    rb_define_method( cH_Interval, "to_f",        hitimes_interval_to_seconds, 0 );
    rb_define_method( cH_Interval, "to_seconds",  hitimes_interval_to_seconds, 0 );
    rb_define_method( cH_Interval, "duration",    hitimes_interval_to_seconds, 0 );
    rb_define_method( cH_Interval, "length",      hitimes_interval_to_seconds, 0 );

    rb_define_method( cH_Interval, "start!", hitimes_interval_start_bang, 0);
    rb_define_method( cH_Interval, "stop!",  hitimes_interval_stop_bang, 0);
    rb_define_method( cH_Interval, "split!",  hitimes_interval_split_bang, 0);
 
}
