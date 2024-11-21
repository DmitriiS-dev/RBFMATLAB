% showfields.m

figure(2), clf reset, colormap(jet), hold on
set(gca,'ButtonDownFcn','clickhandler')
hand1 = []; hand2 = [];
axis equal, axis(axvals(1:4)+[-0.5 0.5 -0.5 0.5]), 
circpts = 0:pi/20:2*pi;
xpts = cos(circpts);
ypts = sin(circpts);
colors = 'wcymg';
for i=1:NUNITS
  c = colors(ceil(rand(1,1)*length(colors)));
  hand1(i)=plot(xpts*sigmavals(i,1)+xcenters(i),ypts*sigmavals(i,2)+ycenters(i),c);
  hand2(i)=plot(xcenters(i),ycenters(i),[c '+']);
end
set(hand1,'ButtonDownFcn','clickhandler')
set(hand2,'ButtonDownFcn','clickhandler')
xlabel('x'),ylabel('y')
hpt = plot(-5,-5,'r*');  % used by clickhandler
drawnow

uicontrol('Style','Pushbutton','Position',[0 0 50 20], ...
    'String','Recolor', ...
    'CallBack','recolor_fields')