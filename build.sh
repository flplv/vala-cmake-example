#!/bin/bash

mkdir -p .build && cd .build && cmake .. && make && ./my_project_unit_tests
