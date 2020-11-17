function [out] = load_pressuremat(filenm)
% Function to load the csv output of the XSENSOR pressure mat
% Export settings Xsensor Pro software:
% CSV/Text Format  - PRO 7 REV 1 (*.CSV export)
% Date/Time Fields - Frame Timestamp
% Center of Pressure Coordniates: Rel to upper-left corner of sensor
%
% FUNCTION
%       out = load_pressuremat(filenm)
% INPUT
%       filnm   = full path to file (only *.csv supported)
% OUTPUT
%       out     = structure with file description and data (i.e., out.data)
%
% Nick Kluft, 2020
%
% Credits: ligth-weight textprogressbar.m [using nested Matlab functions,
% renders more quickly than the build in object oriented function]
% megas (2020). textprogressbar https://www.github.com/megasthenis/...
%                       textprogressbar), GitHub. Retrieved March 3, 2020.
%
% % % % % % % % % % % % % T U D E L F T % % % % % % % % % % % % % % % % %

out = [];
% Check validity of input variable
if ~exist(filenm,'file')
    disp([filenm,': file does not exist!'])
    return
end
% check file extension
[~,~,file_extension] = fileparts(filenm);
if ~isequal(lower(file_extension),'.csv')
    disp([filenm,': only .csv supported']);
    return
end

%% find the lenght of the file (using a temp file identifier)
fid_temp = fopen(filenm,'r');
% find end file
fseek(fid_temp, 0,'eof');
% index of the final row
flength = ftell(fid_temp);
% close temporary fid
fclose(fid_temp);

%% open file now
fid = fopen(filenm,'r');
out.data = [];
% counters
iframe = 0;% frame number
frameplus = 1;
irow = 1;% row number
% initialise progress bar
disprog =false;
% check whether file is in directory
if exist('textprogressbar.m','file')
    disprog =true;
    upd = textprogressbar(flength,'updatestep',1e6);
else
    disp('If you like a lightweight progressbar to run with this code')
    disp('get it from: https://www.github.com/megasthenis/textprogressbar')
end

while ~feof(fid) % continue till end of file
    tline = fgetl(fid); % get first line
    if numel(tline)>100 % data line longer than 100 chars
        if isempty(out.data)
            % get an estimate of size out.data
            % tot lines reserved for data = 9084;
            ndim3 = round(flength/(9084+ftell(fid)));
            % initialize out.data for faster processing.
            out.data = nan(str2double(out.Rows),str2double(out.Columns),ndim3);
            out.tframe = nan(ndim3,1);
            out.COP = nan(ndim3,2);
        end
        % go to next frame after all rows are evaluated
        iframe = iframe + frameplus;
        
        % csv interpreter:
        datframe = replace(tline,'","',' ');
        datframe = replace(datframe,',','.');
        datframe(ismember(datframe,'"')) = [];
        % import a data-row 
        out.data(irow,:,iframe) = eval(['[',datframe,']']);
        
        frameplus = 0;
        irow =irow+1;
        if irow > str2double(out.Rows)
            % difference betweeen this timestamp and start of measurement
            out.tframe(iframe) = tnow-tfirst;%seconds from start
            out.COP(iframe,[1 2]) = COPtmp;
            irow = 1;
            if disprog
                % update progressbar
                upd(ftell(fid))
            end
        end
    elseif ~isempty(tline)
        frameplus = 1;
        if isequal(iframe,0)
            isplit = find(ismember(tline,':'),1,'first');
            sstr = [{tline(1:isplit-1)}, {tline(isplit+2:end)}];
            % get file info (only first run)
            inp = sstr{1}(~isspace(sstr{1}));
            % remove ackward symbols
            inp = inp(~ismember(inp,'()"./²'));
            out.(inp) = sstr{end}(~isspace(sstr{end}));
            out.(inp)(ismember(out.(inp),'"')) = [];
            out.(inp) = replace(out.(inp),',','.');
            if isequal(inp,'Time')
                out.Time(ismember(out.Time,'"')) = [];
                ttemp = datevec(out.Time,'HH:MM:SS.FFF');
                tfirst = (3600*ttemp(4)+60*ttemp(5)+ttemp(6));
                tnow = tfirst;
            end
        elseif contains(tline,'Time')
            % save timestamp in timevector
            sstr= strsplit(tline,':,');
            ttemp = datevec(sstr{end}(~ismember(sstr{end},'"')),'HH:MM:SS.FFF');
            tnow = (3600*ttemp(4)+60*ttemp(5)+ttemp(6));
        end
        if contains(tline,'COP')
            % Get the CoP data from frame description lines 
            sstr= strsplit(tline,':,');
            % row of CoP
            if contains(tline,'Row')
                inpcop = replace(sstr{end},',','.');
                inpcop(ismember(inpcop,'"'))= [];
                COPtmp(1) = str2double(inpcop);
            end
            % collumn of CoP
            if contains(tline,'Column')
                inpcop = replace(sstr{end},',','.');
                inpcop(ismember(inpcop,'"'))= [];
                COPtmp(2) = str2double(inpcop);
            end
        end
    end
end

if disprog
    % update progressbar
    upd(flength)
end
% delete the surplus nan data
if size(out.data,3)>iframe
    out.data(:,:,iframe+1:end) = [];
    out.tframe(iframe+1:end) = [];
    out.COP(iframe+1:end,:) = [];
end
fclose(fid);


