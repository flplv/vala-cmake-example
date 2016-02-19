# FindVala.cmake
# © 2016 Evan Nemerson <evan@nemerson.com>
#
# This file contains functions which can be used to integrate Vala
# compilation with CMake.  It is intended as a replacement for Jakob
# Westhoff's FindVala.cmake and UseVala.cmake.  It uses fast-vapis for
# faster parallel compilation, and per-target directories for
# generated sources to allow reusing source files across, even with
# different options.

set(VALAC_NAMES valac)

set(_FIND_VALA_CURRENT_VERSION 98)
while(_FIND_VALA_CURRENT_VERSION GREATER 0)
  list(APPEND VALAC_NAME "valac-1.${_FIND_VALA_CURRENT_VERSION}")
  math(EXPR _FIND_VALA_CURRENT_VERSION "${_FIND_VALA_CURRENT_VERSION} - 2")
endwhile()
set(_FIND_VALA_CURRENT_VERSION 98)
while(_FIND_VALA_CURRENT_VERSION GREATER 0)
  list(APPEND VALAC_NAME "valac-1.${_FIND_VALA_CURRENT_VERSION}")
  math(EXPR _FIND_VALA_CURRENT_VERSION "${_FIND_VALA_CURRENT_VERSION} - 2")
endwhile()
unset(_FIND_VALA_CURRENT_VERSION)

find_program(VALA_EXECUTABLE
  NAMES ${VALAC_NAMES})
mark_as_advanced(VALA_EXECUTABLE)

unset(VALAC_NAMES)

# Determine the valac version
if(VALA_EXECUTABLE)
  execute_process(COMMAND ${VALA_EXECUTABLE} "--version"
    OUTPUT_VARIABLE VALA_VERSION)
  string(REGEX REPLACE "^.*Vala ([0-9]+\\.[0-9]+\\.[0-9]+(\\.[0-9]+(\\-[0-9a-f]+)?)?).*$" "\\1" VALA_VERSION "${VALA_VERSION}")
endif(VALA_EXECUTABLE)

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(Vala
    REQUIRED_VARS VALA_EXECUTABLE
    VERSION_VAR VALA_VERSION)

# _vala_destination_dir(target-dir destination source-file)
#
# Get destination path for a source file.  For files in the binary
# (build) tree this will be build/path/to/file, for files in the
# source tree it will be source/path/to/file, and for files outside of
# both the source and build trees it will be root/path/to/file.
macro(_vala_destination_dir destvar source)
  get_filename_component(srcfile "${source}" ABSOLUTE BASE_DIR "${CMAKE_CURRENT_SOURCE_DIR}")

  string(LENGTH "${CMAKE_BINARY_DIR}" dirlen)
  string(SUBSTRING "${srcfile}" 0 ${dirlen} tmp)
  if("${CMAKE_BINARY_DIR}" STREQUAL "${tmp}")
    string(SUBSTRING "${srcfile}" ${dirlen} -1 tmp)
    set(${destvar} "build${tmp}")
  else()
    string(LENGTH "${CMAKE_SOURCE_DIR}" dirlen)
    string(SUBSTRING "${srcfile}" 0 ${dirlen} tmp)
    if("${CMAKE_SOURCE_DIR}" STREQUAL "${tmp}")
      string(SUBSTRING "${srcfile}" ${dirlen} -1 tmp)
      set(${destvar} "source${tmp}")
    else ()
      # TODO: this probably doesn't work correctly on Windows…
      set(${destvar} "root${tmp}")
    endif()
  endif()

  unset(tmp)
  unset(dirlen)
  unset(srcfile)
endmacro()

