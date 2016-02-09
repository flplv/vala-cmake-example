[![Build Status](https://travis-ci.org/felipe-lavratti/vala-unittests-cmake.svg?branch=master)](https://travis-ci.org/felipe-lavratti/vala-unittests-cmake)

# Vala Project Template

This is a project template which provides a solid starting point for
creating a project based on Vala and CMake.  It includes support for
lots of features which can be difficult to get right and are often
broken in other projects.  It is divided into three basic components:

- **Library** (*my-project/*): By default, a shared library is built and
  installed.  If you don't want to create a public library you can
  easily change this to be a static library which is only used
  internally by the other components.
- **Unit tests** (*tests/*): Easily create tests for your common code
  using the testing framework created for
  [libgee](https://wiki.gnome.org/Projects/Libgee).
- **Executable** (*executables/*): Executables(s) that make use of
  your library.

Project-wide features include:

- [Travis CI](https://travis-ci.org/) integration.
- [Uncrustify](http://uncrustify.sourceforge.net/) support, including:
  - Automatic support for [Atom](https://atom.io/) editor with the
    [atom-beautify](https://atom.io/packages/atom-beautify) plugin
  - Checks in Travis CI to make sure new any changes adhere to the
    specified format.
- Automatic .gitignore generation.
- Release tarball generation (using
  [CPack](https://cmake.org/Wiki/CMake:Packaging_With_CPack)).
- i18n/l10n support via gettext.

There are pervasive comments throughout the template explaining what
each piece of code does and what your options are.

## Library

The library component is in the *my-project* directory for the
template, though obviously this should be changed to your project's
name.  It is where the vast majority of your code should reside.

### Shared Library

The default for this template is to build a shared library, which is
the most complicated part of this project.  It is also the part which
is easiest to get wrong, which many projects do.

Features supported by this template as part of generating the shared
library include:

- [Valadoc](https://wiki.gnome.org/Projects/Valadoc) support.
- Correct library versioning.
- Generating and installing a VAPI, C header, and
  [pkg-config](https://en.wikipedia.org/wiki/Pkg-config) file.

*my-project/CMakeLists.txt* is thoroughly commented and should explain
eveverything you need to know.

### Static Library

By default, this project will build and install a shared library which
can be used by other projects.  If you don't want this, you can easily
switch to building a static library instead of a shared library.

Static libraries allow you to easily share code between the
executable(s) and test(s), but *not* expose publicly, meaning you are
free to make incompatible API/ABI changes, and don't have to worry
about providing a nice API for anyone but yourself.

Directions for generating a static library are included in
*my-project/CMakeLists.txt*.  It basically consists of changing a
CMake function parameter from "SHARED" to "STATIC" and removing most
of the file contents.

## Tests

The *tests/* subdirectory includes a small example of how you can add
unit tests to your Vala project.  It links against the library and
uses the test runner code from libgee (which is in
*tests/test_case.vala*).

*tests/test_main.vala* and *tests/test_my_class.vala* are the files
you need to pay attention to.  You can also add additional tests
fairly easily; see *tests/CMakeLists.txt* for instructions.

## Executables

By default, a single executable (called *my-project*) will be built
and installed.  Like the tests, it links against the library.

The executable provides a short example of how to use the option
parser built in to GLib, which you can use to provide a good
command-line interface for your program.

## Internationalization and Localization

The project includes support for i18n/l10n through gettext.  A full
tutorial of how to manage gettext translations is outside the scope of
this document.  Detailed documentation is available from the
[GNU gettext manual](https://www.gnu.org/software/gettext/manual/index.html),
or a *brief* introduction can be found on the
[Wikipedia gettext article](https://en.wikipedia.org/wiki/Gettext).

To (re-)generate the pot file, simply run `make update-pot`.

# Special Thanks

This project uses a few pieces of other projects, thanks to:

- [TestCase Class](https://git.gnome.org/browse/libgee/tree/tests/testcase.vala)
  from Gee project
- [Vala CMake](https://github.com/jakobwesthoff/Vala_CMake) functions
- The
  [uncrustify configuration](https://github.com/PerfectCarl/elementary-uncrustify)
  from the Elementary project
