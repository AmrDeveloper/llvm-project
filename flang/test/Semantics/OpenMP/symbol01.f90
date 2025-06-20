! RUN: %python %S/../test_symbols.py %s %flang_fc1 -fopenmp

! Test clauses that accept list.
! 2.1 Directive Format
!   A list consists of a comma-separated collection of one or more list items.
!   A list item is a variable, array section or common block name (enclosed in
!   slashes).

!DEF: /md Module
module md
 !DEF: /md/myty PUBLIC DerivedType
 type :: myty
  !DEF: /md/myty/a ObjectEntity REAL(4)
  real :: a
  !DEF: /md/myty/b ObjectEntity INTEGER(4)
  integer :: b
 end type myty
end module md
!DEF: /mm MainProgram
program mm
 !REF: /md
 use :: md
 !DEF: /mm/c CommonBlockDetails
 !DEF: /mm/x (InCommonBlock) ObjectEntity REAL(4)
 !DEF: /mm/y (InCommonBlock) ObjectEntity REAL(4)
 common /c/x, y
 !REF: /mm/x
 !REF: /mm/y
 real x, y
 !DEF: /mm/myty Use
 !DEF: /mm/t ObjectEntity TYPE(myty)
 type(myty) :: t
 !DEF: /mm/b ObjectEntity INTEGER(4)
 integer b(10)
 !REF: /mm/t
 !REF: /md/myty/a
 t%a = 3.14
 !REF: /mm/t
 !REF: /md/myty/b
 t%b = 1
 !REF: /mm/b
 b = 2
 !DEF: /mm/a (Implicit) ObjectEntity REAL(4)
 a = 1.0
 !DEF: /mm/c (Implicit) ObjectEntity REAL(4)
 c = 2.0
!$omp parallel do  private(a,t,/c/) shared(c)
 !DEF: /mm/OtherConstruct1/i (OmpPrivate, OmpPreDetermined) HostAssoc INTEGER(4)
 do i=1,10
  !DEF: /mm/OtherConstruct1/a (OmpPrivate, OmpExplicit) HostAssoc REAL(4)
  !DEF: /mm/OtherConstruct1/b (OmpShared) HostAssoc INTEGER(4)
  !REF: /mm/OtherConstruct1/i
  a = a+b(i)
  !DEF: /mm/OtherConstruct1/t (OmpPrivate, OmpExplicit) HostAssoc TYPE(myty)
  !REF: /md/myty/a
  !REF: /mm/OtherConstruct1/i
  t%a = i
  !DEF: /mm/OtherConstruct1/y (OmpPrivate, OmpExplicit) HostAssoc REAL(4)
  y = 0.
  !DEF: /mm/OtherConstruct1/x (OmpPrivate, OmpExplicit) HostAssoc REAL(4)
  !REF: /mm/OtherConstruct1/a
  !REF: /mm/OtherConstruct1/i
  !REF: /mm/OtherConstruct1/y
  x = a+i+y
  !DEF: /mm/OtherConstruct1/c (OmpShared, OmpExplicit) HostAssoc REAL(4)
  c = 3.0
 end do
end program
