module CALC-SYNTAX
  imports INT-SYNTAX

  syntax Int    ::= Int "+" Int [function]
                  | Int "*" Int [function]
                  | Int "/" Int [function]
                  | Int "-" Int [function]
                  | Int "^" Int [function]

  syntax Int    ::= "(" Int ")" [bracket]
endmodule

module CALC
  imports CALC-SYNTAX
  imports INT

  rule I1 + I2 => I1 +Int I2
  rule I1 * I2 => I1 *Int I2
  rule I1 / I2 => I1 /Int I2
  rule I1 - I2 => I1 -Int I2
  rule I1 ^ I2 => I1 ^Int I2
endmodule
