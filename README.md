# IV-Curves
All IV curves from laboratory characterization of silicon solar cells.

The IV MATS folder contains all IV Curve .mat files separated by water type.

The water types correspond to Jerlov's water type classification (N. G. Jerlov,Marine optics.    Elsevier, 1976). 

Download both the IVcurve.m file and respective IV_Curve water type .mat file

Water type "Type I" contains IV curves for a zero irradiance curve (depth -2) and AM1.5G standard spectrum (depth -1).

The IVcurve.m file contains the IVcurve class and details explaining each variable.

EXAMPLE CODE TO GENERATE A SINGLE IV CURVE

load('Type_I.mat')
plot(Type_I(1,1).V,Type_I(1,1).I)
xlim([0 7])
ylim([0 0.001])
xlabel('Voltage (V)')
ylabel('Current (A)')
