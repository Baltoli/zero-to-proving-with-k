module CALC-BOOL-SYNTAX
  imports INT-SYNTAX
  imports BOOL-SYNTAX

  syntax Val    ::= Int | Bool

  syntax Int    ::= Int "+" Int [function]
                  | Int "*" Int [function]
                  | Int "/" Int [function]
                  | Int "-" Int [function]
                  | Int "^" Int [function]

  syntax Int    ::= "(" Int ")" [bracket]

  syntax Bool   ::= Int "<" Int [function]
                  | Int "<=" Int [function]
                  | Int ">" Int [function]
                  | Int ">=" Int [function]
                  | Int "==" Int [function]
                  | Int "!=" Int [function]

  syntax Bool   ::= Bool "&&" Bool [function]
                  | Bool "||" Bool [function]

  syntax Bool   ::= "(" Bool ")" [bracket]
endmodule

module CALC-BOOL
  imports CALC-BOOL-SYNTAX
  imports INT
  imports BOOL

  rule I1 + I2 => I1 +Int I2
  rule I1 * I2 => I1 *Int I2
  rule I1 / I2 => I1 /Int I2
  rule I1 - I2 => I1 -Int I2
  rule I1 ^ I2 => I1 ^Int I2

  rule I1 < I2 => I1 <Int I2
  rule I1 <= I2 => I1 <=Int I2
  rule I1 > I2 => I1 >=Int I2
  rule I1 >= I2 => I1 >=Int I2
  rule I1 == I2 => I1 ==Int I2
  rule I1 != I2 => I1 =/=Int I2

  rule B1 && B2 => B1 andBool B2
  rule B1 || B2 => B1 orBool B2
endmodule
