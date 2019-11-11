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
  proof
    fix x1::nat
    have "add x1 (Suc x0)  = Suc (add x1 x0)" by (simp only:add02)
    also have "... = Suc (x1 + x0)" by (simp only:HI)
    also have "... = (x1+ (Suc x0))" by (simp)
    finally show "(add x1 (Suc x0))  = (x1 + (Suc x0))" by simp
  qed
qed

theorem soma2: "\<forall>x .  (add x 0) = x"
  by simp

theorem soma3:"(add 0 x) = x"
proof(induction x)
  show "( add 0 0) = 0"
    by (simp only:add01)
next
  fix x0:: nat
  assume HI: "(add 0 x0) = x0"
  show "(add 0 (Suc x0)) = (Suc x0)"
  proof -
    have "(add 0 (Suc x0)) = ( Suc (add 0 x0))" by (simp only:add02)
    also have "... = (Suc x0)" by (simp only:HI)
    finally show "(add 0 (Suc x0)) = (Suc x0)" by simp
  qed
qed

theorem soma4:"\<forall>x .  (add x y)  = (add y x)"
proof (induction y)
  show "\<forall>x .  (add x 0)  = (add 0 x)"
  proof
    fix x0::nat
    show "(add x0 0) = (add 0 x0)"
    proof -
      have " (add x0 0) = x0" by (simp only:soma2)
      also have "... = (add 0 x0)" by (simp only:soma3)
      finally show "(add x0 0) = (add 0 x0)" by simp
    qed
  qed
next
  fix x0:: nat
  assume HI: "\<forall>x . (add x x0 ) = (add x0 x)"
  show "\<forall>x .(add x (Suc x0)) = (add (Suc x0) x)"
  proof 
    fix x1:: nat
    have "(add x1 (Suc x0)) = (add (Suc x0) x1)" by (simp only:HI)


end