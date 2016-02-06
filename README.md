Project Template for *Vala + Unittests + Cmake*
===============================================

This is a project template.
 
The built is divided in 3 targets: 

- the static library (src_lib): where all project gode goes and generate a .a file.
- the tests build (tests): the lib is linked with the tests and a test binary is built.
- the project build (src_main): where the lib is linked with the main function and the project is built.

Have fun!

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
