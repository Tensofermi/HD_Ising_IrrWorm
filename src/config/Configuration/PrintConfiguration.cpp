#include "Configuration.hpp"

void Configuration::printConfig()
{
    // print the Bond in flie (append mode)
    std::ofstream file;
    file.open("Config_L_" + toStr(L) + ".dat", std::ios::app);
    if (!file.is_open()) {
        std::cerr << "Error: cannot open file " << std::endl;
        return;
    }

file << "==============================\n";

    int num_width = std::to_string(Vol - 1).size();  // 最大编号宽度
    int cell_w = num_width + 2;  // 每个格点单元格宽度
    int W = L * cell_w + 1;
    int H = 2 * L + 1;

    std::vector<std::string> canvas(H, std::string(W, ' '));

    for (int y = 0; y < L; ++y) {
        for (int x = 0; x < L; ++x) {
            std::vector<int> coor = {y, x};
            int site = Latt.getSite(coor);
            int cx = x * cell_w + cell_w / 2;
            int cy = 2 * y + 1;

            // 写 site 编号
            std::string s = std::to_string(site);
            int startx = cx - s.size() / 2;
            for (size_t k = 0; k < s.size(); ++k)
                canvas[cy][startx + k] = s[k];

            // 上方向 (+y)
            if (Bond[Latt.getNNBond(site, 0)] == 1)
                canvas[(cy - 1 + H) % H][cx] = '|';

            // 下方向 (-y)
            if (Bond[Latt.getNNBond(site, 3)] == 1)
                canvas[(cy + 1) % H][cx] = '|';

            // 右方向 (+x)
            if (Bond[Latt.getNNBond(site, 1)] == 1) {
                for (int i = 1; i <= cell_w / 2; ++i)
                    canvas[cy][(cx + i) % W] = '-';
            }

            // 左方向 (-x)
            if (Bond[Latt.getNNBond(site, 2)] == 1) {
                for (int i = 1; i <= cell_w / 2; ++i)
                    canvas[cy][(cx - i + W) % W] = '-';
            }
        }
    }

    // 输出画布
    for (int y = 0; y < H; ++y)
        file << canvas[y] << '\n';

    file << "==============================\n\n";
    file.close();
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