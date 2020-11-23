#!/bin/bash

# sed 's|\s\s// std::sort(v.begin(),v.end());|  std::sort(v.begin(),v.end());|' main.cpp -i
# sed 's|\s\ssorter.sort(v);|  // sorter.sort(v);|' main.cpp -i

# sed 's/optimize=true/optimize=false/' Makefile -i
# make all
# for i in `seq 2 20`; do ./main.exe $((2**$i)) 100.0 100 10 2>/dev/null; done | tee sortSTD.out 

# sed 's/optimize=false/optimize=true/' Makefile -i
# make all
# for i in `seq 2 20`; do ./main.exe $((2**$i)) 100.0 100 10 2>/dev/null; done | tee sortSTD_O3.out



# sed 's|\s\sstd::sort(v.begin(),v.end());|  // std::sort(v.begin(),v.end());|' main.cpp -i
# sed 's|\s\s// sorter.sort(v);|  sorter.sort(v);|' main.cpp -i

# sed 's/optimize=true/optimize=false/' Makefile -i
# make all
# for i in `seq 2 20`; do ./main.exe $((2**$i)) 100.0 100 10 2>/dev/null; done | tee sort.out

# sed 's/optimize=false/optimize=true/' Makefile -i

sed 's/-O3/-O1/' Makefile -i
make all
for i in `seq 2 20`; do ./main.exe $((2**$i)) 100.0 100 10 2>/dev/null; done | tee sort_O1.out

sed 's/-O1/-O2/' Makefile -i
make all
for i in `seq 2 20`; do ./main.exe $((2**$i)) 100.0 100 10 2>/dev/null; done | tee sort_O2.out

sed 's/-O2/-O3/' Makefile -i
# make all
# for i in `seq 2 20`; do ./main.exe $((2**$i)) 100.0 100 10 2>/dev/null; done | tee sort_O3.out

sed 's/-O3/-Ofast/' Makefile -i
make all
for i in `seq 2 20`; do ./main.exe $((2**$i)) 100.0 100 10 2>/dev/null; done | tee sort_Ofast.out

sed 's/-Ofast/-O3/' Makefile -i

# sed 's/optimize=true/optimize=false/' Makefile -i
# make all
# for i in `seq 2 20`; do ./main.exe $((2**$i)) 100.0 100 10 2>/dev/null; done | tee mySort.out

# sed 's/optimize=false/optimize=true/' Makefile -i

# sed 's/-O3/-O1/' Makefile -i
# make all
# for i in `seq 2 20`; do ./main.exe $((2**$i)) 100.0 100 10 2>/dev/null; done | tee mySort_O1.out

# sed 's/-O1/-O2/' Makefile -i
# make all
# for i in `seq 2 20`; do ./main.exe $((2**$i)) 100.0 100 10 2>/dev/null; done | tee mySort_O2.out

# sed 's/-O2/-O3/' Makefile -i
# make all
# for i in `seq 2 20`; do ./main.exe $((2**$i)) 100.0 100 10 2>/dev/null; done | tee mySort_O3.out

# sed 's/-O3/-Ofast/' Makefile -i
# make all
# for i in `seq 2 20`; do ./main.exe $((2**$i)) 100.0 100 10 2>/dev/null; done | tee mySort_Ofast.out

# sed 's/-Ofast/-O3/' Makefile -i



make pdf


