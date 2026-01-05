#include "Configuration.hpp"

void Configuration::updateCnf()
{
    //==== Traditional Worm 
    // Worm();             // for Z sector update
    // Worm_G();           // for G sector update

    //==== Lifted Worm
    // irrWorm();
    // irrWorm_G();

    //==== LC Algorithm
    // Loop_Cluster();

    //==== For XY model
    XY_Worm();
    // XY_Worm_G();

}
