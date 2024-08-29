# Template from GROMACS Simulations
This repository is an example for how to run simple molecular dynamics simulations with GROMACS on the ASU Supercomputer (Sol).

## Step 1: Compiling Gromacs 2022.5
Download GROMACS 2022.5 from here: https://manual.gromacs.org/documentation/2022.5/download.html
```
interactive
module load gcc-11.2.0-gcc-11.2.0
module load cuda-11.7.0-gcc-11.2.0
tar xfz gromacs-2022.5.tar.gz
cd gromacs-2022.5
mkdir build
cd build
cmake .. -DGMX_GPU=CUDA -DCMAKE_INSTALL_PREFIX=$HOME/gromacs-2022.5 -DGMX_BUILD_OWN_FFTW=ON -DREGRESSIONTEST_DOWNLOAD=ON
make -j 4
make check
make install
```

## Configuring your BASHRC
Add the following line to your `~/.bashrc` file. Don't forget to run `source ~/.bashrc`!
```
source '$HOME/gromacs-2022.5/bin/GMXRC.bash'
```

## Usage

The first script will prepare the system for molecular dynamics simulation i.e add solvent, ions and run an energy minimization and an NPT equilibration simulation. Simulation details are provided at `em.mdp` and `equi-constrain.mdp`. You can submit this to the ASU Supercomputer as follows.

```
sbatch 01-prep_MD.sh
```

The second script will run a 10 ns NPT production simulation. The details of this simulation are provided at `run-NPT-constrain.mdp` (hydrogen atoms are constrained, 1 fs timestep, etc.). You can submit this to the ASU Supercomputer as follows. 
```
sbatch 02-run_NPT-10ns.sh
```
