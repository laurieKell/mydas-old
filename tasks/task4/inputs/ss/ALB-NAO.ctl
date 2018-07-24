#V3.30.10.00-safe;_2018_01_09;_Stock_Synthesis_by_Richard_Methot_(NOAA)_using_ADMB_11.6
#_data_and_control_files: ALB-NAO.dat // ALB-NAO.ctl
#V3.30.10.00-safe;_2018_01_09;_Stock_Synthesis_by_Richard_Methot_(NOAA)_using_ADMB_11.6
#_user_support_available_at:NMFS.Stock.Synthesis@noaa.gov
#_user_info_available_at:https://vlab.ncep.noaa.gov/group/stock-synthesis
0  # 0 means do not read wtatage.ss; 1 means read and use wtatage.ss and also read and use growth parameters
1  #_N_Growth_Patterns
1 #_N_platoons_Within_GrowthPattern 
#_Cond 1 #_Morph_between/within_stdev_ratio (no read if N_morphs=1)
#_Cond  1 #vector_Morphdist_(-1_in_first_val_gives_normal_approx)
#
2 # recr_dist_method for parameters:  2=main effects for GP, Area, Settle timing; 3=each Settle entity
1 # not yet implemented; Future usage: Spawner-Recruitment: 1=global; 2=by area
1 #  number of recruitment settlement assignments 
0 # unused option
#GPattern month  area  age (for each settlement assignment)
1 1 1 0
#
#_Cond 0 # N_movement_definitions goes here if Nareas > 1
#_Cond 1.0 # first age that moves (real age at begin of season, not integer) also cond on do_migration>0
#_Cond 1 1 1 2 4 10 # example move definition for seas=1, morph=1, source=1 dest=2, age1=4, age2=10
#
1 #_Nblock_Patterns
1 #_blocks_per_pattern 
# begin and end years of blocks
1929 1929
#
# controls for all timevary parameters 
1 #_env/block/dev_adjust_method for all time-vary parms (1=warn relative to base parm bounds; 3=no bound check)
#  autogen
0 0 0 0 0 # autogen: 1st element for biology, 2nd for SR, 3rd for Q, 4th reserved, 5th for selex
# where: 0 = autogen all time-varying parms; 1 = read each time-varying parm line; 2 = read then autogen if parm min==-12345
# 
#
# setup for M, growth, maturity, fecundity, recruitment distibution, movement 
#
0 #_natM_type:_0=1Parm; 1=N_breakpoints;_2=Lorenzen;_3=agespecific;_4=agespec_withseasinterpolate
#_no additional input for selected M option; read 1P per morph
1 # GrowthModel: 1=vonBert with L1&L2; 2=Richards with L1&L2; 3=age_specific_K; 4=not implemented
1 #_Age(post-settlement)_for_L1;linear growth below this
999 #_Growth_Age_for_L2 (999 to use as Linf)
-999 #_exponential decay for growth above maxage (fixed at 0.2 in 3.24; value should approx initial Z; -999 replicates 3.24)
0  #_placeholder for future growth feature
0 #_SD_add_to_LAA (set to 0.1 for SS2 V1.x compatibility)
0 #_CV_Growth_Pattern:  0 CV=f(LAA); 1 CV=F(A); 2 SD=F(LAA); 3 SD=F(A); 4 logSD=F(A)
3 #_maturity_option:  1=length logistic; 2=age logistic; 3=read age-maturity matrix by growth_pattern; 4=read age-fecundity; 5=disabled; 6=read length-maturity
#_Age_Maturity by growth pattern
0 0 0 0 0 0.5 0.95 1 1 1 1 1 1 1 1 1
3 #_First_Mature_Age
1 #_fecundity option:(1)eggs=Wt*(a+b*Wt);(2)eggs=a*L^b;(3)eggs=a*Wt^b; (4)eggs=a+b*L; (5)eggs=a+b*W
0 #_hermaphroditism option:  0=none; 1=female-to-male age-specific fxn; -1=male-to-female age-specific fxn
1 #_parameter_offset_approach (1=none, 2= M, G, CV_G as offset from female-GP1, 3=like SS2 V1.x)
#
#_growth_parms
#_ LO HI INIT PRIOR PR_SD PR_type PHASE env_var&link dev_link dev_minyr dev_maxyr dev_PH Block Block_Fxn
0.3 1 0.37 0.37 99 3 -2 0 0 0 0 0.5 0 0 # NatM_p_1_Fem_GP_1
20 60 47.23 50 99 0 -2 0 0 0 0 0.5 0 0 # L_at_Amin_Fem_GP_1
70 150 122.198 121.9 99 0 -2 0 0 0 0 0.5 0 0 # L_at_Amax_Fem_GP_1
0.01 1 0.209 0.209 99 0 -3 0 0 0 0 0.5 0 0 # VonBert_K_Fem_GP_1
0.001 20 0.1 0.1 0.6 0 -6 0 0 0 0 0.5 0 0 # CV_young_Fem_GP_1
1e-06 20 0.1 0.1 0.6 0 -6 0 0 0 0 0.5 0 0 # CV_old_Fem_GP_1
0 1 1.339e-05 2.1527e-05 0.8 0 -2 0 0 0 0 0.5 0 0 # Wtlen_1_Fem_GP_1
0 4 3.107 2.976 0.8 0 -2 0 0 0 0 0.5 0 0 # Wtlen_2_Fem_GP_1
35 119 90 90 0.8 0 -2 0 0 0 0 0.5 0 0 # Mat50%_Fem_GP_1
-10 3 -10 -10 0.8 0 -2 0 0 0 0 0.5 0 0 # Mat_slope_Fem_GP_1
-3 3 1 1 0.8 0 -2 0 0 0 0 0.5 0 0 # Eggs/kg_inter_Fem_GP_1
-3 3 0 0 0.8 0 -2 0 0 0 0 0.5 0 0 # Eggs/kg_slope_wt_Fem_GP_1
0 2 1 1 99 0 -50 0 0 0 0 0 0 0 # RecrDist_GP_1
0 2 1 1 99 0 -50 0 0 0 0 0 0 0 # RecrDist_Area_1
0 2 1 1 99 0 -50 0 0 0 0 0 0 0 # RecrDist_month_1
1 1 1 1 1 0 -1 0 0 0 0 0 0 0 # CohortGrowDev
1e-06 0.999999 0.5 0.5 0.5 0 -99 0 0 0 0 0 0 0 # FracFemale_GP_1
#_no timevary MG parameters
#
#_seasonal_effects_on_biology_parms
 0 0 0 0 0 0 0 0 0 0 #_femwtlen1,femwtlen2,mat1,mat2,fec1,fec2,Malewtlen1,malewtlen2,L1,K
