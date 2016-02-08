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
-

Atom editor is recommended with the following plugins:
- language-vala
- language-cmake
- atom-beautify (file .jsbeautifyrc and .uncrustify.vala.cfg are used to format code)

Special Thanks
--------------
This project uses a few pieces of other projects, thanks to:
- TestCase Class from Gee project
- Vala Cmake functions from https://github.com/jakobwesthoff/Vala_CMake
- The Elementary uncrustify config from https://github.com/PerfectCarl/elementary-uncrustify
