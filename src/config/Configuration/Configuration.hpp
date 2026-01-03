#pragma once
#include <bits/stdc++.h>
#include "../../system/Header.hpp"
#include "../Lattice/Lattice.hpp"

class Configuration
{
    Clock& ck;
    IOControl& io;
    RandomNumGen& rn;
    Parameter& para;
    Observable& obs;
    Histogram& his;

public:
    //--- Configuration
    std::vector<int> Bond;  // 0 for empty and 1 for occupied
    Hypercubic Latt;            
    int Dim, L, NNb;
    long Vol;
    double Beta;

    //--- Basic parameter for algorithms
    std::vector<int> Mem, Que;
    int Ira, Masha, lambda;
    double P_w;

    //--- Basic Observables
    std::vector<int> x_max, x_min, x_now;
    long NCluster;                  // Number of clusters
    double C1, C2, S2, S4;          // Cluster size defined by particle number

public:
std::string infoConfig()
{
    return 
    "====================\n"
    "This program simulates the Ising model.\n"
    "It can simulate the Ising model in any spatial dimension.\n"
    "The XY model may also be included here.\n"
    "====================\n";
};

    Configuration(Clock& _ck, IOControl& _io, RandomNumGen& rn, Parameter& _para, Observable& _obs, Histogram& _his);
    void initialConf();
    void initialAlgo();
    void initialMeas();
    void initialObsr();

    void updateCnf();
    bool measureOrNot();
    void measure();
    void writeCnf();

    void printConfig(int _index);
    void corrFunPrint();

    void checkCnf();

    // Traditional Algorithm
    void Worm();
    void Worm_G();
    
    // Lifted Algorithm
    void irrWorm();
    void irrWorm_G();
    void increase_bond();
    void decrease_bond();
    
    // Loop-Cluster Algorithm
    void Loop_Cluster();
    void make_bond();
    void back_track();

    // XY model
    void XY_Worm();
    void XY_Worm_G();
    

};