# vala_precompile_target
#
# Options:
#
#   TARGET target
#     Name of the target you're generated; it's generally best to make
#     this the same as your executable or library target name, but not
#     technically required.
#   GENERATED_SOURCES varname
#     Variable in which to store the list of generated sources (which
#     you should pass to add_executable or add_library).
#   VAPI name.vapi
#     If you would like to have valac generate a VAPI (basically, if
#     you are generating a library not an executable), pass the file
#     name here.
#   GIR name-version.gir
#     If you would like to have valac generate a GIR, pass the file
#     name here.
#   HEADER name.h
#     If you would like to have valac generate a C header, pass the
#     file name here.
#   FLAGS …
#     List of flags you wish to pass to valac.  They will be added to
#     the flags in CMAKE_VALA_FLAGS and CMAKE_VALA_DEBUG_FLAGS (for
#     Debug builds) or CMAKE_VALA_RELEASE_FLAGS (for Release builds).
#   PACKAGES
#     List of dependencies to pass to valac.
macro(vala_precompile_target)
  set (options)
  set (oneValueArgs TARGET GENERATED_SOURCES VAPI GIR HEADER)
  set (multiValueArgs FLAGS PACKAGES)
  cmake_parse_arguments(VALAC "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})
  unset (options)
  unset (oneValueArgs)
  unset (multiValueArgs)

  # Generate extra targets (C header, VAPI, GIR, etc.)
  set(non_source_out_files)
  set(non_source_non_source_valac_args)

  if(VALAC_VAPI)
    list(APPEND out_files "${VALAC_VAPI}")
    list(APPEND non_source_valac_args "--vapi" "${VALAC_VAPI}")
  endif()

  if(VALAC_GIR)
    list(APPEND out_files "${VALAC_GIR}")
    list(APPEND non_source_valac_args
      "--gir" "${VALAC_GIR}"
      "--library" "${VALAC_TARGET}"
      "--shared-library" "${CMAKE_SHARED_LIBRARY_PREFIX}${VALAC_TARGET}${CMAKE_SHARED_LIBRARY_SUFFIX}")
  endif()

  if(VALAC_HEADER)
    list(APPEND non_source_out_files "${VALAC_HEADER}")
    list(APPEND non_source_valac_args "--header" "${VALAC_HEADER}")
  endif()

  set(TARGET_DIR "${CMAKE_CURRENT_BINARY_DIR}/${VALAC_TARGET}-vala")
  set(${VALAC_GENERATED_SOURCES})

  set(vapis)
  set(VALAFLAGS ${VALAC_FLAGS})
  foreach(pkg ${VALAC_PACKAGES})
    list(APPEND VALAFLAGS "--pkg" "${pkg}")
  endforeach()

  list(APPEND VALAFLAGS ${CMAKE_VALA_FLAGS})
  if (CMAKE_BUILD_TYPE MATCHES "Debug")
    list(APPEND VALAFLAGS ${CMAKE_VALA_FLAGS_DEBUG})
  elseif(CMAKE_BUILD_TYPE MATCHES "Release")
    list(APPEND VALAFLAGS ${CMAKE_VALA_FLAGS_RELEASE})
  endif()

  # Generate fast VAPI targets for each Vala file in the source list.
  foreach(source ${VALAC_UNPARSED_ARGUMENTS})
    get_filename_component(source_full "${source}" ABSOLUTE)
    string(REGEX MATCH "[^\\.]+$" extension "${source}")

    if("${extension}" STREQUAL "vala")
      get_filename_component(file_name_noext "${source}" NAME)
      string(REGEX REPLACE "\\.vala$" "" file_name_noext "${file_name_noext}")

      _vala_destination_dir(destpath "${source}")
      get_filename_component(destdir "${destpath}" DIRECTORY)

      file(MAKE_DIRECTORY "${TARGET_DIR}/fast-vapis/${destdir}")

      add_custom_command(OUTPUT "${TARGET_DIR}/fast-vapis/${destdir}/${file_name_noext}.vapi"
        COMMAND "${VALA_EXECUTABLE}"
        ARGS
          ${VALAFLAGS}
          "--fast-vapi" "${file_name_noext}.vapi"
          ${source_full}
        DEPENDS ${source_full}
        WORKING_DIRECTORY "${TARGET_DIR}/fast-vapis/${destdir}"
        COMMAND ${CMAKE_COMMAND} ARGS "-E" "touch" "${TARGET_DIR}/fast-vapis/${destdir}/${file_name_noext}.vapi")

      unset(file_name_noext)
      unset(destpath)
      unset(destdir)
    elseif("${extension}" STREQUAL "vapi")
      list(APPEND vapis "${source_full}")
    endif()

    unset(source_full)
    unset(extension)
  endforeach()

  # Generate C targets
  foreach(source ${VALAC_UNPARSED_ARGUMENTS})
    get_filename_component(source_full "${source}" ABSOLUTE)
    string(REGEX MATCH "[^\\.]+$" extension "${source}")

    if("${extension}" STREQUAL "vala")
      get_filename_component(file_name_noext "${source}" NAME)
      string(REGEX REPLACE "\\.vala$" "" file_name_noext "${file_name_noext}")

      _vala_destination_dir(destpath "${source}")
      get_filename_component(destdir "${destpath}" DIRECTORY)

      # Generate --use-fast-vapi flags for every Vala source file *except* for the current one
      set(fast_vapi_deps)
      set(fast_vapi_args)
      foreach(src ${VALAC_UNPARSED_ARGUMENTS})
        if(NOT "${src}" STREQUAL "${source}")
          string(REGEX MATCH "[^\\.]+$" ext "${src}")
          if("${ext}" STREQUAL "vala")
            _vala_destination_dir(fv_dep "${src}")
            string(REGEX REPLACE "\\.vala$" ".vapi" fv_dep "${TARGET_DIR}/fast-vapis/${fv_dep}")
            list(APPEND fast_vapi_args "--use-fast-vapi" "${fv_dep}")
            list(APPEND fast_vapi_deps "${fv_dep}")
            unset(fv_dep)
          endif()
          unset(ext)
        endif()
      endforeach()

      file(MAKE_DIRECTORY "${TARGET_DIR}/${destdir}")

      add_custom_command(OUTPUT "${TARGET_DIR}/${destdir}/${file_name_noext}.c"
        COMMAND "${VALA_EXECUTABLE}"
        ARGS
          ${VALAFLAGS}
          "-C"
          ${fast_vapi_args}
          ${source_full}
          ${vapis}
        DEPENDS
          ${fast_vapi_deps}
          ${source_full}
          ${vapis}
          # This is just to get these files to actually build;
          # dependencies from other places may or may not work.  For
          # example, an install command will not cause them to be
          # generated.
          ${non_source_out_files}
        WORKING_DIRECTORY "${TARGET_DIR}/${destdir}"
        COMMAND ${CMAKE_COMMAND} ARGS "-E" "touch" "${TARGET_DIR}/${destdir}/${file_name_noext}.c")
      list(APPEND ${VALAC_GENERATED_SOURCES} "${TARGET_DIR}/${destdir}/${file_name_noext}.c")

      unset(fast_vapi_name)
      unset(destdir)
      unset(destpath)
      unset(file_name_noext)
      unset(fast_vapi_args)
      unset(fast_vapi_deps)
    endif()

    unset(source_full)
    unset(extension)
  endforeach()

  if(non_source_out_files)
    set(fast_vapi_args)
    set(deps)
    foreach(source ${VALAC_UNPARSED_ARGUMENTS})
      get_filename_component(source_full "${source}" ABSOLUTE)
      string(REGEX MATCH "[^\\.]+$" extension "${source}")

      if("${extension}" STREQUAL "vala")
        _vala_destination_dir(fv_dep "${source}")
        string(REGEX REPLACE "\\.vala$" ".vapi" fv_dep "${TARGET_DIR}/fast-vapis/${fv_dep}")
        list(APPEND fast_vapi_args "--use-fast-vapi" "${fv_dep}")
        list(APPEND deps "${fv_dep}")
        unset(fv_dep)
      elseif("${extension}" STREQUAL "vapi")
        list(APPEND non_source_valac_args "${source_full}")
        list(APPEND deps "${source_full}")
      endif()
    endforeach()

    add_custom_command(OUTPUT ${non_source_out_files}
      COMMAND ${VALA_EXECUTABLE}
      ARGS
        ${VALAFLAGS}
        "-C"
        ${non_source_valac_args}
        ${fast_vapi_args}
        ${vapis}
      DEPENDS
        ${deps}
        ${vapis}
      COMMAND ${CMAKE_COMMAND} ARGS "-E" "touch" "${non_source_out_files}")

    unset(deps)
    unset(fast_vapi_args)
  endif()

  unset(non_source_valac_args)
  unset(non_source_out_files)
  unset(TARGET_DIR)
  unset(VALAFLAGS)
  unset(vapis)
endmacro()
