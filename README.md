# XSensorPressureMat
Loading and evaluating XSensor pressure mat data

*Export Settings Xsensor Pro Sotware:

    SV/Text Format  - PRO 7 REV 1
    
    Date/Time Fields - Frame Timestamp 
    
    Center of Pressure Coordniates: Rel to upper-left cornner of sensor
    
*Files in repository:

    load_pressuremat.m : Function to load the csv output of the XSENSOR pressure mat
    
    plot_pressuremat.m : Function to plot the loaded data from load_pressuremat.m
    
    batchexport_pressuremat.m : Function to export a full folder to Matlab mat files 
    (saves exported files to mat files with the same name and in the same folder)
    
    trim_presdat : Function to trim the data to a certain samples

Created by Nick Kluft, 2020

GNU GENERAL PUBLIC LICENSE
Copyright (C) 1989, 1991 Free Software Foundation, Inc.,
51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA
Everyone is permitted to copy and distribute verbatim copies
of this license document, but changing it is not allowed.
