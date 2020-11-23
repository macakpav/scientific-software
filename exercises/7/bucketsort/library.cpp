#include <vector>
#include <iostream>
#include <tuple>
#include <cassert>
#include <numeric>
#include <cmath>
namespace tws
{
    void print_vector(std::vector<int> const &v)
    {
        assert(v.size() > 0);
        std::cout << "(" << v.size() << ") [";
        for (decltype(v.size()) i = 0; i < v.size(); ++i)
        {
            std::cout << v[i] << " ";
        }
        std::cout << "]" << std::endl;
    }
    void print_vector(std::vector<double> const &v)
    {
        assert(v.size() > 0);
        std::cout << "(" << v.size() << ") [";
        for (decltype(v.size()) i = 0; i < v.size(); ++i)
        {
            std::cout << v[i] << " ";
        }
        std::cout << "]" << std::endl;
    }
    void reverse_print_vector(std::vector<int> const &v)
    {
        assert(v.size() > 0);
        std::cout << "(" << v.size() << ") [";
        for (decltype(v.size()) i = v.size(); i > 0; --i)
        {
            std::cout << v[i - 1] << " ";
        }
        std::cout << "]" << std::endl;
    }
    std::tuple<double, double> calculate_mean_stdev(std::vector<double> const &v, const int nbtodiscard = 5)
    {
        assert(v.size() > 0);
        assert(nbtodiscard > 0);
        assert((int)v.size() > nbtodiscard);
        int N = v.size();
        auto mean = std::accumulate(v.begin() + nbtodiscard, v.end(), 0.0);
        mean = mean / (N - nbtodiscard);
        auto st_dev = std::accumulate(v.begin() + nbtodiscard, v.end(), 0.0, [mean](auto res, auto x) { return res + (x - mean) * (x - mean); });
        st_dev = std::sqrt(st_dev / (N - nbtodiscard - 1));
        return {mean, st_dev};
    }

} // namespace tws
