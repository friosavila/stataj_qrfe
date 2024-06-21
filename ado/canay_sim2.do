capture program drop canay_sim
program define canay_sim, eclass
	syntax, [n(int 50) t(int 5)]
	clear
	set obs `n'
	gen n_i = rnormal()
	gen id = _n
	
	expand `t'
	gen x_it = rgamma(1,1)
	bysort id:egen a_i=sum(x_it/sqrt(`t'))
	replace a_i = a_i + n_i - sqrt(`t')
	gen y_it = (2+x_it)*sqrt(runiform())+a_i
	qregfe y_it x_it, abs(id) canay qmethod(qrprocess) q(.2 .5 .8)
	ereturn display
	matrix b1=e(b)
	qregfe y_it x_it if id<=`n'*.5, abs(id) canay qmethod(qrprocess) q(.2 .5 .8)
	ereturn display
	matrix b2=e(b)
	qregfe y_it x_it if id> `n'*.5, abs(id) canay qmethod(qrprocess) q(.2 .5 .8)
	ereturn display
	matrix b3=e(b)
	*qrprocess y_it x_it a_i, q(.2 .5 .8)
	 
	matrix b=2*b1-0.5*(b2+b3)
	ereturn post b
end	

simulate, reps(250):canay_sim, n(500) t(5)
gen h1= (q1_b_x_it-sqrt(.2))*5
gen h2= (q2_b_x_it-sqrt(.5))*5
gen h3= (q3_b_x_it-sqrt(.8))*5

sum h*