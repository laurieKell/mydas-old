##-------------------
## simulate some example data
## CM: 1/7/2017
##
##-------------------

library(spict)

## simulate:
set.seed(3)
raz.inp <- list()
raz.inp$nseasons <- 4
raz.inp$splineorder <- 1
ny <- 20
yr.pts <- seq(1, ny)
qtrly.C.pts <- (1 * 4):(ny * 4) / 4
qtrly.I.pts <- (10 * 4):(ny * 4) / 4
raz.inp$obsC <- qtrly.C.pts
raz.inp$timeC <- qtrly.C.pts
raz.inp$obsI <- list(ann1 = yr.pts,
                     ann2 = yr.pts,
                     qtrly1 = qtrly.I.pts,
                     qtrly2 = qtrly.I.pts)
raz.inp$timeI <-  raz.inp$obsI
## biological settings
raz.ini <- list(logn = log(2), gamma = 4, logK = log(1e3), logm = log(3e2),
                logq = log(c(ann1 = 0.1, ann2 = 0.1, qtrly1 = 0.1, qtrly2 = 0.1)),
                logsdf = log(0.1),
                logsdb = log(0.001),
                logsdc = log(0.1),
                logsdi = log(c(0.1)))
raz.inp$ini <- raz.ini ## repin$inp$ini
raz.inp$ini$logF <- NULL
raz.inp$ini$logB <- NULL
raz.inp$ini$logphi <- rep(log(2), 3) # Seasonality introduced here
raz.inp <- check.inp(raz.inp)
raz.sim <- sim.spict(raz.inp)
##
catch.df <- data.frame(year = 2000 + raz.sim$timeC,
                       catch = raz.sim$obsC)
##
I.df <- data.frame(year = 2000 + c(raz.sim$timeI[[1]], raz.sim$timeI[[2]], raz.sim$timeI[[3]], raz.sim$timeI[[4]]),
                   cpue = c(raz.sim$obsI[[1]], raz.sim$obsI[[2]], raz.sim$obsI[[3]], raz.sim$obsI[[4]]),
                   index = rep(names(raz.inp$ini$logq), times = unlist(lapply(raz.sim$obsI, length))))
##
library(ggplot2)
theme_set(theme_bw())

pdf("../tex/figures/sim_catch.pdf", height = 6, width = 7)
ggplot(catch.df, aes(x = year, y = catch)) + geom_line() + ylim(0, max(catch.df$catch)) + xlab("Year") + ylab("Catch") + ggtitle("Seasonal simulated catches") + theme(plot.title = element_text(hjust = 0.5))
dev.off()

pdf("../tex/figures/sim_indices.pdf", height = 7, width = 7)
ggplot(I.df, aes(x = year, y = cpue)) + geom_line() + ylab("Index") + facet_wrap(~ index) + ggtitle("Varying timescale indices") + theme(plot.title = element_text(hjust = 0.5))
dev.off()

## fit
## create data object for spict
raz.stk <- list()
raz.stk$obsC <- raz.sim$obsC
raz.stk$timeC <- raz.sim$timeC 

## indices of abundance
raz.stk$obsI <- list(
    ann1 = raz.sim$obsI[[1]],
    ann1 = raz.sim$obsI[[2]],
    qtrly1 = raz.sim$obsI[[3]],
    qtrly1 = raz.sim$obsI[[4]]
)

raz.stk$timeI <- list(
    ann1 = raz.sim$timeI[[1]],
    ann1 = raz.sim$timeI[[2]],
    qtrly1 = raz.sim$timeI[[3]],
    qtrly1 = raz.sim$timeI[[4]]
)

raz.stk$ini <- list(
    logm = log(mean(raz.sim$obsC)),
    logK = log(1e3),
    logsdc = log(1e-3)
)

## assume Schaefer production
raz.stk$ini$logn <- log(2)
raz.stk$phases$logn <- -1 ## fixes the parameter at starting value
raz.stk$priors$logn <- c(log(2), 1, 0) ## disables the prior
## fix catch measurment error low
raz.stk$phases$logsdc <- -1 ## fixes the parameter at starting value
raz.stk$dteuler <- 1/8

raz.stk <- check.inp(raz.stk)

rep <- fit.spict(raz.stk)

pdf("../tex/figures/sim_fit.pdf", height = 7, width = 9)
plot(rep)
dev.off()
## Note there are warnings but it converges

## diagnostic plots
rep.resid <- calc.osa.resid(rep)
plotspict.diagnostic(rep.resid)

source("myplotb2bmsy.R")
source("myplotf2fmsy.R")

pdf("../tex/figures/sim_b2bmsy.pdf", height = 7, width = 8)
myplotspict.bbmsy(rep, qlegend = FALSE, ylim = c(0,2))
lines(raz.sim$true$time, exp(raz.sim$true$logBBmsy), col = "red", lwd = 2)
dev.off()

pdf("../tex/figures/sim_f2fmsy.pdf", height = 7, width = 8)
myplotspict.ffmsy(rep, qlegend = FALSE, ylim = c(0,1.5))
lines(raz.sim$true$time, exp(raz.sim$true$logFFmsy), col = "red", lwd = 2)
dev.off()

