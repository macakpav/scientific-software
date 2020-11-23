#include <vector>
#include <iostream>
#include <cmath>
#include <algorithm>
#include <cassert>
#include "bucket.hpp"
class bucket_sorter{
public:
    bucket_sorter(int N_,int M_, double r_):N(N_),M(M_),r(r_),buckets(M){
        assert(N_>0);
        assert(M_>0);
        assert(N_>=M_);
        assert(r_>0.0);
        bucket_range=r/M;
        for(auto & bucket:buckets){
            bucket.reserve(N/M);
        }
    };
    
    void sort(std::vector<double> & v) const{
       assert(v.size()>0);
       for(decltype(buckets.size()) bi=0;bi<buckets.size();bi++){
          buckets[bi].clear();
       }
       for(decltype(v.size()) vi=0;vi<v.size();vi++){ 
          buckets[std::floor(v[vi]/bucket_range)].push_back(v[vi]);
       }
       int index=0;
       for(decltype(buckets.size()) bi=0;bi<buckets.size();bi++){
          std::sort(buckets[bi].begin(),buckets[bi].end());
          for(auto elem:buckets[bi]) v[index++]=elem;
       }
    
    };
    void print_info() const{
       std::cout<<"bucket info: ["<<N<<","<<M<<","<<r<<","<<bucket_range<<"], bucketsizes: ";
       for(auto &bucket:buckets){
          std::cout<<bucket.size()<<" ";
       }
       std::cout<<std::endl;
    }
    
    
private:
    int N;
    int M;
    double r;
    mutable std::vector<std::vector<double>> buckets;
    double bucket_range;
};