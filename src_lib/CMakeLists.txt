#
#
# Static Library Target: linked against main and against tests.

vala_precompile(VALA_C
	my_class.vala
PACKAGES
	gio-2.0
    gee-0.8
	posix
OPTIONS
    --target-glib=2.44
	--thread
	--debug
GENERATE_HEADER
	../bin/my_project
GENERATE_VAPI
	../bin/my_project
)

add_library(_my_project
	STATIC
    EXCLUDE_FROM_ALL
	${VALA_C} my_project.h
)
