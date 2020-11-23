#include <iostream>
#include <iomanip>
#include <random>
#include <vector>
#include <cassert>
#include <chrono>
#include <cmath>
#include <algorithm>
#include "bucket.hpp"
#include "bucket_sorter.cpp"
#include "library.hpp"

int main(int argc, char const *argv[])
{ //cmd: the size of the vector, the range, the number of experiments and the number of discarded timings
    assert(argc == 5);
    int n = atoi(argv[1]);
    double r = atof(argv[2]);
    int nb_runs = atoi(argv[3]);
    int nb_warm_up = atoi(argv[4]);

    assert(nb_warm_up < nb_runs);
    assert(n > 0);
    assert(r > 0);
    assert(nb_runs > 0);
    assert(nb_warm_up > 0);

    int m = std::max(4, n / 10 * 4);

    std::vector<double> v(n, 0);
    std::random_device rd;
    std::mt19937 generator(rd());
    std::uniform_real_distribution<> distribution(0, r);

    for (auto &vi : v)
    {
        vi = distribution(generator);
    }
    // tws::print_vector(v);

    std::vector<double> timings(nb_runs, 0.0);
    bucket_sorter sorter = bucket_sorter(n, m, r);
    for (int i = 0; i < nb_runs; i++)
    {
        for (auto &vi : v)
        {
            vi = distribution(generator);
        }
        auto t_start = std::chrono::high_resolution_clock::now();
        // std::sort(v.begin(),v.end());
        sorter.sort(v);
        // buck::BucketSort(v,m);
        auto t_end = std::chrono::high_resolution_clock::now();
        timings[i] = std::chrono::duration<double>(t_end - t_start).count();
        std::cerr << " Time to sort: " << timings[i] << std::endl;
    }

    auto [mean,stdev]=tws::calculate_mean_stdev(timings,nb_warm_up);
    std::cout<<n<<" "<<mean<<" "<<stdev<<std::endl;

    return 0;
}
