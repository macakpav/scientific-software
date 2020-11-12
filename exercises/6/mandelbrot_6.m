% MANDELBROT_00 Not optimised Mandelbrot function. 
% 
% NOTE: On purpose, this code contains a bug and some superfluous code.
%
% HISTORY
%
%   20090701 KP - Initial version
%   20100506 KP - Allowing a center different from the origin
%
% AUTHOR
%
%   Koen Poppe, Nikon Metrology, Brussels, Belgium
%  
function R_tilde=mandelbrot(center,radius,steps,maxiter)

Z = zeros(steps);
C = zeros(steps);
R_tilde = zeros(steps);

for r=0:maxiter
    for m=1:steps
        for n=1:steps
            if r == 0
                C(m,n) = real(center)-radius+2*(n-1)*radius/(steps-1) ...
                    + i*(imag(center)-radius+2*(m-1)*radius/(steps-1));
                Z(m,n) = C(m,n);
                R_tilde(m,n) = maxiter;
            else
               if R_tilde(m,n) == maxiter
                    Z(m,n) = Z(m,n)*Z(m,n) + C(m,n);
                    if abs(Z(m,n)) > 2
                        R_tilde(m,n) = r;
                    end
               end
            end
        end
    end
end


% Q1: It is a function handle.
% 
% Q2: Step skips to next statement in current file/code. Step_in will open
% the function file/code if the current line has a function call.
% 
% Q3: The error was that the R_tilde was rewritten each iteration, so first
% it was assigned the correct r, but then it continued rewriting it ntil
% max_iter. I fixed this by modifying the condition R_tilde(m,n) <= maxiter
% to R_tilde(m,n) == maxiter (meaning only look for R_tilde, if it does not
% have a valid value assigned already)
% 
% Q4: Total time is the time spent in the function. Self time is the total
% time without the time spent in called subfuntions. The mandelbrot is the 
% most costly function. I can either look on self time to find this
% funciton but it is maybe better to look on total time (mandelbrot could 
% also be calling subfuntions) and desregard the mandelbrot_driver since it
% is "the main" function. 
%
% Q5: Yes the line 36 is never executed. This is because R_tilde can never
% have value =0, because it is either assigned max_iter(~=0) on 27th line 
% or r on 32th line, but here r cannot be==0, because for r==0 the else
% block starting at 28th line will not be exectuted.
% 
% Q6: Yes now it is faster because of preallocation the matricies don't
% have to make a system call for allocating memory in each iteration.


