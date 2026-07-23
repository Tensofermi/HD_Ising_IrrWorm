# Repository guide for agents

This file applies to the whole repository. It explains the high-dimensional loop-Ising physics, the current C++ implementation, parameter design, and adaptation of the Zoo task/data workflow.

## Scientific purpose

The code studies the Ising model in its high-temperature loop, or even-subgraph, representation. With $K=\beta J$ and $v=\tanh K$, the partition sum is represented by weighted bond subsets in which every vertex has even degree. Worm updates temporarily introduce defects and efficiently sample this constrained graph space.

The central scientific value is finite-size scaling at and above the upper critical dimension. At $D=4$, logarithmic corrections are important. For $D>4$, Gaussian fixed-point behavior coexists with finite-size effects associated with a dangerous irrelevant variable and complete-graph-like sectors. Those distinctions cannot be resolved reliably with a single size pair or an uncorrected power law.

The lifted irreversible worm is intended to reduce diffusive backtracking and improve sampling efficiency relative to a traditional reversible worm. The `old_version/` Fortran code is the historical complete implementation; the C++ `src/` tree is the actively hardened implementation, but publication work must verify that its enabled sector and measurements reproduce the required historical estimator.

## Code map and algorithm choices

- `src/config/Inputor_config.hpp` defines `D`, `beta`, `L` and sampling validation.
- `src/config/Configuration/UpdataScheme.cpp` selects the update. The default is `irrWorm()` in the closed/even (`Z`) sector.
- Alternative routines include traditional `Worm`, open-sector `Worm_G`, `irrWorm_G`, `Loop_Cluster`, and XY-oriented routines. They are not interchangeable switches.
- `src/config/Measurement_config.hpp` maps graph state to observables.
- `src/config/Observable_config.hpp` registers `Tw`, `Pm`, derived `M2`, and cluster quantities `NCluster`, `C1`, `C2`, `S2`, and `S4`.

`M2` is derived from `Pm`; make sure the selected update actually samples the sector needed by that estimator. Do not merely uncomment a `G`-sector routine alongside `irrWorm()` without defining the transition schedule, normalization, equilibration, and measurement meaning. The printed list of observables is not proof that every observable is populated by the selected update.

Keep bond occupancy, endpoint parity, and worm-sector invariants synchronized. Any change to graph indexing or bond counts needs small-lattice invariant checks.

## Build and single-run workflow

The C++ code requires C++17:

```bash
make clean
make -j
make test
./run.sh
```

The program reads `input.txt`: model fields `D,beta,L`, followed by `Seed,N_Measure,N_Each,N_Therm,N_Total,NBlock,MaxNBin,NperBin`. It writes `ouput.txt`. For a smoke test, use a small lattice and short counts, then confirm that the worm returns, even-sector constraints pass, output reaches 100%, and values are finite.

Before a production run, inspect `UpdataScheme.cpp`, state which sector/update is active, and verify the target observable on a small reference case. When comparison with the paper is required, compare against `old_version/` using matched definitions rather than only matched parameter names.

## Parameter planning

The cost scales at least with $V=L^D$, so a harmless-looking increase in `L` can multiply memory and sweep work dramatically.

1. Choose one `D` and one estimator/update sector per campaign.
2. Use small geometric sizes to measure memory, time per update, worm return time `Tw`, and variance.
3. Coarsely bracket the critical `beta`, then refine where dimensionless graph/magnetic ratios or size-scaled quantities show critical behavior.
4. Increase `L` only while the runtime and memory model remains controlled. Use more independent Seeds instead of one excessively long chain when that improves failure isolation and error diagnosis.
5. Fit several `L_min` values. At `D=4`, include logarithmic corrections; above four dimensions compare the theoretically relevant Gaussian and complete-graph finite-size sectors.

For example, do not reuse a 2D Ising crossing template for a 5D campaign. A 5D analysis should explicitly test the predicted high-dimensional scaling powers and corrections, and distinguish zero-mode-sensitive observables from nonzero-mode observables.

`N_Therm` must be set from equilibration diagnostics, not copied from the example input. Choose `N_Each` and binning from autocorrelation/return-time measurements. Ensure `NBlock>=2` and enough effective bins remain for a meaningful uncertainty.

## Adapting the Zoo pipeline

Clone the workflow source beside this repository and copy the required directories:

```bash
git clone --depth 1 https://github.com/Tensofermi/Zoo_of_Classical_ON_Spin_Model.git ../Zoo_of_Classical_ON_Spin_Model
cp -R ../Zoo_of_Classical_ON_Spin_Model/lsub .
cp -R ../Zoo_of_Classical_ON_Spin_Model/qsub .
cp -R ../Zoo_of_Classical_ON_Spin_Model/data .
cp -R ../Zoo_of_Classical_ON_Spin_Model/fit .
cp -R ../Zoo_of_Classical_ON_Spin_Model/plot .
```

Required adaptations are:

- Replace Zoo model arrays with `D,beta,L`, in that order, followed by the same eight sampling controls.
- Change the generated input labels/order and use job names containing update/sector, `D`, `beta`, `L`, and Seed.
- Build with this repository's C++17 Makefile and point jobs to this repository's `bin/a.out`.
- Set scheduler memory from $L^D$ pilot measurements and wall time from worm-return statistics. Update queue/account/partition directives before submission.
- Keep the update/sector out of a mixed campaign unless each job has a matching executable; it is not encoded in `ouput.txt` and must be retained in directory or manifest metadata.

For data formatting, the printed model order is `D,beta,L`. Set `header=10` and the 1-based `seed_index=6`; zero-based model columns are `D=0`, `beta=1`, `L=2`. Update split/group columns, then inspect one generated `collect.txt` before multi-Seed compression. Confirm that combining reduces only the Seed axis.

Do not reuse Zoo's O(N) BKT or ordinary-dimension fits unchanged. Update file paths and named observable columns, implement the loop-representation finite-size ansatz for the selected dimension/sector, scan `L_min`, and show residuals. If `Pm` is zero or unsampled, a formal `M2=1/Pm` result is invalid and should be rejected before fitting.

## Production workflow

1. Record the question, `D`, beta bracket, size list, active update/sector, target observables, and Seed plan.
2. Build/test, validate parity and estimator behavior, and time a small run.
3. Generate one scheduler task and inspect its input, executable, resources, and output path.
4. Run a pilot grid, refine beta and resources, then launch production.
5. Format/collect/split/compress, verify row counts and Seed grouping, and archive raw output.
6. Analyze using high-dimensional scaling appropriate to `D`, with multiple size cutoffs and explicit correction terms.

Archive the repository commit, active update/sector, parameter generator, input schema, compiler, scheduler settings, Seeds, and analysis environment.

## Change and verification policy

- Run `make test` after every code change and add parity/sector checks for algorithm changes.
- Treat changes that alter RNG calls, worm transition probabilities, sector residence, or estimator normalization as simulation-result changes, not style refactors.
- Cross-check physically important changes against the Fortran version or a small exactly checkable lattice when possible.
- Keep Markdown formulas as `$...$` or `$$...$$`.
- Do not commit binaries, scheduler output, or bulk data unless requested. Commits must state motivation, implementation, validation, and data-compatibility consequences.
