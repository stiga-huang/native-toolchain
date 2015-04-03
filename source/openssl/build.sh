#!/usr/bin/env bash
# Copyright 2012 Cloudera Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# cleans and rebuilds thirdparty/. The Impala build environment must be set up
# by bin/impala-config.sh before running this script.

# Exit on non-true return value
set -e
# Exit on reference to uninitialized variable
set -u

source $SOURCE_DIR/functions.sh
THIS_DIR="$( cd "$( dirname "$0" )" && pwd )"
prepare $THIS_DIR

if needs_build_package ; then
  header $PACKAGE $PACKAGE_VERSION

  CFLAGS="-fPIC -DPIC" CXXFLAGS="$CXXFLAGS -fPIC -DPIC" ./config shared zlib --prefix=$LOCAL_INSTALL >> $BUILD_LOG 2>&1

  # For some reason, the first build seems to fail sometimes
  (make -j${IMPALA_BUILD_THREADS:-4} all || true) >> $BUILD_LOG 2>&1 
  make -j${IMPALA_BUILD_THREADS:-4} all >> $BUILD_LOG 2>&1
  make install >> $BUILD_LOG 2>&1

  footer $PACKAGE $PACKAGE_VERSION
fi