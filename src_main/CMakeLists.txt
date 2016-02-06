#
#
# Main target

vala_precompile(VALA_MAIN_C
	main.vala
PACKAGES
	gio-2.0
    gee-0.8
	posix
CUSTOM_VAPIS
    ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/my_project.vapi
OPTIONS
    --target-glib=2.44
	--thread
	--debug
)

add_executable(my_project
    ${VALA_MAIN_C}
)
target_link_libraries(my_project _my_project-${MY_PROJECT_VERSION_API} -lm)
