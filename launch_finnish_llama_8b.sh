#!/bin/bash
#SBATCH --job-name=alpaca_8b  # Job name
#SBATCH --nodes=1
#SBATCH --partition=dev-g
#SBATCH --time=02:00:00
#SBATCH --ntasks-per-node=8
#SBATCH --cpus-per-task=7
#SBATCH --exclusive=user
#SBATCH --hint=nomultithread
#SBATCH --gpus-per-node=mi250:8
#SBATCH --account=project_462000615
#SBATCH --mem=480G
#SBATCH --output=logs/%j.out
#SBATCH --error=logs/%j.err

module use /appl/local/csc/modulefiles/
module load pytorch
source /scratch/project_462000353/zosaelai2/.alpaca_venv/bin/activate

export PYTHONPATH="/scratch/project_462000353/zosaelai2"
export HF_HOME="/scratch/project_462000353/hf_cache"

#echo "$(python -c 'import torch; print(torch.cuda.is_available())')"

export LANGUAGE="fin" # supported langs: eng or fin

alpaca_eval evaluate_from_model \
  --model_configs "finnish-llama-8b-dpo" \
  --output_path "results/finnish-llama-8b-dpo-$LANGUAGE" \

# alpaca_eval evaluate --model_outputs 'example/outputs.json' \
#                     --reference_outputs 'results/gpt-4-turbo-2024-04-09/model_outputs.json'
