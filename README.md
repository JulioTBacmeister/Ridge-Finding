# Ridge-Finding
Ridge finding software for CESM

Tags.

v1.0.0  initial check-in of CESM2 code. No mods. Doesn't work so well.

v1.0.1 Minor workflow mods to shell scripts and FV 1x1 namelist. Recreates B4B copy of CESM2 bndtopo file, including Greenland rougehning using script:
  create_CESM20_FV_1x1_topo.csh

v2.0.0 WGHTS corrected.  Imprtance sorting now works. My son thinks I am a nerd. More outputs added to ridge_ana.F90 


Major developments for v3

- Discovered nsb/nrs/nridge_subsample was actually working opposite to intent.
  Was flagging profiles with no peak within nsb of center as "sloping terrain" 
  rather than cases with peak nsb or closer to edges of analysis window. CESM2 
  topo was using nsb=8 with Nsw=42 which is OK/not catatstrophic when 
  Co=60 and Fi=1.  But this incorrect implementation was prbably making 
  band passed ridges look like shit.  This was changed in ridge_ana.F90. Now 
  simply checking if ipkh is either 1 or Nsw.  

- Similar confusion about reconcilation window/paintbrush.  Was using "brush" 
  defined by r**2<Nsw instead of as intended r<nsw, so for example for Nsw=42
  brush had radius of only SQRT(42)~6.  This turned out to better than the 
  inetnded Nsw value, but leads to lots of fragmentation of reconstructions
  such as "block" and "profi".  Now using rotating Nsw x Nsw square brush. 
  
- Making scripts more rational.   Ndw scripts create_topo.csh and driver.csh
  replace god-awful scripts for CESM2 topo.
