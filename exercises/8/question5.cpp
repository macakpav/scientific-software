#include "vector.hpp"
#include <iostream>

int main()
{
    tws::vector<double> v(2, 1.);
    std::cout << v * 3. << std::endl;
    std::cout << 3. * v << std::endl;
    return 0;
}
