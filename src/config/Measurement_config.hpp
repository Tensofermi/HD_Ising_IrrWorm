# pragma once

// ------------------------------------------------------------------------
// This function passes the config data into the observable for collection.
// ------------------------------------------------------------------------
void Configuration::measure()
{
//--- Energy and Magnetization 

//--- Cluster Observables
	obs.Ob[para.i_NCluster] = NCluster;
	obs.Ob[para.i_S2] = S2;
	obs.Ob[para.i_S4] = S4;
	obs.Ob[para.i_C1] = C1;
	obs.Ob[para.i_C2] = C2;

	// his.obsAdd(para.his_c1, C1);


}