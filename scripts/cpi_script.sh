echo "SIMPLE DIFFs"
diff /u/k/s/kshitij/private/cs552/project/phase2_3/old_pipe/instTests.summary.log /u/k/s/kshitij/private/cs552/project/phase2_3/improved_pipe/instTests.summary.log > simple.diff
echo "COMPLEX DIFFs"
diff /u/k/s/kshitij/private/cs552/project/phase2_3/old_pipe/complex.summary.log /u/k/s/kshitij/private/cs552/project/phase2_3/improved_pipe/complex.summary.log > complex.diff
echo "RAN SIMPLE DIFFs"
diff /u/k/s/kshitij/private/cs552/project/phase2_3/old_pipe/rand_simple.summary.log /u/k/s/kshitij/private/cs552/project/phase2_3/improved_pipe/rand_simple.summary.log > ran_simple.diff
echo "RAN COMPLEX DIFFs"
diff /u/k/s/kshitij/private/cs552/project/phase2_3/old_pipe/rand_complex.summary.log /u/k/s/kshitij/private/cs552/project/phase2_3/improved_pipe/rand_complex.summary.log > ran_complex.diff
echo "RAN CTRL DIFFs"
diff /u/k/s/kshitij/private/cs552/project/phase2_3/old_pipe/rand_ctrl.summary.log /u/k/s/kshitij/private/cs552/project/phase2_3/improved_pipe/rand_ctrl.summary.log > ran_ctrl.diff
echo "RAN MEM DIFFs"
diff /u/k/s/kshitij/private/cs552/project/phase2_3/old_pipe/rand_mem.summary.log /u/k/s/kshitij/private/cs552/project/phase2_3/improved_pipe/rand_mem.summary.log > ran_mem.diff
echo "DEMO TWO DIFFs"
diff /u/k/s/kshitij/private/cs552/project/phase2_3/old_pipe/complex_demo2.summary.log /u/k/s/kshitij/private/cs552/project/phase2_3/improved_pipe/complex_demo2.summary.log > demo2.diff
