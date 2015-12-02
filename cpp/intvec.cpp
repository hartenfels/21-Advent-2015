#include <vector>

extern "C"
{
    std::vector<int>* intvec_new() { return new std::vector<int>; }

    void intvec_free(std::vector<int>* vec) { delete vec; }

    void intvec_push(std::vector<int>* vec, int x) { vec->push_back(x); }

    int intvec_at(std::vector<int>* vec, int i) { return (*vec)[i]; }
}
