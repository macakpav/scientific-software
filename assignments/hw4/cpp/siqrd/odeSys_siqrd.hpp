#ifndef ODE_SYSTEM_SIQRD_HPP
#define ODE_SYSTEM_SIQRD_HPP
#include <cassert>
#include <iostream>
#include <numeric>
#include <cmath>
#include <fstream>
#include <string>
#include <sstream>
namespace siqrd
{
    template <typename Type = double, typename SizeType = int>
    class OdeSys_SIQRD
    {
    public:
        typedef SizeType size_type;
        typedef Type value_type;

        value_type alpha_, beta_, gamma_, delta_, mu_;
        value_type S0_, I0_, Q0_, R0_, D0_;

        static const size_type dim = 5;

        //parameters from file
        OdeSys_SIQRD(std::string parametersFile) : alpha_(0.0), beta_(0.0), gamma_(0.0), delta_(0.0), mu_(0.0),
                                                   S0_(0.0), I0_(0.0), Q0_(0.0), R0_(0.0), D0_(0.0)
        {
#ifdef DLVL1
            std::cout << "Reading parameters from " << parametersFile << "...       ";
#endif
            std::ifstream file(parametersFile);
            file >> beta_ >> mu_ >> gamma_ >> alpha_ >> delta_ >> S0_ >> I0_;
#ifdef DLVL1
            std::cout << "done." << std::endl;
            std::cout << "Parameters are: " << std::endl
                      << "beta=" << beta_ << ", mu=" << mu_ << ", gamma=" << gamma_ << ", alpha=" << alpha_ << std::endl
                      << "delta=" << delta_ << ", S_0=" << S0_ << ", I0=" << I0_ << std::endl
                      << std::endl;
#endif
        }

        //hardcode initialization
        OdeSys_SIQRD(value_type alpha, value_type beta, value_type gamma, value_type delta, value_type mu,
                     value_type S0, value_type I0, value_type Q0, value_type R0, value_type D0)
            : alpha_(alpha), beta_(beta), gamma_(gamma), delta_(delta), mu_(mu),
              S0_(S0), I0_(I0), Q0_(Q0), R0_(R0), D0_(D0){};

        //destructor
        ~OdeSys_SIQRD(){};

    public:
        ublas::vector<value_type> initial_condition() const
        {
            ublas::vector<value_type> ret(dim);
            ret[0] = S0_;
            ret[1] = I0_;
            ret[2] = Q0_;
            ret[3] = R0_;
            ret[4] = D0_;
            return ret;
        }

        template <typename vector_type>
        ublas::vector<value_type> operator()(const vector_type &variables_vector) const
        {
            assert((size_type)variables_vector.size() == dim);
            ublas::vector<value_type> ret_vector(dim);
            value_type S = variables_vector[0], I = variables_vector[1],
                       Q = variables_vector[2], R = variables_vector[3];
            ret_vector[0] = fS(S, I, R);
            ret_vector[1] = fI(S, I, R);
            ret_vector[2] = fQ(I, Q);
            ret_vector[3] = fR(I, Q, R);
            ret_vector[4] = fD(I, Q);
            return ret_vector;
        };

        template <typename v1, typename v2>
        void operator()(const v1 &variables_vector, v2 &return_vector) const
        {
            assert((size_type)variables_vector.size() == dim);
            assert((size_type)return_vector.size() == dim);
            value_type S = variables_vector[0], I = variables_vector[1],
                       Q = variables_vector[2], R = variables_vector[3];
            return_vector[0] = fS(S, I, R);
            return_vector[1] = fI(S, I, R);
            return_vector[2] = fQ(I, Q);
            return_vector[3] = fR(I, Q, R);
            return_vector[4] = fD(I, Q);
        };

        template <typename vector_type, typename matrix_type>
        void jacobian(const vector_type &variables_vector, matrix_type &jac_matrix) const
        {
            assert((size_type)variables_vector.size() == dim);
            assert(jac_matrix.size1() == variables_vector.size());
            assert(jac_matrix.size1() == jac_matrix.size2());
            value_type S = variables_vector[0], I = variables_vector[1], R = variables_vector[3];

            jac_matrix.clear();
            jac_matrix(0, 0) = dSdS(S, I, R);
            jac_matrix(1, 0) = dIdS(S, I, R);

            jac_matrix(0, 1) = dSdI(S, I, R);
            jac_matrix(1, 1) = dIdI(S, I, R);
            jac_matrix(2, 1) = delta_;
            jac_matrix(3, 1) = gamma_;
            jac_matrix(4, 1) = alpha_;

            jac_matrix(2, 2) = (-1) * (gamma_ + alpha_);
            jac_matrix(3, 2) = gamma_;
            jac_matrix(4, 2) = alpha_;

            jac_matrix(0, 3) = dSdR(S, I, R);
            jac_matrix(1, 3) = dIdR(S, I, R);
            jac_matrix(3, 3) = (-1) * mu_;
        };

    private: // functions for SIQRD equations evluation
        inline value_type fS(const value_type S, const value_type I, const value_type R) const
        {
            return ((-1) * beta_ * S * (I / (S + I + R)) + mu_ * R);
        }
        inline value_type fI(const value_type S, const value_type I, const value_type R) const
        {
            return I * (beta_ * (S / (S + I + R)) - gamma_ - delta_ - alpha_);
        }
        inline value_type fQ(const value_type I, const value_type Q) const
        {
            return delta_ * I - (gamma_ + alpha_) * Q;
        }
        inline value_type fR(const value_type I, const value_type Q, const value_type R) const
        {
            return gamma_ * (I + Q) - mu_ * R;
        }
        inline value_type fD(const value_type I, const value_type Q) const
        {
            return alpha_ * (I + Q);
        }

        inline value_type dSdS(const value_type S, const value_type I, const value_type R) const
        {
            return ((-1) * beta_ * (I / (S + I + R)) + beta_ * S * I * (1 / pow(S + I + R, 2)));
        }
        inline value_type dSdI(const value_type S, const value_type I, const value_type R) const
        {
            return ((-1) * beta_ * (S / (S + I + R)) + beta_ * S * I * (1 / pow(S + I + R, 2)));
        }
        inline value_type dSdR(const value_type S, const value_type I, const value_type R) const
        {
            return (mu_ + beta_ * S * I * (1 / pow(S + I + R, 2)));
        }
        inline value_type dIdS(const value_type S, const value_type I, const value_type R) const
        {
            return I * (beta_ * (1 / (S + I + R)) + beta_ * S * (-1 / pow(S + I + R, 2)));
        }
        inline value_type dIdI(const value_type S, const value_type I, const value_type R) const
        {
            return I * (beta_ * S * (-1 / pow(S + I + R, 2))) + (beta_ * (S / (S + I + R)) - gamma_ - delta_ - alpha_);
        }
        inline value_type dIdR(const value_type S, const value_type I, const value_type R) const
        {
            return I * beta_ * S * (-1 / pow(S + I + R, 2));
        }

    public:
        // beta_mu_gamma_alpha_delta  ( *100 )
        std::string to_string() const
        {
            std::stringstream file;
            file << std::floor(beta_ * 100) << "_" << std::floor(mu_ * 100) << "_"
                 << std::floor(gamma_ * 100) << "_" << std::floor(alpha_ * 100) << "_"
                 << std::floor(delta_ * 100);
            std::string str;
            file >> str;
            return str;
        }
    };
} // namespace siqrd
#endif
