#include "../Configuration.hpp"

///////////////////////////////////////////////
/////////// Update in Z sector 
///////////////////////////////////////////////

void Configuration::Worm()
{
    int j_Dir, j_Site, j_Bond;
    double Tw_ = 0;

    Ira = rn.getRandomNum(Vol);
    Masha = Ira;

    while (true)
    {
        // randomly swap Ira and Masha, then only move Ira
        if(rn.getRandomDouble() < 0.5) std::swap(Ira, Masha);

        // select the direction randomly
        j_Dir = rn.getRandomNum(NNb);

        // get the target
        j_Site = Latt.getNNSite(Ira, j_Dir);
        j_Bond = Latt.getNNBond(Ira, j_Dir);

        if(Bond[j_Bond] == 1)   // to remove this bond
        {
            Bond[j_Bond] = 0;
            Ira = j_Site;
        }
        else    // to add this bond
        {
            if(rn.getRandomDouble() < P_w)
            {
                Bond[j_Bond] = 1;
                Ira = j_Site;
            }
        }

        Tw_++;  // count worm-return time

        if(Ira == Masha) break;
    }
    
    obs.Ob[para.i_Tw] = Tw_;

}

///////////////////////////////////////////////
/////////// Update in G sector 
///////////////////////////////////////////////

void Configuration::Worm_G()
{
    int j_Dir, j_Site, j_Bond;
    double Pm_ = 0;

    // randomly swap Ira and Masha, then only move Ira
    if(rn.getRandomDouble() < 0.5) std::swap(Ira, Masha);

    // select the direction randomly
    j_Dir = rn.getRandomNum(NNb);

    // get the target
    j_Site = Latt.getNNSite(Ira, j_Dir);
    j_Bond = Latt.getNNBond(Ira, j_Dir);

    if(Bond[j_Bond] == 1)   // to remove this bond
    {
        Bond[j_Bond] = 0;
        Ira = j_Site;
    }
    else    // to add this bond
    {
        if(rn.getRandomDouble() < P_w)
        {
            Bond[j_Bond] = 1;
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
