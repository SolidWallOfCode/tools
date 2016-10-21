rm traffic_manager
ln -s ~amc/git/ats/cmd/traffic_manager/.libs/traffic_manager .
rm traffic_server
ln -s ~amc/git/ats/proxy/.libs/traffic_server .
rm traffic_cop
ln -s ~amc/git/ats/cmd/traffic_cop/.libs/traffic_cop .
rm traffic_logcat
ln -s ~amc/git/ats/proxy/.libs/traffic_logcat .
rm traffic_logstats
ln -s ~amc/git/ats/proxy/.libs/traffic_logstats .
rm traffic_ctl
ln -s ~amc/git/ats/cmd/traffic_ctl/.libs/traffic_ctl .
rm traffic_layout
ln -s ~amc/git/ats/cmd/traffic_layout/.libs/traffic_layout .
rm traffic_crashlog
ln -s ~amc/git/ats/cmd/traffic_crashlog/.libs/traffic_crashlog .
rm traffic_line
rm traffic_sac

rm ../lib/libtsutil.la
ln -s ~amc/git/ats/lib/ts/.libs/libtsutil.la ../lib/libtsutil.la
rm ../lib/libtsutil.so.[56].[012].*
ln -s ~amc/git/ats/lib/ts/.libs/libtsutil.so.6.2.0 ../lib
rm ../lib/libtsutil.so.6
ln -s ../lib/libtsutil.so.6.2.0 ../lib/libtsutil.so.6
rm ../lib/libtsutil.so
ln -s ../lib/libtsutil.so.6.2.0 ../lib/libtsutil.so

rm ../lib/libtsmgmt.so.[56].[012].*
ln -s ~amc/git/ats/mgmt/api/.libs/libtsmgmt.so.6.2.0 ../lib
rm ../lib/libtsmgmt.so.[56]
ln -s ../lib/libtsmgmt.so.6.2.0 ../lib/libtsmgmt.so.6
rm ../lib/libtsmgmt.so
ln -s ../lib/libtsmgmt.so.6.2.0 ../lib/libtsmgmt.so

rm ../lib/libtsconfig.la
ln -s ~amc/git/ats/lib/tsconfig/.libs/libtsconfig.la ../lib/libtsconfig.la
rm ../lib/libtsconfig.so.[56].[012].*
ln -s ~amc/git/ats/lib/tsconfig/.libs/libtsconfig.so.6.2.0 ../lib
rm ../lib/libtsconfig.so.[56]
ln -s ../lib/libtsconfig.so.6.2.0 ../lib/libtsconfig.so.6
rm ../lib/libtsconfig.so
ln -s ../lib/libtsconfig.so.6.2.0 ../lib/libtsconfig.so

rm ../lib/libtsmgmt.so.6.*
ln -s ~amc/git/ats/mgmt/api/.libs/libtsmgmt.so.6.2.0 ../lib
rm ../lib/libtsmgmt.so.6
ln -s ../lib/libtsmgmt.so.6.2.0 ../lib/libtsmgmt.so.6
rm ../lib/libtsmgmt.so
ln -s ../lib/libtsmgmt.so.6.2.0 ../lib/libtsmgmt.so

rm ../lib/libatscppapi.so.6.*
ln -s ~amc/git/ats/lib/atscppapi/src/.libs/libatscppapi.so.6.2.0 ../lib
rm ../lib/libatscppapi.so.6
ln -s ../lib/libatscppapi.so.6.2.0 ../lib/libatscppapi.so.6
rm ../lib/libatscppapi.so
ln -s ../lib/libatscppapi.so.6.2.0 ../lib/libatscppapi.so
