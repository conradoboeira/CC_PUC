theory listas
imports Main
begin

primrec add::"nat \<Rightarrow> nat \<Rightarrow> nat"
where
  add01: "add x 0 = x" |
  add02: "add x (Suc y) = Suc (add x y)"

theorem soma1:"\<forall>x .  (add x y)  = (x + y)"
proof (induction y)
  show "\<forall>x .  (add x 0)  = (x + 0)"
    by simp
  next
  fix x0::nat
  assume HI: "\<forall>x .  (add x x0)  = (x + x0)"
  show "\<forall>x .  (add x (Suc x0))  = (x + (Suc x0))"
    have "\<forall>x .  (add x (Suc x0))  = (x + (Suc x0))"
end