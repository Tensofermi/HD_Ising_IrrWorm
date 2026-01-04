#include "../Configuration.hpp"

int Configuration::get_vertex_degree(int _Site)
{
    int degree = 0;
    long nn_bond;
    for(int i = 0; i < NNb; i++)
    {
        nn_bond = Latt.getNNBond(_Site, i);
        if(Bond[nn_bond] == 1) degree++;
    }
    return degree;
}

void Configuration::increase_bond()
{
    int j_select, index_no_bond, j_Dir, j_Site, j_Bond, j_degree;
    double AccProb, P_a, P_b;
    
    //    #      #
    // ###Ira--- j--- 
    //    |      #

    j_select = floor((NNb - vertex_degree) * rn.getRandomDouble()) + 1;

    // find the j_select-th direction without bond
    index_no_bond = 0;
    for(int i = 0; i < NNb; i++)
    {
        long nn_bond = Latt.getNNBond(Ira, i);
        if(Bond[nn_bond] == 0)
        {
            index_no_bond++;
            if(index_no_bond == j_select)
            {
                j_Dir = i;
                break;
            }
        }   
    }

    // obtain j_Site, j_Bond, j_degree
    j_Site = Latt.getNNSite(Ira, j_Dir);
    j_Bond = Latt.getNNBond(Ira, j_Dir);
    j_degree = get_vertex_degree(j_Site);

    // calculate acceptance probability
    if (Ira == Masha)
    {
        P_a = 1.0 / (NNb - vertex_degree) + 1.0 / (NNb - j_degree);
        P_b = 1.0 / (vertex_degree + 1.0) + 1.0 / (j_degree + 1.0);
        AccProb = P_w * P_b / P_a;
    }
    else
    {
        AccProb = P_w * (double)(NNb - vertex_degree) / (j_degree + 1.0);
    }

    // update the bond with acceptance probability
    if(rn.getRandomDouble() < AccProb)
    {
        Bond[j_Bond] = 1;
        Ira = j_Site;
    }
    else 
    {
        lambda = - lambda;
    }
        
}

void Configuration::decrease_bond()
{
    int j_select, index_occupy_bond, j_Dir, j_Site, j_Bond, j_degree;
    double AccProb, P_a, P_b;
    
    //    |      #
    // ---Ira####j--- 
    //    #      |

    j_select = floor(vertex_degree * rn.getRandomDouble()) + 1;

    // find the j_select-th direction without bond
    index_occupy_bond = 0;
    for(int i = 0; i < NNb; i++)
    {
        long nn_bond = Latt.getNNBond(Ira, i);
        if(Bond[nn_bond] == 1)
        {
            index_occupy_bond++;
            if(index_occupy_bond == j_select)
            {
                j_Dir = i;
                break;
            }
        }   
    }

    // obtain j_Site, j_Bond, j_degree
    j_Site = Latt.getNNSite(Ira, j_Dir);
    j_Bond = Latt.getNNBond(Ira, j_Dir);
    j_degree = get_vertex_degree(j_Site);

    // calculate acceptance probability
    if (Ira == Masha)
    {
        P_a = 1.0 / vertex_degree + 1.0 / j_degree;
        P_b = 1.0 / (NNb - vertex_degree + 1) + 1.0 / (NNb - j_degree + 1);
        AccProb = (1.0 / P_w) * P_b / P_a;
    }
    else
    {
        AccProb = (double)(vertex_degree) / (P_w * (double)(NNb - j_degree + 1.0));
    }

    // update the bond with acceptance probability
    if(rn.getRandomDouble() < AccProb)
    {
        Bond[j_Bond] = 0;
        Ira = j_Site;
    }
    else 
    {
        lambda = - lambda;
    }
}

///////////////////////////////////////////////
/////////// Update in Z sector 
///////////////////////////////////////////////

void Configuration::irrWorm()
{
    double Tw_ = 0;

    Ira = rn.getRandomNum(Vol);
    Masha = Ira;

    while (true)
    {
        // randomly swap Ira and Masha, then only move Ira
        if(rn.getRandomDouble() < 0.5) std::swap(Ira, Masha);

        // obtain the vertex degree at Ira
        vertex_degree = get_vertex_degree(Ira);

        // decide the move direction
        if (lambda == 1 && vertex_degree < NNb)
        {
            increase_bond();
        }
        else if (lambda == -1 && vertex_degree > 0)
        {
            decrease_bond();
        }
        else
        {
            lambda = - lambda;
        }

        Tw_++;  // count worm-return time

        if(Ira == Masha) break;
    }
    
    obs.Ob[para.i_Tw] = Tw_;

}


///////////////////////////////////////////////
/////////// Update in G sector 
///////////////////////////////////////////////

void Configuration::irrWorm_G()
{
    double Pm_ = 0;

    // randomly swap Ira and Masha, then only move Ira
    if(rn.getRandomDouble() < 0.5) std::swap(Ira, Masha);

    // obtain the vertex degree at Ira
    vertex_degree = get_vertex_degree(Ira);

    // decide the move direction
    if (lambda == 1 && vertex_degree < NNb)
    {
        increase_bond();
    }
    else if (lambda == -1 && vertex_degree > 0)
    {
        decrease_bond();
    }
    else
    {
        lambda = - lambda;
    }

    if(Ira == Masha)
    {
        Ira = rn.getRandomNum(Vol);
        Masha = Ira;
        Pm_ = 1;
    }
    
    
    obs.Ob[para.i_Pm] = Pm_;

}
