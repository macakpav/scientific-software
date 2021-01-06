#ifndef FOO_HPP
#define FOO_HPP

template <typename Type>
class foo
{
public:
    typedef int size_type;
    typedef Type value_type;

public:
    template <typename v1, typename v2>
    void operator()(const v1 &variables_vector, v2 &return_vector)
    {
        v2[0] = 3*v1[0];
    }
};

#endif
