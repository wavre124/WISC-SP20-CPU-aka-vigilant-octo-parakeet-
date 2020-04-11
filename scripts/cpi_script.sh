OPATH=/u/k/s/kshitij/private/cs552/project/phase3/vigilant-octo-parakeet/results/old_results
NPATH=/u/k/s/kshitij/private/cs552/project/phase3/vigilant-octo-parakeet/results/new_results
CPATH=/u/k/s/kshitij/private/cs552/project/phase3/vigilant-octo-parakeet/results/diffs

echo "SIMPLE DIFFs"
diff $OPATH/instTests.summary.log $NPATH/instTests.summary.log > $CPATH/simple.diff
echo "COMPLEX DIFFs"
diff $OPATH/complex.summary.log $NPATH/complex.summary.log > $CPATH/complex.diff
echo "RAN SIMPLE DIFFs"
diff $OPATH/rand_simple.summary.log $NPATH/rand_simple.summary.log > $CPATH/ran_simple.diff
echo "RAN COMPLEX DIFFs"
diff $OPATH/rand_complex.summary.log $NPATH/rand_complex.summary.log > $CPATH/ran_complex.diff
echo "RAN CTRL DIFFs"
diff $OPATH/rand_ctrl.summary.log $NPATH/rand_ctrl.summary.log > $CPATH/ran_ctrl.diff
echo "RAN MEM DIFFs"
diff $OPATH/rand_mem.summary.log $NPATH/rand_mem.summary.log > $CPATH/ran_mem.diff
echo "DEMO TWO DIFFs"
diff $OPATH/complex_demo2.summary.log $NPATH/complex_demo2.summary.log > $CPATH/demo2.diff
