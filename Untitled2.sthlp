{smcl}

{title:{cmd:csdid}: Difference in Difference with Multiple periods estimator}

{marker syntax}{...}
{title:Syntax}

{p 8 17 2}
{cmd:csdid}
{depvar} [{indepvars}]
{ifin} {weight},
[{opt i:var(varname)}]
{opt t:ime(varname)} {opt gvar(varname)}
[{it:options}]

{marker options}{...}
{title:Options}

{synoptset 20 tabbed}{...}

{syntab:Model Specification}
{synopt:{opt depvar}}Declares the dependent variable or outcome of interest{p_end}
{synopt:{opt indepvar}}Declares the independent variable or controls{p_end}
{synopt:{opt i:var(varname)}}Variable used as panel identifier{p_end}
{synopt:{opt t:ime(varname)}}Variable to identify time{p_end}
{synopt:{opt gvar(varname)}}Variable identifying treatment groups or cohorts{p_end}
{synopt:{opt notyet}}Request using observations never treated and those not yet treated as control group{p_end}
{synopt:{opt long}}Request estimation of long gaps for periods before treatment{p_end}
{synopt:{opt long2}}Request estimation of long gaps for periods before treatment (similar to base universal){p_end}
{synopt:{opt asinr}}Request estimation of pre-treatment ATTGT's as in R's version (DID){p_end}

{syntab:Estimation Method}
{synopt:{opt method(method)}}Specifies the estimation method{p_end}

