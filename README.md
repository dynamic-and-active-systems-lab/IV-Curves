# IV-Curves
All IV curves from laboratory characterization of silicon solar cells.

The IV MATS folder contains all IV Curve .mat files separated by water type.

The water types correspond to Jerlov's water type classification (N. G. Jerlov,Marine optics.    Elsevier, 1976). 

Download both the IVcurve.m file and respective IV_Curve water type .mat file

Water type "Type I" contains IV curves for a zero irradiance curve (depth -2) and AM1.5G standard spectrum (depth -1).

The IVcurve.m file contains the IVcurve class and details explaining each variable.

**To generate a simple IV curve for any given depth, the example code below can be used:**

%Assuming all .mat files have been loaded

%% Simple 2d line plot of the current and voltage

plot(Type_I(1,1).V,Type_I(1,1).I)

%% Set the xlim and ylim 
%xlim set between 0 and 7 V. The experimental testing did not go past 7 V

xlim([0 7])

%ylim set between 0 and the first current value (largest value)

ylim([0 Type_I(1,1).I(1)])

%% Set the xlabel and ylabel

xlabel('Voltage (V)')
ylabel('Current (A)')

**To compare different IV curves or other parameters, I found it best to combine all .mat files into one giant IV curve set. Below is some MATLAB code to combine the .mat files into one set:**

%Assuming all .mat files have been loaded

%% Combine the IV curves

IVcurves = [Type_I; Type_IA; Type_IB; Type_II; Type_III; Type_CW1; Type_CW3; Type_CW5; Type_CW7; Type_CW9];

Now that the IV curves are combined, it is easy to sort by water quality, depth, temperature, or the parameter that is desired. I will use depth as the parse and will first parse by a single depth and then by multiple depths:

%Assuming all .mat files have been loaded

%% Combine the IV curves

IV_curves = [Type_I; Type_IA; Type_IB; Type_II; Type_III; Type_CW1; Type_CW3; Type_CW5; Type_CW7; Type_CW9];

%Depth of interest to parse data set by

depth = 1;

%Generate a mask where the depths of the IV curves are equal to the depth of interest

depth_mask = [IV_curves(:).d] == depth;

%Refine the IV curve data set by the depth mask

IV_refined = IV_curves(depth_mask);

**Now to grab IV curves over at different depths, we just use a for loop to loop through the depths or any other parameter of interest:**

%Depth of interest to parse data set by

depth = 0:1:30;

%Generate a mask where the depths of the IV curves are equal to the depth of interest

for i = 1:length(depth)

depth_mask = [IV_curves(:).d] == depth(i);

%Refine the IV curve data set by the depth mask

IV_refined = IV_curves(depth_mask);
end

**Now we have a method grab IV curves at any searchable parameter. Next we can interpolate between points by any of the parameters. However, the method of interpolation is important here. For VOC and only for extrapolation, a natural log fitting extrapolation is needed if interpolating between irradiance. Here is an example of strictly interpolating the VOC, ISC, and MPP for the values at the nominal irradiance:** 

%Depth of interest to parse data set by

depth = 1;

%Temperature of interest

temp = 5;

%Water quality of interest

quality = "Type I";

%Generate a mask where the depths of the IV curves are equal to the depth of interest

depth_mask = [IV_curves(:).d] == depth;

%Refine the IV curve data set by the depth mask

IV_depth = IV_curves(depth_mask);

%Generate a mask where the depths of the IV curves are equal to the depth of interest

temp_mask = [IV_depth(:).T] == temp;

%Refine the IV curve data set by the temp mask

IV_temp = IV_depth(temp_mask);

%Generate a mask where the depths of the IV curves are equal to the depth of interest

quality_mask = [IV_temp(:).quality] == quality;

%Refine the IV curve data set by the quality mask

IV_refined = IV_temp(quality_mask);

%Need to add in the zero IV curve (complete darkness) to allow for complete interpolation. At a depth of -2, this is the zero IV curve

zero_curve = IV_curves([IV_curves.d] == -2);

%Add this zero curve to the refined data set

IV_refined = [zero_curve; IV_refined];

%Interpolate the ISC using linear interpolation

ISC = interp1([IV_refined.irr],[IV_refined.ISC],IV_refined(end).nom);

%Interpolate the VOC using linear interpolation

VOC = interp1([IV_refined.irr],[IV_refined.VOC],IV_refined(end).nom);

%Interpolate the MPP using linear interpolation

MPP = interp1([IV_refined.irr],[IV_refined.MPP],IV_refined(end).nom);

**Finally, here is some example code of how to extrapolate the VOC, ISC, and MPP for the nominal irradiance:**

%Depth of interest to parse data set by

depth = 1;

%Temperature of interest

temp = 5;

%Water quality of interest

quality = "Type I";

%Generate a mask where the depths of the IV curves are equal to the depth of interest

depth_mask = [IV_curves(:).d] == depth;

%Refine the IV curve data set by the depth mask

IV_depth = IV_curves(depth_mask);

%Generate a mask where the depths of the IV curves are equal to the depth of interest

temp_mask = [IV_depth(:).T] == temp;

%Refine the IV curve data set by the temp mask

IV_temp = IV_depth(temp_mask);

%Generate a mask where the depths of the IV curves are equal to the depth of interest

quality_mask = [IV_temp(:).quality] == quality;

%Refine the IV curve data set by the quality mask

IV_refined = IV_temp(quality_mask);

%Perform natural log fitting to the VOC first
%This equation is the equation for a natural log

myfit = fittype('a + b*log(x)',...
'dependent',{'y'},'independent',{'x'},...
'coefficients',{'a','b'}); %Complete equation

%Grab all the original data curves. Need to make sure that the zero curve is not in here for natural log extrapolation 

x = [IV_refined.irr];
y = [IV_refined.VOC];

%Perform the natural log curve fitting  

[fitted_curve,gof] = fit(x',y',myfit);

%Turns off warnings

warning('off')
   
%Perform the extrapolation on the data set over the complete range of irradiances.

VOC = interp1(0.1:0.1:IV_refined(end).nom*1.1,...
fitted_curve((0.1:0.1:IV_refined(end).nom*1.1)),...
IV_refined(end).nom);
                    
%If the irradiance value is less than the nominal, use
%linear extrapolation to obtain the nominal values
%Add in zero curve for linear extrapolation

IV_refined = [zero_curve; IV_refined];
   
ISC = interp1([IV_refined.irr],[IV_refined.ISC],IV_refined(end).nom...
,'linear','extrap');

MPP = interp1([IV_refined.irr],[IV_refined.MPP],IV_refined(end).nom...
,'linear','extrap');
