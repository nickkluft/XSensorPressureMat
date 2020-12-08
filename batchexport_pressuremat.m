% batch export pressuremat
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
