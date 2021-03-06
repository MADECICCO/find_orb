# Makefile for Microsoft C/C++ to build an executable linked to PDCurses.
# Add BITS_32=Y for 32-bit code.  Assumes various libraries ('pdcurses',
# 'lunar' or 'lunar64', 'sat_code', 'jpl_eph') will be found.
#    NOT ENTIRELY TO BE TRUSTED,  simply because I almost always compile
# for Windows using MinGW64,  cross-compiled from Linux.  Worked last time
# I tried it.  If you see failure,  let me know and I can probably update
# it without much trouble.

all: find_orb.exe fo.exe

OBJS=ades_out.obj b32_eph.obj bc405.obj bias.obj collide.obj   \
  conv_ele.obj details.obj eigen.obj elem2tle.obj elem_out.obj  \
  elem_ou2.obj ephem0.obj errors.obj expcalc.obj gauss.obj  \
  geo_pot.obj healpix.obj lsquare.obj miscell.obj  \
  monte0.obj mpc_obs.obj mt64.obj nanosecs.obj \
  orb_func.obj orb_fun2.obj pl_cache.obj roots.obj runge.obj \
  shellsor.obj sigma.obj simplex.obj sm_vsop.obj sr.obj stackall.obj

CCLIBS      = user32.lib gdi32.lib advapi32.lib shell32.lib comdlg32.lib
!ifdef BITS_32
CFLAGS=-c -Ot -W3 -nologo -MT -DCONSOLE -I../PDCurses
ADD_LIBS    = pdcurses.lib sat_code32.lib jpleph32.lib lunar.lib
RM=rm
!else
CFLAGS=-c -Ot -W3 -nologo -MT -DCONSOLE -I../PDCurses -D_CRT_SECURE_NO_WARNINGS
ADD_LIBS    = pdcurses.lib sat_code64.lib jpleph64.lib lunar64.lib
RM=del
!endif

find_orb.exe:               findorb.obj $(OBJS) clipfunc.obj
     link /out:find_orb.exe findorb.obj $(OBJS) clipfunc.obj $(ADD_LIBS) \
                       user32.lib $(CCLIBS)

fo.exe:                     fo.obj $(OBJS)
     link /out:fo.exe       fo.obj $(OBJS) $(ADD_LIBS)

fo_serve.exe:               fo_serve.obj $(OBJS)
     link /out:fo_serve.exe fo_serve.obj $(OBJS) $(ADD_LIBS)

.cpp.obj:
   cl $(CFLAGS) $<

clean:
   $(RM) $(OBJS)
   $(RM) fo.obj find_orb.obj fo_serve.obj
   $(RM) covar.txt covar?.txt debug.txt eleme?.txt elements.txt
   $(RM) ephemeri.txt find_orb.exe fo.exe gauss.out monte.txt monte?.txt
   $(RM) mpc_f?.txt mpc_fmt.txt mpec.htm obser?.txt observe.txt
   $(RM) residual.txt state.txt state?.txt virtu?.txt virtual.txt
   $(RM) sr_elems.txt mpcorb.dat fo_serve.cgi find_orb.res
   $(RM) elements.txt covar.txt gauss.out
   $(RM) find_orb.exp vc*.pdb obs_temp.txt guide.txt
   $(RM) find_orb.map find_orb.pdb find_orb.lib vc*.idb

