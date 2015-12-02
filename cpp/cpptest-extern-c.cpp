#include <iostream>

extern "C"
{
    void holler(const char* str)
    {
        std::cout << str << "!\n";
    }
}