#_ LO HI INIT PRIOR PR_SD PR_type PHASE
#_Cond -2 2 0 0 -1 99 -2 #_placeholder when no seasonal MG parameters
#
#_Spawner-Recruitment
3 #_SR_function: 2=Ricker; 3=std_B-H; 4=SCAA; 5=Hockey; 6=B-H_flattop; 7=survival_3Parm; 8=Shepard_3Parm
0  # 0/1 to use steepness in initial equ recruitment calculation
0  #  future feature:  0/1 to make realized sigmaR a function of SR curvature
#_          LO            HI          INIT         PRIOR         PR_SD       PR_type      PHASE    env-var    use_dev   dev_mnyr   dev_mxyr     dev_PH      Block    Blk_Fxn #  parm_name
8 16 10.1 10.1 99 0 1 0 0 0 0 0 0 0 # SR_LN_R0
0.2 1 0.9 0.9 0.15 2 -2 0 0 0 0 0 0 0 # SR_steep
0             1           0.4           0.4            99             6         -4          0          0          0          0          0          0          0 # SR_sigmaR
-5             5             0             0            99             6         -6          0          0          0          0          0          0          0 # SR_regime
0           0.5             0            -1             1             6         -3          0          0          0          0          0          0          0 # SR_autocorr
2 #do_recdev:  0=none; 1=devvector; 2=simple deviations
1930 # first year of main recr_devs; early devs can preceed this era
2010 # last year of main recr_devs; forecast devs start in following year
-2 #_recdev phase 
1 # (0/1) to read 13 advanced options
0 #_recdev_early_start (0=none; neg value makes relative to recdev_start)
0 #_recdev_early_phase
0 #_forecast_recruitment phase (incl. late recr) (0 value resets to maxphase+1)
1 #_lambda for Fcast_recr_like occurring before endyr+1
1930 #_last_early_yr_nobias_adj_in_MPD
1930 #_first_yr_fullbias_adj_in_MPD
2011 #_last_yr_fullbias_adj_in_MPD
2011 #_first_recent_yr_nobias_adj_in_MPD
1 #_max_bias_adj_in_MPD (-1 to override ramp and set biasadj=1.0 for all estimated recdevs)
0 #_period of cycles in recruitment (N parms read below)
-5 #min rec_dev
5 #max rec_dev
82 #_read_recdevs
#_end of advanced SR options
#
# read specified recr devs
#_Yr Input_value
1930  0.0167451117754618 #_stochastic_recdev_with_sigmaR=0.4
1931  0.62751486891225 #_stochastic_recdev_with_sigmaR=0.4
1932 -0.196103974693932 #_stochastic_recdev_with_sigmaR=0.4
1933  0.368818699417151 #_stochastic_recdev_with_sigmaR=0.4
1934  0.10914486869103 #_stochastic_recdev_with_sigmaR=0.4
1935 -0.245378215343597 #_stochastic_recdev_with_sigmaR=0.4
1936  0.101245444374113 #_stochastic_recdev_with_sigmaR=0.4
1937 -0.435098479595851 #_stochastic_recdev_with_sigmaR=0.4
1938 -0.135580156417551 #_stochastic_recdev_with_sigmaR=0.4
1939  0.339667359159054 #_stochastic_recdev_with_sigmaR=0.4
1940  0.450767315824745 #_stochastic_recdev_with_sigmaR=0.4
1941 -1.13734583140201 #_stochastic_recdev_with_sigmaR=0.4
1942  0.250513008374853 #_stochastic_recdev_with_sigmaR=0.4
1943 -0.302713620485433 #_stochastic_recdev_with_sigmaR=0.4
1944 -0.258636658809756 #_stochastic_recdev_with_sigmaR=0.4
1945 -0.039687993856598 #_stochastic_recdev_with_sigmaR=0.4
1946  0.0164518777051997 #_stochastic_recdev_with_sigmaR=0.4
1947  0.554423656317462 #_stochastic_recdev_with_sigmaR=0.4
1948 -0.472761606167411 #_stochastic_recdev_with_sigmaR=0.4
1949 -0.657093111415423 #_stochastic_recdev_with_sigmaR=0.4
1950 -0.561949171330211 #_stochastic_recdev_with_sigmaR=0.4
1951 -0.161760078359129 #_stochastic_recdev_with_sigmaR=0.4
1952 -0.499093658288165 #_stochastic_recdev_with_sigmaR=0.4
1953  0.489641005964709 #_stochastic_recdev_with_sigmaR=0.4
1954  0.719070274416819 #_stochastic_recdev_with_sigmaR=0.4
1955  0.524355833537411 #_stochastic_recdev_with_sigmaR=0.4
1956  0.479214510924668 #_stochastic_recdev_with_sigmaR=0.4
1957  0.482722520594764 #_stochastic_recdev_with_sigmaR=0.4
1958  0.110669315677041 #_stochastic_recdev_with_sigmaR=0.4
1959 -0.0184136979801844 #_stochastic_recdev_with_sigmaR=0.4
1960 -0.275544036401879 #_stochastic_recdev_with_sigmaR=0.4
1961  0.490213915166796 #_stochastic_recdev_with_sigmaR=0.4
1962  0.219912353320095 #_stochastic_recdev_with_sigmaR=0.4
1963  0.122387533298516 #_stochastic_recdev_with_sigmaR=0.4
1964  0.64005980664094 #_stochastic_recdev_with_sigmaR=0.4
1965  0.508737764617562 #_stochastic_recdev_with_sigmaR=0.4
1966 -0.422920042608245 #_stochastic_recdev_with_sigmaR=0.4
1967  0.415639659680332 #_stochastic_recdev_with_sigmaR=0.4
1968 -0.173454712450828 #_stochastic_recdev_with_sigmaR=0.4
1969 -0.0563979858350285 #_stochastic_recdev_with_sigmaR=0.4
1970 -0.034808189487014 #_stochastic_recdev_with_sigmaR=0.4
1971 -0.128130925692451 #_stochastic_recdev_with_sigmaR=0.4
1972  0.380241680151119 #_stochastic_recdev_with_sigmaR=0.4
1973 -0.579186051866846 #_stochastic_recdev_with_sigmaR=0.4
1974 -0.191535170691418 #_stochastic_recdev_with_sigmaR=0.4
1975 -0.291427063759153 #_stochastic_recdev_with_sigmaR=0.4
1976 -0.896963646320747 #_stochastic_recdev_with_sigmaR=0.4
1977 -0.259385670977865 #_stochastic_recdev_with_sigmaR=0.4
1978 -0.161988672152962 #_stochastic_recdev_with_sigmaR=0.4
1979 -0.704887338508712 #_stochastic_recdev_with_sigmaR=0.4
1980 -0.19372078529733 #_stochastic_recdev_with_sigmaR=0.4
1981  0.0168024046561596 #_stochastic_recdev_with_sigmaR=0.4
1982  0.393775016267698 #_stochastic_recdev_with_sigmaR=0.4
1983 -0.84085908327434 #_stochastic_recdev_with_sigmaR=0.4
1984  0.210481497769884 #_stochastic_recdev_with_sigmaR=0.4
1985 -0.425919726538668 #_stochastic_recdev_with_sigmaR=0.4
1986  0.215316228870959 #_stochastic_recdev_with_sigmaR=0.4
1987  0.247870625998366 #_stochastic_recdev_with_sigmaR=0.4
1988 -0.356283622149752 #_stochastic_recdev_with_sigmaR=0.4
1989  0.124196651536036 #_stochastic_recdev_with_sigmaR=0.4
1990  0.236683047218477 #_stochastic_recdev_with_sigmaR=0.4
1991  0.061877668162708 #_stochastic_recdev_with_sigmaR=0.4
1992  0.283728587453035 #_stochastic_recdev_with_sigmaR=0.4
1993 -0.635987433672586 #_stochastic_recdev_with_sigmaR=0.4
1994  0.352933364998584 #_stochastic_recdev_with_sigmaR=0.4
1995  0.00790930541284859 #_stochastic_recdev_with_sigmaR=0.4
1996 -0.388695842028803 #_stochastic_recdev_with_sigmaR=0.4
1997  0.2911540044745 #_stochastic_recdev_with_sigmaR=0.4
1998  0.264642866319175 #_stochastic_recdev_with_sigmaR=0.4
1999 -0.0359407738613969 #_stochastic_recdev_with_sigmaR=0.4
2000  0.145559061099017 #_stochastic_recdev_with_sigmaR=0.4
2001 -0.479795923363793 #_stochastic_recdev_with_sigmaR=0.4
2002  0.165433179050094 #_stochastic_recdev_with_sigmaR=0.4
2003  0.289535957527847 #_stochastic_recdev_with_sigmaR=0.4
2004  0.131049377230947 #_stochastic_recdev_with_sigmaR=0.4
2005  0.0643804268675908 #_stochastic_recdev_with_sigmaR=0.4
2006  0.152822858341694 #_stochastic_recdev_with_sigmaR=0.4
2007  0.0638567695678233 #_stochastic_recdev_with_sigmaR=0.4
2008  0.704475286188327 #_stochastic_recdev_with_sigmaR=0.4
2009 -0.321569076527001 #_stochastic_recdev_with_sigmaR=0.4
2010 -0.371998276703775 #_stochastic_recdev_with_sigmaR=0.4
2011  0.506373734761988 #_stochastic_recdev_with_sigmaR=0.4
#Fishing Mortality info 
0.1 # F ballpark
-2000 # F ballpark year (neg value to disable)
3 # F_Method:  1=Pope; 2=instan. F; 3=hybrid (hybrid is recommended)
4 # max F or harvest rate, depends on F_Method
# no additional F input needed for Fmethod 1
# if Fmethod=2; read overall start F value; overall phase; N detailed inputs to read
# if Fmethod=3; read N iterations for tuning for Fmethod 3
6  # N iterations for tuning F in hybrid method (recommend 3 to 7)
#
#_initial_F_parms; count = 0
#_ LO HI INIT PRIOR PR_SD  PR_type  PHASE
#2012 2032
# F rates by fleet
# Yr:  1930 1931 1932 1933 1934 1935 1936 1937 1938 1939 1940 1941 1942 1943 1944 1945 1946 1947 1948 1949 1950 1951 1952 1953 1954 1955 1956 1957 1958 1959 1960 1961 1962 1963 1964 1965 1966 1967 1968 1969 1970 1971 1972 1973 1974 1975 1976 1977 1978 1979 1980 1981 1982 1983 1984 1985 1986 1987 1988 1989 1990 1991 1992 1993 1994 1995 1996 1997 1998 1999 2000 2001 2002 2003 2004 2005 2006 2007 2008 2009 2010 2011 2012
# seas:  1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1
# ALB_fleet 0.0389506 0.055779 0.0533582 0.0501233 0.0751562 0.0833335 0.0709073 0.0593866 0.0674019 0.0859091 0.0596526 0.0616867 0.0844537 0.0958079 0.0942822 0.152112 0.142566 0.11951 0.131678 0.174511 0.227277 0.218846 0.250429 0.207782 0.172382 0.157122 0.201314 0.173365 0.241623 0.240358 0.277883 0.259151 0.4094 0.541443 0.716658 0.763131 0.627715 0.757548 0.66442 0.648682 0.649979 0.876301 0.779549 0.71506 0.815779 0.607939 0.76922 0.829325 0.922766 0.839101 0.568776 0.49644 0.571392 0.845017 0.890122 1.15647 1.18543 0.725115 0.587438 0.420076 0.441504 0.316634 0.31789 0.338881 0.336355 0.404492 0.305068 0.270228 0.300337 0.298773 0.254014 0.194329 0.16603 0.209054 0.186545 0.20728 0.27696 0.150817 0.14654 0.0832716 0.114286 0.119476 0.119476
#
#_Q_setup for fleets with cpue or survey data
#_1:  link type: (1=simple q, 1 parm; 2=mirror simple q, 1 mirrored parm; 3=q and power, 2 parm)
#_2:  extra input for link, i.e. mirror fleet
#_3:  0/1 to select extra sd parameter
#_4:  0/1 for biasadj or not
#_5:  0/1 to float
#_survey: 2 Depletion_survey is a depletion fleet
#_Q_setup(f,2)=0; add 1 to phases of all parms;
#_   fleet      link link_info  extra_se   biasadj     float  #  fleetname
2         1         0         0         0         1  #  Depletion_survey
-9999 0 0 0 0 0
#
#_Q_parms(if_any);Qunits_are_ln(q)
#_          LO            HI          INIT         PRIOR         PR_SD       PR_type      PHASE    env-var    use_dev   dev_mnyr   dev_mxyr     dev_PH      Block    Blk_Fxn  #  parm_name
-25            25  -1.82179e-06             1             1             0         -1          0          0          0          0          0          0          0  #  LnQ_base_Depletion_survey(2)
#_no timevary Q parameters
#
#_size_selex_patterns
#Pattern:_0; parm=0; selex=1.0 for all sizes
#Pattern:_1; parm=2; logistic; with 95% width specification
#Pattern:_5; parm=2; mirror another size selex; PARMS pick the min-max bin to mirror
#Pattern:_15; parm=0; mirror another age or length selex
#Pattern:_6; parm=2+special; non-parm len selex
#Pattern:_43; parm=2+special+2;  like 6, with 2 additional param for scaling (average over bin range)
#Pattern:_8; parm=8; New doublelogistic with smooth transitions and constant above Linf option
#Pattern:_9; parm=6; simple 4-parm double logistic with starting length; parm 5 is first length; parm 6=1 does desc as offset
#Pattern:_21; parm=2+special; non-parm len selex, read as pairs of size, then selex
#Pattern:_22; parm=4; double_normal as in CASAL
#Pattern:_23; parm=6; double_normal where final value is directly equal to sp(6) so can be >1.0
#Pattern:_24; parm=6; double_normal with sel(minL) and sel(maxL), using joiners
#Pattern:_25; parm=3; exponential-logistic in size
#Pattern:_27; parm=3+special; cubic spline 
#Pattern:_42; parm=2+special+3; // like 27, with 2 additional param for scaling (average over bin range)
#_discard_options:_0=none;_1=define_retention;_2=retention&mortality;_3=all_discarded_dead;_4=define_dome-shaped_retention
#_Pattern Discard Male Special
0 0 0 0 # 1 ALB_fleet
0 0 0 0 # 2 Depletion_survey
#
#_age_selex_types
#Pattern:_0; parm=0; selex=1.0 for ages 0 to maxage
#Pattern:_10; parm=0; selex=1.0 for ages 1 to maxage
#Pattern:_11; parm=2; selex=1.0  for specified min-max age
#Pattern:_12; parm=2; age logistic
#Pattern:_13; parm=8; age double logistic
#Pattern:_14; parm=nages+1; age empirical
#Pattern:_15; parm=0; mirror another age or length selex
#Pattern:_16; parm=2; Coleraine - Gaussian
#Pattern:_17; parm=nages+1; empirical as random walk  N parameters to read can be overridden by setting special to non-zero
#Pattern:_41; parm=2+nages+1; // like 17, with 2 additional param for scaling (average over bin range)
#Pattern:_18; parm=8; double logistic - smooth transition
#Pattern:_19; parm=6; simple 4-parm double logistic with starting age
#Pattern:_20; parm=6; double_normal,using joiners
#Pattern:_26; parm=3; exponential-logistic in age
#Pattern:_27; parm=3+special; cubic spline in age
#Pattern:_42; parm=2+nages+1; // cubic spline; with 2 additional param for scaling (average over bin range)
#_Pattern Discard Male Special
12 0 0 0 # 1 ALB_fleet
10 0 0 0 # 2 Depletion_survey
#
#_          LO            HI          INIT         PRIOR         PR_SD       PR_type      PHASE    env-var    use_dev   dev_mnyr   dev_mxyr     dev_PH      Block    Blk_Fxn  #  parm_name
1            15           3.5           3.5             1          0.01         -2          0          0          0          0          0          0          0  #  AgeSel_P1_ALB_fleet(1)
0.01             3           1             1             1          0.01         -3          0          0          0          0          0          0          0  #  AgeSel_P2_ALB_fleet(1)
#_no timevary selex parameters
#
0   #  use 2D_AR1 selectivity(0/1):  experimental feature
#_no 2D_AR1 selex offset used
#
# Tag loss and Tag reporting parameters go next
0  # TG_custom:  0=no read; 1=read if tags exist
#_Cond -6 6 1 1 2 0.01 -4 0 0 0 0 0 0 0  #_placeholder if no parameters
#
# no timevary parameters
#
#
# Input variance adjustments factors: 
 #_1=add_to_survey_CV
 #_2=add_to_discard_stddev
 #_3=add_to_bodywt_CV
 #_4=mult_by_lencomp_N
 #_5=mult_by_agecomp_N
 #_6=mult_by_size-at-age_N
 #_7=mult_by_generalized_sizecomp
