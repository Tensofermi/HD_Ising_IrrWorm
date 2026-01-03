#include "Configuration.hpp"

void Configuration::printConfig(int _index)
{
    // std::cout<<_index<<std::endl;
    // squarePrint();
    // corrFunPrint();
}


void Configuration::corrFunPrint()
{
    std::ofstream file;
    file.open("CorrFun_L_" + toStr(L) + ".dat");
    for (int i = 0; i < int(L / 2.0); i++)
    {
        file << i << '\t' << para.Corr_Fun[i] / para.corr_num << '\n';
    }
    file.close();
}