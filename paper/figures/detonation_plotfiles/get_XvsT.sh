for wn in 0 20 35 45
do
  d="wn_"$wn
  r="~/detonations/"
  cp $r$d"/XvsT_"$d"*" .
done
python eps2pdfall.py
