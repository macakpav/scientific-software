% MANDELBROT_16 Fully optimized Mandelbrot function with imaginary arithmetic unrolling.
% AUTHOR
%   default version Koen Poppe, Nikon Metrology, Brussels, Belgium
%   optimized by Pavel Macak
function R_tilde = mandelbrot(center, radius, steps, maxiter)

[X, Y] = meshgrid(1:steps, 1:steps);
Cr = real(center) - radius + 2 * (X - 1) * radius / (steps - 1);
Ci = imag(center) - radius + 2 * (Y - 1) * radius / (steps - 1);
R_tilde = maxiter * ones(steps);

for n = 1:steps
  for m = 1:steps
    cr=Cr(m,n);%this is faster than evaluating function for c on every iteration
    ci=Ci(m,n);
    zr=cr;
    zi=ci;
    zrOld=zr;
    for r = 1:maxiter
      zr = zr^2 - zi^2 + cr;
      zi = 2*zrOld*zi + ci;
      if sqrt(zr^2 + zi^2) > 2
        R_tilde(m, n) = r;
        break
      end
      zrOld=zr;
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
%
% Q7: This saves time because Matlab does not have to look if by i we mean
% a variable or a complex unit. It also improves code readability.
%
% Q8: It is unnucessary, we should do these things before the loop
% and not every iteration.
%
% Q9: Looks like it matters and implies that Matlab probably used
% column-base storage of matricies. Normally we dont have to know about
% this if we use the Matlab matrix/vector operations which are optimized
% for speed without user interaction.
%
% Q10: This is a nice idea, but the vector that we get from find in the
% first iterations are VERY large (steps^2 both) and dunamically creating
% them each iteration is very slow, so this question does not yield
% improvement. The succes rate of the test in
% question was 176435 out of 16002181 attempts (1%).
%
% Q11: This improves execution time in comparisson to Q10, beacuse now we
% only create a single VERY large vector. It still runs slower that Q9.
%
% Q12: Slight improvement.
%
% Q13: Noticed just a small improvement.
%
% Q14: Avoided explicit loops in initialization. I dont think linspace is
% needed in this case.
%
% Q15: Started from Q9. This code is less tidy than Q14 but faster.
% Rearranged the loops n,m,r. Got rid of Z matrix.
%
% Q16: Imaginary arithmetic unrolling.
