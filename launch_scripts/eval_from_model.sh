#!/bin/bash
#SBATCH --job-name=alpaca_$model_name  # Job name
#SBATCH --nodes=1
#SBATCH --partition=standard-g
#SBATCH --time=01:00:00
#SBATCH --ntasks-per-node=8
#SBATCH --cpus-per-task=7
#SBATCH --exclusive=user
#SBATCH --hint=nomultithread
#SBATCH --gpus-per-node=mi250:8
#SBATCH --account=project_462000353
#SBATCH --mem=480G
#SBATCH --output=logs/%j.out
#SBATCH --error=logs/%j.err

module use /appl/local/csc/modulefiles/
module load pytorch
source /scratch/project_462000353/zosaelai2/.alpaca_venv/bin/activate

export PYTHONPATH="/scratch/project_462000353/zosaelai2"
export HF_HOME="/scratch/project_462000353/hf_cache"
export LANGUAGE=$lang

echo ""
echo "Evaluating $model_name for ${lang^^}"

alpaca_eval evaluate_from_model \
    --model_configs "$model_name" \
    --output_path "results/$model_name-$lang" \



