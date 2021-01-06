#ifndef DEBUGLEVELS_HPP
#define DEBUGLEVELS_HPP
//debug info from every time step
#ifdef DLVL3
//debug info from solver
#define DLVL2
//input and output debugging info
#define DLVL1 
//
#define DLVL0
#endif
#ifdef DLVL2
#define DLVL1
#define DLVL0
#endif
#ifdef DLVL1
#define DLVL0
#endif
#ifdef NDEBUG
#undef DLVL3
#undef DLVL2
#undef DLVL1
#undef DLVL0
#endif
#endif