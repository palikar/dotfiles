cmake_minimum_required(VERSION 3.10)
project({{project_name}} LANGUAGES CXX)

include(cmake/safeguards.cmake)

include(GNUInstallDirs)


#######################################################################
#######################################################################
############################     Options     ##########################
#######################################################################
#######################################################################


option(ONLY_COVERAGE "Build only tests necessary for coverage" FALSE)
option(LIBCPP "Build with libc++" FALSE)
option(ENABLE_COVERAGE "Enable coverage reporting for gcc/clang" FALSE)
option(ENABLE_ASAN "Enable address sanitizer" FALSE)
option(BUILD_SHARED_LIBS "Enable compilation of shared libraries" FALSE)
option(ENABLE_TESTING "Enable the building of the test" FALSE)
option(ENABLE_CLANG_TIDY "Enable testing with clang-tidy" FALSE)
option(ENABLE_CPPCHECK "Enable testing with cppcheck" FALSE)
option(SIMPLE_BUILD "Build the project as minimally as possible" FALSE)
option(BUILD_DOC "Build the project's documentation" ON)
option(FORCE_COLORED_OUTPUT "Always produce ANSI-colored output (GNU/Clang only)." TRUE)
option(ELF_LOGGING "Use elf as a hashing function" FALSE)
option(JENKINS_LOGGING "Use jenkins one at a time as a hashing function" FALSE)
option(DEBUG_LOGGING "Enabling debug loggng" 0)
option(BUILD_PACK "Enabling packaging" 0)




#######################################################################
#######################################################################



message("+++++++${PROJECT_NAME}++++++++++")

set(CMAKE_CXX_STANDARD 17)

add_library(project_warnings INTERFACE)
add_library(project_options INTERFACE)


target_compile_features(project_options INTERFACE cxx_std_17)


if(ONLY_COVERAGE OR ENABLE_COVERAGE)
    target_compile_options(project_options INTERFACE --coverage -O0 -g)
    target_link_libraries(project_options INTERFACE --coverage)
endif()


if(ENABLE_ASAN)
    target_compile_options(project_options INTERFACE -fsanitize=address)
    target_link_libraries(project_options INTERFACE -fsanitize=address)
endif()



target_compile_options(project_warnings
    INTERFACE
    -Wall
    # -Werror
    -Wextra
    -Wshadow
    -Wnon-virtual-dtor
    -Wold-style-cast
    -Wcast-align
    # -Wunused
    -Woverloaded-virtual
    -Wpedantic
    -Wconversion
    -Wsign-conversion
    -Wnull-dereference
    -Wdouble-promotion
    -Wformat=2
    )



if("${CMAKE_CXX_COMPILER_ID}" STREQUAL "GNU")
    target_compile_options(project_warnings
        INTERFACE
        -Wmisleading-indentation
        # -Wduplicated-cond
        # -Wduplicated-branches
        -Wlogical-op
        -Wuseless-cast
        )
    target_link_libraries(project_options INTERFACE stdc++fs)
endif()

if (${FORCE_COLORED_OUTPUT})
    if ("${CMAKE_CXX_COMPILER_ID}" STREQUAL "GNU")
        add_compile_options (-fdiagnostics-color=always)
    elseif ("${CMAKE_CXX_COMPILER_ID}" STREQUAL "Clang")
        add_compile_options (-fcolor-diagnostics)
    endif ()
endif ()



find_program(CCACHE ccache)
if(CCACHE)
    set(CMAKE_CXX_COMPILER_LAUNCHER ${CCACHE})
endif()



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

if(ENABLE_CLANG_TIDY)
    find_program(CLANGTIDY clang-tidy)
    if(CLANGTIDY)
	set(CMAKE_CXX_CLANG_TIDY ${CLANGTIDY})
    else()
	message(SEND_ERROR "clang-tidy requested but executable not found")
    endif()
endif()


if(NOT EXISTS "${CMAKE_BINARY_DIR}/conan.cmake")
    message(STATUS "Downloading conan.cmake from https://github.com/conan-io/cmake-conan")
    file(DOWNLOAD "https://raw.githubusercontent.com/conan-io/cmake-conan/master/conan.cmake"
        "${CMAKE_BINARY_DIR}/conan.cmake")
endif()

include(${CMAKE_BINARY_DIR}/conan.cmake)
conan_check(REQUIRED)
conan_cmake_run(
    CONANFILE
    conanfile.txt
    BASIC_SETUP
    CONAN_COMMAND
    ${CONAN_CMD}
    CMAKE_TARGETS
    BUILD
    missing)

include(${CMAKE_BINARY_DIR}/conanbuildinfo.cmake)
conan_basic_setup()

list(APPEND CMAKE_MODULE_PATH ${CMAKE_BINARY_DIR})



if(ENABLE_TESTING)
    enable_testing()
endif()

set(CMAKE_EXPORT_COMPILE_COMMANDS 1)

#######################################################################
#######################################################################
###########################    Libraries     ##########################
#######################################################################
#######################################################################



