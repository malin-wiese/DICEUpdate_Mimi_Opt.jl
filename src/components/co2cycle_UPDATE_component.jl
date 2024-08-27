@defcomp co2cycle begin
    CCYCLE     = Variable(index=[time,4])  #Four Carbon cycle boxes
    MAT        = Variable(index=[time])    #Carbon concentration increase in atmosphere (GtC from 1750)
    alpha      = Variable(index=[time])    #Alpha variable for calibration
    
    E          = Parameter(index=[time])   #Total CO2 emissions (GtCO2 per year)
    TATM_1750  = Parameter(index=[time])   #Increase in temperature of atmosphere (degrees C from 1750)  (=TAT)
    CCA        = Parameter(index=[time])   #Cumulative industrial emissions
    CUMETREE   = Parameter(index=[time])   #Cumulative emissions from land
    
    ccycle0    = Parameter(index=[4])      #Initial value carbon cycle boxes
    mat0       = Parameter()               #Initial Concentration in atmosphere 2010 (GtC)
    fraction   = Parameter(index=[4])
    tscale     = Parameter(index=[4])

    
    function run_timestep(p, v, d, t)

        if is_first(t)
            v.alpha[t]=0.01  # lower bound of alpha
        else

            # Create function to pass to nlsolve to find alpha:
            # nlsolve is for non-linear systems of equations with are indexed with [1], [2], etc.
            # as this is only one equation, it still has to be indexed with [1] and the variable for which it should be solved (x) too, so x[1]
            # the function of Hänsel et al. is changed, so that it equals 0
            function f!(fvec, x)
                fvec[1]= x[1]*p.fraction[1]*p.tscale[1]*(1-2.718^(-100/(x[1] * p.tscale[1])))+
                     x[1]*p.fraction[2]*p.tscale[2]*(1-2.718^(-100/(x[1] * p.tscale[2])))+
                     x[1]*p.fraction[3]*p.tscale[3]*(1-2.718^(-100/(x[1] * p.tscale[3])))+
                     x[1]*p.fraction[4]*p.tscale[4]*(1-2.718^(-100/(x[1] * p.tscale[4])))-
                     (35+0.019*((p.CCA[t-1]+p.CUMETREE[t-1])-(v.MAT[t-1]-588)) + 4.165*(p.TATM_1750[t-1]))
            
            end

            # Solve for alpha:
            res = nlsolve(f!, [v.alpha[t-1]], autodiff=:forward)  #starting point is set to v.alpha[t-1] (alpha[1] is lower bound) to make calculation faster, sensitivity check: set to 0.01
            
            if converged(res) && (res.zero[1] <=100)  # if solution found (residuals converged) and it is lower than upper bound (line 136)
                v.alpha[t] = res.zero[1]  # numerical solution to x if above equation is set to zero
            else
                v.alpha[t] = 100 # upper bound (line 136)
            end
     
        end
        
        #define functions for carbon cycle with 4 boxes
        if is_first(t)
            for box=1:4
                v.CCYCLE[t,box] = p.ccycle0[box]
            end
        else
            
            for box=1:4
                # here alpha[t] and not alpha[t-1] (as in Hänsel et al.) is used as above in the alpha calculation the values for [t-1] and not [t] are used 
                v.CCYCLE[t,box] = v.CCYCLE[t-1,box]*2.718^(-5/(v.alpha[t]*p.tscale[box])) 
                                + p.fraction[box] * (p.E[t-1]*2.781^(-5    /(v.alpha[t]*p.tscale[box]))*(1/3.666)) 
                                + p.fraction[box] * (p.E[t-1]*2.781^(-(5-1)/(v.alpha[t]*p.tscale[box]))*(1/3.666))
                                + p.fraction[box] * (p.E[t-1]*2.781^(-(5-2)/(v.alpha[t]*p.tscale[box]))*(1/3.666))  
                                + p.fraction[box] * (p.E[t-1]*2.781^(-(5-3)/(v.alpha[t]*p.tscale[box]))*(1/3.666)) 
                                + p.fraction[box] * (p.E[t-1]*2.781^(-(5-4)/(v.alpha[t]*p.tscale[box]))*(1/3.666)) 
            end
        end
        
        #Define function for MAT
        if is_first(t)
            v.MAT[t] = p.mat0
        else
            v.MAT[t] = v.CCYCLE[t,1] + v.CCYCLE[t,2] + v.CCYCLE[t,3] + v.CCYCLE[t,4] + 588
        end

    end
end