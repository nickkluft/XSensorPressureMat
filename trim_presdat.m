function out = trim_presdat(presdat,samps)

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
