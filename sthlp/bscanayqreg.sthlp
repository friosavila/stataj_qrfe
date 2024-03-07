{smcl}
{* *! version 0.0.1  05mar2024}{...}
{findalias asfradohelp}{...}
{title:Canay (2011) estimators of regression quantiles with multiple fixed effects}


{marker syntax}{...}
{title:Syntax}

{phang}
Canay (2011) estimator

{p 8 17 2}
{cmdab:canayqreg}
{varlist}
{ifin}
{weight}
{cmd:,}
	{cmd:absorb(}{it:{varlist}}{cmd:)}
[{it:canayqreg_options}]

{phang}
A wrapper arround {cmd:canayqreg} to easily request bootstrapped s.e.

{p 8 17 2}
{cmdab:bscanayqreg}
anything
[{cmd:,} {it:bscanayqreg_options}]


{synoptset 25 tabbed}{...}
{synopthdr: canayqreg_options}
{synoptline}
{syntab:Main}
{synopt:{opt abs:orb}({it:varlist})}variables to absorb{p_end}
{synopt:{opt q:uantile}({it:#})}quantile to estimate. Default is .5{p_end}
{synopt:{opt mod:ified}}request Modified Canay estimator{p_end}
{synoptline}
{p2colreset}{...}


{synoptset 25 tabbed}{...}
{synopthdr: bscanayqreg_options}
{synoptline}
{syntab:{cmd:bootstrap} options}
{synopt:{opt r:eps}({it:#})}perform {it:#} bootstrap replications; default is {cmd:reps(50)}{p_end}
{synopt:{opt str:ata}({it:varlist})}variables identifying strata{p_end}
{synopt:{opt seed}({it:#})}set random number seed to {it:#}{p_end}
{synopt:{opt bca}}compute acceleration for BCa confidence intervals{p_end}
{synopt:{opt tie:s}}adjust BC/BCa confidence intervals for ties{p_end}
{synopt:{opt cl:uster}({varname})}variables identifying resampling clusters{p_end}
{synopt:{opt idcluster}({it:newvar})}create new cluster ID variable{p_end}
{synopt:{opt nodots}}supress replication dots{p_end}
{synopt:{opt level}({it:#})}set confidence level; default is {cmd:level(95)}{p_end}
{synopt:{opt force}}do not check for {it:weights} or {cmd:svy} commands{p_end}

{syntab: Parallel processing options}
{synopt:{opt parallel}}request parallel computing of bootstrap replications{p_end}
{synopt:{opt parallel_cluster}({it:#})}set the number of child processes for parallel computing. Default is 2{p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}
{cmd:by} is allowed; see {manhelp by D}.{p_end}
{p 4 6 2}
{cmd:iweight}s are allowed; see {help weight}.


{marker description}{...}
{title:Description}

{pstd}
{cmd:canayqreg} computes Canay (2011) estimator for regression quantiles with fixed effects by a two step procedure in which first step estimates of FE are subsequently used to calculate coefficients of explanatory variables that vary across quantiles.

{pstd}
{cmd:bscanayqreg} wraps arround {cmd:canayqreg}, providing a simple command to request bootstrapped standard errors. Note that the bootstrap algorithm is such that the two step procedure is repeated for each bootstrap sample.

{marker options_canayqreg}{...}
{title:Options for canayqreg}

{dlgtab:Main}

{phang}
{opt absorb(varlist)} Indicates which variables to "absorb". Multiple FE are allowed with this option. If requested, Sergio Correira's {cmd:reghdfe} command must be installed.

{phang}
{opt quantile(#)} Sets the quantile for which regression quantiles will be computed. Default is .5 or the median of the distribution.

{phang}
{opt modified} Requests that Modified Canay estimator be computed. Instead of Canay's (2011) approach to subtract the estimated FE from the dependent variable, Modified Canay includes the estimated FE as regressors in the equation and leaves the dependent variable unaltered.
{marker options_bscanayqreg}
{title:Options for bscanayqreg}

{dlgtab:Bootstrap options}

{phang}
Options listed above in the syntax for {cmd:bscanayqreg} are the same as those described in {manlink R Bootstrap}.

{dlgtab:Parallel options}

{phang}
{opt parallel} Requests parallel computing of bootstrap replications. Upon requesting this option, Stata module for parallel computing {cmd:parallel} from Yon Vega and Quistorff is required.

{phang}
{opt parallel_cluster(#)} Sets the number of child processes for parallel computing. Default is 2 parallel processes.

{marker remarks}{...}
{title:Remarks}

{pstd}
Concisely describe the difference between Canay and Modified Canay approach. 
{manlink R Intro}.


{marker examples}{...}
{title:Examples}

{phang}{cmd:. sysuse auto}{p_end}

{phang}{cmd:. bscanayqreg price weight length, abs(rep78) quantile(.25)}{p_end}

{phang}{cmd:. bscanayqreg price weight length, abs(rep78) quantile(.25) modified}{p_end}

{marker references}{...}
{title:References}

{marker C2011}{...}
{phang}
Canay, I. 2011. A simple approach to quantile regression for panel data. {it:The Econometrics Journal} 14, pp.368-386.
{p_end}
