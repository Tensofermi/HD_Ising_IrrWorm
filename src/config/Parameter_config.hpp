#pragma once

struct Parameter
{
    // Simulation Parameters
    int Seed;
    unsigned long N_Measure;
    unsigned long N_Each;
    unsigned long N_Therm;
    unsigned long N_Total;
    unsigned long NBlock;
    unsigned long MaxNBin;
    unsigned long NperBin;

    // Model Parameters
    int D, L;
    double beta;

    // Observable label
    int i_Tw, i_Pm;
    int i_M, i_absM, i_M2, i_M4, i_E, i_E2;
    int i_NCluster, i_S2, i_S4, i_SM4, i_C1, i_C2;

    // Distribution label
    int his_c1, his_ns;

    // Function
    std::vector<double> Corr_Fun;
    double corr_num;

};