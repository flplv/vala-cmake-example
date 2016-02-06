#
#
# Main target

vala_precompile(MY_PROJECT_MAIN_SOURCES
	main.vala
PACKAGES
	gio-2.0
	gee-0.8
	posix
CUSTOM_VAPIS
	${CMAKE_BINARY_DIR}/src_lib/my-project-${MY_PROJECT_VERSION_API}.vapi
OPTIONS
	--target-glib=2.44
	--thread
	--debug
)

add_executable(my-project
	${MY_PROJECT_MAIN_SOURCES}
)

set_target_properties(my-project PROPERTIES
	INCLUDE_DIRECTORIES ${CMAKE_BINARY_DIR}/src_lib)

target_link_libraries(my-project my-project-${MY_PROJECT_VERSION_API} -lm)
