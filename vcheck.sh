export PATH=$PATH:/u/s/i/sinclair/public/html/courses/cs552/spring2020/handouts/bins
echo "Verilog rule checker test: "
vcheck-all.sh
grep Line ./*
rm -f *.vcheck.out
