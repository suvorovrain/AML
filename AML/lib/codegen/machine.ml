
type reg = 
| X0
| A of int
| RA
| SP
| T of int
| S of int
| ROff of int * reg
[@@deriving eq]

let rec pp_reg ppf =
  let open Format in
  function 
  | X0 -> fprintf ppf "x0"
  | A n -> fprintf ppf "a%d" n
  | T n -> fprintf ppf "t%d" n
  | S n -> fprintf ppf "s%d" n
  | RA -> fprintf ppf "ra"
  | SP -> fprintf ppf "sp"
  | ROff (n,r) -> fprintf ppf "%d(%a)" n pp_reg r

type instr = 
| Addi of reg * reg * int
| Add of reg * reg * reg
| Sub of reg * reg * reg
| Mul of reg * reg * reg
| Beq of reg * reg * string
| Blt of reg * reg * string
| Bne of reg * reg * string
| Jal of reg * string
| Jalr of reg * reg * string
| J of string
| Ret
| Sd of reg * reg
| Ld of reg * reg 
| Li of reg * int
| Ecall
| Label of string
;;

let pp_instr ppf =
  let open Format in 
  function
  | Addi (r1,r2,n) -> fprintf ppf "addi %a, %a, %d" pp_reg r1 pp_reg r2 n
  | Add (r1,r2,r3) -> fprintf ppf "add %a, %a, %a" pp_reg r1 pp_reg r2 pp_reg r3
  | Sub (r1,r2,r3) -> fprintf ppf "sub %a, %a, %a" pp_reg r1 pp_reg r2 pp_reg r3
  | Mul (r1,r2,r3) -> fprintf ppf "mul %a, %a, %a" pp_reg r1 pp_reg r2 pp_reg r3
  | Beq (r1,r2,s) -> fprintf ppf "beq %a, %a, %s" pp_reg r1 pp_reg r2 s
  | Blt (r1,r2,s) -> fprintf ppf "blt %a, %a, %s" pp_reg r1 pp_reg r2 s
  | Bne (r1,r2,s) -> fprintf ppf "bne %a, %a, %s" pp_reg r1 pp_reg r2 s
  | Jal (r1,s) -> fprintf ppf "jal %a, %s" pp_reg r1 s
  | Jalr (r1,r2,s) -> fprintf ppf "jalr %a, %a, %s" pp_reg r1 pp_reg r2 s
  | J s -> fprintf ppf "j %s" s
  | Ret -> fprintf ppf "ret"
  | Sd (r1,r2) -> fprintf ppf "sd %a, %a" pp_reg r1 pp_reg r2
  | Ld (r1,r2) -> fprintf ppf "ld %a, %a" pp_reg r1 pp_reg r2
  | Li (r1,n) -> fprintf ppf "li %a, %d" pp_reg r1 n
  | Ecall -> fprintf ppf "ecall"
  | Label s -> fprintf ppf "%s:" s
;;

let addi k r1 r2 n = k @@ Addi (r1, r2, n)
let add k r1 r2 r3 = k @@ Add (r1, r2, r3)
let sub k r1 r2 r3 = k @@ Sub (r1, r2, r3)
let mul k r1 r2 r3 = k @@ Mul (r1, r2, r3)
let beq k r1 r2 s = k @@ Beq (r1, r2, s)
let blt k r1 r2 s = k @@ Blt (r1, r2, s)
let ble k r1 r2 s = k @@ Bne (r1, r2, s)
let ecall k = k Ecall
let ret k = k Ret
let jal k r1 s = k @@ Jal (r1, s) 
let jalr k r1 r2 s = k @@ Jalr (r1,r2,s)
let j k s = k (J s)
let ld k a b = k (Ld (a, b))
let sd k a b = k (Sd (a, b))
let li k r n = k (Li (r, n))
let label k s = k (Label s)

(*
  .globl main
    .text

main:
    li   a0, 4
    jal  ra, fac

    li   a7, 1
    ecall

    li   a7, 10
    ecall

fac:
    addi sp, sp, -16
    sd   ra, 8(sp)
    sd   a0, 0(sp)

    li   t0, 1
    ble  a0, t0, .Lbase

    addi a0, a0, -1
    jal  ra, fac

    ld   t1, 0(sp)
    mul  a0, a0, t1
    j    .Lend

.Lbase:
    li   a0, 1

.Lend:
    ld   ra, 8(sp)
    addi sp, sp, 16
    ret

*)