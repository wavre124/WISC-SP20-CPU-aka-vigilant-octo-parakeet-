SPATH=/u/k/s/kshitij/private/cs552/project/phase2_3/vigilant-octo-parakeet/scripts
LPATH=/u/k/s/kshitij/private/cs552/project/phase2_3/vigilant-octo-parakeet/paths
VPATH=/u/k/s/kshitij/private/cs552/project/phase2_3/vigilant-octo-parakeet/verilog
RPATH=/u/k/s/kshitij/private/cs552/project/phase2_3/vigilant-octo-parakeet/results

$SPATH/wsrun.pl -pipe -list $LPATH/all_simple.list $VPATH/proc_hier_pbench $VPATH/*.v
mv summary.log $RPATH/instTests.summary.log
$SPATH/wsrun.pl -pipe -list $LPATH/all_complex.list $VPATH/proc_hier_pbench $VPATH/*.v
mv summary.log $RPATH/complex.summary.log
$SPATH/wsrun.pl -pipe -list $LPATH/all_ran_simple.list $VPATH/proc_hier_pbench $VPATH/*.v
mv summary.log $RPATH/rand_simple.summary.log
$SPATH/wsrun.pl -pipe -list $LPATH/all_ran_complex.list $VPATH/proc_hier_pbench $VPATH/*.v
mv summary.log $RPATH/rand_complex.summary.log
$SPATH/wsrun.pl -pipe -list $LPATH/all_ran_ctrl.list $VPATH/proc_hier_pbench $VPATH/*.v
mv summary.log $RPATH/rand_ctrl.summary.log
$SPATH/wsrun.pl -pipe -list $LPATH/all_ran_mem.list $VPATH/proc_hier_pbench $VPATH/*.v
mv summary.log $RPATH/rand_mem.summary.log
$SPATH/wsrun.pl -pipe -list $LPATH/all_demo_two.list $VPATH/proc_hier_pbench $VPATH/*.v
mv summary.log $RPATH/complex_demo2.summary.log
$SPATH/wsrun.pl -pipe -list $LPATH/my_tests.list $VPATH/proc_hier_pbench $VPATH/*.v
mv summary.log $RPATH/mytests.summary.log
echo "File names with FAILURES listed below: "
grep -l "FAILED" $RPATH/*.log
echo "FAILED tests listed below: "
grep -i "FAILED" $RPATH/*.log
