#include "single.h"

int main (int argc, char *argv[])
{
	for ( int i=0; i<200; i++ ) {
		for ( int n=0; n<13; n++ ) {
			char *rr = rand_numbers( 3 );
			rr = ( *rr > 51 ) ? &rr[1] : rr;
			printf( "%s,", rr );
		}
		char *rr = rand_numbers( 3 );
		rr = ( *rr > 51 ) ? &rr[1] : rr;
		printf( "%s\n", rr );
	}
	return 1;
}
