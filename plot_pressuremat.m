function guis = plot_pressuremat(pres)
% Function to plot the pressure data nicely
% FUCTION:
%     plot_pressuremat(presdat)
%     guis = plot_pressuremat(presdat)
% INPUT:
%     presdat : pressuremat data retrieved from load_pressuremat.m 
%               (or from batchexport_pressuremat.m)
% OUTPUT:
%     guis : handles to figure
% 
% Created by Nick Kluft, 2020 [TU Delft]
% 
% GNU GENERAL PUBLIC LICENSE
% Copyright (C) 1989, 1991 Free Software Foundation, Inc.,
% 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA
% Everyone is permitted to copy and distribute verbatim copies
% of this license document, but changing it is not allowed.


% starting frame
i_fr = 1;
nframes = size(pres.data,3);
[maxval,imax] = max(max(max(pres.data)));
%% Make mesh and plot first figure
[Xmesh,Ymesh] = meshgrid(0:str2double(pres.Rows)-1,0:str2double(pres.Columns)-1);
Xmesh = Xmesh * str2double(pres.SenselWidthcm)+.5*str2double(pres.SenselWidthcm);
Ymesh = Ymesh * str2double(pres.SenselHeightcm)+.5*str2double(pres.SenselHeightcm);
%% Graphical User Interface
guis = [];
figure('Color','w')
guis.hsurf = surf(Xmesh,Ymesh,pres.data(:,:,i_fr));
zlim([0 maxval])

guis.pushb = uicontrol('Callback',{@playsurf,guis},...
    'Style','togglebutton','String','Play/Pause',...
    'Tag','play');
guis.slide = uicontrol('Callback',{@update_surf,guis},'Style','slider',...
    'Position',guis.pushb.Position+[80 -5 100 0],...
    'SliderStep',[1/(nframes-1) 1/(nframes-1)],...
    'Tag','slider','ListboxTop',0,'Value',1,'Min',1,'Max',nframes);
guis.sampfeed = uicontrol('Style','text',...
    'String',sprintf('sample # %06d',i_fr),...
    'Position',guis.pushb.Position+[300 -5 40 0]);
set(gcf,'userdata',pres)
end

function update_surf(~,~,guis)
% update the surf-plot
if ~isfield(guis,'sampfeed')
    guis.slide = findobj(gcf,'Tag','slider');
    guis.pushb = findobj(gcf,'Tag','play');
    guis.sampfeed = findobj(gcf,'Style','text');
end
% get user data
pres = get(guis.pushb.Parent,'userdata');
% get slider value
i_fr = round(guis.slide.Value);
% set new data in surf
guis.hsurf.ZData = pres.data(:,:,i_fr);
% set string in text field
guis.sampfeed.String = sprintf('sample # %06d',i_fr);
drawnow
end


function playsurf(hand,~,guis)
% start animation
guis.slide = findobj(gcf,'Tag','slider');
guis.pushb = findobj(gcf,'Tag','play');
guis.sampfeed = findobj(gcf,'Style','text');
while hand.Value
    i_fr = round(guis.slide.Value);
    guis.slide.Value = i_fr+1;
    update_surf([],[],guis)
end
end