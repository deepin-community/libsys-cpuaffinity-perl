#include <EXTERN.h>
#include <perl.h>
#include <XSUB.h>

#include <stdio.h>
#include <windows.h>
#include <winbase.h>

=pod
   
  Calls the MSWin32 GetSystemInfo system function, which can
  access the number of processors on the system, among
  other things.
 
  The code in this file is identical to  win32_system_info.xs .
  It attempts to  #include  the Windows header files from different
  directories, so it may be useful if  win32_system_info.xs  can't
  find the header files under a "win32" directory.

=cut

MODULE = Sys::CpuAffinity   PACKAGE = Sys::CpuAffinity

#pragma comment(lib, "user32.lib")

void 
xs_display_system_info_alt()
CODE:
   SYSTEM_INFO siSysInfo;
 
   // Copy the hardware information to the SYSTEM_INFO structure. 
 
   GetSystemInfo(&siSysInfo); 
 
   // Display the contents of the SYSTEM_INFO structure. 

   printf("Hardware information: \n");  
   printf("  OEM ID: %u\n", siSysInfo.dwOemId);
   printf("  Number of processors: %u\n", 
      siSysInfo.dwNumberOfProcessors); 
   printf("  Page size: %u\n", siSysInfo.dwPageSize); 
   printf("  Processor type: %u\n", siSysInfo.dwProcessorType); 
   printf("  Minimum application address: %lx\n", 
      siSysInfo.lpMinimumApplicationAddress); 
   printf("  Maximum application address: %lx\n", 
      siSysInfo.lpMaximumApplicationAddress); 
   printf("  Active processor mask: %u\n", 
      siSysInfo.dwActiveProcessorMask);



int
xs_get_numcpus_from_windows_system_info_alt()
CODE:
	SYSTEM_INFO siSysInfo;
	GetSystemInfo(&siSysInfo);
	RETVAL = siSysInfo.dwNumberOfProcessors;
OUTPUT:
	RETVAL



