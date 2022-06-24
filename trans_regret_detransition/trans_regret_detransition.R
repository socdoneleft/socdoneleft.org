#####
# init
#####
# remove all objects
rm(list=ls(all=TRUE))

# load packages
require("data.table")
require("stringr")
require("ggplot2")
library("hrbrthemes")
library("survival")
library("survminer")

# set working directory
(wd = paste0("C:/Users/", Sys.info()["effective_user"], "/google_drive/research/blog/_complete/trans_regret_detransition"))
setwd(wd)

#####
# read data
#####
# trans patients data
trans = data.table(year_cohort = c(1972, 1980, 1985, 1990, 1995, 2000, 2005, 2010),
                   men_n = c(119, 189, 319, 392, 522, 605, 476, 138),
                   men_gah = c(.899, .884, .759, .658, .655, .560, .616, .609),
                   men_gas = c(.794, .719, .765, .767, .787, .673, .686, NA),
                   women_n = c(30, 69, 105, 142, 177, 207, 185, 70),
                   women_gah = c(.967, .841, .848, .690, .650, .633, .638, .714),
                   women_gas = c(.724, .828, .798, .888, .887, .870, .814, NA))
trans[, gas_n := round(men_n * men_gah * men_gas + women_n * women_gah * women_gas)]

# gas patient regret data
year_bins = c(0, 1972, 1980, 1985, 1990, 1995, 2000, 2005, 2010, 3e4)
regret = data.table(year_gas = c(1979, 1984, 1988, 1990, 1990, 1993, 1995, 1994, 1997, 1999, 2007, 1990, 1993, 1997),
                    years_since_gas = c(130, 27, 197, 167, 44, 49, 225, 61, 73, 27, 92, 50, 74, 212)/12,
                    reason = c("social acceptance", "true regret", "non-binary")[c(1,1,1,2,1,1,2,3,2,2,2,2,3,2)])
regret[, year_cohort := year_gas - 4] # average of ~4 years between first visit, hormone therapy, and then gas
regret[, year_cut := cut(year_cohort, year_bins, right = FALSE)]
regret[, year_cut_num := as.numeric(year_cut) - 1]
regret[, year_gas_bin := trans[["year_cohort"]][year_cut_num]]

# specific subsets
regret = regret[reason %in% c("true regret", "non-binary"), ]
# regret = regret[reason %in% c("social acceptance"), ]

# combine data
regret_smy = regret[, .(regret_n = .N), by = c("year_gas_bin")]
trans = merge(trans, regret_smy, by.x = c("year_cohort"), by.y = c("year_gas_bin"), all = TRUE)
trans[is.na(regret_n), regret_n := 0]

# create pseudo-individual data from aggregated data, assuming uniform distribution of years to regret
regret_surv = regret[, c("years_since_gas", "year_gas_bin", "reason")]
setnames(regret_surv, "year_gas_bin", "year_cohort")
regret_surv[, regr := 1]
dup_row = function(row) {
  year_cohort = row[["year_cohort"]]
  gas_n = row[["gas_n"]]
  regret_n = row[["regret_n"]]
  if (is.na(gas_n)) {
    return()
  }
  l = gas_n - regret_n
  # 3 is lower end of how fast btwn first appt and GAS
  # 4 is lower end of how fast btwn first appt and GAS
  return(data.table(year_cohort = year_cohort,
                    years_since_gas = seq(from = 2015 - (year_cohort + 3), to = (2015 - (min(2015, year_cohort + 4 + 5))), length.out = l),
                    regr = rep(0, l),
                    reason = rep("none", l)))
}
dup_rows = rbindlist(lapply(1:nrow(trans), function(i){row=trans[i, ];dup_row(row)}))
regret_surv = rbindlist(list(dup_rows, regret_surv), use.names = TRUE)

ggplot(dup_rows, aes(y = year_cohort, x = years_since_gas)) +
  geom_jitter() +
  theme_ft_rc() +
  labs(caption = "@socdoneleft")

# assuming all regrets reported within 20 years (has no effect on results)
regret_surv[, years_since_gas_min := min(20, years_since_gas), by = 1:nrow(regret_surv)]

# generate cox proportional hazard fit
cox_fit = coxph(formula = Surv(time=years_since_gas, event=regr) ~ year_cohort, data = regret_surv)
summary(cox_fit)
ggsurvplot(survfit(cox_fit, data = regret_surv), ylim = c(0.95, 1), censor = FALSE, ggtheme = theme_ft_rc())

# test fails significance, suggesting proportional hazards assumption holds
# http://www.sthda.com/english/wiki/cox-model-assumptions
(cox_test = cox.zph(cox_fit))
ggcoxzph(cox_test)

