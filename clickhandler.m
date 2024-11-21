% clickhandler.m

pt = get(gca,'CurrentPoint');

px = pt(1,1);
py = pt(1,2);

set(hpt,'XData',px,'YData',py)

hlin = get(gca,'UserData');
if ~isempty(hlin)
  set(hlin,'XData',[px px],'YData',[py py])
end

pdistsq = (xcenters-px).^2./sigmavals(:,1) + (ycenters-py).^2./sigmavals(:,2);
pact = exp(-pdistsq);
nact = pact / sum(pact);
zact = nact.^(1/5);
zgray = [0.3 0.3 0.3];

for i=1:NUNITS
  set(hand1(i),'Color',max(zgray,zact(i)*[1 0 0]))
  set(hand2(i),'Color',zact(i)*[1 1 1])
end