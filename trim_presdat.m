function out = trim_presdat(presdat,samps)
% function to trim pressure mat data (exported with load_pressuremat.m or batchexport_pressuremat.m).
% FUNCTION:
%   out = trim_presdat(presdat,samps)
% INPUT:
%       presdat : data structure file retrieved from load_pressuremat.m 
%                 (or batchexport_pressuremat.m)
%       samps   : indices samples that you want the data to.
% OUTPUT:
%       out     : trimmed data structure file.
%
% Created by Nick Kluft, 2020 [TU Delft]
% 
% GNU GENERAL PUBLIC LICENSE
% Copyright (C) 1989, 1991 Free Software Foundation, Inc.,
% 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA
% Everyone is permitted to copy and distribute verbatim copies
% of this license document, but changing it is not allowed.


out = presdat;
out.data = presdat.data(:,:,samps);
out.COP =  presdat.COP(samps,:);

% new starting time
tvecdiff = datevec(seconds(presdat.tframe(samps(1))));
tvecstart = datevec([presdat.Date,' ',presdat.Time],'yyyy-mm-dd HH:MM:SS.FFF');
tvecnew = tvecstart+tvecdiff;
datestring =  strsplit(string(datetime(tvecnew,'Format','yyyy-MM-dd HH:mm:ss.SSS')),' ');
out.Date = datestring{1};
out.Time = datestring{2};
out.tframe = presdat.tframe(samps)-presdat.tframe(samps(1));

if isfield(out,'data2')
    out.data2 = presdat.data2(:,:,samps);
    out.COP2 = presdat.COP2(samps,:);
end