#_Factor  Fleet  Value
-9999   1    0  # terminator
#
300 #_maxlambdaphase
1 #_sd_offset; must be 1 if any growthCV, sigmaR, or survey extraSD is an estimated parameter
# read 0 changes to default Lambdas (default value is 1.0)
# Like_comp codes:  1=surv; 2=disc; 3=mnwt; 4=length; 5=age; 6=SizeFreq; 7=sizeage; 8=catch; 9=init_equ_catch; 
# 10=recrdev; 11=parm_prior; 12=parm_dev; 13=CrashPen; 14=Morphcomp; 15=Tag-comp; 16=Tag-negbin; 17=F_ballpark
#like_comp fleet  phase  value  sizefreq_method
-9999  1  1  1  1  #  terminator
#
# lambdas (for info only; columns are phases)
#  0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 #_CPUE/survey:_1
#  1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 #_CPUE/survey:_2
#  0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 #_init_equ_catch
#  0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 #_recruitments
#  1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 #_parameter-priors
#  1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 #_parameter-dev-vectors
#  1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 #_crashPenLambda
#  0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 # F_ballpark_lambda
0 # (0/1) read specs for more stddev reporting 
 # 0 1 -1 5 1 5 1 -1 5 # placeholder for selex type, len/age, year, N selex bins, Growth pattern, N growth ages, NatAge_area(-1 for all), NatAge_yr, N Natages
 # placeholder for vector of selex bins to be reported
 # placeholder for vector of growth ages to be reported
 # placeholder for vector of NatAges ages to be reported
999

