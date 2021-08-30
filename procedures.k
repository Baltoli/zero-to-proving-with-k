module PROCEDURES-SYNTAX
    imports INT-SYNTAX
    imports BOOL-SYNTAX
    imports ID

    syntax Exp ::= IExp | BExp

    syntax KResult ::= Int | Bool | Ints

    syntax Bot
    syntax Bots ::= List{Bot, ","} [klabel(exps)]
    syntax Ints ::= List{Int, ","} [klabel(exps)]
                  | Bots
    syntax Ids  ::= List{Id, ","}  [klabel(exps)]
                  | Bots
    syntax IExps ::= List{Exp, ","} [klabel(exps), seqstrict]
                   | Ids | Ints

    syntax IExp ::= Id | Int
                  | "(" IExp ")" [bracket]
                  | Id "(" IExps ")" [strict(2)]
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

    syntax Return ::= "return" IExp ";" [strict]

    syntax Stmt ::= Id "=" IExp ";" [strict(2)]
                  | Stmt Stmt [left]
                  | "if" "(" BExp ")" Block "else" Block [strict(1)]
                  | "while" "(" BExp ")" Block
                  | Return
                  | Block

    syntax Block  ::= "{" "}"
                    | "{" Stmt "}"

    syntax Def    ::= "def" Id "(" Ids ")" Block
    syntax Defs   ::= List{Def, ""}

    syntax Pgm    ::= Defs Return
endmodule

module PROCEDURES
    imports INT
    imports BOOL
    imports LIST
    imports MAP
    imports PROCEDURES-SYNTAX

    configuration
      <T>
        <k> $PGM:Pgm </k>
        <frame> .Map </frame>
        <procs>
          <proc multiplicity="*" type="Map">
            <id> . </id>
            <params> . </params>
            <body> . </body>
          </proc>
        </procs>
        <stack> ListItem(stackFrame(.K, .Map)) </stack>
      </T>

    syntax KItem ::= stackFrame(K, Map)
                   | #makeBindings(Ids, Ints)

    rule <k> I1 + I2 => I1 +Int I2 ...</k>
    rule <k> I1 - I2 => I1 -Int I2 ...</k>
    rule <k> I1 * I2 => I1 *Int I2 ...</k>
    rule <k> I1 / I2 => I1 /Int I2 ...</k>
    rule <k> I1 ^ I2 => I1 ^Int I2 ...</k>

    rule  <k> I:Id => M[I] ...</k>
          <frame> M </frame>

    rule <k> I1 <= I2 => I1  <=Int I2 ...</k>
    rule <k> I1  < I2 => I1   <Int I2 ...</k>
    rule <k> I1 >= I2 => I1  >=Int I2 ...</k>
    rule <k> I1  > I2 => I1   >Int I2 ...</k>
    rule <k> I1 == I2 => I1  ==Int I2 ...</k>
    rule <k> I1 != I2 => I1 =/=Int I2 ...</k>

    rule <k> B1 && B2 => B1 andBool B2 ...</k>
    rule <k> B1 || B2 => B1  orBool B2 ...</k>

    rule  <k> ID = I:Int ; => . ...</k>
          <frame> MEM => MEM [ ID <- I:Int ] </frame>

    rule  <k> S1:Stmt S2:Stmt => S1 ~> S2 ...</k>

    rule  <k> {   } => . ...</k>
    rule  <k> { S } => S ...</k>

    rule  <k> if ( true  ) TB else _  => TB ...</k>
    rule  <k> if ( false ) _  else FB => FB ...</k>

    rule  <k> while (C) B => if (C) { B while (C) B } else { } ...</k>

    rule  <k> DS:Defs R:Return => DS ~> R ...</k>
    rule  <k> D1:Def DS:Defs => D1 ~> DS ...</k>
    rule  <k> .Defs => . ...</k>

    rule  <k> def I:Id ( Ps:Ids ) B => . ...</k>
          <procs>
            ...
            (.Bag =>
              <proc>
                <id> I </id>
                <params> Ps </params>
                <body> B </body>
              </proc>)
            ...
          </procs>

    rule  <k> I:Id ( Args:Ints ) ~> K => #makeBindings(Ps, Args) ~> B </k>
          <stack> .List => ListItem(stackFrame(K, F)) ...</stack>
          <procs>
            ...
            <proc>
              <id> I </id>
              <params> Ps </params>
              <body> B </body>
            </proc>
            ...
          </procs>
          <frame> F => .Map </frame>

    rule <k> #makeBindings(.Ids, .Ints) => . ... </k>
    rule <k> #makeBindings((I:Id, IDS => IDS), (IN:Int, INTS => INTS)) ... </k>
         <frame> MEM => MEM [ I <- IN ] </frame>

    rule  <k> return I ; => I ~> K ...</k>
          <stack> ListItem(stackFrame(K, F)) => .List ...</stack>
          <frame> _ => F </frame>
endmodule
