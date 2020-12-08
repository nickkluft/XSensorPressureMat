% Script to batch export pressuremat
% 
% Created by Nick Kluft, 2020 [TU Delft]
% 
% GNU GENERAL PUBLIC LICENSE
% Copyright (C) 1989, 1991 Free Software Foundation, Inc.,
% 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA
% Everyone is permitted to copy and distribute verbatim copies
% of this license document, but changing it is not allowed.

uifold = uigetdir(cd);
foldir = dir([uifold,filesep,'*.csv']);
%% loop over files in directory
for ifilenm =  1:numel(foldir)
    % get filename
    filenm = [uifold,filesep,foldir(ifilenm).name];
    % import pressuremat data
    presdat = load_pressuremat(filenm);
    % Saving data to mat file
    disp('Saving pressuremat data to: ')
    save([filenm(1:end-4),'.mat'],'presdat');
    disp([filenm(1:end-4),'.mat'])
end
