# setwd('~/GitHub/analysis/') # you might need to set this to the working directory of the repo

list.of.packages <- c("dplyr", "ggplot2", "magrittr", 'reshape2', "gridExtra")
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
if(length(new.packages)) install.packages(new.packages)

library(dplyr)
library(ggplot2)
library(magrittr)
library(reshape2)
library(gridExtra)

d <- read.csv('data-samples/2018_household_individual_weights_cleaned.csv')
# remove all the "total" stats which weren't excluded when we downloaded this data from statsa

d %<>% filter(PROVINCES != 'Total')
# we can start by checking that the total weight for the country reconciles with what we knew the population size to be in 2018
d %>% group_by(PROVINCES) %>% summarise(pop = sum(Person.information))
d %>% names
d$Person.information %>% sum
d %>% group_by(Safe.to.drink) %>% summarise(pop = sum(Person.Weight))
d

d %>% group_by(PROVINCES) %>% summarise(pop = sum(Person.information))
normalisationNum = d$Person.Weight %>% sum()
d$Person.Weight <- (d$Person.Weight  / normalisationNum) * 100

d %>% group_by(PROVINCES) %>% summarise(pop = sum(Person.Weight))

p <- d %>% group_by(PROVINCES, Safe.to.drink) %>% summarise(pop = sum(Person.Weight)) 
p1<- ggplot(data = p) + 
  geom_bar(aes(x = PROVINCES, group = Safe.to.drink, y = pop, fill = Safe.to.drink), 
                            stat = 'identity', position = 'dodge') + 
  theme_bw() + 
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) + ylab("Proportion of total population")
p1

p<- dcast(p, PROVINCES ~ Safe.to.drink, value.var = 'pop')
p[is.na(p)] <- 0
q<- p %>% 
  mutate(Total = No + Unspecified + Yes) %>%
  mutate(UnsafeWater = No / Total * 100, SafeWater = Yes / Total * 100)
q<- melt(q) %>% filter(variable == 'SafeWater' | variable == 'UnsafeWater')
p2<- ggplot(data = q) + 
  geom_bar(aes(x = PROVINCES, group = variable, y = value, fill = variable), 
           stat = 'identity', position = 'dodge') + 
  theme_bw() + 
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) + ylab("Proportion of province population")
p2


scalar = 100
#png('examples/safe_unsafe_water.png', height = 6 * scalar, width = 9 * scalar, res = 100)
grid.arrange(p1,p2)
#dev.off()
