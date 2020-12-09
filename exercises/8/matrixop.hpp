#ifndef tws_matrixop_hpp
#define tws_matrixop_hpp
#include <cassert>
#include <iostream>
#include <cmath>
#include <typeinfo>
#include <algorithm>
#include <random>
#include <chrono>
#include <iterator>

namespace tws
{
    template <typename V1, typename V2>
    void matvec1(V1 const &x, V2 &y)
    {
        assert(x.size() == y.size());
        for (int i = 0; i < x.size(); i++)
        {
            y(i) = x(i) / (i + 1);
        };
    };

    template <typename V1, typename V2>
    struct matvec2
    {
        void operator()(V1 const &x, V2 &y) const
        {
            assert(x.size() == y.size());
            for (int i = 0; i < x.size(); i++)
            {
                y(i) = x(i) / (i + 1);
            };
        };
    };

    template <typename V1, typename V2, typename parameter_type>
    class matvec3
    {
        parameter_type m_;

    public:
        matvec3(parameter_type parameter) : m_(parameter){};

        void operator()(V1 const &x, V2 &y) const
        {
            assert(x.size() == y.size());
            for (int i = 0; i < x.size(); i++)
            {
                y(i) = x(i) / (m_ + i + 1);
            };
        };
    };

    template <typename V1, typename V2>
    class matvec4
    {

    public:
        typedef V1 v1_;
        typedef V2 v2_;

        template <typename parameter_type>
        void operator()(v1_ const &x, v2_ &y, parameter_type param) const
        {
            assert(x.size() == y.size());
            for (int i = 0; i < x.size(); i++)
            {
                y(i) = x(i) / (param + i + 1);
            };
        };
    };

    template <typename function, typename vector>
    void element_apply(function f, vector &v)
    {
        for (decltype(v.size()) i = 0; i < v.size(); i++)
        {
            v(i) = f(v(i));
        }
    }

} //namespace tws

#endif
