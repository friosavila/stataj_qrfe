capture program drop canay_sim
program canay_sim, eclass
    syntax, [n(int 50) t(int 5)]
    clear
    set obs `n'
    gen n_i = rnormal()
    gen id = _n
    expand `t'
    gen x_it = rgamma(1,1)
    gen u_it = runiform()

    bysort id:egen a_i=sum(x_it/sqrt(`t')) 
    replace a_i = a_i + n_i -sqrt(`t')
     
    gen y_it = (2+x_it)*sqrt(u_it)+a_i
    qregfe y_it x_it, abs(id) canay q(20)
    matrix b1 = e(b)
    qregfe y_it x_it, abs(id) canay q(50)
    matrix b2 = e(b)
    qregfe y_it x_it, abs(id) canay q(80)
    matrix b3 = e(b)
    
    qregfe y_it x_it, abs(id) cre q(20)
    matrix b4 = e(b)
    qregfe y_it x_it, abs(id) cre q(50)
    matrix b5 = e(b)
    qregfe y_it x_it, abs(id) cre q(80)
    matrix b6 = e(b)
    
    qrprocess y_it x_it a_i, q(.20)
    matrix b7 = e(b)
    qrprocess y_it x_it a_i, q(.50)
    matrix b8 = e(b)
    qrprocess y_it x_it a_i, q(.80)
    matrix b9 = e(b)
    
    matrix coleq b1 = canay20
    matrix coleq b2 = canay50
    matrix coleq b3 = canay80
    
    matrix coleq b4 = cre20
    matrix coleq b5 = cre50
    matrix coleq b6 = cre80
        
    matrix coleq b7 = true20
    matrix coleq b8 = true50
    matrix coleq b9 = true80
    
    matrix b= b1,b2,b3,b4,b5,b6,b7,b8,b9
    ereturn post b
end
