#include "../Configuration.hpp"

void Configuration::printBond()
{
    std::cout<<"Bond configuration: \n";
    for (int i = 0; i < Dim * Vol; ++i)
    {   
        if(Bond[i]==0) continue;
        std::cout<< i <<"\t "<<Bond[i]<<"\t \n";
    }
    std::cout<<std::endl;
}

void Configuration::make_bond()
{
    for (int i = 0; i < Dim * Vol; ++i)
    {
        if (Bond[i] == 0)
        {
            if (rn.getRandomDouble() < P_w)
            {
                Bond[i] = 1;
                // std::cout<<"Activate bond "<<i<<std::endl;
            }
        }
    }
}

void Configuration::back_track()
{
    // ---- Reset observables ----
    NCluster = 0;
    C1 = 0.0;
    C2 = 0.0;
    S2 = 0.0;
    S4 = 0.0;

    // ---- Initialize state arrays ----
    for (int i = 0; i < Vol; ++i)
    {
        Mem[i] = 0;     // 可选：存储每个节点的集群编号
        Tree[i] = i;    // 初始化父节点为自身（根）
    }

    std::vector<bool> visited(Vol, false);

    // ---- Loop over all lattice sites ----
    for (long root = 0; root < Vol; ++root)
    {
        if (visited[root])
            continue;

        NCluster++;
        long cluster_size = 0;

        // ---- DFS stack ----
        std::vector<long> stack;
        stack.push_back(root);
        visited[root] = true;

        while (!stack.empty())
        {
            long current = stack.back();
            stack.pop_back();
            cluster_size++;

            // ---- Explore all nearest neighbors ----
            for (int dir = 0; dir < NNb; ++dir)
            {
                long neigh = Latt.getNNSite(current, dir);
                long bond_index = Latt.getNNBond(current, dir);

                if (Bond[bond_index] != 1)
                    continue;  // 仅考虑激活的键

                if (!visited[neigh])
                {
                    // ---- Normal DFS step ----
                    visited[neigh] = true;
                    Tree[neigh] = current; // 记录父节点
                    stack.push_back(neigh);
                }
                else if (neigh != Tree[current])
                {
                    // std::cout<<"Loop detected between "<<current<<" and "<<neigh<<std::endl;
                    // ---- Loop detected ----
                    // 邻居已访问且不是父节点 ⇒ 形成环路

                    if (rn.getRandomDouble() >= 0.5)
                    {
                        // ---- 1. 回溯两条路径到根节点 ----
                        long a = current;
                        long b = neigh;
                        std::vector<long> path_a;
                        std::vector<long> path_b;

                        while (Tree[a] != a)
                        {
                            // std::cout<<"Backtracking a: "<<a<<std::endl;
                            path_a.push_back(a);
                            a = Tree[a];
                        }
                        path_a.push_back(a); // include root

                        while (Tree[b] != b)
                        {
                            // std::cout<<"Backtracking b: "<<b<<std::endl;
                            path_b.push_back(b);
                            b = Tree[b];
                        }
                        path_b.push_back(b);

                        // ---- 2. 找到公共祖先 (LCA) ----
                        long LCA = -1;
                        for (long x : path_a)
                        {
                            if (std::find(path_b.begin(), path_b.end(), x) != path_b.end())
                            {
                                LCA = x;
                                break;
                            }
                        }
                        if (LCA == -1)
                            continue; // 理论上不应发生

                        // ---- 3. 收集环上所有边 ----
                        std::vector<std::pair<long, long>> loop_edges;

                        // 路径 current -> LCA
                        a = current;
                        while (a != LCA)
                        {
                            long parent = Tree[a];
                            loop_edges.push_back({a, parent});
                            a = parent;
                        }

                        // 路径 neigh -> LCA
                        b = neigh;
                        while (b != LCA)
                        {
                            long parent = Tree[b];
                            loop_edges.push_back({b, parent});
                            b = parent;
                        }

                        // 最后一条闭合边 current ↔ neigh
                        loop_edges.push_back({current, neigh});

                        // ---- 4. 标记整个环为 Bond=2 ----
                        for (auto [u, v] : loop_edges)
                        {
                            long e = Latt.getNNBond(u, Latt.getDir(u, v));
                            // 如果本来就是2的话变成0:
                            if(Bond[e]==2)
                            {
                                Bond[e]=1;
                            }
                            else
                            {
                                Bond[e] = 2;
                            }
                            ;
                        }
                    }
                }
            }
        }

        // ---- Update observables for this cluster ----
        double s = static_cast<double>(cluster_size);
        if(s > C1)
        {
            C2 = C1;
            C1 = s;
        }
        else if(s > C2)
        {
            C2 = s;
        }

        S2 += s * s;
        S4 += s * s * s * s;
    }

    // ---- Clear bonds marked as 2 ----
    for (int i = 0; i < Dim * Vol; ++i)
    {
        if (Bond[i] == 2)
        {
            Bond[i] = 1;
            // std::cout<<"Loop bond "<<i<<std::endl;
        }
        else
        {
            Bond[i] = 0;
        }
    }

     for (int i = 0; i < Vol; ++i)
    {
        int Degree = get_vertex_degree(i);
        // std::cout<<"Vertex "<<i<<" degree: "<<Degree<<std::endl;
        if (Degree % 2 != 0)
        {  
            std::cout<<"("<<i<<")Error in Loop-Cluster back_track: vertex degree is odd."<<std::endl;
        }
    }
}

void Configuration::Loop_Cluster()
{
    make_bond();
    // printBond();
    back_track();
    // printBond();

}