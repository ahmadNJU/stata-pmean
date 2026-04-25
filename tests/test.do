clear
input id time x
1 1 10
1 2 20
2 1 30
2 2 40
end

pmean x, id(id) time(time)

assert pm_overall_x == 25
