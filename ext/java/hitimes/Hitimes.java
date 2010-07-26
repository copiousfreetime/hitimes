package hitimes;

import java.lang.Math;
import java.lang.System;

import org.jruby.anno.JRubyClass;
import org.jruby.anno.JRubyMethod;
import org.jruby.anno.JRubyModule;

import org.jruby.Ruby;
import org.jruby.RubyClass;
import org.jruby.RubyException;
import org.jruby.RubyModule;
import org.jruby.RubyNumeric;
import org.jruby.RubyObject;

import org.jruby.exceptions.RaiseException;

import org.jruby.runtime.builtin.IRubyObject;

import org.jruby.runtime.Block;
import org.jruby.runtime.ObjectAllocator;
import org.jruby.runtime.ThreadContext; 

/**
 * @author <a href="mailto:jeremy@hinegardner.org">Jeremy Hinegardner</a>
 */
@JRubyModule( name = "Hitimes" )
public class Hitimes {
    public static RubyClass hitimesIntervalClass;
    /**
     * Create the Hitimes module and add it to the Ruby runtime.
     */
    public static RubyModule createHitimes( Ruby runtime ) {
        RubyModule mHitimes = runtime.defineModule("Hitimes");

        RubyClass  cStandardError = runtime.getStandardError();
        RubyClass  cHitimesError  = mHitimes.defineClassUnder("Error", cStandardError, cStandardError.getAllocator());

        RubyClass  cHitimesStats  = mHitimes.defineClassUnder("Stats", runtime.getObject(), HitimesStats.ALLOCATOR );
        cHitimesStats.defineAnnotatedMethods( HitimesStats.class );

        RubyClass  cHitimesInterval  = mHitimes.defineClassUnder("Interval", runtime.getObject(), HitimesInterval.ALLOCATOR );
        Hitimes.hitimesIntervalClass = cHitimesInterval;
        cHitimesInterval.defineAnnotatedMethods( HitimesInterval.class );

        return mHitimes;
    }

    static RaiseException newHitimesError( Ruby runtime, String message ) {
        RubyClass errorClass = runtime.fastGetModule("Hitimes").fastGetClass( "Error" );
        return new RaiseException( RubyException.newException( runtime, errorClass, message ), true );
    }



    @JRubyClass( name = "Hitimes::Error", parent = "StandardError" )
    public static class Error {};

    @JRubyClass( name = "Hitimes::Stats" )
    public static class HitimesStats extends RubyObject {

        private double min   = 0.0;
        private double max   = 0.0;
        private double sum   = 0.0;
        private double sumsq = 0.0;
        private long   count = 0;

        private static final ObjectAllocator ALLOCATOR = new ObjectAllocator() {
            public IRubyObject allocate(Ruby runtime, RubyClass klass) {
                return new HitimesStats( runtime, klass );
            }
        };

        public HitimesStats( Ruby runtime, RubyClass klass ) {
            super( runtime, klass );
        }

        @JRubyMethod( name = "update", required = 1, argTypes = RubyNumeric.class )
        public IRubyObject update( IRubyObject val ) {
            double v = RubyNumeric.num2dbl( val );

            if ( 0 == this.count ) {
                this.min = this.max = v;
            } else {
                this.min = ( v < this.min ) ? v : this.min;
                this.max = ( v > this.max ) ? v : this.max;
            }

            this.count += 1;
            this.sum   += v;
            this.sumsq += (v * v);

            return val;
        }

        @JRubyMethod( name = "mean" )
        public IRubyObject mean() {
            double mean = 0.0;

            if ( this.count > 0 ) {
                mean = this.sum / this.count;
            }

            return getRuntime().newFloat( mean );
        }


        @JRubyMethod( name = "rate" )
        public IRubyObject rate() {
            double rate = 0.0;

            if ( this.sum > 0.0 ) {
                rate = this.count / this.sum ;
            }

            return getRuntime().newFloat( rate );
        }

        @JRubyMethod( name = "stddev" )
        public IRubyObject stddev() {
            double stddev = 0.0;

            if ( this.count > 1 ) {
                double sq_sum = this.sum * this.sum;
                stddev = Math.sqrt( ( this.sumsq - ( sq_sum / this.count ) ) / ( this.count - 1 ) );
            }
            return getRuntime().newFloat( stddev );
        }


        @JRubyMethod( name = "min" )
        public IRubyObject min() {
            return getRuntime().newFloat( this.min );
        }

        @JRubyMethod( name = "max" )
        public IRubyObject max() {
            return getRuntime().newFloat( this.max );
        }

        @JRubyMethod( name = "sum" )
        public IRubyObject sum() {
            return getRuntime().newFloat( this.sum );
        }

        @JRubyMethod( name = "sumsq" )
        public IRubyObject sumsq() {
            return getRuntime().newFloat( this.sumsq );
        }

        @JRubyMethod( name = "count" )
        public IRubyObject count() {
            return getRuntime().newFixnum( this.count );
        }
    }

    @JRubyClass( name = "Hitimes::Interval" )
    public static class HitimesInterval extends RubyObject {

