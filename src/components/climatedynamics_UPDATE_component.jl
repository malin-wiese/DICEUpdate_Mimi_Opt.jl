@defcomp climatedynamics begin
    TATM         = Variable(index=[time])  #Increase in temperature of atmosphere (degrees C from 1850-1900) (=TAT_IPCC)
    TATM_1750    = Variable(index=[time])  #Increase in temperature of atmosphere (degrees C from 1750)  (=TAT)
    TOCEAN       = Variable(index=[time])  #Increase in temperature of lower oceans (°C from 1750)
    TATM_short   = Variable(index=[time,5])  #Atmospheric temperature change short (°C from 1750)

    FORC    = Parameter(index=[time])   #Increase in radiative forcing (watts per m2 from 1900)
    fco22x  = Parameter()               #Forcings of equilibrium CO2 doubling (Wm-2)
    t2xco2  = Parameter()               #Equilibrium temp impact (oC per doubling CO2)
    tatm0   = Parameter()               #Initial atmospheric temp change (C from 1750)
    tocean0 = Parameter()               #Initial lower stratum temp change (C from 1900)
    deltaT  = Parameter()               #Adjustment parameter to compare to 1850-1900 temperature levels
    
    # Transient TSC Correction ("Speed of Adjustment Parameter")
    xi1 = Parameter()                    #Speed of adjustment parameter for atmospheric temperature
    xi3 = Parameter()                    #Coefficient of heat loss from atmosphere to oceans
    xi4 = Parameter()                    #Coefficient of heat gain by deep oceans
    
    function run_timestep(p, v, d, t)
        
        #Define the short term Energy balance model (temperature increase from 1750) for the 5 timestep
        if is_first(t)  
            v.TATM_1750[t] = p.tatm0
        else
            v.TATM_short[t-1,1] = v.TATM_1750[t-1]
            for ts=1:4
                v.TATM_short[t-1,ts+1] = v.TATM_short[t-1,ts] + 1/p.xi1 * ((p.FORC[t] - (p.fco22x/p.t2xco2) * v.TATM_short[t-1,ts]) - (p.xi3 * (v.TATM_short[t-1,ts] - v.TOCEAN[t-1])))
            end
            v.TATM_1750[t] = v.TATM_short[t-1,5]      
        end
        
        #Define function for TATM (temperature increase from period 1850-1900) which is also used in the damage function
        v.TATM[t] = v.TATM_1750[t] - p.deltaT
        
        #Define function for TOCEAN
        if is_first(t)
            v.TOCEAN[t] = p.tocean0        
        else
            v.TOCEAN[t] = v.TOCEAN[t-1] + 5 * p.xi3/p.xi4 * (v.TATM_1750[t-1] - v.TOCEAN[t-1])
        end
        
    end
end