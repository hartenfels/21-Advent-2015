test: compile
	LD_LIBRARY_PATH=. prove -e perl6 cpp.t

compile: cpptest.so cpptest-extern-c.so

%.so: %.cpp
	g++ -Wall -Wextra -Wshadow -std=c++98 -pedantic -pedantic-errors $< -shared -g -o $@ -fPIC

clean:
	rm *.so

.PHONY: test compile clean
