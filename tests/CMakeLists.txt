#
#
# Unit Tests Target

vala_precompile(VALA_UNIT_TESTS_C
	test_case.vala
	test_main.vala
    test_my_class.vala
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

add_executable(my_project_unit_tests
  	${VALA_UNIT_TESTS_C}
)
target_link_libraries(my_project_unit_tests _my_project -lm)

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
