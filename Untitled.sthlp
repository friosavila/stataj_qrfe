{smcl}
{* *! version 1.0.0  30aug2024}{...}
{hline}
help for {cmd:qregplot}{right:Fernando Rios Avila}
{hline}

{title:Module for plotting coefficients of Quantile Regressions}

{p 8 21 2}
{cmdab:qregplot}
[{it:varlist}]
[{cmd:,}
{cmdab:q:uantiles}{cmd:(}{it:numlist}{cmd:)}
{cmd:cons}
{cmd:ols}
{cmd:olsopt(}{it:regress_options}{cmd:)}
{cmdab:seed}{cmd:(}{it:seed_number}{cmd:)}
{cmdab:raopt}{cmd:(}{it:rarea_options}{cmd:)}
{cmdab:lnopt}{cmd:(}{it:line_options}{cmd:)}
{cmdab:twopt}{cmd:(}{it:twoway_options}{cmd:)}
{cmdab:estore}{cmd:(}{it:name}{cmd:)}
{cmdab:from}{cmd:(}{it:name}{cmd:)}
{cmdab:label}
{cmdab:labelopt}{cmd:(}{it:label_options}{cmd:)}
{cmdab:mtitles(}{it:titles}{cmd:)}
{cmdab:grcopt}{cmd:(}{it:graph_combine_options}{cmd:)}
{it:graph_combine_options}
]

{title:Description}

{pstd}
{cmd:qregplot} graphs the coefficients of quantile regressions produced by various 
programs, including {cmd:qreg}, {cmd:bsqreg}, {cmd:sqreg}, {cmd:mmqreg}, {cmd:smqreg}, 
{cmd:sivqr}, and {cmd:rifhdreg} (for unconditional quantiles).

{pstd}
{cmd:qregplot} works similarly to {help grqreg}, but provides additional options
for greater control over figure creation and allows for the use of factor notation.

{pstd}
The command operates as follows:

{phang2}1. Gathers information from a previously estimated model (e.g., via {help qreg}).{p_end}
{phang2}2. Estimates {it:N} quantile regressions using the original model's specification.{p_end}
{phang2}3. Plots coefficients using {cmd:twoway rarea} for CI and {cmd:twoway line} for point estimates.{p_end}
{phang2}4. Optionally adds OLS coefficients and CI to each figure.{p_end}
{phang2}5. Combines plots using {cmd:graph combine} if multiple variables are requested.{p_end}

{pstd}
The only exception to this process is {help sqreg}. When used after this command, 
coefficients are collected from {cmd:sqreg} output rather than reestimated.

{pstd}
Standard errors are estimated based on the original command specifications. For example, 
if {cmd:qreg} was first estimated using {cmd:vce(robust)}, {cmd:qregplot} will use 
the same type of standard errors for plotting.

{pstd}
In all cases, CI are plotted automatically using the same level of confidence as 
the original estimation specification (typically 95%).

{marker options}{...}
{title:Options}

{dlgtab:Main}

{phang}
{opt varlist} specifies variables to be plotted. If omitted, all coefficients except 
the intercept will be plotted. Factor notation is accepted.

{phang}
{cmdab:q:uantiles(numlist)} indicates which quantiles to use for plotting. 
The default is {cmd:quantile(10(5)90)}. This option is ignored after {cmd:sqreg}.

{phang}
{opt cons} requests that the intercept be plotted.

{phang}
{opt ols} includes coefficients and CI for the standard OLS model (via {help regress}).

{phang}
{opt olsopt(regress_options)} provides additional options for the OLS estimation. 
For example, {cmd:olsopt(robust)} requests robust standard errors.

{dlgtab:Graph Options}

{phang}
{opt raopt(rarea_options)} provides options for the {cmd:twoway rarea} part of the graph, 
controlling the appearance of Confidence Intervals. 
Default: {cmd:pstyle(p1) fintensity(30) lwidth(none)}.

{phang}
{opt lnopt(line_options)} provides options for the {cmd:twoway line} part of the graph, 
controlling the appearance of point estimates. 
Default: {cmd:pstyle(p1) lwidth(0.3)}.

{phang}
{opt twopt(twoway_options)} provides options for the overall {cmd:twoway} graph. 
Default: sets graph and plot region margins to {cmd:vsmall}.

{phang}
{opt grcopt(graph_combine_options)} provides options for {cmd:graph combine}. 
Controls aspects of the combined graph of all coefficients.

{phang}
{it:graph_combine_options} can be specified directly in the command line. 
For single coefficient plots, these affect {help twoway_options}.

{dlgtab:Advanced Options}

{phang}
{opt seed(#)} sets the seed for random number generation when using {help bsqreg}.

{phang}
{opt estore(name)} saves all estimated coefficients and CI in e() under {it:name}. 
This can be used later for plotting without re-estimating quantile regressions.

{phang}
{opt from(name)} plots quantile coefficients using previously stored information in e().

{phang}
{opt label} uses variable (or value) labels as titles for individual quantile plots. 
The default is to use variable names.

{phang}
{opt labelopt(label_options)} provides additional options for handling long variable labels:

{phang2}- {cmd:lines(#L)} breaks a label into {it:#L} lines.{p_end}
{phang2}- {cmd:maxlength(#k)} breaks a label into lines of maximum length {it:#k}.{p_end}

{phang}
{opt mtitles(titles)} provides custom titles for each sub-graph. Titles should be in double quotes.

{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse womenwk}{p_end}

{pstd}Simple Conditional quantile regression{p_end}
{phang2}{cmd:. qreg wage age education i.married children i.county}{p_end}

{pstd}Plot coefficients for quantiles 5 to 95 in 2.5 increments{p_end}
{phang2}{cmd:. qregplot age education i.married children, q(5(2.5)95) estore(qp)}{p_end}

{pstd}Add OLS coefficients and CI{p_end}
{phang2}{cmd:. qregplot age education i.married children, q(5(2.5)95) ols}{p_end}

{pstd}Change CI appearance{p_end}
{phang2}{cmd:. qregplot age education i.married children, q(5(2.5)95) ols raopt(color(black%5))}{p_end}

{pstd}Plot in single column{p_end}
{phang2}{cmd:. qregplot age education i.married children, q(5(2.5)95) ols raopt(color(black%5)) col(1)}{p_end}

{pstd}Use stored results{p_end}
{phang2}{cmd:. qregplot age education children, from(qp)}{p_end}

{pstd}Use variable labels as titles{p_end}
{phang2}{cmd:. qregplot age education children, from(qp) label}{p_end}

{marker acknowledgements}{...}
{title:Acknowledgements}

{pstd}
This program was created as a companion for {help rifhdreg}, to facilitate plotting 
coefficients across different quantiles. It also addresses the common question of 
plotting dummies when using factor notation with {help grqreg}.

{pstd}
This program requires {cmd:ftools} for expanding varlists with factor notation.

{marker author}{...}
{title:Author}

{pstd}Fernando Rios-Avila{p_end}
{pstd}Levy Economics Institute of Bard College{p_end}
{pstd}Blithewood-Bard College{p_end}
{pstd}Annandale-on-Hudson, NY{p_end}
{pstd}friosavi@levy.org{p_end}

{title:Also see}

{pstd}
Help: {help qreg}, {help qreg2}, {help ivqreg2}, {help qrprocess}, {help bsqreg}, 
{help sqreg}, {help rifhdreg}, {help xtqreg}, {help mmqreg}, {help sivqr}
{p_end}