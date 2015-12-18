test: compile
	LD_LIBRARY_PATH=. PERL6LIB=. prove -e perl6 cpp.t

compile: cpptest.so cpptest-extern-c.so intvec.so

%.so: %.cpp
	${CXX} $< -shared -g -o $@ -fPIC

clean:
	rm *.so

.PHONY: test compile clean
