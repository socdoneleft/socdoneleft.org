rm(list=ls(all=TRUE))

x = c(1, 2, 3)
y = c(4, 5, 6)
x * y

p = c(0.5, 0.5)
z = c(1, 0)
p * z
sum(p * z)

# cd, nb, fm, mf
gid = c(.03, .35, .29, .33)
srs = c(.06, .43, .82, .68)
gid * srs
sum(gid * srs)
p_transition = sum(gid * srs)

p_regret = 0.022 # 2.2%
uspop = 329000000 # 329 million
ukpop = 67000000 # 67 million

uspop * 0.0066 # 0.66%
uspop * 0.0066 * p_transition * (ukpop/uspop)
uspop * 0.0066 * p_transition * p_regret
uspop * 0.0066 * p_transition * p_regret * (ukpop/uspop)

uspop * 0.0066 * p_transition * (1 - p_regret) * (ukpop/uspop)