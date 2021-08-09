classdef IVcurve < handle
    %This class takes the current voltage (IV) data from lab experiments 
    %utilizing a Keithley Source Meter and a Verasol 2 Solar Simulator.
    %
    %The data is split into individual IV curves with the recorded
    %temperature, depth, water quality, and irradiance that the IV was
    %performed at. An ID is assigned to the IV curve and the short circuit
    %current (ISC), open circuit voltage (VOC), and maximum power point
    %(MPP), are calculated from the IV data.
    %
    %The experiments were conducted to determine effects of temperature,
    %water quality, depth, and irradiance on IV curve parameters
    %
    %The data outputted from the lab experiments contained the following
    %parameters with respective sizes
    %   Water_Qualities: A 1x10 string where:
    %                       Each array cell defined the water quality 
    %                       (e.g. Array cell 1 corresponds to Type 1
    %                       water quality, Array cell 2 corresponds to 
    %                       Type IA water quality, etc.)
    %
    %   voltage:        A 10x50x10 double where:
    %                       The 10 rows corresponds to the irradiance value
    %                       hitting the cell (e.g. Array cell 1
    %                       corresponding to 50 W/m^2, Array cell 2
    %                       corresponding to 90 W/m^2, etc.)
    %
    %                       The 50 columns correspond to the voltage value
    %                       at each step in the IV sweep (i.e. 50 steps 
    %                       were used in the IV sweep starting at 0 V and 
    %                       ending at 7 V). 
    %                       
    %                       The 10 pages correspond to the 10 water 
    %                       qualities. At each depth and temperature, the 
    %                       IV sweeps were conducted on the 10 different 
    %                       water qualities at 10 different irradiances
    %
    %   current:        A 10x50x10 double where:
    %                       The 10 rows corresponds to the irradiance value
    %                       hitting the cell (e.g. Array cell 1
    %                       corresponding to 50 W/m^2, Array cell 2
    %                       corresponding to 90 W/m^2, etc.)
    %
    %                       The 50 columns correspond to the current value
    %                       at each step in the IV sweep (i.e. 50 steps 
    %                       were used in the IV sweep with a maximum limit
    %                       on the current of 50 mA). 
    %                       
    %                       The 10 pages correspond to the 10 water 
    %                       qualities. At each depth and temperature, the 
    %                       IV sweeps were conducted on the 10 different 
    %                       water qualities at 10 different irradiances
    %
    %   time:           A 10x50x10 double where:
    %                       The 10 rows corresponds to the irradiance value 
    %                       hitting the cell (e.g. Array cell 1
    %                       corresponding to 50 W/m^2, Array cell 2
    %                       corresponding to 90 W/m^2, etc.)
    %
    %                       The 50 columns correspond to the time value
    %                       at each step in the IV sweep (i.e. the time it
    %                       took for each IV sweep was recorded). 
    %                       
    %                       The 10 pages correspond to the 10 water 
    %                       qualities. At each depth and temperature, the 
    %                       IV sweeps were conducted on the 10 different 
    %                       water qualities at 10 different irradiances
    %
    %   irradiances     A 10x1x10 double where:
    %                       The 10 rows correspond to the irradiance that 
    %                       was hitting the cell (recorded from the 
    %                       Verasol)
    %
    %                       The 10 pages correspond to the 10 water 
    %                       qualities. At each depth and temperature, the 
    %                       IV sweeps were conducted on the 10 different 
    %                       water qualities at 10 different irradiances
    %
    %The parameters below under the properties section were parsed out
    %
    %There are 21,141 individual IV curves combined into 1 catagory called
    %IV_Curves.
    %
    % AUTHOR:   Collin Krawczyk
    % DATE:     6/8/21
    
    properties
        I       %The current data of the IV curve (1x50 double in Amps)
        
        V       %The voltage data of the IV curve (1x50 double in Volts)
        
        T       %The ideal temperature that the IV curve was recorded at 
                %   (1x1 in °C)
                
        T_act   %The actual temperature that the IV curve was recorded at
                %(1x1 in °C). This is based upon averages of the IR camera
                %that was recording at each temperature every 30 min.
        
        d       %The depth that the IV curve was simulated at 
                %   (1x1 in meters) (A -1 m depth corresponds to AM 1.5
                %   Spectrum, A -2 m depth corresponds to a completely dark
                %   panel at 0 irradiance)
        
        quality %The water quality that the IV curve was simulated at (1x1)
        
        irr     %The irradiance value that was taken from the Verasol 
                %   (1x1 in W/m^2)

        nom     %The nominal irradiance for the spectrum (1x1 in W/m^2)
        
        ID      %The unique ID number that corresponds to the IV curve.
                %The format of the ID number is ###_###_###_### where:
                %   the first three ### correspond to the temperature (C)
                %   the second set of ### correspond to the depth (m)
                %   the third set of ### correspond to the water quality 
                %       type(e.g. 1 corresponds to Type I, 2 corresponds
                %       to type IA, etc.)
                %   the fourth set of ### correspond to the 
                %       irradiance value (W/m^2)
                
        MPP     %The maximum power point (1x1 in W)
        
        Vmpp    %The voltage at the maximum power point (1x1 in V)
        
        Impp    %The current at the maximum power point (1x1 in A)
        
        ISC     %The short circuit current (1x1 in A)
        
        VOC     %The open circuit voltage (1x1 in V)
    end
    
    methods
        function obj = IVcurve(I,V,T,T_act,d,quality,irr,nom,ID)
            %Load in the respective IV curve data
            
            obj.I = I;                  %Current (A)
            obj.V = V;                  %Voltage (V)    
            obj.T = T;                  %Temperature (°C)
            obj.T_act = T_act;          %Temperature (°C)
            obj.d = d;                  %Depth (m)
            obj.quality = quality;      %Water quality
            obj.irr = irr;              %Irradiance (W/m^2)
            obj.nom = nom;              %Nominal Irradiance (W/m^2)
            obj.ID = ID;                %Unique ID number
            
        end
        
        function [] = setMPP(obj)
            %Calculate the MPP by finding the maximum of the multiplication
            %between current and voltage.
            
            obj.MPP = max(obj.I.*obj.V);    %MPP (W)
            
            %Also set the voltage and current at the maximum power point
            obj.Vmpp = obj.V(find(obj.V.*obj.I == obj.MPP)); %Vmpp (V)
            
            obj.Impp = obj.I(find(obj.V.*obj.I == obj.MPP)); %Impp (A)
        end
       
        function [] = setISC(obj)
            %Calculate the short circuit current of the IV curve. While
            %thie value is normally recorded where the voltage is zero, we 
            %take the average of the first 5 current values to prevent an 
            %incorrect ISC value due to an incorrectly recorded first
            %current value.
            
            obj.ISC = mean(obj.I(:,1:5));   %ISC (A)
        end
        
        function [] = setVOC(obj)
            %Calculate the VOC by interpolating the IV curve and finding 
            %where the current is equal to 0
            
            %At maximum irradiance, set the VOC to the last voltage value
            %since the current never equals 0
            if obj.irr == 1000
                obj.VOC = obj.V(end);
                
            %At 0 irradiance (dark panel), set the VOC to 0. While it can
            %never technically be 0 due to the logarithmic nature of the
            %VOC on irradiance, it will be small enough to be considered 0.
            elseif obj.irr == 0
                obj.VOC = 0;
                
            else
                %Due to issues with the values needing to be unique for
                %interpolation, filter the I and V data to make sure the values
                %are unique. 
                [~,ia,~] = unique(obj.I); %ia grabs all indexes that are 
                                               %unique and we use those in
                                               %interpolation

                obj.VOC = interp1(obj.I(ia),obj.V(ia),0);   %VOC (V)
            end
        end
    end
end

