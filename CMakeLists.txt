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


set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${PROJECT_BINARY_DIR}/bin)
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${PROJECT_BINARY_DIR}/bin)
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${PROJECT_BINARY_DIR}/bin)

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
