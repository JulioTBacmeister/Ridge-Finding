# Ridge-Finding
Ridge finding software for CESM

Tags.

v1.0.0  initial check-in of CESM2 code. No mods. Doesn't work so well.

v1.0.1 Minor workflow mods to shell scripts and FV 1x1 namelist. Recreates B4B copy of CESM2 bndtopo file, including Greenland rougehning using script:
  create_CESM20_FV_1x1_topo.csh

v2.0.0 WGHTS corrected.  Imprtance sorting now works. My son thinks I am a nerd. More outputs added to ridge_ana.F90 

made this branch "v2_branch" (11/19/21) Let's see what happens now.

Not sure this branch is really needed but code here has a bug in imortance sorting fixed, that does change the answers from those for CESM2.  I owsuld use this for non-answer changing mods to the "fixed" CESM2 code.  Main branch will continue to track new development. 
