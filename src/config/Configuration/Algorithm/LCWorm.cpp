#include "../Configuration.hpp"

void Configuration::make_bond()
{
    for (int i = 0; i < Dim * Vol; ++i)
    {
        if (Bond[i] == 0)
        {
            if (rn.getRandomDouble() < P_w)
            {
                Bond[i] = 1;
            }
        }
    }
}

void Configuration::back_track()
{
    // DFS to find clusters and calculate observables

    // Reset observables
    NCluster = 0;
    C1 = 0.0;
    C2 = 0.0;
    S2 = 0.0;
    S4 = 0.0;

    std::vector<bool> visited(Vol, false);
    for (long site = 0; site < Vol; ++site)
    {
        if (!visited[site])
        {
            NCluster++;
            long cluster_size = 0;

            // DFS stack
            std::vector<long> stack;
            stack.push_back(site);
            visited[site] = true;

            while (!stack.empty())
            {
                long current_site = stack.back();
                stack.pop_back();
                cluster_size++;

                // Explore neighbors
                for (int dir = 0; dir < Dim * 2; ++dir)
                {
                    long neighbor_site = Latt.getNNSite(current_site, dir);
                    long bond_index = Latt.getNNBond(current_site, dir);

                    if (Bond[bond_index] == 1 && !visited[neighbor_site])
                    {
                        visited[neighbor_site] = true;
                        stack.push_back(neighbor_site);
                    }
                }
            }

            // Update observables
            C1 += static_cast<double>(cluster_size);
            C2 += static_cast<double>(cluster_size * cluster_size);
            S2 += static_cast<double>(cluster_size * cluster_size);
            S4 += static_cast<double>(cluster_size * cluster_size * cluster_size * cluster_size);
        }
    }

}

void Configuration::Loop_Cluster()
{
    make_bond();
    back_track();
}