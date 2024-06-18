*! v0.1 Very Basic!
/*******************************************
This Program Implements basic and Modified 
Canay QREG estimator.

Option 1:
1st: Estimate OLS model with FE -> y = xb + fe + e
2nd: Modify Y  and run QREG:  q_t(y-fe|x) =  x b(t) 

Option 2:
2nd: run QREG:  q_t(y|x, fe) =  x b(t) + fe g(t)

*******************************************/

/*
Author:  Fernando Rios-Avila, Leonardo Siles, Gustavo Canavire 
Structure: QREGFE - Main Program
           CMD_PARSER - Parse qreg Command. Useful for passing options
           ESTIMATOR_CANAY - Canay Estimator
           ESTIMATOR_CRE   - Correlated Random Effects Estimator
           DISPLAY_PARSER  - Parse Display
           DISPLAY_RESULTS - Display Results
*/
program define qregfe 
    syntax [anything(everything)], [* BS ///
                                    CANAY CANAY1(str asis) ///
                                    CRE   CRE1(str asis) ]
                                 
	if replay() {
		display_results, `options'
        exit
    }
	else {
        ** Required Program
        qui: which reghdfe
        if _rc!=0 {
            display as error "reghdfe is not installed. Please install it from SSC"
            error 101
        }
        if "`canay'`canay1'"!="" & "`cre'`cre1'"!="" {
            display as error "You cannot Specify both 'canay' and 'cre' as part of qmethod"
            error 110
        }
        if "`canay'`canay1'"!="" {
            _qregfe_canay `0'
            display_results, `options'
        }
        else if "`cre'`cre1'"!="" {
            _qregfe_cre `0'
            display_results, `options'
        }
        else {
            display as error "Need to provide a method. CRE or Canay"
            error 111
        }
    }      
end



program cmd_parser, rclass
	syntax [anything] [aw fw pw iw ] [if] [in], [* Quantile(passthru) ] 
	if "`anything'"=="" exit
	else {
		qui: which `anything'
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

program _estimator_canay, eclass		 

syntax varlist(fv ts) [if] [in] [pw], ABSorb(varlist)    /// variables to absorb
		[Quantile(numlist >0 <100) /// quantile to estimate <- Lets use numbers between 0-100
		 qmethod(str asis) ///	<- Default its qreg. may include options
		 bs * CANAY CANAY1(str asis) ///
		 seed(str asis) ]  


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
	

    // Getting fixed effects
    // Modified "Saves" the absorbed fixed effects.
    // Original use tempvars for  fixed effects
	foreach i of local absorb {
		local j = `j'+1
		if "`canay1'"=="" {
			tempvar f`j'
			local toabs `toabs' `f`j''=`i'
			local vlist `vlist' `f`j''
		}	
		else {
            if "`canay1'"!="modified" {
                display as error "Invalid Option for CANAY"
                error 113
            }
            capture drop __f`j'__
			local toabs `toabs' __f`j'__=`i'
			local vlist `vlist' __f`j'__
		}
	}
	
    /**********************************************************/
    /*  Step 1 : Obtain FEs                                   */   
	capture drop __fe__
	quietly: reghdfe `yvar' `xvar' if `touse', abs(`toabs') keepsingletons
    // This creates the aggregated fixed effect
	qui: gen double __fe__	= 0 if e(sample)
    	
	if "`canay1'" =="" {
		foreach i of local vlist {
			replace __fe__=__fe__+`i'
		}
	}
	
	* Step 2: Estimation of QREG

	if "`canay1'"=="" {
        tempvar yvar_hat			
		qui: gen double `yvar_hat' = `yvar' - __fe__
        label var __fe__ "Aggregated Absorbed Fixed Effects"
		qui:`qmethod' `yvar_hat' `xvar'     if `touse' [`weight'`exp'], q(`quantile')	    `options' `qoptions'
    }
    else {
        display in w "Modified Canay Estimator"
		qui:`qmethod' `yvar' `xvar' `vlist' if `touse' [`weight'`exp'], q(`quantile')  	 	`options'
	}
	
	
	*if "`bs'"=="" display in white "Std Errors are not valid for Inference. Try bscanayreg"
	ereturn local depvar "`yvar'"
    ereturn local quantile `quantile'
    ereturn local absorb "`absorb'"
    ereturn local wcmd "qregfe"
    ereturn local cmdline qregfe `0'


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