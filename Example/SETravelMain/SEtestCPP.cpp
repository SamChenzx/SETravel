//
//  SEtestCPP.cpp
//  SETravel_Example
//
//  Created by Sam Chen on 2/7/24.
//  Copyright © 2024 chenzhixiang. All rights reserved.
//

#include "SEtestCPP.hpp"
#include <iostream>
#include <tuple>

struct A {
  void Foo() {
  }
  
    int xxx() {return 0;}
    virtual int ccc() const {return 0;}
  
  int value = 345987;
};
void Bar() {

}

template <typename T>
struct FunctionTraits {
};

template <typename C, typename R, typename... Args>
struct FunctionTraits<R (C::*)(Args...)> {
  using ClassName = C;
  using RetClassName = R;
};

template <typename C, typename R, typename... Args>
struct FunctionTraits<R (C::*)(Args...) const> {
  using ClassName = C;
  using RetClassName = R;
};

template<typename MemberFunc, typename...Args>
void RunSinksImpl(MemberFunc&& memfunc, std::true_type, Args&&...args) {
  using V = typename FunctionTraits<MemberFunc>::ClassName;
  using R = typename FunctionTraits<MemberFunc>::RetClassName;

  std::tuple<int, bool, A*> my_tuple(2314123, false, new A()); // std::get<void>(my_tuple) ;

  std::cout <<std::endl << __FUNCTION__ << " "
  << " " << std::get<int>(my_tuple)
  << " " << std::get<bool>(my_tuple)
  << " " << std::get<A*>(my_tuple)->value
  << " " << std::get<V*>(my_tuple)->value  << std::endl;
}

template <typename F, typename... Args>
void RunSinksImpl(F&& func, std::false_type, Args&&... args) {
  std::cout <<__FUNCTION__ <<std::endl;
}

template <typename F, typename... Args>
void RunSinks(F&& fn, Args&&... args) {
  RunSinksImpl(std::forward<F>(fn), std::true_type(), std::forward<Args>(args)...);
}

int mmmain() {
    // Write C++ code here
    std::cout << "Hello world!";
RunSinks(&A::ccc);
//RunSinks(&Bar);

    return 0;
}

