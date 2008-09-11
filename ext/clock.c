#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>
#include <CoreServices/CoreServices.h>

int main( int argc, char** argv ) 
{

    AbsoluteTime    start;
    AbsoluteTime    end;
    Duration        duration;
    Nanoseconds     elapsedNano;
    uint64_t       *nano;
    
    int count      = atoi(argv[1]);
    int i;
    float secs;

    start = UpTime();

    for( i = 0 ; i < count ; i++) { (void) getpid(); }

    end = UpTime();

    elapsedNano = AbsoluteDeltaToNanoseconds( end, start );

    nano = (uint64_t *)&elapsedNano;
 
    secs = (double)((*nano) * (1e-9));

    printf("elapsed time : %lld\n", *nano);

    exit( 0 );
}

