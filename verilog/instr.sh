SPATH=/u/k/s/kshitij/private/cs552/project/phase2_3/vigilant-octo-parakeet/scripts
LPATH=/u/k/s/kshitij/private/cs552/project/phase2_3/vigilant-octo-parakeet/paths
RPATH=/u/k/s/kshitij/private/cs552/project/phase2_3/vigilant-octo-parakeet/results

$SPATH/wsrun.pl -pipe -list $LPATH/all_simple.list proc_hier_pbench *.v
mv summary.log $RPATH/instTests.summary.log
$SPATH/wsrun.pl -pipe -list $LPATH/all_complex.list proc_hier_pbench *.v
mv summary.log $RPATH/complex.summary.log
$SPATH/wsrun.pl -pipe -list $LPATH/all_ran_simple.list proc_hier_pbench *.v
mv summary.log $RPATH/rand_simple.summary.log
$SPATH/wsrun.pl -pipe -list $LPATH/all_ran_complex.list proc_hier_pbench *.v
mv summary.log $RPATH/rand_complex.summary.log
$SPATH/wsrun.pl -pipe -list $LPATH/all_ran_ctrl.list proc_hier_pbench *.v
mv summary.log $RPATH/rand_ctrl.summary.log
$SPATH/wsrun.pl -pipe -list $LPATH/all_ran_mem.list proc_hier_pbench *.v
mv summary.log $RPATH/rand_mem.summary.log
$SPATH/wsrun.pl -pipe -list $LPATH/all_demo_two.list proc_hier_pbench *.v
mv summary.log $RPATH/complex_demo2.summary.log
$SPATH/wsrun.pl -pipe -list $LPATH/my_tests.list proc_hier_pbench *.v
mv summary.log $RPATH/mytests.summary.log
echo "File names with FAILURES listed below: "
grep -l "FAILED" $RPATH/*.log
echo "FAILED tests listed below: "
grep -i "FAILED" $RPATH/*.log
