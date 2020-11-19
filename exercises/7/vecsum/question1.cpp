#include <algorithm>
#include <iostream>
#include <iomanip>
#include <numeric>
#include <random>
#include <vector>
#include <cassert>
#include <chrono>
#include "library.hpp"

int main(int argc, char const *argv[])
{
    assert(argc==2);
    int n = atoi(argv[1]);
    assert(n>0);
    std::vector<int> v(n,0);
    for (int i = 0; i < n; i++)
    {
        v[i]=i+1;
    }
    tws::reverse_print_vector(v);
    //Shuffle the elements of v using the given random number generator
    std::shuffle(v.begin(), v.end(), std::mt19937{std::random_device{}()});

    tws::print_vector(v);
    
    return 0;
}
