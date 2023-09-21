#!/bin/bash
#SBATCH -p general
#SBATCH -G a100:1
#SBATCH -N 1
#SBATCH -c 12
#SBATCH -t 7-00:00                  # wall time (D-HH:MM)
#SBATCH -o step-2.out


#Run NPT Simulation for 1 ns
gmx=gmx_plumed

files=(
equi-NPT/confout.gro
)

for file in ${files[@]}
do
if [ ! -f ${file} ]; then
echo "-could not find file ${file} in current directory"
echo "-you are either starting this in the wrong directory"
echo " or you missed a previous step"
echo "-exiting"
exit
fi
done

mkdir run-NPT
cd run-NPT

${gmx} grompp -f ../run-NPT-constrain.mdp -c ../equi-NPT/confout.gro -p ../complex.top -o topol.tpr -maxwarn 1 >& grompp.out
${gmx} mdrun -v -s topol.tpr -o traj.trr -e ener.edr -g md.log -c confout.gro -cpi -ntomp 12 -pin on -pme gpu -gpu_id 0 -cpo state.cpt >& mdrun.out
${gmx} trjconv -s topol.tpr -f traj.trr -pbc mol -o traj_pbc.trr << STOP >&trjconv.out
1
STOP
cd ..
