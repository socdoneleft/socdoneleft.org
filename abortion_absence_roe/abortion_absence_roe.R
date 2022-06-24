#####
# init
#####
# remove all objects
rm(list=ls(all=TRUE))

# load packages
require("data.table")
require("ggplot2")
require("sdlutils")
require("stringr")
require("tigris")

# set working directory
wd = paste0("C:/Users/", Sys.info()["effective_user"], "/google_drive/research/blog/_complete/abortion_absence_roe/")
setwd(wd)

#####
# create data
#####
# load state data
states_ = states(cb = TRUE)
states_shift = shift_geometry(states_, position = "below")
statesdt = data.table(states_shift)
statesdt[, STATEFP := as.numeric(STATEFP)]

# create data table of state laws
st = data.table(state)
st[, law := NA_character_]
trigger_bans = c("arkansas", "idaho", "kentucky", "louisiana", "mississippi", "missouri", "north dakota", "oklahoma", "south dakota", "tennessee", "texas", "utah", "wyoming")
total_bans = c("alabama", "arkansas", "louisiana", "oklahoma", "utah")
sixweek_bans = c("georgia", "idaho", "iowa", "kentucky", "louisiana", "mississippi", "north dakota", "ohio", "oklahoma", "south carolina", "tennessee", "texas")
eightweek_bans = c("missouri")
st[region %in% c(trigger_bans, total_bans, sixweek_bans, eightweek_bans), law := "CERTAIN BAN:\nState has at least one of:\n* post-Roe trigger ban\n* total abortion ban\n* six week abortion ban\n* eight week abortion ban"]
const_bar = c("alabama", "louisiana", "tennessee", "west virginia")
likely_ban = c("florida", "indiana", "montana", "nebraska")
st[is.na(law) & region %in% c(const_bar, likely_ban), law := "LIKELY BAN:\nState has at least one of:\n* constitution bars protection for abortion\n* recently sharply restricted abortion"]
const_prot = c("montana", "kansas", "minnesota", "iowa", "florida")
st[is.na(law) & region %in% const_prot, law := "IMPLICIT PROTECTION:\nState constitution protects right to abortion, but:\n* Minnesota: State law does not explicitly\nprotect specific abortion rights\n* Kansas: Legislature voted for a ballot measure\non 2022 August 02 where voters will decide\nwhether to remove the right to abortion\nHouse vote: 86 R for, 38 D against\nSenate vote: 27R for, 1R 12D against"]
preroe_ban = c("alabama", "arizona", "arkansas", "michigan", "mississippi", "north carolina", "oklahoma", "texas", "west virginia", "wisconsin")
st[is.na(law) & region %in% preroe_ban, law := "PRE-ROE BAN:\nState has an unenforced pre-1973 ban\nwhich the state may choose to enforce"]
st[is.na(law), law := "NO CLEAR LAW"]
law_prot = c("california", "colorado", "connecticut", "delaware", "district of columbia", "hawaii", "illinois", "maine", "maryland", "massachusetts", "nevada", "new jersey", "new york", "oregon", "rhode island", "vermont", "washington")
st[region %in% law_prot, law := "LEGAL PROTECTION:\nCurrent state law protects right to abortion"]

# factor group laws
st[, law2 := factor(law, levels = c(str_subset(unique(law), "CERTAIN"), str_subset(unique(law), "LIKELY"), str_subset(unique(law), "PRE-ROE"), str_subset(unique(law), "NO CLEAR"), str_subset(unique(law), "IMPLICIT"), str_subset(unique(law), "LEGAL")))]

ex = 0
ggplot(data=st, aes(x=long, y=lat, fill=law2, group=group)) +
  geom_polygon(size = 0, color = "white") +
  labs(title = "Current law on abortion by state, in the absence of Roe and Casey",
       fill = "Current law") +
  scale_fill_manual(values = c("red4", "salmon", "grey50", "grey75", "royalblue", "navyblue")) +
  coord_map(projection = "albers", lat0 = 39, lat1 = 45) +
  scale_x_continuous(expand = c(ex, ex)) +
  scale_y_continuous(expand = c(ex, ex)) +
  theme_sdl(map = TRUE) +
  theme(rect = element_rect(fill = "#FFFFFF", color = "#FFFFFF"))
ggsave("abortion_map.png", width = 12, height = 8)