if(CONAN_CATCH2_ROOT_DEBUG)
    include(${CONAN_CATCH2_ROOT_DEBUG}/lib/cmake/Catch2/Catch.cmake)
else()
    include(${CONAN_CATCH2_ROOT}/lib/cmake/Catch2/Catch.cmake)
endif()
find_package(Catch2 REQUIRED)


set(THREADS_PREFER_PTHREAD_FLAG ON)
find_package(Threads REQUIRED)

find_package(fmt)

find_package(spdlog)

find_package(clara)

find_package(rang)


#######################################################################
#######################################################################



set(PROJECT_BRIEF "{{project_description}}")


if(ELF_HASHING)
    target_compile_definitions(project_options INTERFACE -DELF_HASHING)
endif(ELF_HASHING)


if(JENKINS_HASHING)
    target_compile_definitions(project_options INTERFACE -DJENKINS_HASHING)
endif(JENKINS_HASHING)



set(VERSION_MAJOR 1)
set(VERSION_MINOR 0)
set(VERSION_PATCH 0)
set(VERSION ${VERSION_MAJOR}.${VERSION_MINOR}.${VERSION_PATCH})

configure_file (
    "${PROJECT_SOURCE_DIR}/src/include/${PROJECT_NAME}/config.hpp.in"
    "${PROJECT_BINARY_DIR}/src/include/${PROJECT_NAME}/config.hpp"
    )

include_directories("${PROJECT_BINARY_DIR}/src/include")

install (FILES
    "${PROJECT_BINARY_DIR}/src/include/${PROJECT_NAME}/config.hpp"
    DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}/${PROJECT_NAME}/
    )


if(BUILD_PACK)
		include (InstallRequiredSystemLibraries)
		set (CPACK_RESOURCE_FILE_LICENSE  
				"${CMAKE_CURRENT_SOURCE_DIR}/LICENSE")
		set (CPACK_PACKAGE_VERSION_MAJOR "${MF_VERSION_MAJOR}")
		set (CPACK_PACKAGE_VERSION_MINOR "${MF_VERSION_MINOR}")
		set (CPACK_PACKAGE_VERSION_PATCH "${MF_VERSION_PATCH}")
		include (CPack)
endif()

if(BUILD_DOC)
    find_package(Doxygen)
    if (DOXYGEN_FOUND)
	# set input and output files
	set(DOXYGEN_IN ${CMAKE_CURRENT_SOURCE_DIR}/doc/Doxyfile.in)
	set(DOXYGEN_OUT ${CMAKE_CURRENT_BINARY_DIR}/Doxyfile)

	# request to configure the file
	configure_file(${DOXYGEN_IN} ${DOXYGEN_OUT} @ONLY)
	message(STATUS "Doxygen build started")

	# note the option ALL which allows to build the docs together with the application
	add_custom_target(doc ALL
	    COMMAND ${DOXYGEN_EXECUTABLE} ${DOXYGEN_OUT}
	    WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
	    COMMENT "Generating API documentation with Doxygen"
	    VERBATIM )
    else (DOXYGEN_FOUND)
	message("Doxygen need to be installed to generate the doxygen documentation")
    endif (DOXYGEN_FOUND)
endif()


add_subdirectory(libs)

add_subdirectory(src)


message("#########################################")
message("\t \t Summary")
message("#########################################")
message("Build type:       \t ${CMAKE_BUILD_TYPE}")
message("Install prefix:   \t ${CMAKE_INSTALL_PREFIX}")
message("Testing enabled:  \t ${ENABLE_TESTING}")
message("Clang-tidy:       \t ${ENABLE_CLANG_TIDY}")
message("Cppcheck:         \t ${ENABLE_CPPCHECK}")
message("Compiler:         \t ${CMAKE_CXX_COMPILER_ID}")
message("Sanizizers:       \t ${ENABLE_ASAN}")
message("Shared libs:      \t ${BUILD_SHARED_LIBS}")
message("Build libcpp:     \t ${LIBCPP}")
message("CCache executable:\t ${CCACHE}")
message("Building doc:     \t ${BUILD_DOC}")
message("Simple build:     \t ${SIMPLE_BUILD}")
message("Jenkins Hashing:  \t ${JENKINS_HASHING}")
message("Elf Hashing:      \t ${ELF_HASHING}")
message("Debug Logging:    \t ${DEBUG_LOGGING}")


message("------------------------------------------")
message("Version:        \t ${VERSION}")
message("########################################")




####################################################
##############    Available Targets   ##############
####################################################
# Catch2::Catch2 
####################################################
# absl::base
# absl::algorithm
# absl::debugging
# absl::flat_hash_map
# absl::memory
# absl::meta
# absl::numeric
# absl::strings
# absl::synchronization
# absl::time
# absl::utility
####################################################
# Threads::Threads
####################################################
# fmt::fmt
####################################################
# spdlog::spdlog
####################################################
# imgui
####################################################

