test: compile
	LD_LIBRARY_PATH=. PERL6LIB=. prove -e perl6 cpp.t

compile: libcpptest.so libcpptest-extern-c.so libintvec.so

lib%.so: %.cpp
	${CXX} $< -shared -g -o $@ -fPIC

clean:
	rm *.so

.PHONY: test compile clean
