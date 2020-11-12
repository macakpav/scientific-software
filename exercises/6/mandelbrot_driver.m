% MANDELBROT_DRIVER Example of a call to the mandelbrot functions

clear variables; clc; close all;

%% Parameters for an interesting part of the complex space
center  = -0.7465 + 0.1240i;
radius  = 0.0037;
steps   = 512; % Change steps when the computation takes too much or too little time.
maxiter = 100;

% ranges
xr = real(center)+linspace(-radius,radius,steps);
yr = imag(center)+linspace(-radius,radius,steps);

%% Calculate for a range of revisions
R_tilde_ref = mandelbrot_99(center,radius,steps,maxiter);
mandelbrot_fun = str2func('mandelbrot');
fprintf('- Testing %s ... \n',func2str(mandelbrot_fun));

% Run the function
tic
R_tilde = mandelbrot_fun(center,radius,steps,maxiter);
toc
max_abs_err = max(abs((R_tilde(:)-R_tilde_ref(:))));
fprintf(' max.abs.err.: %g\n', max_abs_err );

% Create a figure with the result ...
figure; clf;
subplot(1,2,1);
imagesc(xr,yr,R_tilde);
axis image;
colormap(jet);
title(sprintf('Mandelbrot set (%ix%i, iters <=%i)',...
    steps,steps,maxiter));
xlabel('Real(z)');
ylabel('Imag(z)');
set(gca,'XTick',[],'YTick',[]);
colorbar

% ...  and the error
subplot(1,2,2);
imagesc(xr,yr,abs(R_tilde-R_tilde_ref) );
axis image;
colormap(jet);
title(sprintf('Error plot (max.abs.err.: %g)', max_abs_err ));
xlabel('Real(z)');
ylabel('Imag(z)');
set(gca,'XTick',[],'YTick',[]);
colorbar
set(gcf,'units','points','position',[100,50,1000,400])
set(0, 'DefaultFigureVisible', 'on');

