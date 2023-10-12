#include <EXTERN.h>
#include <perl.h>
#include <XSUB.h>

#include <linux/unistd.h>
#include <sched.h>

=pod

linux-sched_setaffinity.xs: update CPU affinity with the Linux
sched_setaffinity(2)  system call. See also:
linux-sched_getaffinity.xs .

=cut




MODULE = Sys::CpuAffinity        PACKAGE = Sys::CpuAffinity

int
xs_sched_setaffinity_set_affinity(pid,mask,debug_flag)
    int pid
    AV *mask
    int debug_flag
  CODE:
    static cpu_set_t cpumask;
    int i,r;
    
    CPU_ZERO(&cpumask);
    for (i=0; i <= av_len(mask); i++) {
        int c = SvIV(*av_fetch(mask,i,0));
        if (debug_flag) fprintf(stderr,"sched_setaffinity%d = %d\n", i, c);
        CPU_SET(c, &cpumask);
    }
    r = sched_setaffinity(pid, sizeof(cpu_set_t), &cpumask);
if (debug_flag) fprintf(stderr,"sched_setaffinity(%d,%ld,...) = %d\n", pid, (long unsigned int) sizeof(cpu_set_t), r);
    if (r != 0) {
      fprintf(stderr,"result: %d %d %s\n", r, errno,
            errno==EFAULT ? "EFAULT" /* a supplied memory address was invalid */
          : errno==EINVAL ? "EINVAL" /* the affinity bitmask contains no
                                        processors that are physically on the
                                        system, or _cpusetsize_ is smaller than
                                        the size of the affinity mask used by
                                        the kernel */
          : errno==EPERM ? "EPERM"   /* the calling process does not have
                                        appropriate privilieges. The process
                                        calling *sched_setaffinity()* needs an
                                        effective user ID equal to the user ID
                                        or effective user ID of the process
                                        identified by _pid_, or it must possess
                                        the _CAP_SYS_NICE_ capability. */
          : errno==ESRCH ? "ESRCH"   /* the process whose ID is _pid_ could not
                                        be found */
              :"E_WTF");
    }
    RETVAL = !r;
  OUTPUT:
    RETVAL


