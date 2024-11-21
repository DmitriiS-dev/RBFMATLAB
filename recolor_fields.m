% recolor_fields.m

colors = 'wcymg';
for i=1:NUNITS
  c = colors(ceil(rand(1,1)*length(colors)));
  set(hand1(i),'Color',c)
  set(hand2(i),'Color',c)
end