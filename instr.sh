wsrun.pl -pipe -list all_simple.list proc_hier_pbench *.v
mv summary.log instTests.summary.log
wsrun.pl -pipe -list all_complex.list proc_hier_pbench *.v
mv summary.log complex.summary.log
wsrun.pl -pipe -list all_ran_simple.list proc_hier_pbench *.v
mv summary.log rand_simple.summary.log
wsrun.pl -pipe -list all_ran_complex.list proc_hier_pbench *.v
mv summary.log rand_complex.summary.log
wsrun.pl -pipe -list all_ran_ctrl.list proc_hier_pbench *.v
mv summary.log rand_ctrl.summary.log
wsrun.pl -pipe -list all_ran_mem.list proc_hier_pbench *.v
mv summary.log rand_mem.summary.log
wsrun.pl -pipe -list all_demo_two.list proc_hier_pbench *.v
mv summary.log complex_demo2.summary.log
wsrun.pl -pipe -list my_tests.list proc_hier_pbench *.v
mv summary.log mytests.summary.log
echo "File names with FAILURES listed below: "
grep -l "FAILED" *.log
echo "FAILED tests listed below: "
grep -i "FAILED" *.log
