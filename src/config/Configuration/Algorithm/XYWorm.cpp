#include "../Configuration.hpp"

double modifiedBesselI(int J, double K, int maxIter = 200, double tol = 1e-12) {
    if (J < 0) J = -J; // I_{-J}(K) = I_J(K)

    double sum = 0.0;
    double term = pow(K / 2.0, J) / tgamma(J + 1); // m = 0 的第一项
    sum += term;

    for (int m = 1; m < maxIter; ++m) {
        term *= (K/2.0) * (K/2.0) / (m * (m + J)); // 每一项递推计算
        sum += term;
        if (term < tol) break; // 收敛判断
    }

    return sum;
}

void Configuration::XY_Worm()
{
    int j_Dir, j_Site, j_Bond;
    double Tw_ = 0;
    double P_XY = 0;

    Ira = rn.getRandomNum(Vol);
    Masha = Ira;

    while (true)
    {   
        ///////////////////////////////////////////////////////////////////////////////////
        // note that for directed graph, do not randomly swap Ira and Masha, only move Ira
        ///////////////////////////////////////////////////////////////////////////////////

        // select the direction randomly
        j_Dir = rn.getRandomNum(NNb);

        // get the target
        j_Site = Latt.getNNSite(Ira, j_Dir);
        j_Bond = Latt.getNNBond(Ira, j_Dir);

        if(j_Dir < Dim)   // to add this bond
        {
            P_XY = modifiedBesselI(Bond[j_Bond] + 1, Beta) / modifiedBesselI(Bond[j_Bond], Beta);

            if(rn.getRandomDouble() < P_XY)
            {
                Bond[j_Bond] += 1;
                Ira = j_Site;
            }
        }
        else    // to remove this bond
        {
            P_XY = modifiedBesselI(Bond[j_Bond] - 1, Beta) / modifiedBesselI(Bond[j_Bond], Beta);

            if(rn.getRandomDouble() < P_XY)
            {
                Bond[j_Bond] -= 1;
                Ira = j_Site;
            }
        }

        Tw_++;  // count worm-return time

        if(Ira == Masha) break;
    }
    
    obs.Ob[para.i_Tw] = Tw_;

}


void Configuration::XY_Worm_G()
{
    int j_Dir, j_Site, j_Bond;
    double Pm_ = 0;
    double P_XY = 0;

    // select the direction randomly
    j_Dir = rn.getRandomNum(NNb);

    // get the target
    j_Site = Latt.getNNSite(Ira, j_Dir);
    j_Bond = Latt.getNNBond(Ira, j_Dir);

    if(j_Dir < Dim)   // to add this bond
    {
        P_XY = modifiedBesselI(Bond[j_Bond] + 1, Beta) / modifiedBesselI(Bond[j_Bond], Beta);

        if(rn.getRandomDouble() < P_XY)
        {
            Bond[j_Bond] += 1;
            Ira = j_Site;
        }
    }
    else    // to remove this bond
    {
        P_XY = modifiedBesselI(Bond[j_Bond] - 1, Beta) / modifiedBesselI(Bond[j_Bond], Beta);

        if(rn.getRandomDouble() < P_XY)
        {
            Bond[j_Bond] -= 1;
            Ira = j_Site;
        }
    }

    if(Ira == Masha)
    {
        Ira = rn.getRandomNum(Vol);
        Masha = Ira;
        Pm_ = 1;
    }
    
    obs.Ob[para.i_Pm] = Pm_;

}
