import strutils

let damm = [ [0, 3, 1, 7, 5, 9, 8, 6, 4, 2],
             [7, 0, 9, 2, 1, 5, 4, 8, 6, 3],
             [4, 2, 0, 6, 8, 7, 1, 3, 5, 9],
             [1, 7, 5, 0, 9, 8, 3, 4, 2, 6],
             [6, 1, 2, 3, 0, 4, 5, 9, 7, 8],
             [3, 6, 7, 4, 2, 0, 9, 5, 8, 1],
             [5, 8, 6, 9, 7, 2, 0, 1, 3, 4],
             [8, 9, 4, 5, 3, 6, 2, 0, 1, 7],
             [9, 4, 3, 8, 6, 1, 7, 2, 0, 5],
             [2, 5, 8, 1, 4, 3, 6, 7, 9, 0] ]

proc is_valid(num: int): bool =
  let n_str = intToStr(num)
  var temp = 0
  for i in 0..len(n_str) - 1:
    temp = damm[temp][int(n_str[i]) - 48]
  return temp == 0

echo "Valid numbers between 5700 and 5800 are:"
for i in 5700..5800:
  if is_valid(i):
    stdout.write i, " "
echo ""
