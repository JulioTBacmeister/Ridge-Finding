EXEDIR = .
EXENAME = cube_to_target
RM = rm

ifndef ($(FC))
machine=logan
#machine=my_mac
FC = gfortran

#echo Setting FC to gfortran
#echo assume mach is harmon

#------------------------------------------------------------------------
# cheating ..... GFORTRAN
#------------------------------------------------------------------------
#
ifeq ($(FC),gfortran)
  ifeq ($(machine),my_mac)
    INC_NETCDF := /opt/local/include
    LIB_NETCDF := /opt/local/lib
  endif
  ifeq ($(machine),harmon)
    INC_NETCDF :=/usr/local/netcdf-gcc-g++-gfortran/include
    LIB_NETCDF :=/usr/local/netcdf-gcc-g++-gfortran/lib
  endif
  ifeq ($(machine),logan)
    INC_NETCDF :=/usr/local/netcdf-c-4.6.1-f-4.4.4-gcc-g++-gfortran-4.8.5/include
    LIB_NETCDF :=/usr/local/netcdf-c-4.6.1-f-4.4.4-gcc-g++-gfortran-4.8.5//lib
  endif


  LDFLAGS = -L$(LIB_NETCDF) -lnetcdf -lnetcdff 
  FFLAGS   := -c  -fdollar-ok  -I$(INC_NETCDF)

  ifeq ($(DEBUG),TRUE)
#   FFLAGS += --chk aesu  -Cpp --trace
    FFLAGS += -Wall -fbacktrace -fbounds-check -fno-range-check # -DDEBUGRIDGE
  else
    FFLAGS += -O # -DDEBUGRIDGE
  endif

endif

endif




.SUFFIXES:
.SUFFIXES: .F90 .o

.F90.o:
	$(FC) $(FFLAGS) $<

#------------------------------------------------------------------------
# Default rules and macros
#------------------------------------------------------------------------

OBJS :=  reconstruct.o remap.o shr_kind_mod.o shared_vars.o rot.o smooth_topo_cube.o ridge_ana.o cube_to_target.o 

$(EXEDIR)/$(EXENAME): $(OBJS)
	$(FC) -o $@ $(OBJS) $(LDFLAGS)
	mkdir -p output

clean:
	$(RM) -f $(OBJS)  *.mod $(EXEDIR)/$(EXENAME)

cube_to_target.o: shr_kind_mod.o remap.o reconstruct.o shared_vars.o
reconstruct.o: remap.o 
remap.o      : shr_kind_mod.o
shared_vars.o: shr_kind_mod.o
