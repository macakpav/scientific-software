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
function R_tilde = mandelbrot(center, radius, steps, maxiter)

C = zeros(steps);
R_tilde = maxiter * ones(steps);

for m = 1:steps %just a quick copy-paste, should be done using Matlab vector notation
  for n = 1:steps
    C(m, n) = real(center) - radius + 2 * (n - 1) * radius / (steps - 1) ...
      +1i * (imag(center) - radius + 2 * (m - 1) * radius / (steps - 1));
  end
end
Z = C;
for r = 1:maxiter
  I = find(R_tilde == maxiter);
  Z(I) = Z(I) .* Z(I) + C(I);
  R_tilde(I(abs(Z(I))>2)) = r;
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
