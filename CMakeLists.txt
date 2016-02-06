project("my_project" C)
cmake_minimum_required(VERSION 3.2)

# Library version
#
# This should be incremented with every release.  See semver.org.
set (MY_PROJECT_VERSION_MAJOR    0)
set (MY_PROJECT_VERSION_MINOR    1)
set (MY_PROJECT_VERSION_REVISION 0)

# API version.
#
# This will go in the pkg-config and shared library names.  Should
# only be changed if the API breaks backwards compatibility.
set (MY_PROJECT_VERSION_API      "0.1")

# ABI version
#
# Rules from § 11.4: Library Versioning of the autobook
# https://www.sourceware.org/autobook/autobook/autobook_61.html
#
# 1) If you have changed any of the sources for this library, the
#    revision number must be incremented. This is a new revision of
#    the current interface.
# 2) If the interface has changed, then current must be incremented,
#    and revision reset to ‘0’. This is the first revision of a new
#    interface.
# 3) If the new interface is a superset of the previous interface
#    (that is, if the previous interface has not been broken by the
#    changes in this new release), then age must be incremented. This
#    release is backwards compatible with the previous release.
# 4) If the new interface has removed elements with respect to the
#    previous interface, then you have broken backward compatibility
#    and age must be reset to ‘0’. This release has a new, but
#    backwards incompatible interface.
#
# Conveniently, this also matches semantic versioning for the most
# part (API changes are a bit more complicated since we change the
# library and pkg-config names and can reset these to whatever we
# want, but we don't *have* to.
set (MY_PROJECT_SOVERSION_CURRENT  ${MY_PROJECT_VERSION_MAJOR})
set (MY_PROJECT_SOVERSION_REVISION ${MY_PROJECT_VERSION_MINOR})
set (MY_PROJECT_SOVERSION_AGE      ${MY_PROJECT_VERSION_REVISION})

include(GNUInstallDirs)

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

include_directories(${CMAKE_RUNTIME_OUTPUT_DIRECTORY})

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

add_subdirectory(src_lib)
add_subdirectory(src_main)
add_subdirectory(tests)
