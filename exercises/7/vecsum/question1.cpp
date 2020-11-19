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
    assert(argc==4);
    int n = atoi(argv[1]);
    assert(n>0);
    int nb_runs = atoi(argv[2]);
    assert(nb_runs>0);
    int nb_warm_up = atoi(argv[3]);
    assert(nb_warm_up>0);
    assert(nb_warm_up<nb_runs);
    
    std::vector<int> v(n,0);
    for (int i = 0; i < n; i++)
    {
        v[i]=i+1;
    }
    //Shuffle the elements of v using the given random number generator
    std::shuffle(v.begin(), v.end(), std::mt19937{std::random_device{}()});
    
    int sum;
    std::vector<double> timings(nb_runs,0.0);
    for (int i = 0; i < nb_runs; i++)
    {
        auto t_start = std::chrono::high_resolution_clock::now();
        sum = tws::sum_vector(v);
        auto t_end = std::chrono::high_resolution_clock::now();
        timings[i]=std::chrono::duration<double>(t_end-t_start).count();
        std::cerr<< " Resulting sum: " << sum << std::endl;
    }
    
    // std::cout<<"Timings:"<<std::endl;
    // tws::print_vector(timings);

    
    auto [mean,stdev]=tws::calculate_mean_stdev(timings,nb_warm_up);
    std::cout<<n<<" "<<mean<<" "<<stdev<<std::endl;
    // tws::print_vector(v);
    // tws::reverse_print_vector(v);
    // int sum = tws::sum_vector(v);
    // std::cout << sum << std::endl;
    // assert(sum==n*(n+1)/2);
    // sum = std::accumulate(v.begin(), v.end(), 0);



    return 0;
}
