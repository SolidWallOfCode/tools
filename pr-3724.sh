#!/usr/bin/env bash
if [ ! -d include ] ; then mkdir include ; fi
if [ ! -d include/ts ] ; then git mv proxy/api/ts include ; fi
if [ ! -d include/tscore ] ; then mkdir include/tscore ; fi
if [ ! -d include/tscpp ] ; then mkdir include/tscpp ; fi
if [ ! -d include/tscpp/api ] ; then
	git mv lib/cppapi/include/atscppapi include/tscpp
	git mv include/tscpp/atscppapi include/tscpp/api
fi
if [ ! -d include/tscpp/util ] ; then mkdir include/tscpp/util ; fi
if [ ! -f include/tscore/IntrusiveDList.h ] ; then git mv lib/ts/*.h include/tscore ; fi
if [ -f include/tscore/TextView.h ] ; then git mv include/tscore/TextView.h include/tscpp/util ; fi
if [ -f include/tscore/PostScript.h ] ; then git mv include/tscore/PostScript.h include/tscpp/util ; fi

# Library source fixups
if [ -d lib/ts ] ; then git mv lib/ts src/tscore ; fi
if [ ! -d src/tscpp ] ; then mkdir src/tscpp ; fi
if [ ! -d src/tscpp/util ] ; then mkdir src/tscpp/util ; fi
if [ -f src/tscore/TextView.cc ] ; then git mv src/tscore/TextView.cc src/tscpp/util ; fi
if [ -f src/tscore/apidefs.h.in ] ; then git mv src/tscore/apidefs.h.in include/ts ; fi
if [ -f src/tscore/ink_config.h.in ] ; then git mv src/tscore/ink_config.h.in include/tscore ; fi

# Fix up unit-tests
if [ -d src/tscore/unit-tests ] ; then git mv src/tscore/unit-tests src/tscore/unit_tests ; fi
if [ -d iocore/eventsystem/unit-tests ] ; then git mv iocore/eventsystem/unit-tests iocore/eventsystem/unit_tests ; fi
if [ -d proxy/http/unit-tests ] ; then git mv proxy/http/unit-tests proxy/http/unit_tests ; fi
if [ -d plugins/s3_auth/unit-tests ] ; then git mv plugins/s3_auth/unit-tests plugins/s3_auth/unit_tests ; fi
if [ -d plugins/experimental/access_control/unit-tests ] ; then git mv plugins/experimental/access_control/unit-tests plugins/experimental/access_control/unit_tests ; fi

if [ ! -d src/tscpp/util/unit_tests ] ; then mkdir src/tscpp/util/unit_tests ; fi
if [ ! -f src/tscpp/util/unit_tests/unit_test_main.cc ] ; then cp src/tscore/unit_tests/unit_test_main.cc src/tscpp/util/unit_tests ; fi
if [ -f src/tscore/unit_tests/test_TextView.cc ] ; then git mv src/tscore/unit_tests/test_TextView.cc src/tscpp/util/unit_tests ; fi
if [ -f src/tscore/unit_tests/test_PostScript.cc ] ; then git mv src/tscore/unit_tests/test_PostScript.cc src/tscpp/util/unit_tests ; fi

if [ -d lib/cppapi ] ; then git mv lib/cppapi src/tscpp/ ; git mv src/tscpp/cppapi src/tscpp/api ; fi
if [ -f src/tscpp/api/include/logging_internal.h ] ; then
  git mv src/tscpp/api/include/logging_internal.h src/tscpp/api
fi
if [ -f src/tscpp/api/include/utils_internal.h ] ; then
  git mv src/tscpp/api/include/utils_internal.h src/tscpp/api
fi

if [ -d lib/wccp ] ; then git mv lib/wccp src/wccp ; fi
if [ ! -d include/wccp ] ; then mkdir include/wccp ; fi
if [ -f src/wccp/Wccp.h ] ; then git mv src/wccp/Wccp.h include/wccp ; fi

sed -i -e 's!libtsutil!libtscore!' CMakeLists.txt
sed -i -e 's!lib/ts/!src/tscore/!' CMakeLists.txt
sed -i -e 's!lib/wccp/!src/wccp/!' CMakeLists.txt
sed -i -e 's!src/wccp/Wccp.h!include/wccp/Wccp.h!' CMakeLists.txt
sed -i -e 's!unit-tests!unit_tests!' CMakeLists.txt
sed -i -E -e 's!src/tscore/([^.]+[.]h)!include/tscore/\1!' CMakeLists.txt
sed -i -E -e 's!test_tslib!test_tscore!' CMakeLists.txt
sed -i -E -e '\!lib/cppapi/!d' CMakeLists.txt
sed -i -e '/TextView.cc/d' CMakeLists.txt

# Adjust makefiles
find . \( -name 'Makefile.am' -o -name 'Makefile.inc' \) -exec sed -i -E -e 's/unit-tests/unit_tests/g' {} \;
find . \( -name 'Makefile.am' -o -name 'Makefile.inc' \) -exec sed -i -E -e 's!-I[$][(]abs_top_srcdir[)]/lib!-I$(abs_top_srcdir)/include!g' {} \;
find . \( -name 'Makefile.am' -o -name 'Makefile.inc' \) -exec sed -i -E -e 's!lib/ts/libtsutil.la!src/tscore/libtscore.la!g' {} \;
find . \( -name 'Makefile.am' -o -name 'Makefile.inc' \) -exec sed -i -E -e 's!/lib/wccp/libwccp!/src/wccp/libwccp!g' {} \;

# One un-fixup for include paths.
sed -i -E -e '/-I/s!/include/yamlcpp!/lib/yamlcpp!' lib/yamlcpp/Makefile.am

sed -i -E -e '/^SUBDIRS/s! proxy/api/ts lib! src/tscpp/util lib src/tscore!' Makefile.am
sed -i -E -e '/^SUBDIRS/s!$! include!' Makefile.am
sed -i -E -e '\!proxy/api/ts!d' Makefile.am

if ! grep --quiet 'noinst_PROGRAMS' src/Makefile.am ; then
  sed -i -E -e '/TESTS =/a\
noinst_PROGRAMS =' src/Makefile.am
fi

if ! grep --quiet 'lib_LTLIBRARIES' src/Makefile.am ; then
  sed -i -E -e '/TESTS =/a\
lib_LTLIBRARIES =' src/Makefile.am
fi

sed -i -E -e 's!ts records tsconfig cppapi!records tsconfig!' lib/Makefile.am
sed -i -E -e '/if BUILD_WCCP/,+3d' lib/Makefile.am
if ! grep --quiet 'tscpp' src/Makefile.am ; then
    sed -i -E -e '/noinst_PROGRAMS =/a\
\
SUBDIRS = tscpp/api' src/Makefile.am
fi

sed -i -E -e '/if BUILD_WCCP/,+4d' src/Makefile.am
sed -i -E -e '\!SUBDIRS!a\
\
if BUILD_WCCP \
SUBDIRS += wccp \
include traffic_wccp/Makefile.inc \
endif' src/Makefile.am

sed -i -E -e '/test_cache_SOURCES/,+8d' src/wccp/Makefile.am

sed -i -E -e '/library_include_HEADERS/,+1d' src/tscore/Makefile.am
sed -i -E -e 's/test_tsutil/test_libtscore/g' src/tscore/Makefile.am
sed -i -E -e 's/test_tslib/test_tscore/g' src/tscore/Makefile.am
sed -i -E -e 's/tsutil/tscore/g' src/tscore/Makefile.am
sed -i -E -e '/TextView/d' src/tscore/Makefile.am
sed -i -E -e '/PostScript/d' src/tscore/Makefile.am
sed -i -E -e 's!test_scoped_resource.cc \\!test_scoped_resource.cc!' src/tscore/Makefile.am

sed -i -E -e 's! api/ts Makefile.am! include/ts Makefile.am!' include/ts/Makefile.am
sed -i -E -e '\!ts[.]h!i\
\tapidefs.h \\' include/ts/Makefile.am

cat > src/tscpp/util/Makefile.am <<'HERE'
# tscpp/util Makefile.am
#
#  Licensed to the Apache Software Foundation (ASF) under one
#  or more contributor license agreements.  See the NOTICE file
#  distributed with this work for additional information
#  regarding copyright ownership.  The ASF licenses this file
#  to you under the Apache License, Version 2.0 (the
#  "License"); you may not use this file except in compliance
#  with the License.  You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
#  Unless required by applicable law or agreed to in writing, software
#  distributed under the License is distributed on an "AS IS" BASIS,
#  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#  See the License for the specific language governing permissions and
#  limitations under the License.

check_PROGRAMS = test_tscpputil

TESTS = $(check_PROGRAMS)

lib_LTLIBRARIES = libtscpputil.la

AM_CPPFLAGS += -I$(abs_top_srcdir)/include

libtscpputil_la_LDFLAGS = -no-undefined -version-info @TS_LIBTOOL_VERSION@

libtscpputil_la_SOURCES = \
	PostScript.h \
	TextView.h TextView.cc

test_tscpputil_CPPFLAGS = $(AM_CPPFLAGS)\
	-I$(abs_top_srcdir)/tests/include

test_tscpputil_CXXFLAGS = -Wno-array-bounds $(AM_CXXFLAGS)
test_tscpputil_LDADD = libtscpputil.la
test_tscpputil_SOURCES = \
	unit_tests/unit_test_main.cc \
	unit_tests/test_PostScript.cc \
	unit_tests/test_TextView.cc

clean-local:
	rm -f ParseRulesCType ParseRulesCTypeToLower ParseRulesCTypeToUpper

clang-tidy-local: $(DIST_SOURCES)
	$(CXX_Clang_Tidy)

HERE

cat > include/tscpp/util/Makefile.am << 'HERE'
# include/tscpp/util Makefile.am
#
#  Licensed to the Apache Software Foundation (ASF) under one
#  or more contributor license agreements.  See the NOTICE file
#  distributed with this work for additional information
#  regarding copyright ownership.  The ASF licenses this file
#  to you under the Apache License, Version 2.0 (the
#  "License"); you may not use this file except in compliance
#  with the License.  You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
#  Unless required by applicable law or agreed to in writing, software
#  distributed under the License is distributed on an "AS IS" BASIS,
#  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#  See the License for the specific language governing permissions and
#  limitations under the License.

library_includedir=$(includedir)/tscpp/util

library_include_HEADERS = \
        PostScript.h \
        TextView.h
HERE

# tscpp/api
if ! grep --quiet 'AM_CPPFLAGS' src/tscpp/api/Makefile.am ; then
    sed -i -E -e '/lib_LTLIBRARIES/a \
\
libtscppapi_la_CPPFLAGS = $(AM_CPPFLAGS) -I $(abs_top_srcdir)/include \
' src/tscpp/api/Makefile.am
fi
sed -i -E -e 's/atscppapi/tscppapi/g' src/tscpp/api/Makefile.am
sed -i -E -e '/include ..top_srcdir/,+1d' src/tscpp/api/Makefile.am
sed -i -E -e '/tidy.mk/i\
MARKY_MARK' src/tscpp/api/Makefile.am
sed -i -E -e '/library_includedir/,/MARKY_MARK/d' src/tscpp/api/Makefile.am

## Get the include set up for install.

cat > include/Makefile.am << 'HERE'
# include Makefile.am
#
#  Licensed to the Apache Software Foundation (ASF) under one
#  or more contributor license agreements.  See the NOTICE file
#  distributed with this work for additional information
#  regarding copyright ownership.  The ASF licenses this file
#  to you under the Apache License, Version 2.0 (the
#  "License"); you may not use this file except in compliance
#  with the License.  You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
#  Unless required by applicable law or agreed to in writing, software
#  distributed under the License is distributed on an "AS IS" BASIS,
#  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#  See the License for the specific language governing permissions and
#  limitations under the License.

SUBDIRS = ts tscpp/api tscpp/util
HERE

cat > include/tscpp/api/Makefile.am << 'HERE'
#
#  Licensed to the Apache Software Foundation (ASF) under one
#  or more contributor license agreements.  See the NOTICE file
#  distributed with this work for additional information
#  regarding copyright ownership.  The ASF licenses this file
#  to you under the Apache License, Version 2.0 (the
#  "License"); you may not use this file except in compliance
#  with the License.  You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
#  Unless required by applicable law or agreed to in writing, software
#  distributed under the License is distributed on an "AS IS" BASIS,
#  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#  See the License for the specific language governing permissions and
#  limitations under the License.

library_includedir = $(includedir)/tscpp/api

library_include_HEADERS = \
        Async.h \
        AsyncHttpFetch.h \
        AsyncTimer.h \
        CaseInsensitiveStringComparator.h \
        ClientRequest.h \
        Continuation.h \
        GlobalPlugin.h \
        GzipDeflateTransformation.h \
        GzipInflateTransformation.h \
        Headers.h \
        HttpMethod.h \
        HttpStatus.h \
        HttpVersion.h \
        InterceptPlugin.h \
        Logger.h \
        Plugin.h \
        PluginInit.h \
        RemapPlugin.h \
        Request.h \
        Response.h \
        Stat.h \
        Transaction.h \
        TransactionPlugin.h \
        TransformationPlugin.h \
        Url.h \
        noncopyable.h \
        utils.h
HERE

sed -i -E -e 's!lib/cppapi/Makefile!src/tscpp/api/Makefile!' configure.ac
sed -i -E -e '\!lib/ts/Makefile!d' configure.ac
sed -i -E -e '\!proxy/api/ts/Makefile!d' configure.ac
sed -i -E -e 's!lib/ts/apidefs.h!include/ts/apidefs.h!' configure.ac
sed -i -E -e 's!lib/ts/ink_config.h!include/tscore/ink_config.h!' configure.ac
sed -i -E -e '\!rc/trafficserver.xml!a\
  src/tscpp/util/Makefile \
  src/tscore/Makefile' configure.ac
sed -i -E -e 's!lib/wccp/Makefile!src/wccp/Makefile!' configure.ac
sed -i -E -e '\!example/Makefile!a\
  include/Makefile \
  include/ts/Makefile \
  include/tscpp/api/Makefile \
  include/tscpp/util/Makefile' configure.ac

# include path fixups - do top level dirs explicitly to avoid conflicts in plugins vs. core about "ts/".
find . \( -name '*.cc' -o -name '*.h' \) -exec sed -i -E -e 's!api/ts/!ts/!' {} \;
find . \( -name '*.cc' -o -name '*.h' \) -exec sed -i -E -e 's!"atscppapi/!"tscpp/api/!' {} \;
find . \( -name '*.cc' -o -name '*.h' \) -exec sed -i -E -e 's!<atscppapi/([_[:alnum:]]+)[.]h>!"tscpp/api/\1.h"!' {} \;

find src \( -name '*.cc' -o -name '*.h' \) -exec sed -i -E -e 's!include .ts/([+_[:alnum:]]+)[.]h.!include "tscore/\1.h"!' {} \;
find tools \( -name '*.cc' -o -name '*.h' -o -name '*.c' \) -exec sed -i -E -e 's!include .ts/([+_[:alnum:]]+)[.]h.!include "tscore/\1.h"!' {} \;
find lib \( -name '*.cc' -o -name '*.h' -o -name '*.y' \) -exec sed -i -E -e 's!include .ts/([+_[:alnum:]]+)[.]h.!include "tscore/\1.h"!' {} \;
find include/tscore \( -name '*.cc' -o -name '*.h' \) -exec sed -i -E -e 's!include .ts/([+_[:alnum:]]+)[.]h.!include "tscore/\1.h"!' {} \;
find include/wccp \( -name '*.cc' -o -name '*.h' \) -exec sed -i -E -e 's!include .ts/([+_[:alnum:]]+)[.]h.!include "tscore/\1.h"!' {} \;
find iocore \( -name '*.cc' -o -name '*.h' \) -exec sed -i -E -e 's!include .ts/([+_[:alnum:]]+)[.]h.!include "tscore/\1.h"!' {} \;
find mgmt \( -name '*.cc' -o -name '*.h' \) -exec sed -i -E -e 's!include .ts/([+_[:alnum:]]+)[.]h.!include "tscore/\1.h"!' {} \;
find proxy \( -name '*.cc' -o -name '*.h' \) -exec sed -i -E -e 's!include .ts/([+_[:alnum:]]+)[.]h.!include "tscore/\1.h"!' {} \;
# file specific fixups.
find iocore \( -name '*.cc' -o -name '*.h' \) -exec sed -i -E -e 's!I_RecProcess.h!records/I_RecProcess.h!' {} \;
find iocore \( -name '*.cc' -o -name '*.h' \) -exec sed -i -E -e 's!"I_RecHttp.h"!"records/I_RecHttp.h"!' {} \;
find iocore \( -name '*.cc' -o -name '*.h' \) -exec sed -i -E -e 's!P_RecCore.h!records/P_RecCore.h!' {} \;
find proxy  \( -name '*.cc' -o -name '*.h' \) -exec sed -i -E -e 's!I_RecCore.h!records/I_RecCore.h!' {} \;
find proxy  \( -name '*.cc' -o -name '*.h' \) -exec sed -i -E -e 's!P_RecCore.h!records/P_RecCore.h!' {} \;
find proxy  \( -name '*.cc' -o -name '*.h' \) -exec sed -i -E -e 's!P_RecProcess.h!records/P_RecProcess.h!' {} \;
find proxy  \( -name '*.cc' -o -name '*.h' \) -exec sed -i -E -e 's!P_RecUtils.h!records/P_RecUtils.h!' {} \;
find proxy  \( -name '*.cc' -o -name '*.h' \) -exec sed -i -E -e 's!"P_RecDefs.h"!"records/P_RecDefs.h"!' {} \;
find mgmt   \( -name '*.cc' -o -name '*.h' \) -exec sed -i -E -e 's![<"]P_RecCore.h[">]!"records/P_RecCore.h"!' {} \;
find mgmt   \( -name '*.cc' -o -name '*.h' \) -exec sed -i -E -e 's!"I_RecLocal.h"!"records/I_RecLocal.h"!' {} \;
find src    \( -name '*.cc' -o -name '*.h' \) -exec sed -i -E -e 's!"I_RecLocal.h"!"records/I_RecLocal.h"!' {} \;
find src    \( -name '*.cc' -o -name '*.h' \) -exec sed -i -E -e 's!"P_RecLocal.h"!"records/P_RecLocal.h"!' {} \;
find src    \( -name '*.cc' -o -name '*.h' \) -exec sed -i -E -e 's!"I_RecProcess.h"!"records/I_RecProcess.h"!' {} \;
find src    \( -name '*.cc' -o -name '*.h' \) -exec sed -i -E -e 's!"I_RecCore.h"!"records/I_RecCore.h"!' {} \;
find src    \( -name '*.cc' -o -name '*.h' \) -exec sed -i -E -e 's![<"]P_RecUtils.h[">]!"records/P_RecUtils.h"!' {} \;
find src    \( -name '*.cc' -o -name '*.h' \) -exec sed -i -E -e 's![<"]I_RecDefs.h[">]!"records/I_RecDefs.h"!' {} \;

find doc    \( -name '*.rst' \) -exec sed -i -E -e 's!lib/ts/unit-tests!src/tscore/unit_tests!' {} \;

# Easier to repair these than to get it right the first time.
find . \( -name '*.cc' -o -name '*.h' \) -exec sed -i -E -e 's!tscore/TextView.h!tscpp/util/TextView.h!' {} \;
find . \( -name '*.cc' -o -name '*.h' \) -exec sed -i -E -e 's!tscore/PostScript.h!tscpp/util/PostScript.h!' {} \;
find . \( -name '*.cc' -o -name '*.h' \) -exec sed -i -E -e 's!tscore/ts[.]h!ts/ts.h!' {} \;
find . \( -name '*.cc' -o -name '*.h' \) -exec sed -i -E -e 's!tscore/apidefs.h!ts/apidefs.h!' {} \;
find . \( -name '*.cc' -o -name '*.h' \) -exec sed -i -E -e 's!tscore/InkAPIPrivateIOCore.h!ts/InkAPIPrivateIOCore.h!' {} \;
find . \( -name '*.cc' -o -name '*.h' \) -exec sed -i -E -e 's!tscore/experimental.h!ts/experimental.h!' {} \;
find . \( -name '*.cc' -o -name '*.h' \) -exec sed -i -E -e 's!tscore/remap.h!ts/remap.h!' {} \;
# Nasty little files that have to be hand done.
sed -i -E -e 's![.][.]/lib/ts/ink_hrtime.h!tscore/ink_hrtime.h!' proxy/Milestones.h
sed -i -E -e 's!"AcidPtr.h"!"tscore/AcidPtr.h"!' src/tscore/AcidPtr.cc
sed -i -E -e 's!"BaseLogFile.h"!"tscore/BaseLogFile.h"!' src/tscore/BaseLogFile.cc
sed -i -E -e 's!"ConsistentHash.h"!"tscore/ConsistentHash.h"!' src/tscore/ConsistentHash.cc
sed -i -E -e 's!"ContFlags.h"!"tscore/ContFlags.h"!' src/tscore/ContFlags.cc
sed -i -E -e 's!"ink_assert.h"!"tscore/ink_assert.h"!' src/tscore/InkErrno.cc
sed -i -E -e 's!"InkErrno.h"!"tscore/InkErrno.h"!' src/tscore/InkErrno.cc
sed -i -E -e '/"ink_inet.h"/d' src/tscore/ink_inet.cc
sed -i -E -e 's!"tscore/TextView.h"!"tscpp/util/TextView.h"!' src/tscpp/util/TextView.cc
sed -i -E -e 's!"ink_inet.h"!"tscore/ink_inet.h"!' src/tscore/IpMap.cc
sed -i -E -e 's!"tscore/TextView.h"!"tscore/tscpp/util/TextView.h"!' src/tscore/IpMap.cc
sed -i -E -e 's!"ink_defs.h"!"tscore/ink_defs.h"!' src/tscore/SourceLocation.cc
sed -i -E -e 's!"SourceLocation.h"!"tscore/SourceLocation.h"!' src/tscore/SourceLocation.cc
sed -i -E -e 's!"runroot.h"!"tscore/runroot.h"!' src/tscore/runroot.cc
sed -i -E -e 's!"tscore/TsException.h"!"ts/TsException.h"!' src/wccp/WccpMsg.cc
sed -i -E -e 's!"Wccp[.]h"!"wccp/Wccp.h"!' src/wccp/WccpLocal.h
sed -i -E -e 's!"Wccp[.]h"!"wccp/Wccp.h"!' src/wccp/WccpUtil.h
sed -i -E -e 's!"WccpUtil[.]h"!"wccp/WccpUtil.h"!' src/traffic_wccp/wccp_client.cc
sed -i -E -e 's!"[.][.]/[.][.]/proxy/IPAllow.h"!"IPAllow.h"!' proxy/http/remap/RemapConfig.cc
sed -i -E -e 's!"PriorityQueue.h"!"tscore/PriorityQueue.h"!' src/tscore/test_PriorityQueue.cc
sed -i -E -e 's!"BufferWriter.h"!"tscore/BufferWriter.h"!' src/tscore/unit_tests/test_History.cc

# Linking fixups
sed -i -E -e '\!traffic_api_cli_remote_LDADD!,\![$][(]top_builddir[])]/src/tscore/libtscore.la \\!a\
	$(top_builddir)/src/tscpp/util/libtscpputil.la \\' mgmt/api/Makefile.am

sed -i -E -e '\!libtscore.la \\!a\
	$(top_builddir)/src/tscpp/util/libtscpputil.la \\' src/traffic_via/Makefile.inc

sed -i -E -e '\!libtscore.la \\!a\
\t$(top_builddir)/src/tscpp/util/libtscpputil.la \\' src/traffic_manager/Makefile.inc

sed -i -E -e 's!..top_builddir./src/wccp/libwccp.a!wccp/libwccp.a!' src/traffic_manager/Makefile.inc

sed -i -E -e '\!libtscore.la \\!a\
\t$(top_builddir)/src/tscpp/util/libtscpputil.la \\' src/traffic_server/Makefile.inc

sed -i -E -e '\!libtscore.la$!s![.]la!.la \\\
\t$(top_builddir)/src/tscpp/util/libtscpputil.la!' src/traffic_logstats/Makefile.inc

sed -i -E -e '\!libtscore.la \\!a\
\t$(top_builddir)/src/tscpp/util/libtscpputil.la \\' src/traffic_crashlog/Makefile.inc

sed -i -E -e '\!libtscore.la \\!a\
\t$(top_builddir)/src/tscpp/util/libtscpputil.la \\' src/traffic_ctl/Makefile.inc

sed -i -E -e '\!libtscore.la \\!a\
\t$(top_builddir)/src/tscpp/util/libtscpputil.la \\' src/traffic_layout/Makefile.inc

sed -i -E -e '\!libtscore.la$!s![.]la!.la \\\
\t$(top_builddir)/src/tscpp/util/libtscpputil.la!' src/traffic_logcat/Makefile.inc

sed -i -E -e '\!libtscore.la \\!a\
\t$(top_builddir)/src/tscpp/util/libtscpputil.la \\' src/traffic_top/Makefile.inc

sed -i -E -e '\!libtscore.la \\!a\
\t$(top_builddir)/src/tscpp/util/libtscpputil.la \\' src/traffic_wccp/Makefile.inc

sed -i -E -e 's!/lib/cppapi/libatscppapi.la!/src/tscpp/api/libtscppapi.la!' plugins/test_cppapi/Makefile.inc
sed -i -E -e '/_la_LDFLAGS/,$d' plugins/experimental/server_push_preload/Makefile.inc
sed -i -E -e '$ a\
experimental_server_push_preload_server_push_preload_la_LDFLAGS = \\\
  $(AM_LDFLAGS) \
\
experimental_server_push_preload_server_push_preload_la_LIBADD = \\\
  $(top_builddir)/src/tscpp/api/libtscppapi.la \
' plugins/experimental/server_push_preload/Makefile.inc

sed -i -E -e 's`/lib/ts/[.]libs`/src/tscore/.libs`' src/traffic_cache_tool/Makefile.inc
sed -i -E -e 's`/src/tscore/.libs/TextView.o`/src/tscpp/util/.libs/TextView.o`' src/traffic_cache_tool/Makefile.inc
sed -i -E -e 's`-I ..top_srcdir./lib`-I $(abs_top_srcdir)/include`' src/traffic_cache_tool/Makefile.inc
sed -i -E -e 's`[.][.]/[.][.]/lib/ts/apidefs.h`ts/apidefs.h`' plugins/header_rewrite/operators.cc

sed -i -E -e 's! -lssl! $(top_builddir)/src/tscpp/util/libtscpputil.la -lssl!' tools/Makefile.am

sed -i -E -e 's!^libatscppapi.*$!libtscppapi = $(top_builddir)/src/tscpp/api/libtscppapi.la!' example/Makefile.am

sed -i -E -e 's!(/src/tscore/libtscore.la)!\1 $(top_builddir)/src/tscpp/util/libtscpputil.la!' lib/tsconfig/Makefile.am
sed -i -E -e 's!LDADD = libtscore.la!LDADD = libtscore.la $(top_builddir)/src/tscpp/util/libtscpputil.la!' src/tscore/Makefile.am
sed -i -E -e 's!(src/tscore/libtscore.la)!\1 $(top_builddir)/src/tscpp/util/libtscpputil.la!' iocore/eventsystem/Makefile.am
sed -i -E -e 's!(src/tscore/libtscore.la)!\1 $(top_builddir)/src/tscpp/util/libtscpputil.la!' iocore/net/Makefile.am
sed -i -E -e 's!(src/tscore/libtscore.la)!\1 \\\
\t$(top_builddir)/src/tscpp/util/libtscpputil.la!' iocore/aio/Makefile.am
sed -i -E -e 's!(src/tscore/libtscore.la)!\1 \\\
\t$(top_builddir)/src/tscpp/util/libtscpputil.la!' iocore/hostdb/Makefile.am
sed -i -E -e 's!(src/tscore/libtscore.la)!\1 \\\
\t$(top_builddir)/src/tscpp/util/libtscpputil.la!' proxy/hdrs/Makefile.am
sed -i -E -e 's!(src/tscore/libtscore.la)!\1 \\\
\t$(top_builddir)/src/tscpp/util/libtscpputil.la!' proxy/http/Makefile.am
sed -i -E -e 's!(src/tscore/libtscore.la)!\1 \\\
\t$(top_builddir)/src/tscpp/util/libtscpputil.la!' proxy/http2/Makefile.am
sed -i -E -e 's!(src/tscore/libtscore.la)!\1 \\\
\t$(top_builddir)/src/tscpp/util/libtscpputil.la!' proxy/logging/Makefile.am
sed -i -E -e 's!(src/tscore/libtscore.la)!\1 \\\
\t$(top_builddir)/src/tscpp/util/libtscpputil.la!' mgmt/utils/Makefile.am

## plugin fixups
# Things to to be fixed
find plugins \( -name '*.cc' -o -name '*.h' -o -name '*.c' \) -exec sed -i -E -e 's![<"]ts/ink_defs.h[">]!"tscore/ink_defs.h"!' {} \;
find example \( -name '*.cc' -o -name '*.h' -o -name '*.c' \) -exec sed -i -E -e 's![<"]ts/ink_defs.h[">]!"tscore/ink_defs.h"!' {} \;
find plugins \( -name '*.cc' -o -name '*.h' -o -name '*.c' \) -exec sed -i -E -e 's![<"]ts/ink_config.h[">]!"tscore/ink_config.h"!' {} \;
find example \( -name '*.cc' -o -name '*.h' -o -name '*.c' \) -exec sed -i -E -e 's![<"]ts/ink_config.h[">]!"tscore/ink_config.h"!' {} \;
find plugins \( -name '*.cc' -o -name '*.h' \) -exec sed -i -E -e 's![<"]ts/ink_atomic.h[">]!"tscore/ink_atomic.h"!' {} \;
find plugins \( -name '*.cc' -o -name '*.h' \) -exec sed -i -E -e 's![<"]ts/ink_string.h[">]!"tscore/ink_string.h"!' {} \;
find plugins \( -name '*.cc' -o -name '*.h' \) -exec sed -i -E -e 's![<"]ts/ink_inet.h[">]!"tscore/ink_inet.h"!' {} \;
find example \( -name '*.cc' -o -name '*.h' \) -exec sed -i -E -e 's![<"]ts/ink_inet.h[">]!"tscore/ink_inet.h"!' {} \;
find plugins \( -name '*.cc' -o -name '*.h' -o -name '*.c' \) -exec sed -i -E -e 's![<"]ts/ink_platform.h[">]!"tscore/ink_platform.h"!' {} \;
find plugins \( -name '*.cc' -o -name '*.h' \) -exec sed -i -E -e 's![<"]ts/ParseRules.h[">]!"tscore/ParseRules.h"!' {} \;
find plugins \( -name '*.cc' -o -name '*.h' \) -exec sed -i -E -e 's![<"](ts/)?I_Version.h[">]!"tscore/I_Version.h"!' {} \;
find plugins \( -name '*.cc' -o -name '*.h' \) -exec sed -i -E -e 's![<"](ts/)?ink_memory.h[">]!"tscore/ink_memory.h"!' {} \;
find plugins \( -name '*.cc' -o -name '*.h' \) -exec sed -i -E -e 's![<"]ts/ink_time.h[">]!"tscore/ink_time.h"!' {} \;
find plugins \( -name '*.cc' -o -name '*.h' \) -exec sed -i -E -e 's![<"](ts/)?ink_hrtime.h[">]!"tscore/ink_hrtime.h"!' {} \;
find plugins \( -name '*.cc' -o -name '*.h' \) -exec sed -i -E -e 's![<"]ts/IpMap.h[">]!"tscore/IpMap.h"!' {} \;
find plugins \( -name '*.cc' -o -name '*.h' \) -exec sed -i -E -e 's![<"]ts/TextView.h[">]!"tscpp/util/TextView.h"!' {} \;
find plugins \( -name '*.cc' -o -name '*.h' \) -exec sed -i -E -e 's![<"](ts/)?CryptoHash.h[">]!"tscore/CryptoHash.h"!' {} \;
find example \( -name '*.cc' -o -name '*.h' -o -name '*.c' \) -exec sed -i -E -e 's![<"]ts/ink_assert.h[">]!"tscore/ink_assert.h"!' {} \;
find plugins \( -name '*.cc' -o -name '*.h' \) -exec sed -i -E -e 's![<"](ts/)?TestBox.h[">]!"tscore/TestBox.h"!' {} \;

# Legit
find plugins \( -name '*.cc' -o -name '*.h' \) -exec sed -i -E -e 's![<"]ts/PostScript.h[">]!"tscpp/util/PostScript.h"!' {} \;

sed -i -E -e 's!unit-tests/!unit_tests/!' plugins/s3_auth/aws_auth_v4.h
sed -i -E -e 's!-I[$][(]abs_top_srcdir[)]/lib!-I$(abs_top_srcdir)/include!' build/plugins.mk
sed -i -E -e 's!(src/tscore/libtscore.la)!\1 \\\
\t$(top_builddir)/src/tscpp/util/libtscpputil.la!' plugins/experimental/sslheaders/Makefile.inc
# Need this to pass the dependency checks in tools
sed -i -E -e 's!iport = atoi[(]port[)];!iport = ts::svtoi(port);!' tools/jtest/jtest.cc
sed -i -E -e '63a\
#include "tscpp/util/TextView.h"' tools/jtest/jtest.cc

git add include/Makefile.am include/tscpp/api/Makefile.am include/tscpp/util/Makefile.am src/tscpp/util/Makefile.am src/tscpp/util/unit_tests/unit_test_main.cc
