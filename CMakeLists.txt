project("my_project" C)
cmake_minimum_required(VERSION 3.2)

enable_testing()

list(APPEND CMAKE_MODULE_PATH
    ${CMAKE_SOURCE_DIR}/cmake/vala/
    ${CMAKE_SOURCE_DIR}/cmake/glib/
)
find_package(GLIB2 REQUIRED)

find_package(Vala "0.30" REQUIRED)
include(${VALA_USE_FILE})

find_package(PkgConfig)
pkg_check_modules(GOBJECT REQUIRED gobject-2.0)
pkg_check_modules(GIO REQUIRED gio-2.0)
pkg_check_modules(GTHREAD REQUIRED gthread-2.0)
pkg_check_modules(GEE REQUIRED gee-0.8)

set(CFLAGS
	${GOBJECT_CFLAGS} ${GOBJECT_CFLAGS_OTHER}
	${GIO_CFLAGS} ${GIO_CFLAGS_OTHER}
	${GTHREAD_CFLAGS} ${GTHREAD_CFLAGS_OTHER}
	${GEE_CFLAGS} ${GEE_CFLAGS_OTHER}
)
add_definitions(${CFLAGS})

set(LIBS
	${GOBJECT_LIBRARIES}
	${GIO_LIBRARIES}
	${GTHREAD_LIBRARIES}
	${GEE_LIBRARIES}
)
link_libraries(${LIBS})

set(LIB_PATHS
	${GOBJECT_LIBRARY_DIRS}
	${GIO_LIBRARY_DIRS}
	${GTHREAD_LIBRARY_DIRS}
	${GEE_LIBRARY_DIRS}
)
link_directories(${LIB_PATHS})

#
#
# Static Library Target: linked against main and against tests.

vala_precompile(VALA_C
	src_lib/my_class.vala
PACKAGES
	gio-2.0
    gee-0.8
	posix
OPTIONS
    --target-glib=2.44
	--thread
	--debug
GENERATE_HEADER
	my_project
GENERATE_VAPI
	my_project
)

add_library(lmy_project
	STATIC
    EXCLUDE_FROM_ALL
	${VALA_C} my_project.h
)

#
#
# Main target

vala_precompile(VALA_MAIN_C
	src_main/main.vala
PACKAGES
	gio-2.0
    gee-0.8
	posix
CUSTOM_VAPIS
    ${CMAKE_CURRENT_BINARY_DIR}/my_project.vapi
OPTIONS
    --target-glib=2.44
	--thread
	--debug
)

add_executable(my_project
    ${VALA_MAIN_C}
)
target_link_libraries(my_project lmy_project -lm)

#
#
# Unit Tests Target

vala_precompile(VALA_UNIT_TESTS_C
	tests/test_case.vala
	tests/test_main.vala
    tests/test_my_class.vala
PACKAGES
	gio-2.0
    gee-0.8
	posix
CUSTOM_VAPIS
    ${CMAKE_CURRENT_BINARY_DIR}/my_project.vapi
OPTIONS
    --target-glib=2.44
	--thread
	--debug
)

add_executable(my_project_unit_tests
  	${VALA_UNIT_TESTS_C}
)
target_link_libraries(my_project_unit_tests lmy_project -lm)

# List of tests in the `my_project_unit_tests' executable that you
# want to execute.  Note that this is a list; to add additional tests
# you don't need to quote them, just use whitespace to separate them
# and you're done.
set(MY_PROJECT_TESTS
  /my_class/foo)

# Add the tests in the MY_PROJECT_TESTS list to ctest
foreach(test_name ${MY_PROJECT_TESTS})
  add_test(NAME ${test_name}
    COMMAND $<TARGET_FILE:my_project_unit_tests> -p ${test_name})
endforeach(test_name)
