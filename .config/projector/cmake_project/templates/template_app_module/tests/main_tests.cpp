#define CATCH_CONFIG_MAIN
#include "catch2/catch.hpp"



TEST_CASE( "Basic test", "[equality]" ) {
	REQUIRE( 3 == 3 );
}
