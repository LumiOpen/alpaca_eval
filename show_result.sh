awk -F, 'NR==1 {
  for (i=1; i<=NF; i++) if ($i=="length_controlled_winrate") col=i
}
NR==2 && col { printf("length_controlled_winrate: %.2f\n", $col) }' ./results/$1-$2/weighted_alpaca_eval_gpt-4o-2024-08-06/leaderboard.csv