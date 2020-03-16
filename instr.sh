export PATH=$PATH:/u/s/i/sinclair/public/html/courses/cs552/spring2020/handouts/bins
wsrun.pl -list all_simple.list proc_hier_bench *.v
mv summary.log simple.summary.log
wsrun.pl -list all_complex.list proc_hier_bench *.v
mv summary.log complex.summary.log
wsrun.pl -list all_ran_simple.list proc_hier_bench *.v
mv summary.log rand_simple.summary.log
wsrun.pl -list all_ran_complex.list proc_hier_bench *.v
mv summary.log rand_complex.summary.log
wsrun.pl -list all_ran_ctrl.list proc_hier_bench *.v
mv summary.log rand_ctrl.summary.log
wsrun.pl -list all_ran_mem.list proc_hier_bench *.v
mv summary.log rand_mem.summary.log
echo "File names with FAILURES listed below: \n"
grep -l "FAILED" *.log
echo "FAILED tests listed below: \n"
grep -i "FAILED" *.log
