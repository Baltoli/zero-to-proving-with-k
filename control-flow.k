module CONTROL-FLOW-SYNTAX
    imports INT-SYNTAX
    imports BOOL-SYNTAX
    imports ID

    syntax Exp ::= IExp | BExp

    syntax KResult ::= Int | Bool

    syntax IExp ::= Id | Int

    syntax IExp ::= "(" IExp ")" [bracket]
                  | IExp "+" IExp [strict]
                  | IExp "-" IExp [strict]
                  > IExp "*" IExp [strict]
                  | IExp "/" IExp [strict]
                  > IExp "^" IExp [strict]

    syntax BExp ::= Bool

    syntax BExp ::= "(" BExp ")" [bracket]
                  | IExp "<=" IExp [strict]
                  | IExp "<"  IExp [strict]
                  | IExp ">=" IExp [strict]
                  | IExp ">"  IExp [strict]
                  | IExp "==" IExp [strict]
                  | IExp "!=" IExp [strict]

    syntax BExp ::= BExp "&&" BExp [strict]
                  | BExp "||" BExp [strict]

    syntax Stmt ::= Id "=" IExp ";" [strict(2)]
                  | Stmt Stmt [left]
                  | "if" "(" BExp ")" Block "else" Block [strict(1)]
                  | "while" "(" BExp ")" Block
                  | Block

    syntax Block  ::= "{" "}"
                    | "{" Stmt "}"
                    
endmodule

module CONTROL-FLOW
    imports INT
    imports BOOL
    imports MAP
    imports CONTROL-FLOW-SYNTAX

    configuration
      <k> $PGM:Stmt </k>
      <mem> .Map </mem>

    rule <k> I1 + I2 => I1 +Int I2 ...</k>
    rule <k> I1 - I2 => I1 -Int I2 ...</k>
    rule <k> I1 * I2 => I1 *Int I2 ...</k>
    rule <k> I1 / I2 => I1 /Int I2 ...</k>
    rule <k> I1 ^ I2 => I1 ^Int I2 ...</k>

    rule  <k> I:Id => {M[I]}:>Int ...</k>
          <mem> M </mem>

    rule <k> I1 <= I2 => I1  <=Int I2 ...</k>
    rule <k> I1  < I2 => I1   <Int I2 ...</k>
    rule <k> I1 >= I2 => I1  >=Int I2 ...</k>
    rule <k> I1  > I2 => I1   >Int I2 ...</k>
    rule <k> I1 == I2 => I1  ==Int I2 ...</k>
    rule <k> I1 != I2 => I1 =/=Int I2 ...</k>

    rule <k> B1 && B2 => B1 andBool B2 ...</k>
    rule <k> B1 || B2 => B1  orBool B2 ...</k>

    rule  <k> ID = IEXP ; => . ...</k>
          <mem> MEM => MEM [ ID <- IEXP ] </mem>

    rule  <k> S1:Stmt S2:Stmt => S1 ~> S2 ...</k>

    rule  <k> {   } => . ...</k>
    rule  <k> { S } => S ...</k>

    rule  <k> if ( true  ) TB else _  => TB ...</k>
    rule  <k> if ( false ) _  else FB => FB ...</k>

    rule  <k> while (C) B => if (C) { B while (C) B } else { } ...</k>
endmodule
