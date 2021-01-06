#ifndef BAR_HPP
#define BAR_HPP

#include "testFoo.hpp"

#include <boost/numeric/ublas/vector.hpp>

namespace ublas = boost::numeric::ublas;

template <typename Type>
class bar
{

public:
    typedef int size_type;
    typedef Type value_type;

private:
    ublas::vector<value_type> temp_;

public:
    bar(int n) { temp_(n); };
    ~bar(){};

    template <typename vector>
    void function(const foo &object, const vector &input) const
    {
        temp_ = object.function(input);
    };
};

#endif
