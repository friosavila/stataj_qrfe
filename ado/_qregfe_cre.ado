*! v0.2 CRE Estimator

program _qregfe_cre, eclass		 

syntax varlist(fv ts) [if] [in] [pw], ABSorb(varlist)    /// variables to absorb
		[Quantile(numlist >0 <100) /// quantile to estimate <- Lets use numbers between 0-100
		 qmethod(str asis) ///	<- Default its qreg. may include options
		 BOOT BOOT1(str asis) * CRE CRE1(str asis) ///
		 seed(str asis) parallel parallel_cluster(int 2) ]  


    // Set Sample (touse) and Absorb Variables (absorb)	 
    marksample touse
    markout `touse' `absorb'

    // Getting Quantile: Default is 50. Allowing for multiple Qs depend on Command option
    if "`quantile'"=="" local quantile = 50

    // qmethod, and options
    if "`qmethod'"!="" {
        cmd_parser `qmethod'
        local qmethod   `r(rcmd)'
        local qoptions  `r(ropt)'
    }    

    if      "`qmethod'"==""          local qmethod      qreg            // Default is qreg
    
    // Setup Y and X
	gettoken yvar xvar : varlist
	
    if "`weight'`exp'"!="" local weightexp [`weight'`exp'] 
    qui: cre, abs(`absorb') `cre1' keep : ///
        `qmethod' `yvar' `xvar' `if' `in' `weightexp', `qoptions' `options'  q(`quantile')

	*if "`bs'"=="" display in white "Std Errors are not valid for Inference. Try bscanayreg"
	ereturn local depvar "`yvar'"
    ereturn local quantile `quantile'
    ereturn local absorb "`absorb'"
    ereturn local wcmd "qregfe"
    ereturn local cmdline qregfe `0'
    ereturn local method "CRE"
    display_results, `options'

end

 
program display_parser, rclass
	syntax  ,  [ level(passthru) * ///
									 noci               ///
									 nopvalues          ///
									 noomitted          ///
									 vsquish            ///
									 noemptycells       ///
									 baselevels         ///
									 allbaselevels      ///
									 nofvlabel          ///
									 fvwrap(passthru)   ///
									 fvwrapon(passthru) ///
									 cformat(passthru)  ///
									 pformat(passthru)  ///
									 sformat(passthru)  ///
									 nolstretch ]
	return local display_opt `level' `noci' `nopvalues' `noomitted' `vsquish' `noemptycells' `baselevels' `allbaselevels' `nofvlabel' `fvwrap' `fvwrapon' `cformat' `pformat' `sformat' `nolstretch'
    return local other_opt `options'
end

program display_results
    syntax [anything(everything)], [*]
    display_parser, `options'
    if "`e(wcmd)'"=="qregfe" {
        display "Quantile Regression with Fixed Effects"
        `e(cmd)', `display_opt'
        display "Dependent Variable: `e(depvar)'"
        display "Quantile(s): `e(quantile)'"
        display "Fixed Effects: `e(absorb)'"
    }
    else {
        display in red "last estimates not found"
        error 301
    }
end 

program cmd_parser, rclass
	syntax [anything] [aw fw pw iw ] [if] [in], [* Quantile(passthru) ] 
	if "`anything'"=="" exit
	else {
		qui:capture which `anything'
		if _rc!=0 {
		    display as error "There is no `anything' command" _n "Search if it can be installed from SSC"
			error 111
		}
	}
	if  !missing("`quantile'") {
	    display as error "You cannot Specify 'quantile' as part of qmethod"
		error 112
	}
	local wgt=subinstr("`exp'","=","",1)
	return local  rcmd  `anything'
	return local  ropt  `options' 
	return local  rwgt  `wgt'
	return local  rif  `if'
	return local  rin  `in'
	return local  rewgt [`weight'`exp']

end