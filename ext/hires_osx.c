#include <hires.h>

#ifndef __HIRES_OSX__
#define __HIRES_OSX__

#include <CoreServices/CoreServices.h>
extern hires_units = { "nanosecond", 1e-9 }

hires_time_t hires_uptime()
{
    AbsoluteTime now_raw = UpTime();
    hires_time_t now;

    now.value = AbsoluteToNanoseconds( now_raw );
    now.units = hirest_units;

    return now;
}
