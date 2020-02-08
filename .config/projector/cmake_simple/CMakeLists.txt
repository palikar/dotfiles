cmake_minimum_required(VERSION 3.2 FATAL_ERROR)



list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_LIST_DIR}/cmake")
project({{project_name}} LANGUAGES CXX)

include(safeguards)
include(GNUInstallDirs)

find_program(CCACHE ccache)
if(CCACHE)
    set(CMAKE_CXX_COMPILER_LAUNCHER ${CCACHE})
endif()

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_EXPORT_COMPILE_COMMANDS 1)

add_library(project_warnings INTERFACE)
add_library(project_options INTERFACE)

target_compile_features(project_options INTERFACE cxx_std_17)


option(FORCE_COLORED_OUTPUT "Always produce ANSI-colored output (GNU/Clang only)." TRUE)
if (${FORCE_COLORED_OUTPUT})
    if ("${CMAKE_CXX_COMPILER_ID}" STREQUAL "GNU")
        target_compile_options (project_options INTERFACE -fdiagnostics-color=always)
    elseif ("${CMAKE_CXX_COMPILER_ID}" STREQUAL "Clang")
        target_compile_options (project_options INTERFACE -fcolor-diagnostics)
    endif ()
endif ()


option(ENABLE_COVERAGE "Enable coverage reporting for gcc/clang" FALSE)
option(ONLY_COVERAGE "Build only tests necessary for coverage" FALSE)
if(ONLY_COVERAGE OR ENABLE_COVERAGE)
    target_compile_options(project_options INTERFACE --coverage -O0 -g)
    target_link_libraries(project_options INTERFACE --coverage)
endif()


option(ENABLE_ASAN "Enable address sanitizer" FALSE)
if(ENABLE_ASAN)
    target_compile_options(project_options INTERFACE -fsanitize=address)
    target_link_libraries(project_options INTERFACE -fsanitize=address)
endif()


option(ENABLE_FUZZERS "Enable fuzz testing tools" FALSE)
if(ENABLE_FUZZERS)
endif()


target_compile_options(project_warnings
    INTERFACE
    -Wall
    -Wextra 
    -Wshadow
    )

option(ALL_WARNINGS "Enable all waring that the compiler supports" FALSE)
if(${ALL_WARNINGS})
    target_compile_options(project_warnings
	INTERFACE
	-Wnon-virtual-dtor
	-Wold-style-cast 
	-Wcast-align 
	-Wunused 
	-Woverloaded-virtual
	-Wpedantic 
	-Wconversion
	-Wsign-conversion 
	-Wnull-dereference
	-Wdouble-promotion                         
	-Wformat=2)
endif()


option(LIBCPP "Build with libc++" FALSE)
if("${CMAKE_CXX_COMPILER_ID}" STREQUAL "GNU" AND ${ALL_WARNINGS})

    if(CMAKE_CXX_COMPILER_VERSION VERSION_GREATER 6.3)
        target_compile_options(project_warnings INTERFACE
            -Wduplicated-branches)
    endif()
    
    target_compile_options(project_warnings INTERFACE
	-Wmisleading-indentation
        -Wduplicated-cond
	-Wlogical-op
	-Wuseless-cast)
    target_link_libraries(project_options INTERFACE stdc++fs)
else()
    if(LIBCPP)
	target_compile_options(project_options INTERFACE -stdlib=libc++)
    else()
	target_link_libraries(project_options INTERFACE stdc++fs)
    endif()
endif()


option(BUILD_SHARED_LIBS "Enable compilation of shared libraries" FALSE)
option(ENABLE_CLANG_TIDY "Enable testing with clang-tidy" FALSE)
if(ENABLE_CLANG_TIDY)
    find_program(CLANGTIDY clang-tidy)
    if(CLANGTIDY)
	set(CMAKE_CXX_CLANG_TIDY ${CLANGTIDY})
    else()
	message(SEND_ERROR "clang-tidy requested but executable not found")
    endif()
endif()

option(ENABLE_CPPCHECK "Enable testing with cppcheck" FALSE)
if(ENABLE_CPPCHECK)
    find_program(CPPCHECK cppcheck)
    if(CPPCHECK)
	set(CMAKE_CXX_CPPCHECK
	    ${CPPCHECK}
	    --suppress=syntaxError
	    --enable=all
	    --inconclusive)
    else()
	message(SEND_ERROR "cppcheck requested but executable not found")
    endif()
endif()



# Project setup

file(READ "${PROJECT_SOURCE_DIR}/version" VERSION NEWLINE_CONSUME)
string(REPLACE "\n" "" VERSION "${VERSION}")
string(REPLACE "." ";" VERSION_LIST ${VERSION})

list(GET VERSION_LIST 0 VERSION_MAJOR)
list(GET VERSION_LIST 1 VERSION_MINOR)
list(GET VERSION_LIST 2 VERSION_PATCH)

configure_file("${PROJECT_SOURCE_DIR}/include/config.hpp.in" "${CMAKE_CURRENT_BINARY_DIR}/config.hpp")
include_directories(${CMAKE_CURRENT_BINARY_DIR})

set(THREADS_PREFER_PTHREAD_FLAG ON)
find_package(Threads REQUIRED)

target_include_directories(project_options INTERFACE include)

# Basic header-only library

add_executable({{project_name}} ./src/main.cpp)
target_link_libraries({{project_name}} PRIVATE project_options project_warnings)
target_include_directories({{project_name}} INTERFACE ./include)


if(NOT ONLY_COVERAGE)
		
endif()



option(BUILD_TESTS "Build the tests for the project" TRUE)
if(BUILD_TESTS OR ONLY_COVERAGE)
    
    enable_testing()
    include(CTest)
    include(Catch)
    add_executable({{project_name}}_test ./tests/main_test.cpp)
    target_link_libraries({{project_name}}_test
        PRIVATE project_options project_warnings)
		catch_discover_tests({{project_name}}_test)

		if(ONLY_COVERAGE OR ENABLE_COVERAGE)

        include(CodeCoverage)

        set(COVERAGE_GCOVR_EXCLUDES "${PROJECT_SOURCE_DIR}/tests/catch.hpp" "${PROJECT_SOURCE_DIR}/src/*")

        setup_target_for_coverage_gcovr_html(
            NAME {{project_name}}_coverage_html
            EXECUTABLE ctest -j2
            DEPENDENCIES {{project_name}}_coverage_html_tests)

        setup_target_for_coverage_gcovr_xml(
            NAME {{project_name}}_coverage_html
            EXECUTABLE ctest -j2
            DEPENDENCIES {{project_name}}_tests)
    endif()

endif()


install(TARGETS {{project_name}}
    PUBLIC_HEADER DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}/${PROJECT_NAME}/
    RUNTIME DESTINATION       ${CMAKE_INSTALL_BINDIR}
    LIBRARY DESTINATION       ${CMAKE_INSTALL_LIBDIR}
    INCLUDES DESTINATION      ${CMAKE_INSTALL_INCLUDEDIR}/${PROJECT_NAME}/
    ARCHIVE DESTINATION       ${CMAKE_INSTALL_SHAREDSTATEDIR})
install(DIRECTORY ./include/ DESTINATION include)