{syntab:Standard Error Options}
{synopt:{opt wboot}}Request estimation of standard errors using multiplicative WildBootstrap procedure{p_end}
{synopt:{opt wboot(Options)}}Specify options for WildBootstrap procedure{p_end}
{synopt:{opt cluster(clust var)}}Request estimation of clustered standard errors{p_end}
{synopt:{opt level(#)}}Request changing the confidence level for estimation of confidence intervals{p_end}
{synopt:{opt pointwise}}Request producing pointwise CI when requesting Wildbootstrap SE{p_end}

{syntab:Other Options}
{synopt:{opt saverif(filename)}}Request the command to save the RIFs for all the DID ATT into a dataset{p_end}
{synopt:{opt replace}}Request replacing the file if it already exists{p_end}
{synopt:{opt agg(aggtype)}}Request different aggregations as the command output{p_end}

{marker description}{...}
{title:Description}

{pstd}{cmd:csdid} implements the DiD with multiple periods estimator proposed by Callaway and Sant'Anna (2021).{p_end}

{pstd}Internally, all 2x2 DiD estimates (ATTGT's) are obtained using -drdid-. Thus {cmd: csdid} works as a wrapper
that determines all relevant designs and aggregates them.{p_end}

{pstd}As in -drdid-, the underlying assumption is that all covariates are time constant. When using panel data, 
even if covariates are time-varying, only the base-period (earlier-period) values are used for the estimation.{p_end}

{pstd}When using crossection data, while all characteristics can be considered time-varying, the underlying assumption is that 
within treated and untreated group, characteristics are stationary (time constant).{p_end}

{pstd}The intuition behind Callaway and Sant'Anna (2021) estimator is that in order to obtain consistent estimators for ATT's
one should only use never-treated or not-yet treated units as controls.{p_end}

{pstd}For the command to work, you need to have at least one period in the data for each group/cohort in gvar. You also require 
at least one pre-treatment period for each cohort/group, in order to estimate the ATT for that group.{p_end}

{marker remarks}{...}
{title:Remarks}

{pstd}When using panel data, the estimator does not require data to be strongly balanced. However, when estimating each ATTGT,
only observations that are balanced within a specific 2x2 designed are used for the estimator.{p_end}

{pstd}This approach is in contrast with the default approach in R's DID. When unbalanced data exists, the default is to 
estimate the model using Repeated Crossection estimators.{p_end}

{pstd}Even if WBootstrap SE are requested, asymptotic SE are stored in e().{p_end}

{pstd}Each succesful iteration is represented by a ".", whereas an "x" indicates for some ATT(G,T), the estimation failed.{p_end}

{marker post_estimation}{...}
{title:Post Estimation}

{pstd}{cmd: csdid} offers three post estimation utilities. See {help csdid_postestimation} for more details.{p_end}

{phang}{cmd: csdid_estat} For the estimation of aggregations and pretreatment tests.{p_end}

{phang}{cmd: csdid_stats} For the estimation of aggregations and pretreatment tests using RIF files.{p_end}

{phang}{cmd: csdid_plot} For creating plots of the results.{p_end}

{phang}{cmd: csdid_rif} This is a multiuse command. It can be used to produce results, including wildbootstrap tables, based on RIFs.{p_end}

{marker examples}{...}
{title:Examples}

{phang}{stata "use https://friosavila.github.io/playingwithstata/drdid/mpdta.dta, clear"}

{pstd}Estimation of all ATTGT's using Doubly Robust IPW (DRIPW) estimation method{p_end}
{phang}{stata csdid  lemp lpop , ivar(countyreal) time(year) gvar(first_treat) method(dripw)}

{pstd}Estimation of all ATTGT's using Doubly Robust IPW (DRIPW) estimation method, with Wildbootstrap SE{p_end}
{phang}{stata csdid  lemp lpop , ivar(countyreal) time(year) gvar(first_treat) method(dripw) wboot rseed(1)}

{pstd}Repeated crosssection estimator with Wildbootstrap SE{p_end}
{phang}{stata csdid  lemp lpop , time(year) gvar(first_treat) method(dripw) wboot rseed(1)}

{pstd}Estimation of all Dynamic effects using Doubly Robust IPW (DRIPW) estimation method, with Wildbootstrap SE{p_end}

{phang}{stata csdid  lemp lpop , ivar(countyreal) time(year) gvar(first_treat) method(dripw) wboot rseed(1) agg(event)}

{pstd}Estimation of all Dynamic effects using Doubly Robust IPW (DRIPW) estimation method, with Wildbootstrap SE, 
and not-yet treated observations as controls{p_end}
{phang}{stata csdid  lemp lpop , ivar(countyreal) time(year) gvar(first_treat) method(dripw) wboot rseed(1) agg(event) notyet}

{pstd}Estimation of ATTGT's assuming unbalance panel data, with panel estimators{p_end}
{phang}{stata set seed 1}

{phang}{stata gen sample = runiform()<.9}

{phang}{stata csdid  lemp lpop  if sample==1, ivar(countyreal) time(year) gvar(first_treat) method(dripw) }

{pstd}Estimation of ATTGT's assuming unbalance panel data, with repeated crosssection estimators, but clustered SE{p_end}
{phang}{stata csdid  lemp lpop  if sample==1, cluster(countyreal) time(year) gvar(first_treat) method(dripw) }

{marker authors}{...}
{title:Authors}

{pstd}Fernando Rios-Avila{break}
Levy Economics Institute of Bard College{break}
Annandale-on-Hudson, NY{break}
friosavi@levy.org

{pstd}Pedro H. C. Sant'Anna{break}
Vanderbilt University

{pstd}Brantly Callaway{break}
University of Georgia

{marker references}{...}
{title:References}

{phang2}Abadie, Alberto. 2005. 
"Semiparametric Difference-in-Differences Estimators." 
{it:The Review of Economic Studies} 72 (1): 1–19.

{phang2}Callaway, Brantly and Sant'Anna, Pedro H. C. 2021. 
"Difference-in-Differences with multiple time periods." , 225(2):200-230.
{it:Journal of Econometrics}.

{phang2}Sant'Anna, Pedro H. C., and Jun Zhao. 2020. 
"Doubly Robust Difference-in-Differences Estimators." 
{it:Journal of Econometrics} 219 (1): 101–22.

{phang2}Rios-Avila, Fernando, 
Pedro H. C. Sant'Anna, 
and Brantly Callaway, 2021.
 "CSDID: Difference-in-Differences with Multiple periods." 

{marker aknowledgement}{...}
{title:Aknowledgement}

{pstd}This command was built using the DID command from R as benchmark, originally written by Pedro Sant'Anna and Brantly Callaway. 
Many thanks to Pedro and Brantly Callaway for helping to understand the inner workings of the estimator.{p_end}

{pstd}Thanks to Enrique, who helped with the display set up{p_end}

{pstd}If you use this package, please cite:{p_end}

{phang2}Callaway, Brantly and Sant'Anna, Pedro H. C. 2021. 
"Difference-in-Differences with multiple time periods.", 
{it:Journal of Econometrics}, 225(2):200-230. 

{phang2}Sant'Anna, Pedro H. C., and Jun Zhao. 2020. 
"Doubly Robust Difference-in-Differences Estimators." 
{it:Journal of Econometrics} 219 (1): 101–22.

{title:Also see}

{p 7 14 2}
Help:  {help drdid}, {help csdid}, {help csdid postestimation}, {help xtdidregress}, {help xthdidregress}

