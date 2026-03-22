// RUN: %clang_cc1 -fsyntax-only -verify %s

typedef char __attribute__((__vector_size__(64))) V;

void implicit_cast_complex_to_vector() {
  _Complex double x;
  V y;
  // expected-error@+1 {{implicit conversion from '_Complex double' to incompatible type 'V' (vector of 64 'char' values)}}
  V z = x + y;
}