surv_fit = survfit(cox_fit)
# equivalent to: basehaz(cox_fit)
# cbind(surv_fit$time, surv_fit$cumhaz)
# plot(surv_fit$time, exp(surv_fit$cumhaz))

# see also https://stats.stackexchange.com/questions/288393/calculating-survival-probability-per-person-at-time-t-from-cox-ph
cox_leftover_mult_calc = function(year_row, year_coef, year_mean, surv_fit) {
  reference_year = 2015
  time_left = reference_year - year_row

  times = surv_fit$time
  cumhaz = surv_fit$cumhaz
  cumhazx = exp(cumhaz)^(exp((year_row-year_mean)*year_coef))

  index = which.min(abs(times - time_left))

  mult_t1 = cumhazx[index]
  mult_t2 = last(cumhazx)
  mult_diff = mult_t2 - mult_t1
  print(c(mult_t1, mult_t2, mult_diff))

  return(mult_diff)
}

year_mean = mean(regret_surv[["year_cohort"]])
year_coef = cox_fit$coef
(cox_leftover_mult_calc(2000, year_coef, year_mean, surv_fit))

# obtain relative hazard risk of cox survival curve by year
# see also: https://stat.ethz.ch/R-manual/R-devel/library/survival/html/predict.coxph.html
# see also: https://stats.stackexchange.com/questions/44896/how-to-interpret-the-output-of-predict-coxph
# TLDR: represents the relative risk, given the covariates for that individual
regret_surv[, c("pred", "pred_se") := predict(cox_fit, type="risk", se.fit = TRUE)]
preds = regret_surv[, .(pred = min(pred)), by = c("year_cohort")]
preds

# merge predicted with actual regret
trans = merge(trans, preds, all = TRUE)

trans[, mult_extrapolate := cox_leftover_mult_calc(year_cohort + 4, year_coef, year_mean, surv_fit), by = 1:nrow(trans)]

# extrapolate likely number of regretters yet to be seen
trans[, regret_n_extrapolated := regret_n + (gas_n - regret_n) * mult_extrapolate]

# calculate regret rate by 5-year period
trans[, regret := regret_n / gas_n]
trans[, regret_extrapolated := regret_n_extrapolated / gas_n]

#####
# graph data
#####
# graph fancy density curve
ggplot(regret, aes(x = years_since_gas, y = 0)) +
  scale_x_continuous(limits = c(0, max(regret[["years_since_gas"]]))) +
  geom_violin() + geom_boxplot(width = .1) + geom_point() + geom_vline(xintercept = mean(regret[["years_since_gas"]])) +
  labs(x = "proportion of patients currently reporting regret of gender-affirming surgery",
       y = "density",
       caption = "@socdoneleft")

# graph survival curve
ggsurvplot(survfit(cox_fit, data = regret_surv),
           ylim = c(0.95, 1),
           censor = FALSE,
           ggtheme = theme_ft_rc(),
           title = "Survival curve of regret among Dutch patients",
           xlab = "time since gender-affirming surgery",
           ylab = "proportion who have not reported regret",
           caption = "@socdoneleft",
           surv.scale = "percent")
ggsave("survival.png", width=10, height=7.5)

# graph regret rate over time
ggplot(trans, aes(x = year_cohort, y = regret)) +
  geom_point() + geom_line() +
  theme_ft_rc() +
  scale_x_continuous(expand = c(0.01, 0.01)) +
  scale_y_continuous(expand = c(0, 0), limits = c(0, 0.05), labels = percent) +
  labs(x = "year patient first visited clinic",
       y = "% who regret gender-affirming surgery",
       title = "Gender-affirming surgery regret rate among Dutch patients, by cohort",
       caption = "@socdoneleft")
ggsave("rate.png", width=10, height=7.5)

mdt = melt(trans[, c("year_cohort", "regret", "regret_extrapolated")], id.vars = c("year_cohort"))
mdt[, variable := str_replace_all(variable, c("regret$"="regret_actual"))]
mdt[variable == "regret_extrapolated" & year_cohort < 1990, value := NA]
ggplot(mdt, aes(x = year_cohort, y = value, color = variable)) +
  geom_point() + geom_line() +
  theme_ft_rc() +
  scale_x_continuous(expand = c(0.01, 0.01)) +
  scale_y_continuous(expand = c(0, 0), limits = c(0, 0.05), labels = percent) +
  labs(x = "year patient first visited clinic",
       y = "% who regret gender-affirming surgery",
       title = "Gender-affirming surgery regret rate among Dutch patients, by cohort",
       subtitle = "Subsample: Regret because patient feels non-binary or regrets surgery proper",
       caption = "@socdoneleft")
ggsave("rate2.png", width=10, height=7.5)
