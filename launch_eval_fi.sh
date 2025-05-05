#!/bin/bash
#SBATCH --job-name=alpaca_eval  # Job name
#SBATCH --account=project_462000615  # Project for billing
#SBATCH --output=logs/%j.out # Name of stdout output file
#SBATCH --error=logs/%j.err  # Name of stderr error file
#SBATCH --partition=dev-g  # Partition (queue) name
#SBATCH --nodes=1              # Total number of nodes
#SBATCH --ntasks-per-node=1     # 8 MPI ranks per node, 128 total (16x8)
#SBATCH --gpus-per-node=8
#SBATCH --time=2:00:00       # Run time (d-hh:mm:ss)

module use /appl/local/csc/modulefiles/
module load pytorch/2.4
source /scratch/project_462000353/zosaelai2/.alpaca_venv/bin/activate

export PYTHONPATH="/scratch/project_462000353/zosaelai2"
export HF_HOME="/scratch/project_462000353/hf_cache"

#echo "$(python -c 'import torch; print(torch.cuda.is_available())')"

export LANGUAGE="fi"

alpaca_eval evaluate_from_model \
  --model_configs 'gpt-4-turbo-2024-04-09' \
  --reference_model_configs 'gpt-4-turbo-2024-04-09'

# alpaca_eval evaluate --model_outputs 'example/outputs.json' \
#                     --reference_outputs 'results/gpt-4-turbo-2024-04-09/model_outputs.json'
