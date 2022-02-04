for i in {0..8};do
	java -jar tools/venus.jar src/main.s -ms -1 tests/inputs/mnist/bin/m0.bin tests/inputs/mnist/bin/m1.bin tests/inputs/mnist/bin/inputs/mnist_input${i}.bin  out.bin
	cd tests/inputs/mnist/txt/
	python print_mnist.py $i
	cd -
	echo "================================================"
done
