#!/bin/bash
#SBATCH --job-name=alpacaeval  # Job name
#SBATCH --nodes=1
#SBATCH --partition=dev-g
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

# Ensure at least 3 arguments are provided
if [ "$#" -lt 3 ]; then
  echo "Usage: $0 <model_name> <model_path> <lang1> [<lang2> ...]"
  exit 1
fi

# First two arguments
model_name="$1"
model_path="$2"
shift 2  # Remove first two args from the list

# Remaining arguments are language codes
lang_codes=("$@")  # Array of language codes

output_dir="./src/alpaca_eval/models_configs/$model_name"
yaml_file="$output_dir/configs.yaml"
prompt_file="$output_dir/prompt.txt"

# Function to create YAML config
create_yaml() {
  if [ -f "$yaml_file" ]; then
    echo "config yaml already exists"
    return 1
  fi
  mkdir -p "$output_dir"
  cat <<EOF > "$yaml_file"
$model_name:
  prompt_template: "$model_name/prompt.txt"
  fn_completions: "vllm_local_completions"
  completions_kwargs:
    model_name: "$model_path"
    model_kwargs:
      max_model_len: 4096
      tensor_parallel_size: 1
    max_new_tokens: 2048
    temperature: 0.6
    top_p: 0.9
    batch_size: 64
  pretty_name: "$model_name"
  link: ""
EOF

echo "DONE creating yaml file at: $yaml_file"
}

# Function to create prompt template (by default, it just copies the Llama template)
create_prompt() {
  # mkdir -p "$output_dir"
  if [ -f "$prompt_file" ]; then
    echo "prompt.txt already exists"
    return 1
  fi
  cat <<EOF > "$prompt_file"
<|begin_of_text|><|start_header_id|>user<|end_header_id|>

{instruction}<|eot_id|><|start_header_id|>assistant<|end_header_id|>
EOF
echo "DONE creating prompt file at: $prompt_file"
}

# Create configs.yaml and prompt.txt for model_name
create_yaml
create_prompt

echo "RUNNING AlpacaEval... "
for lang in "${lang_codes[@]}"; do
  job_id=$(sbatch --export=model_name=$model_name,lang=$lang launch_scripts/eval_from_model.sh | awk '{print $4}')
  echo "Submitted slurm job for lang: ${lang^^}. Job ID: $job_id"
done