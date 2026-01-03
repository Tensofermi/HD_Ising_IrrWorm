#include "Configuration.hpp"

Configuration::Configuration(Clock& _ck, IOControl& _io, RandomNumGen& _rn, Parameter& _para, Observable& _obs, Histogram& _his) 
: ck(_ck), io(_io), rn(_rn), para(_para), obs(_obs), his(_his)
{
    initialConf();  // for bond configuration 
    initialAlgo();  // for algorithms
    initialMeas();  // for cluster measurement
    initialObsr();  // for basic observables
}

void Configuration::initialConf()
{
    //--- Initialize Basic Parameters
    Dim = para.D;
    Beta = para.beta;
    L = para.L;

    //--- Initialize Lattice
    Latt.set(Dim, L);
    Vol = Latt.getVol();
    NNb = Latt.getNNb();
    Bond.resize(Dim * Vol, 0);

    //--- Initialize Spin Configuration
    for (unsigned int i = 0; i < Vol; i++)
    {
        Bond[i] = 0;
    }

}

void Configuration::initialAlgo()
{
    //--- Initialize Queue and Memory
    Que.resize(Vol);
    Mem.resize(Vol);
    for (int i = 0; i < Vol; i++)
    {
        Que[i] = 0;
        Mem[i] = 0;
    }

    //--- Initialize Ira and Masha
    Ira = 0;
    Masha = 0;

    //--- Initialize Probabilities
    P_w = tanh(Beta);

}

void Configuration::initialMeas()
{
    //--- Geometric Measurement
    x_max.resize(Dim);
    x_min.resize(Dim);
    x_now.resize(Dim);

    for (int i = 0; i < Dim; i++)
    {
        x_max[i] = 0;
        x_min[i] = 0;
        x_now[i] = 0;
    }

}

void Configuration::initialObsr()
{
    //--- Initialize Cluster Observables
    NCluster = 0;
    C1 = 0;
    C2 = 0;
    S2 = 0;
    S4 = 0;

    para.Corr_Fun.resize(L);
}

#include "../Measurement_config.hpp"

bool Configuration::measureOrNot()
{
    return true;
}

void Configuration::writeCnf()
{
    
}

void Configuration::checkCnf()
{

}
