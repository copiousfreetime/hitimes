/**
 * Copyright (c) 2008 Jeremy Hinegardner
 * All rights reserved.  See LICENSE and/or COPYING for details.
 *
 * vim: shiftwidth=4 
 */ 

#include "hitimes_interval.h"

/* Modules and Classes -- defined here */
VALUE cH_Interval;         /* class  Hitimes::Interval  */

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
    return Qnil;
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
 * call-seq:
 *    Interval.now -> Interval
 *
 * Create an interval that has already started
 */
VALUE hitimes_interval_now( VALUE self )
{
    VALUE obj;
    hitimes_interval_t *i = xmalloc( sizeof( hitimes_interval_t ) );

    i->start_instant = hitimes_get_current_instant( );
    i->stop_instant  = 0L;
    i->duration      = Qnil;

    obj = Data_Wrap_Struct(cH_Interval, NULL, hitimes_interval_free, i);

    return obj;
}

/**
 * call-seq:
 *    Interval.measure {  }  -> Float
 *
 * Times the execution of the block returning the number of seconds it took
 */
VALUE hitimes_interval_measure( VALUE self )
{
    hitimes_instant_t before;
    hitimes_instant_t after;
    double            duration;

    if ( !rb_block_given_p() ) {
        rb_raise(eH_Error, "No block given to Interval.measure" );
    }
    
    before = hitimes_get_current_instant( );
    rb_yield( Qnil );
    after  = hitimes_get_current_instant( );

    duration = ( after - before ) / HITIMES_INSTANT_CONVERSION_FACTOR;
    return rb_float_new( duration );
}

/**
 * call-seq:
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
 * call-seq:
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
 * call-seq:
 *    interval.stop -> bool or Float
 *
 * mark the stop of the interval.  Calling stop on an already stopped interval
 * has no effect.  An interval can only be stopped once.  If the interval is
 * truely stopped then the duration is returned, otherwise +false+.
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
      double d;

      i->stop_instant = hitimes_get_current_instant( );
      d = ( i->stop_instant - i->start_instant ) / HITIMES_INSTANT_CONVERSION_FACTOR;
      i->duration = rb_float_new( d );
      rb_gc_register_address( &(i->duration) );
      rc = i->duration;
    }

    return rc;
}

/**
 * call-seq:
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
 * call-seq:
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
 * call-seq:
 *    interval.running? -> boolean
 *
 * returns whether or not the interval is running or not.  This means that it
 * has started, but not stopped.
 */
VALUE hitimes_interval_running( VALUE self )
{
    hitimes_interval_t *i;
    VALUE              rc = Qfalse;

    Data_Get_Struct( self, hitimes_interval_t, i );
    if ( ( 0L != i->start_instant ) && ( 0L == i->stop_instant ) ) {
        rc = Qtrue;
    }

    return rc;
}


/** 
 * call-seq:
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
 * call-seq:
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
 * Document-class: Hitimes::Interval
 *
 * This is the lowest level timing mechanism available.  It allows for easy
 * measuring based upon a block:
 *
 *   duration = Interval.measure { ... }
 *
 * Or measuring something specifically
 *
 *   interval = Interval.new
 *   interval.start
 *   duration = interval.stop
 *
 * Allocating and starting an interval can be done in one method call with
 *
 *   interval = Interval.now
 *
 * Interval is useful when you only need to track a single interval of time, or
 * if you do not want to track statistics about an operation.
 *
 */
void Init_hitimes_interval()
{
    mH = rb_define_module("Hitimes"); 
   
    cH_Interval = rb_define_class_under( mH, "Interval", rb_cObject );
    rb_define_alloc_func( cH_Interval, hitimes_interval_alloc );

    rb_define_module_function( cH_Interval, "now", hitimes_interval_now, 0 ); /* in hitimes_interval.c */
    rb_define_module_function( cH_Interval, "measure", hitimes_interval_measure, 0 ); /* in hitimes_interval.c */

    rb_define_method( cH_Interval, "to_f",         hitimes_interval_duration, 0 ); /* in hitimes_interval.c */
    rb_define_method( cH_Interval, "to_seconds",   hitimes_interval_duration, 0 ); /* in hitimes_interval.c */
    rb_define_method( cH_Interval, "duration",     hitimes_interval_duration, 0 ); /* in hitimes_interval.c */
    rb_define_method( cH_Interval, "length",       hitimes_interval_duration, 0 ); /* in hitimes_interval.c */
     
    rb_define_method( cH_Interval, "started?",     hitimes_interval_started, 0 ); /* in hitimes_interval.c */
    rb_define_method( cH_Interval, "running?",     hitimes_interval_running, 0 ); /* in hitimes_interval.c */
    rb_define_method( cH_Interval, "stopped?",     hitimes_interval_stopped, 0 ); /* in hitimes_interval.c */

    rb_define_method( cH_Interval, "start_instant", hitimes_interval_start_instant, 0 ); /* in hitimes_interval.c */
    rb_define_method( cH_Interval, "stop_instant",  hitimes_interval_stop_instant, 0 ); /* in hitimes_interval.c */

    rb_define_method( cH_Interval, "start", hitimes_interval_start, 0); /* in hitimes_interval.c */
    rb_define_method( cH_Interval, "stop",  hitimes_interval_stop, 0); /* in hitimes_interval.c */
    rb_define_method( cH_Interval, "split",  hitimes_interval_split, 0); /* in hitimes_interval.c */
 
}
