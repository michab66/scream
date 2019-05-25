echo off
if "%1" == "protected" goto probuild
goto regbuild
:probuild
CLS
echo  .
echo  .
echo  This batch stream which is on the PC SCHEME Source Diskette #1
echo  has been envoked with the "protected" option, and will assemble,
echo  compile, and link the PROTECTED MODE VERSION of PC SCHEME. The
echo  diskette generated by this build procedure is:
echo  .
echo  .     2537903-1615 FDO, PC SCHEME PROTECTED MODE DISKETTE
echo  .
echo  .
echo  The source for building is contained on the diskettes
echo  labeled PC SCHEME Source Diskette #1 through #4.
echo  .
echo  .
echo  Please press the RETURN key to continue.
echo  .
PAUSE
CLS
echo  A list of hardware and software required for the build is given below.
echo  .
echo  .     TI Business Pro with:
echo  .		- 640K memory 
echo  .		- 1.2 MB floppy disk drive (drive A)
echo  .		- 360 KB floppy disk drive (drive B)
echo  .		- a Winchester disk drive with at least 10 MB free space
echo  .
echo  .
echo  .     MS-DOS Operating System, version 3.21
echo  .     MS-Macro Assembler, version 4.00
echo  .     Lattice C Compiler, version 3.0
echo  .     Dater
echo  .
echo  Please press the RETURN key to continue.
echo  .
pause
cls
echo  Before continuing, make sure you have 1 blank, formatted
echo  360KB floppy disk available.
echo  .
echo  Also, the system must be booted with a CONFIG.SYS file
echo  containing these 2 entries:
echo  .
echo        FILES=20
echo        BUFFERS=15
echo  .
echo  Lastly, DOS files must be located in the root directory
echo  (in particular, COMMAND.COM).
echo  .
echo  Use CTRL-C to exit this batch stream if these conditions have not
echo  been met, else press the RETURN key to continue.
echo  .
pause
echo  ********************************************************************
echo  .
echo  Please press the PRINT key to echo print the execution of this batch.
echo  .
echo  Please press the RETURN key to continue.
PAUSE
goto continue
:regbuild
CLS
echo  These commands will build 4 master distribution diskettes for PC SCHEME.
echo  .
echo  .
echo  This batch stream which is on the PC SCHEME Source Diskette #1
echo  assembles, compiles, and links PC SCHEME. The diskettes generated
echo  by this build procedure are:
echo  .
echo  .     2537903-1610 FDO, PC SCHEME INSTALLATION DISKETTE
echo  .     2537903-1611 FDO, PC SCHEME AUTOLOAD DISKETTE
echo  .     2537903-1614 FDO, PC SCHEME 3 1/2" INSTALLATION DISKETTE
echo  .     2537903-1615 FDO, PC SCHEME PROTECTED MODE DISKETTE
echo  .
echo  .
echo  The source for building is contained on the diskettes
echo  labeled PC SCHEME Source Diskette #1 through #4.
echo  .
echo  .
echo  Please press the RETURN key to continue.
echo  .
PAUSE
CLS
echo  A list of hardware and software required for the build is given below.
echo  .
echo  .     TI Business Pro with:
echo  .		- 640K memory 
echo  .		- 1.2 MB floppy disk drive (drive A)
echo  .		- 360 KB floppy disk drive (drive B)
echo  .		- a Winchester disk drive with at least 10 MB free space
echo  .
echo  .     A computer system with both:
echo  .		- one low-density 360 KB floppy disk drive
echo  .		- one 3 1/2" media drive
echo  .
echo  .     MS-DOS Operating System, version 3.21
echo  .     MS-Macro Assembler, version 4.00
echo  .     Lattice C Compiler, version 3.0
echo  .     Dater
echo  .     PC Scheme 3.02
echo  .
echo  Please press the RETURN key to continue.
echo  .
pause
cls
echo  Before continuing, make sure you have 3 blank, formatted
echo  360KB floppy disks available and 1 blank, formatted 
echo  3 1/2" diskette. 
echo  .
echo  Also, the system must be booted with a CONFIG.SYS file
echo  containing these 2 entries:
echo  .
echo        FILES=20
echo        BUFFERS=15
echo  .
echo  Lastly, DOS files must be located in the root directory
echo  (in particular, COMMAND.COM).
echo  .
echo  Use CTRL-C to exit this batch stream if these conditions have not
echo  been met, else press the RETURN key to continue.
echo  .
pause
echo  ********************************************************************
echo  .
echo  Please press the PRINT key to echo print the execution of this batch.
echo  .
echo  Please press the RETURN key to continue.
PAUSE
:continue
echo on
CLS
rem
rem
rem	Begin building PC SCHEME
rem
rem
MD \BUILD
MD \BUILD\EDWIN
MD \BUILD\NEWPCS
MD \BUILD\SCOOPS
MD \BUILD\SOURCES
MD \BUILD\XLI
MD \EXEC
MD \EXEC\MISC
MD \TOOLS
MD \LIB
MD \OBJECT
MD \OBJECTX
MD \OBJECTP
MD \PCS
COPY A:*.BAT \BUILD
PATH = \TOOLS;\PCS;\
CD \BUILD
SCHBUILD %1 %2
