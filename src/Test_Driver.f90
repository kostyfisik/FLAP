!< A testing program for FLAP, Fortran command Line Arguments Parser for poor men
program Test_Driver
!< A testing program for FLAP, Fortran command Line Arguments Parser for poor men
!<
!<### Compile
!< See [compile instructions](https://github.com/szaghi/FLAP/wiki/Download-compile).
!<
!<###Usage Compile
!< See [usage instructions](https://github.com/szaghi/FLAP/wiki/Testing-Program).
!-----------------------------------------------------------------------------------------------------------------------------------
USE IR_Precision                                                        ! Integers and reals precision definition.
USE Data_Type_Command_Line_Interface, only: Type_Command_Line_Interface ! Definition of Type_Command_Line_Interface.
USE Lib_IO_Misc                                                         ! Procedures for IO and strings operations.
!-----------------------------------------------------------------------------------------------------------------------------------

!-----------------------------------------------------------------------------------------------------------------------------------
implicit none
type(Type_Command_Line_Interface):: cli        !< Command Line Interface (CLI).
character(99)::                     sval       !< String value.
real(R8P)::                         rval       !< Real value.
real(R8P)::                         prval      !< Positional real value.
integer(I4P)::                      ival       !< Integer value.
logical::                           bval       !< Boolean value.
logical::                           vbval      !< Valued-boolean value.
integer(I8P)::                      ilist(1:3) !< Integer list values.
integer(I4P)::                      error      !< Error trapping flag.
integer(I4P)::                      l          !< Counter.
!-----------------------------------------------------------------------------------------------------------------------------------

!-----------------------------------------------------------------------------------------------------------------------------------
! initializing CLI
call cli%init(progname    = 'Test_Driver',                                           &
              version     = 'v0.0.5',                                                &
              description = 'Toy program for testing FLAP',                          &
              examples    = ["Test_Driver -s 'Hello FLAP'                          ",&
                             "Test_Driver -s 'Hello FLAP' -i -2 # printing error...",&
                             "Test_Driver -s 'Hello FLAP' -i 3 -r 33.d0            ",&
                             "Test_Driver -s 'Hello FLAP' --integer_list 10 -3 87  ",&
                             "Test_Driver 33.0 -s 'Hello FLAP' -i 5                ",&
                             "Test_Driver --string 'Hello FLAP' --boolean          "])
! setting CLAs
call cli%add(switch='--string',switch_ab='-s',help='String input',required=.true.,act='store',error=error)
call cli%add(switch='--integer',switch_ab='-i',help='Integer input with fixed range',required=.false.,act='store',&
             def='1',choices='1,3,5',error=error)
call cli%add(switch='--real',switch_ab='-r',help='Real input',required=.false.,act='store',def='1.0',error=error)
call cli%add(switch='--boolean',switch_ab='-b',help='Boolean input',required=.false.,act='store_true',def='.false.',&
             error=error)
call cli%add(switch='--boolean_val',switch_ab='-bv',help='Valued boolean input',required=.false., act='store',&
             def='.true.',error=error)
call cli%add(switch='--integer_list',switch_ab='-il',help='Integer list input',required=.false.,act='store',&
             nargs='3',def='1 8 32',error=error)
call cli%add(positional=.true.,position=1,help='Positional real input',required=.false.,def='1.0',error=error)
! parsing CLI
call cli%parse(error=error)
if (error/=0) stop
! using CLI data to set Test_Driver behaviour
call cli%get(switch='-s',    val=sval,  error=error) ; if (error/=0) stop
call cli%get(switch='-r',    val=rval,  error=error) ; if (error/=0) stop
call cli%get(switch='-i',    val=ival,  error=error) ; if (error/=0) stop
call cli%get(switch='-b',    val=bval,  error=error) ; if (error/=0) stop
call cli%get(switch='-bv',   val=vbval, error=error) ; if (error/=0) stop
call cli%get(switch='-il',   val=ilist, error=error) ; if (error/=0) stop
call cli%get(position=1_I4P, val=prval, error=error) ; if (error/=0) stop
write(stdout,'(A)'   )'Test_Driver has been called with the following arguments values:'
write(stdout,'(A)'   )'String          input = '//trim(adjustl(sval))
write(stdout,'(A)'   )'Real            input = '//str(n=rval)
write(stdout,'(A)'   )'Integer         input = '//str(n=ival)
write(stdout,'(A,L1)')'Boolean         input = ',bval
write(stdout,'(A,L1)')'Valued boolean  input = ',vbval
write(stdout,'(A)'   )'Positional real input = '//str(n=prval)
write(stdout,'(A)'   )'Integer list inputs:'
do l=1,3
  write(stdout,'(A)' )'Input('//trim(str(.true.,l))//') = '//trim(str(n=ilist(l)))
enddo
stop
!-----------------------------------------------------------------------------------------------------------------------------------
endprogram Test_Driver
