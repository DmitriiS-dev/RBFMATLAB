[xvals,yvals,zvals] = peaks;
axvals = [min(xvals(:)) max(xvals(:)) min(yvals(:)) max(yvals(:)) ...
      floor(min(zvals(:))) ceil(max(zvals(:)))];
[nx,ny] = size(xvals);

rbfmode=1;
eta=0.01;%learning rate

%disp('Mouse in either window to see RBF activation.')

switch rbfmode
  case 1,
    xrange = -3:1:3;
    yrange = -3:1:3;
    [xcenters, ycenters] = meshgrid(xrange, yrange);
    xcenters = xcenters(:);
    ycenters = ycenters(:);
    NUNITS = length(xcenters);
    if ~exist('constant_sigma'), constant_sigma = 0.7, end
    sigmavals = repmat(constant_sigma,NUNITS,2);
  case 2,
    if ~exist('NUNITS'), NUNITS = 60, end
    xcenters = rand(NUNITS,1)*(axvals(2)-axvals(1))+axvals(1);
    ycenters = rand(NUNITS,1)*(axvals(4)-axvals(3))+axvals(3);
    sigmavals = 0.6 + rand(NUNITS,2)*0.5-0.2;
end

colordef none
figure(1),clf reset, colormap(jet)
subplot(1,2,1)
h1=surf(xvals,yvals,zvals);
hold on
set(gca,'ButtonDownFcn','clickhandler')
set(h1,'ButtonDownFcn','clickhandler')
set(gca,'UserData',plot3([-50 -50],[-50 -50],[-50 50],'m--', ...
    'ButtonDownFcn','clickhandler'))
xlabel('x'),ylabel('y')
axis(axvals)

showfields

Weights = 0 * xcenters';
xv = repmat(xvals(:)',NUNITS,1);
yv = repmat(yvals(:)',NUNITS,1);
zv = zvals(:)';
NPOINTS = length(xv);

% Since we're not adapting the centers or the variances, we can
% compute the activations just once.

distsq = ...
    (repmat(xcenters,1,NPOINTS)-xv).^2./repmat(sigmavals(:,1).^2,1,NPOINTS) + ...
    (repmat(ycenters,1,NPOINTS)-yv).^2./repmat(sigmavals(:,2).^2,1,NPOINTS);
act = exp(-distsq);%Russian Fei = exp( - || xe - xi ||^2 / 2variancei^2 )
nact = act ./ repmat(sum(act),NUNITS,1);

% Now adapt the weights.

MSE = Inf;

for epoch = 1:50

  outputs = Weights * nact;
  figure(1)
  subplot(1,2,2), cla
  h2=surf(xvals,yvals,reshape(outputs,nx,ny));
  hold on
  set(gca,'UserData',plot3([-50 -50],[-50 -50],[-50 50],'m--', ...
      'ButtonDownFcn','clickhandler'))
  set(h2,'ButtonDownFcn','clickhandler')
  set(gca,'ButtonDownFcn','clickhandler')
  axis(axvals)      
  xlabel('x'),ylabel('y')
  drawnow
  error = zv - outputs;
  oldMSE = MSE;
  MSE = sum(error.^2) / NPOINTS;
  title(sprintf('Epoch %d,  MSE = %6.4f',epoch,MSE))
  if abs(MSE-oldMSE) < 0.001
    break
  end
  Weights = Weights + (eta*nact*error')';%same weight update equation
end
disp('');
