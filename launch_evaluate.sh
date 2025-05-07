#!/bin/bash
#SBATCH --job-name=eval_alpaca  # Job name
#SBATCH --output=logs/%j.out # Name of stdout output file
#SBATCH --error=logs/%j.err  # Name of stderr error file
#SBATCH --partition=dev-g  # Partition (queue) name
#SBATCH --nodes=1              # Total number of nodes
#SBATCH --ntasks-per-node=1     # 8 MPI ranks per node, 128 total (16x8)
#SBATCH --gpus-per-node=8
#SBATCH --time=00:30:00       # Run time (d-hh:mm:ss)
#SBATCH --account=project_462000615  # Project for billing

module use /appl/local/csc/modulefiles/
module load pytorch/2.4
source /scratch/project_462000353/zosaelai2/.alpaca_venv/bin/activate

export PYTHONPATH="/scratch/project_462000353/zosaelai2"
export HF_HOME="/scratch/project_462000353/hf_cache"

export LANGUAGE="fin"

alpaca_eval evaluate --model_outputs "results/finnish-llama-8b-dpo-$LANGUAGE/model_outputs.json" \
                    --reference_outputs "results/finnish-llama-8b-dpo-$LANGUAGE/reference_outputs.json"
