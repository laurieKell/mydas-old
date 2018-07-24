rm(list=ls())
# install LBSPR from cran
install.packages("LBSPR")
#install LIME at master branch
devtools::install_github("merrillrudd/LIME")
library(LIME)
library(LBSPR)
#devtools::install_github("kaskr/TMB_contrib_R/TMBhelper", dependencies=TRUE)
library(TMBhelper)
library(dplyr)
library(ggplot2)
library(RColorBrewer)
library(reshape2)

## working directory
wd <- "C:/Users/Maite Pons/Desktop/LIME"

## life history list
lh <- create_lh_list(vbk=0.209, 
					 linf=122.198, 
					 t0=-1.338,
					 lwa=1.34e-05, 
					 lwb=3.1066, 
					 S50=78, 
					 S95=90, 
					 selex_input="length",
					 selex_type=c("logistic"),
					 M50=90,
					 M95=100,
					 maturity_input="length",
					 M=0.3, 
					 AgeMax=15,
					 h=0.9,
					 binwidth=2,
					 CVlen=0.1,
					 SigmaR=0.001, 
					 SigmaF=0.1,
					 SigmaC=0.1,
					 SigmaI=0.1,
					 R0=1,
					 Frate=0.1,
					 Fequil=0.25,
					 qcoef=1e-5,
					 start_ages=0,
					 nseasons=1,
					 nfleets=1)

## look at some life history stuff
# pdf("life_history_ALB.pdf",height = 6,width = 8)
ggplot(lh$df %>% filter(By=="Age")) +
	geom_line(aes(x=X, y=Value), lwd=2) +
	facet_wrap(~Variable, scale="free_y") +
	xlab("Age") + ylab("Value")
# dev.off()

## read length data and make sure it has column names for the bins
lfdata <- as.matrix(read.csv(file.path(wd, "Length_comps_ALB_onefleet_RecDevs.csv"), row=1))
colnames(lfdata) <- seq(from=20, length.out=ncol(lfdata), by=lh$binwidth)

## filter years --- last 5 years of data
years <- 1997:2011
lf <- lfdata[which(rownames(lfdata) %in% years),]

## plot data
plot_LCfits(LFlist=list("LF"=lf))

## input data
data_list <- list("years"=as.numeric(rownames(lf)), "LF"=lf)

## create input list -- adds some zeros on the end as well to make sure there is room for larger fish
inputs <- create_inputs(lh=lh, input_data=data_list)

## run LIME
#*** keep estimation of log_sigma_R on unless it has convergence issues
res <- run_LIME(modpath=NULL,
				input=inputs,
				data_avail="LC")

## check TMB inputs
Inputs <- res$Inputs
## Report file
Report <- res$Report
## Standard error report
Sdreport <- res$Sdreport

## check convergence
hessian <- Sdreport$pdHess
gradient <- res$opt$max_gradient <= 0.001
hessian == TRUE & gradient == TRUE

## plot length composition data and fits
plot_LCfits(Inputs=Inputs, 
			Report=Report,
			true_years=years)		


#######################################################
## compare with LBSPR
#######################################################

   LB_lengths <- new("LB_lengths")
   LB_lengths@LMids <- inputs$mids
   LB_lengths@LData <- t(inputs$LF[,,1])
   LB_lengths@Years <- as.numeric(rownames(inputs$LF))
   LB_lengths@NYears <- nrow(inputs$LF)           

      ##----------------------------------------------------------------
      ## Step 2: Specify biological inputs and parameter starting values
      ##----------------------------------------------------------------
   LB_pars <- new("LB_pars")
   LB_pars@MK <- lh$M/lh$vbk
   LB_pars@Linf <- lh$linf
   LB_pars@L50 <- lh$ML50
   LB_pars@L95 <- lh$ML95
   LB_pars@Walpha <- lh$lwa
   LB_pars@Wbeta <- lh$lwb
   LB_pars@BinWidth <- lh$binwidth  
   LB_pars@R0 <- 1
   LB_pars@Steepness <- ifelse(lh$h==1, 0.99, lh$h)


   lbspr_res <- LBSPRfit(LB_pars=LB_pars, LB_lengths=LB_lengths, Control=list(modtype=c("GTG")))

   plot_output(Inputs=Inputs, 
            Report=Report,
            Sdreport=Sdreport, 
            lh=lh,
            LBSPR=lbspr_res,
            plot=c("Fish","Rec","SPR","Selex"), 
            set_ylim=list("SPR" = c(0,1)))
