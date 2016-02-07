# CMake Valadoc support
# Copyright (c) 2016 Evan Nemerson <evan@nemerson.com>
#
# Permission is hereby granted, free of charge, to any person
# obtaining a copy of this software and associated documentation files
# (the "Software"), to deal in the Software without restriction,
# including without limitation the rights to use, copy, modify, merge,
# publish, distribute, sublicense, and/or sell copies of the Software,
# and to permit persons to whom the Software is furnished to do so,
# subject to the following conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
# BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
# ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
# CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

include(FindValadoc)

# Valadoc
#
# The signature for this is based on the signature for the
# vala_precompile function, mainly to make it easier to learn as
# people are likely already using that function.  I'm too lazy to
# document (patches welcome) this, just look at the vala_precompile
# docs.
#
# Options:
#  * DOCLET [default = html]
#  * SOURCES
#  * PACKAGES
#  * OPTIONS
#  * DEFINITIONS
#  * CUSTOM_VAPIS
#  * PACKAGE_NAME
#  * PACKAGE_VERSION
function(valadoc_generate OUTPUT_DIR)
  set (options ALL)
  set (oneValueArgs DOCLET PACKAGE_NAME PACKAGE_VERSION)
  set (multiValueArgs SOURCES PACKAGES OPTIONS DEFINITIONS CUSTOM_VAPIS)
  cmake_parse_arguments(VALADOC "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})
  unset (options)
  unset (oneValueArgs)
  unset (multiValueArgs)

  set(VALADOC_ARGS)

  if("${VALADOC_DOCLET}" STREQUAL "")
    list(APPEND VALADOC_ARGS "--doclet=html")
  else()
    list(APPEND VALADOC_ARGS "--doclet=${VALADOC_DOCLET}")
  endif()

  if(NOT "${VALADOC_PACKAGE_NAME}" STREQUAL "")
    list(APPEND VALADOC_ARGS "--package-name=${VALADOC_PACKAGE_NAME}")
  endif()

  if(NOT "${VALADOC_PACKAGE_VERSION}" STREQUAL "")
    list(APPEND VALADOC_ARGS "--package-version=${VALADOC_PACKAGE_VERSION}")
  endif()

  # list(APPEND VALADOC_ARGS ${CMAKE_VALA_FLAGS})
  # if (CMAKE_BUILD_TYPE MATCHES "Debug")
  #   list(APPEND VALADOC_ARGS ${CMAKE_VALA_FLAGS_DEBUG})
  # elseif(CMAKE_BUILD_TYPE MATCHES "Release")
  #   list(APPEND VALADOC_ARGS ${CMAKE_VALA_FLAGS_RELEASE})
  # endif()
  # list(APPEND VALADOC_ARGS ${VALADOC_OPTIONS})

  foreach(pkg ${VALADOC_PACKAGES})
    list(APPEND VALADOC_ARGS "--pkg=${pkg}")
  endforeach(pkg)

  add_custom_command(
    OUTPUT "${OUTPUT_DIR}"
    COMMAND "${VALADOC_EXECUTABLE}"
    ARGS
      --force
      -o "${CMAKE_CURRENT_BINARY_DIR}/${OUTPUT_DIR}"
      ${VALADOC_ARGS}
      ${VALADOC_SOURCES}
    DEPENDS
      ${VALADOC_SOURCES}
    COMMENT "Generating documentation with Valadoc"
    WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR})

  if(NOT ${VALADOC_ALL})
    add_custom_target(doc DEPENDS "${OUTPUT_DIR}")
  else()
    add_custom_targeT(doc ALL DEPENDS "${OUTPUT_DIR}")
  endif()
endfunction()
