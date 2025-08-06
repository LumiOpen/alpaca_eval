model_name="$1"
csv_file="./results/$1-$2/weighted_alpaca_eval_gpt-4o-2024-08-06/leaderboard.csv"

awk -F',' -v model="$model_name" '$1 == model { printf "length_controlled_winrate: %.2f\n", $11 }' "$csv_file"

