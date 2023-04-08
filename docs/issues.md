The core of the issue is how they built most of the benchmarks. Basically, they have a simple computation (e.g. total energy in nbody), and they redo the initialization each iteration, meaning that if the compiler is doing its job the entire benchmark can be run in a single iteration and the code will get pulled out of the main loop body. Verification is only done for a single iteration of the main loop because of this. You can see how it's done in ST:
image.png

# GENERAL ISSUES

For the verification of the floating point benchmarks, we also think that it would make more sense to have the beebs function look for errors of relative magnitude:

`#define float_eq_beebs(exp, actual) (fabsf(exp - actual) < VERIFY_FLOAT_EPS ) // current`

`#define float_eq_beebs(exp, actual) (fabsf(exp - actual) < VERIFY_FLOAT_EPS * max(exp, actual)) // proposed change`

# NBODY

**Algorithm issues**

The issue is that there is no function that updates position - only one that calculates the total energy and one that calculates the velocities of each body.

Because of this bodies_endergy can be hoisted out of the main loop, and it's likely momentum can as well. Update momentum (as it is now) should also update all bodies, not just body 0.

**PROPOSED CHANGE**

Change the scope of the tot_e variable to become global to prevent it from being optimized out of the main loop.

# ST

ST does a calculation for finding the stddev, but never checks for it or uses it in another function, so the computation for it gets optimized out.

**PROPOSED CHANGE**

Create a check for stddev as well so the compiler doesn't optimize the stddev function out.


# EDN
EDN runs the jpeg function (variable arrays a / b), but does not verify the results or use them in another function, so the entire jpeg function gets optimized out.

a and b should be checked for their correct values to ensure that they aren't optimized out by the compiler.