        private static final long   INSTANT_CONVERSION_FACTOR = 1000000000l;

        private static final long   INSTANT_NOT_SET  = Long.MIN_VALUE;
        private static final double DURATION_NOT_SET = Double.NaN;

        private static final ObjectAllocator ALLOCATOR = new ObjectAllocator() {
            public IRubyObject allocate(Ruby runtime, RubyClass klass) {
                return new HitimesInterval( runtime, klass );
            }
        };

        public HitimesInterval( Ruby runtime, RubyClass klass ) {
            super( runtime, klass );
        }

        public HitimesInterval( Ruby runtime, RubyClass klass, long start ) {
            super( runtime, klass );
            this.start_instant = start;
        }


        private long start_instant = INSTANT_NOT_SET;
        private long stop_instant  = INSTANT_NOT_SET;
        private double duration    = DURATION_NOT_SET;

        @JRubyMethod( name = "duration", alias = { "length", "to_f", "to_seconds" } )
        public IRubyObject duration() {

            /*
             * if stop has not yet been called, then return the amount of time so far
             */
            if ( INSTANT_NOT_SET == this.stop_instant ) {
                double d = ( System.nanoTime() - this.start_instant ) / INSTANT_CONVERSION_FACTOR;
                return getRuntime().newFloat( d );
            }

            /*
             * if stop has been called, then calculate the duration and return
             */
            if ( DURATION_NOT_SET == this.duration ) {
                this.duration = (this.stop_instant - this.start_instant) / INSTANT_CONVERSION_FACTOR;
            }

            return getRuntime().newFloat( this.duration );

        }

        @JRubyMethod( name = "duration_so_far" )
        public IRubyObject duration_so_far() {
            IRubyObject rc = getRuntime().getFalseClass();

            if ( INSTANT_NOT_SET == this.start_instant ) {
                return rc;
            }

            if ( INSTANT_NOT_SET == this.stop_instant ) {
                double d = ( System.nanoTime() - this.start_instant ) / INSTANT_CONVERSION_FACTOR;
                return getRuntime().newFloat( d );
            }

            return rc;
        }

        @JRubyMethod( name = "started?" )
        public IRubyObject is_started() {
            if ( INSTANT_NOT_SET == this.start_instant ) {
                return getRuntime().getFalseClass();
            }
            return getRuntime().getTrueClass();
        }

        @JRubyMethod( name = "running?" )
        public IRubyObject is_running() {
            if ( ( INSTANT_NOT_SET != this.start_instant ) && ( INSTANT_NOT_SET == this.stop_instant ) ) {
                return getRuntime().getTrueClass();
            }
            return getRuntime().getFalseClass();
        }

        @JRubyMethod( name = "stopped?" )
        public IRubyObject is_stopped() {
            if ( INSTANT_NOT_SET == this.stop_instant ) {
                return getRuntime().getFalseClass();
            }
            return getRuntime().getTrueClass();
        }

        @JRubyMethod( name = "start_instant" )
        public IRubyObject start_instant() {
            return getRuntime().newFixnum( this.start_instant );
        }

        @JRubyMethod( name = "stop_instant" )
        public IRubyObject stop_instant() {
            return getRuntime().newFixnum( this.stop_instant );
        }

        @JRubyMethod( name = "start" )
        public IRubyObject start() {
            if ( INSTANT_NOT_SET == this.start_instant ) {
                this.start_instant = System.nanoTime();
                return getRuntime().getTrueClass();
            }
            return getRuntime().getFalseClass();
        }

        @JRubyMethod( name = "stop" )
        public IRubyObject stop() {
            if ( INSTANT_NOT_SET == this.start_instant ) {
                throw Hitimes.newHitimesError( getRuntime(), "Attempt to stop an interval that has not started." );
            }

            if ( INSTANT_NOT_SET == this.stop_instant ) {
                this.stop_instant = System.nanoTime();
                this.duration = (this.stop_instant - this.start_instant) / INSTANT_CONVERSION_FACTOR;
                return getRuntime().newFloat( this.duration );
            }

            return getRuntime().getFalseClass();
        }

        @JRubyMethod( name = "split" )
        public IRubyObject split() {
            this.stop();
            return new HitimesInterval( getRuntime(), Hitimes.hitimesIntervalClass, this.start_instant );
        }

        @JRubyMethod( name = "now", meta = true )
        public static IRubyObject now( ThreadContext context ) {
            return new HitimesInterval( context.getRuntime(), Hitimes.hitimesIntervalClass, System.nanoTime() );
        }

        @JRubyMethod( name = "measure", frame = true, meta = true )
        public static IRubyObject measure( ThreadContext context, Block block ) {
            if ( block.isGiven() ) {
                Ruby runtime    = context.getRuntime();
                IRubyObject nil = runtime.getNil();

                HitimesInterval interval = new HitimesInterval( runtime, Hitimes.hitimesIntervalClass );

                interval.start();
                block.yield( context, nil ); 
                interval.stop();

                return interval.duration();
            } else {
                throw Hitimes.newHitimesError( context.getRuntime(), "No block given to Interval.measure" );
            }
        }
    }
}
