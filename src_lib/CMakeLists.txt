#
#
# Static Library Target: linked against main and against tests.

vala_precompile(MY_PROJECT_C_SOURCES
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
	my-project-${MY_PROJECT_VERSION_API}
GENERATE_VAPI
	my-project-${MY_PROJECT_VERSION_API}
)

add_library(my-project-${MY_PROJECT_VERSION_API}
	${MY_PROJECT_C_SOURCES}
)

set_target_properties ("my-project-${MY_PROJECT_VERSION_API}" PROPERTIES
  SOVERSION "${MY_PROJECT_SOVERSION_CURRENT}.${MY_PROJECT_SOVERSION_REVISION}.${MY_PROJECT_SOVERSION_AGE}"
  VERSION   "${MY_PROJECT_SOVERSION_CURRENT}.${MY_PROJECT_SOVERSION_REVISION}")
