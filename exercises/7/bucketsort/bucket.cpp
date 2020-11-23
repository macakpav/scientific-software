#include <vector>
#include <iostream>
#include <cmath>
#include <algorithm>
#include "bucket.hpp"

namespace buck
{
    void BucketSort(std::vector<double> &v, int noBuckets)
    {
        
#ifndef NDEBUG
        std::cout << "Number of buckets:"<<noBuckets << std::endl;
#endif
        std::vector<std::vector<double>> buckets(noBuckets);
        for (int i = 0; i < noBuckets; ++i)
        {
            buckets[i].reserve(v.size() / noBuckets);
        }
        double max_ = *std::max_element(v.begin(), v.end());

#ifndef NDEBUG
        std::cout << "Max element value:" << max_ << std::endl;
        std::cout << "Bucket size: " << buckets.size() << std::endl;
#endif
        for (decltype(v.size()) i = 0; i < v.size(); ++i)
        {
#ifndef NDEBUG
            std::cout << "Getting index: " << ceil(((double)noBuckets) * v[i] / ((double)max_)) << std::endl;
#endif
            buckets[std::min((int)(((double)noBuckets) * v[i] / ((double)max_)), noBuckets - 1)].push_back(v[i]);
        }
        int v_ind = 0;
        for (int i = 0; i < noBuckets; ++i)
        {
            std::sort(buckets[i].begin(), buckets[i].end());
            for (decltype(buckets[i].size()) j = 0; j < buckets[i].size(); j++)
            {
                v[v_ind++] = buckets[i][j];
            }
        }
#ifndef NDEBUG
        std::cout << "Clearing..." << std::endl;
        for (int i = 0; i < noBuckets; ++i)
        {
            buckets[i].clear();
        }
        buckets.clear();
#endif
    }

} /* namespace buck */
