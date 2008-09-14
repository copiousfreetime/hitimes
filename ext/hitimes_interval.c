/**
 * Copyright (c) 2008 Jeremy Hinegardner
 * All rights reserved.  See LICENSE and/or COPYING for details.
 *
 * vim: shiftwidth=4 
 */ 

#include "hitimes_interval.h"

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
 *    interval.split -> Interval
 *
 * Immediately stop the current interval and start a new interval that has a
 * start_instant equivalent to the stop_interval of self.
 */
VALUE hitimes_interval_split( VALUE self )
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
 *    interval.start -> boolean 
 *
 * mark the start of the interval.  Calling start on an already started
 * interval has no effect.  An interval can only be started once.  If the
 * interval is truely started +true+ is returned otherwise +false+.
 */
VALUE hitimes_interval_start( VALUE self )
{
    hitimes_interval_t *i;
    VALUE               rc = Qfalse;

    Data_Get_Struct( self, hitimes_interval_t, i );
    if ( 0L == i->start_instant ) {
      i->start_instant = hitimes_get_current_instant( );
      i->stop_instant  = 0L;
      i->duration      = Qnil;

      rc = Qtrue;
    }

    return rc;
}


/**
 * call-sec:
 *    interval.stop -> boolean
 *
 * mark the stop of the interval.  Calling stop on an already stopped interval
 * has no effect.  An interval can only be stopped once.  If the interval is
 * truely stopped then +true+ is returned, otherwise +false+.
 */
VALUE hitimes_interval_stop( VALUE self )
{
    hitimes_interval_t *i;
    VALUE               rc = Qfalse;

    Data_Get_Struct( self, hitimes_interval_t, i );
    if ( 0L == i->start_instant )  {
        rb_raise(eH_Error, "Attempt to stop an interval that has not started.\n" );
    }

    if ( 0L == i->stop_instant ) {
      i->stop_instant = hitimes_get_current_instant( );
      rc = Qtrue;
    }

    return rc;
}

/**
 * call-sec:
 *    interval.started? -> boolean
 *
 * returns whether or not the interval has been started
 */
VALUE hitimes_interval_started( VALUE self )
{
    hitimes_interval_t *i;

    Data_Get_Struct( self, hitimes_interval_t, i );

    return ( 0L == i->start_instant ) ? Qfalse : Qtrue;
}


/**
 * call-sec:
 *    interval.stopped? -> boolean
 *
 * returns whether or not the interval has been stopped
 */
VALUE hitimes_interval_stopped( VALUE self )
{
    hitimes_interval_t *i;

    Data_Get_Struct( self, hitimes_interval_t, i );

    return ( 0L == i->stop_instant ) ? Qfalse : Qtrue;
}


/** 
 * call-sec:
 *    interval.start_instant -> Integer
 *
 * The integer representing the start instant of the Interval.  This value
 * is not useful on its own.  It is a platform dependent value.
 */
VALUE hitimes_interval_start_instant( VALUE self )
{
    hitimes_interval_t *i;

    Data_Get_Struct( self, hitimes_interval_t, i );
   
    return ULL2NUM( i->start_instant );
}


/** 
 * call-sec:
 *    interval.stop_instant -> Integer
 *
 * The integer representing the stop instant of the Interval.  This value
 * is not useful on its own.  It is a platform dependent value.
 */
VALUE hitimes_interval_stop_instant( VALUE self )
{
    hitimes_interval_t *i;

    Data_Get_Struct( self, hitimes_interval_t, i );
   
    return ULL2NUM( i->stop_instant );
}



/**
 * call-seq:
 *    interval.duration -> Float
 *
 * Returns the Float value of the interval, the value is in seconds.  If the
 * interval has not had stop called yet, it will report the number of seconds
 * in the interval up to the current point in time.
 */
VALUE hitimes_interval_duration ( VALUE self )
{
    hitimes_interval_t *i;
    double             d;

    Data_Get_Struct( self, hitimes_interval_t, i );

    /** 
     * if stop has not yet been called, then return the amount of time so far
     */
    if ( 0L == i->stop_instant ) {
        hitimes_instant_t now = hitimes_get_current_instant( );
        d = ( now - i->start_instant ) / HITIMES_INSTANT_CONVERSION_FACTOR;
        return rb_float_new( d );
    }


    /*
     * stop has been called, calculate the duration and save the result
     */
    if ( Qnil == i->duration ) {
        d = ( i->stop_instant - i->start_instant ) / HITIMES_INSTANT_CONVERSION_FACTOR;
        i->duration = rb_float_new( d );
        rb_gc_register_address( &(i->duration) );
    }

    return i->duration;
}


/**
 * The HiTimes Ruby Extension
 */
void Init_hitimes_interval()
{
    /*
     * Top level module encapsulating the entire HiTimes library
     */
    mH = rb_define_module("Hitimes");
   
    /* Error class */
    eH_Error = rb_define_class_under(mH, "Error", rb_eStandardError);

    /* Interval class */
    cH_Interval = rb_define_class_under( mH, "Interval", rb_cObject );
    rb_define_alloc_func( cH_Interval, hitimes_interval_alloc );
    rb_define_method( cH_Interval, "to_f",         hitimes_interval_duration, 0 );
    rb_define_method( cH_Interval, "to_seconds",   hitimes_interval_duration, 0 );
    rb_define_method( cH_Interval, "duration",     hitimes_interval_duration, 0 );
    rb_define_method( cH_Interval, "length",       hitimes_interval_duration, 0 );
    
    rb_define_method( cH_Interval, "started?",  hitimes_interval_started, 0 );
    rb_define_method( cH_Interval, "stopped?",  hitimes_interval_stopped, 0 );

    rb_define_method( cH_Interval, "start_instant", hitimes_interval_start_instant, 0 );
    rb_define_method( cH_Interval, "stop_instant",  hitimes_interval_stop_instant, 0 );

    rb_define_method( cH_Interval, "start", hitimes_interval_start, 0);
    rb_define_method( cH_Interval, "stop",  hitimes_interval_stop, 0);
    rb_define_method( cH_Interval, "split",  hitimes_interval_split, 0);
 
}
