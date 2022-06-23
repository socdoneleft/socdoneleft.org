# Regret rates from gender-affirming surgery have not increased in the Dutch sample

The [VU University Medical Center](https://en.wikipedia.org/wiki/VU_University_Medical_Center) (VUmc) [Center of Expertise on Gender Dysphoria](https://www.vumc.com/departments/center-of-expertise-on-gender-dysphoria.htm) (CEGD) treats ~95% of patients who seek medical transition in the Netherlands.[^wiepjes2018note1] The CEGD saw a ~36x increase in adult patients, which some worry may result in increased regret rates. This post reviews the regret rate among patients received gender-affirming surgery (GAS).

In short: Evidence shows that the regret rate has not changed, even after extrapolating for future regret cases. This suggests that current patients may also benefit from medical transition.

![](https://cdn.discordapp.com/attachments/742557921849901077/989301109703196764/rate2.png)

<!--more-->

### The Dutch sample: Overview

The CEGD reviewed all of its medical records of all patients from 1972 to 2015. The first striking feature is that the CEGD saw a dramatic increase in adult patients from 1973 (~5 patients per year) to 2005 (~180 patients per year): 

![](https://cdn.discordapp.com/attachments/742557921849901077/989243475675480084/unknown.png)

Some conseratives worry that these new patients are less dysphoric than the old adult patients and may come to regret their gender-affirming surgery. More conspiratorially, many prominent conservative commentators have suggested that the new patients aren't truly trans and have been brainwashed by leftist gender ideology (or some other nonsense).

Both theories would suggest that the dramatic increase in new adult patients would lead to a dramatic increase in regret for gender-affirming surgery. 

The evidence shows otherwise: There has been no change in the regret rate.

### The Dutch sample: Unique features

Unlike most studies which report regret rates, the CEGD sample has two features:

1. It contains nearly the entire universe of patients (because it treats 95% of patients). Unless the remaining 5% are very unlike the included 95%, conclusions from this sample likely generalize to all people who seek medical transition in the Netherlands, and could plausibly generalize to all people who seek medical transition in other countries.
2. It published both the year that a patient received GAS and the time in months that it took for that patient to report regret for that GAS to the CEGD:

![Characteristics of GAS patients with regret](https://cdn.discordapp.com/attachments/742557921849901077/987602689540112434/unknown.png)

The latter point is particularly useful, because a survival curve for our purposes needs [1] time since treatment (months since GAS) and [2] binary event outcomes (regret / no regret).

### Briefly explaining survival curves and right-censoring

Survival curves track the proportion of patients who have died against the time since that patient received treatment. For example, this graph shows the percent of patients in the `veteran` dataset who survived, against the number of days since lung cancer teatment:

![](https://cdn.discordapp.com/attachments/742557921849901077/989252936255287336/unknown.png)

Lots of survival data follows different people for different lengths of time. This makes a simple comparison of outcomes between those who received a treatment and those who didn't difficult, because some experienced more time since the treatment. Survival models are good at estimating risks in data with different treatment-times and with "right-censored" individuals, where the study ended stopped following an individual before "completion" (death or the end of period of interest). If you want to know more about survival models, watch this [excellent lecture by MarinStats](https://www.youtube.com/watch?v=vX3l36ptrTU). The following section explains the difficulties with the Dutch sample. 

The CEGD study used medical records of patients from 1973 to 2015. The graph below shows the "calendar time" (number of years between the start of treatment and the end of observation):

![](https://cdn.discordapp.com/attachments/742557921849901077/989257937212035172/unknown.png)

The graph below shows the "serial time" (number of years between the start of treatment and end of observation):

![](https://cdn.discordapp.com/attachments/742557921849901077/989257953007779870/unknown.png)

The graph above shows that different cohorts (based on when they started treatment) have different serial time to observation. For example, the 1995 cohort has been observed for 20 years, while the 2005 cohort has been observed for just 10 years.

This fact results from right-censoring: We have not observed every cohort until "completion" (eg, until the patient died), so we cannot know their *lifetime* regret rate. Instead, we can only know their *serial-time* regret rate.

That causes a problem: Because the serial-time is greater for earlier cohorts than later cohorts, there is more time for earlier cohorts to regret than later cohorts. If we naively compared the observed regret rates, we might underestimate the true regret rate for later cohorts.

For example: Let's imagine that 100% of regret occurs within the first 20 years. If so, then the 2010 cohort would be missing 15 years of observation (shown in red), the 2005 cohort 10, and the 2000 cohort 5:

![](https://cdn.discordapp.com/attachments/742557921849901077/989266366324432956/unknown.png)

All of the above is to establish a very simple point: We can't just compare the "naive" rates of regret for each cohort. Instead, my strategy is, for recent cohorts, to [extrapolate](https://en.wikipedia.org/wiki/Extrapolation) the extra cases of regret that we expect to observe.

The above facts will *increase* the rate of regret for recent cohorts. This is a conservative assumption that will tend to strengthen the case *against* gender-affirming surgery. However, because rates of regret remain so low, that case remains very weak.

### Pseudo-individual data creation

In their published results, Wiepjes et al 2018 reported that 0.5% of their patients who had received gender-affirming surgery (GAS) later reported regret to the clinic.[^wiepjes2018]

However, this estimate comes from both their adult and adolescent sample. Wiepjes et al 2018 provided semi-detailed information only about their adult sample, which is shown below:

![](https://cdn.discordapp.com/attachments/742557921849901077/989269922393763930/unknown.png)

All cases of regret came from their adult sample. Below, I will only estimate the regret rate among the adult sample. This is another conservative assumption that will tend to *increase* the rate of regret.

The Wiepjes et al 2018 report only publishes data for non-regretful adult patients by cohort, rather than by individual. In order to do create a better survival curve, I simulated data that approximates what that individual data would look like: For each cohort of N-many people, a uniform distribution of N `years_since_gas` was generated from `year_cohort` + 3 (the lower bound of [year joined clinic] minus [year obtained GAS]) to `year_cohort` + 4 + 5 (since most cohorts were 5-years long). This data is shown below:

![](https://cdn.discordapp.com/attachments/742557921849901077/989284749753352212/unknown.png)

It's not a perfect dataset, but it's a good rough approximation.

### Rates of regret: Naive and extrapolated

Of 1825 adult patients (at time of first visit), 0.9% ever reported regret to the clinic. The graph below shows their observed regret rates (naive) by cohort:

![](https://cdn.discordapp.com/attachments/742557921849901077/989301110311383060/rate.png)

There seems to be a downward trend in the above data, but it's not worth investigating before we extrapolate potential future regret for the 2000 and 2005 cohorts.

The graph below shows the Cox Proportional Hazards survival curve[^coxnote] of regret rate against serial time (time since gender-affirming surgery):

![](https://cdn.discordapp.com/attachments/742557921849901077/989301109942280212/survival.png)

In this survival model, the regret rate slowly rises from 0% immediately after surgery to 0.5% after 10 years and 0.9% after 19 years. We can use the above survival curve to extrapolate missing cases for the 1995-2005 cohorts (which have not yet observed 19 years of data as of 2015).[^note18]

The extrapolation model is as follows: We multiply the ([number of GAS patients N0 in a cohort] minus [number of GAS patients NR in a cohort who currently regret surgery]) by ([the predicted risk at 19 years] minus [the predicted risk at *t* years]), where t is the [cohort year] plus 4[^note4] minus 2015. Example: For 2000, we would multiply (342 patients, N0) - (1 patient, NR) by (risk at 19 years) - (risk at 15 years). This gives an extrapolated guess of how many patients will regret their surgery in the future, given that 19-t years have already passed without regret their surgery.

The addition of 2.6 extrapolated regret cases nearly doubles the regret rates for 1995 and 2000, and raises the regret rate from 0% in 2005. The graph below compares the actual regret rate against the extrapolated regret rate:

![](https://cdn.discordapp.com/attachments/742557921849901077/989301109703196764/rate2.png)

However, the graph above still appears to have a substantial downward slope. Indeed, in our Cox PH model, the coefficient for `year_cohort` is negative. However, this trend is not significant (see that the confidence interval for `year_cohort` overlaps 1):

```r
> summary(cox_fit)
Call:
coxph(formula = Surv(time = years_since_gas, event = regr) ~ 
    year_cohort, data = regret_surv)

  n= 1825, number of events= 14 

                coef exp(coef) se(coef)      z Pr(>|z|)
year_cohort -0.03614   0.96451  0.03167 -1.141    0.254

            exp(coef) exp(-coef) lower .95 upper .95
year_cohort    0.9645      1.037    0.9065     1.026

Concordance= 0.62  (se = 0.065 )
Likelihood ratio test= 1.26  on 1 df,   p=0.3
Wald test            = 1.3  on 1 df,   p=0.3
Score (logrank) test = 1.32  on 1 df,   p=0.3
```

### Conclusions

Conservative fears of less-dysphoric or brainwashed patients attending gender identity clinics would suggest an upward trend in regret rates. The CEGD saw a dramatic increase of patients, which makes this a good dataset to test that fear. However, there was no upward trend in regret rates, significant or otherwise. In fact, there was a *downward* trend, though it was not significant.

This suggests that regret rates for gender-affirmation surgery may not increase in the future. Along with other CEGD results, this suggests that the patients seen nowadays are comparable to the patients seen in decades past, for whom social and medical transition had substantial benefits. (See next post.)

In short: The CEGD constant regret rate results lend support to granting gender-affirmation surgery to the current larger pool of patients seen in the Netherlands. If we believe that these Dutch results are similar to American results, similar logic would apply here.

### Shilling

Support my Patreon to support my work: <https://www.patreon.com/socdoneleft>

A better world is possible. Join the DSA: <https://act.dsausa.org/donate/membership2020/>

[^coxnote]: Cox Proportional Hazards is a semi-parametric survival curve model. (Read: It makes some assumptions, but not a lot, about the underlying data.) Cox PH which assumes that the relative hazards do not vary with time. This proportional hazard assumptions are satisfied with respect to cohort, the only covariate: There is no obvious trend with time, and p > 0.05: ![](https://cdn.discordapp.com/attachments/742557921849901077/989290799445467226/unknown.png)
[^wiepjes2018]: Wiepjes et al 2018: 2760 trans women and 985 trans men visited the VUcm CEGD (representing 95% of Dutch patients for gender dysphoria from 1972-2015); of those, 2624 trans women (68.9%) and 1183 trans men (72.9%) began gender-affirming hormones (GAH); of those, 1976 trans women (79.5%) and 992 trans men (83.8%) obtained gender-affirming surgery (GAS); and of those, 11 trans women (0.6%) and 3 trans men (0.3%) reported regret to the CEGD: <https://pubmed.ncbi.nlm.nih.gov/29463477/> <https://sci-hub.se/10.1016/j.jsxm.2018.01.016> <https://www.jsm.jsexmed.org/article/S1743-6095(18)30057-2/fulltext> <https://cdn.discordapp.com/attachments/742557921849901077/987178425448005632/wiepjes2018.pdf> https://cdn.discordapp.com/attachments/742557921849901077/987594105620164608/unknown.png https://cdn.discordapp.com/attachments/742557921849901077/987602689540112434/unknown.png
[^wiepjes2018note1]: Wiepjes et al 2018: the VUcm CEGD sample includes ~95% of Dutch patients for gender dysphoria from 1972-2015: <https://pubmed.ncbi.nlm.nih.gov/29463477/> <https://sci-hub.se/10.1016/j.jsxm.2018.01.016> <https://www.jsm.jsexmed.org/article/S1743-6095(18)30057-2/fulltext> <https://cdn.discordapp.com/attachments/742557921849901077/987178425448005632/wiepjes2018.pdf> https://cdn.discordapp.com/attachments/742557921849901077/987612873041784882/unknown.png
[^note18]: It's 18.75 years, but I say "19 years" for concision.
[^note4]: Four is the average years between visiting the clinic and obtaining gender-affirming surgery.