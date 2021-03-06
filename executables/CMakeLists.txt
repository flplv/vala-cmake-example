#
#
# Main target

# Compile Vala sources to C
vala_precompile_target(
  "${PROJECT_NAME}-vala"
  MY_PROJECT_MAIN_SOURCES
  ${CMAKE_BINARY_DIR}/my-project/my-project-${MY_PROJECT_VERSION_API}.vapi
  main.vala
  DEPENDS "${MY_PROJECT_LIBRARY_NAME}-vala")

# Tell CMake to create an executable named "my-project"
add_executable(${PROJECT_NAME}
	${MY_PROJECT_MAIN_SOURCES})

# Make sure the Vala sources are compiled to C before attempting to
# build the executable.
add_dependencies("${PROJECT_NAME}" "${PROJECT_NAME}-vala")

# We need to add the directory where the C header for our library is
# installed, otherwise we'll get an error from the C compiler.
set_target_properties(${PROJECT_NAME} PROPERTIES
	INCLUDE_DIRECTORIES ${CMAKE_BINARY_DIR}/my-project)

# Any libraries that your tests need to link to should go here.
# Usually this will just be your library.
target_link_libraries(${PROJECT_NAME}
    ${MY_PROJECT_LIBRARY_NAME})

# Install the executable.
install (TARGETS ${PROJECT_NAME}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR})

# Generate a .gitignore
file(WRITE  ".gitignore" "# Automatically generated by CMake, do not modify.\n")
foreach(file
    ".gitignore"
    "my-project${CMAKE_EXECUTABLE_SUFFIX}")
  file(APPEND ".gitignore" "/${file}\n")
endforeach(file)
foreach(file ${MY_PROJECT_MAIN_SOURCES})
  string(REPLACE "${CMAKE_CURRENT_BINARY_DIR}/" "" file ${file})
  file(APPEND ".gitignore" "/${file}\n")
endforeach(file)
