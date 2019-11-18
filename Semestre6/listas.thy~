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
    have " (add x0 0) = x0" by (simp only:soma2)
    also have "... = (add 0 x0)" by (simp only:soma3)
    finally show "(add x0 0) = (add 0 x0)" by simp
  qed
next
  fix x0:: nat
  assume HI: "\<forall>x . (add x x0 ) = (add x0 x)"
  show "\<forall>x .(add x (Suc x0)) = (add (Suc x0) x)"
  proof 
    fix x1:: nat
    have "(add x1 (Suc x0)) = (Suc (add x1 x0))" by (simp only:add02)
    also have "... = (Suc (add x0 x1))" by (simp only:HI)
    also have "... = (add x0 (Suc x1))" by (simp only:add02)
    also have "... = (x0 + (Suc x1))" by (simp only:soma1)
    also have "... = ((Suc x0) + x1)" by simp
    also have "... = (add (Suc x0) x1)" by (simp only:soma1)
    finally show "(add x1 (Suc x0)) = (add (Suc x0) x1)" by simp
  qed
qed

theorem soma5:"\<forall>x y. add x (add y z) = add (add x y) z"
proof (induction z)
  show "\<forall>x y. add x (add y 0) = add (add x y) 0"
  proof(rule allI, rule allI)
    fix x0::nat and y0::nat
    have "add x0 (add y0 0) = add x0 y0" by (simp only:add01)
    also have "... = add (add x0 y0) 0" by (simp only:add01)
    finally show "(add x0 (add y0 0)) = (add (add x0 y0) 0)" by simp
  qed
next
fix z0::nat
assume HI:"\<forall>x y. add x (add y z0) = add (add x y) z0"
show "\<forall>x y. add x (add y (Suc z0)) = add (add x y) (Suc z0)"
proof(rule allI, rule allI)
  fix x0::nat and y0::nat
  have "add x0 (add y0 (Suc z0)) = add x0 (Suc (add y0 z0))" by (simp only:add02)
  also have "... = Suc (add x0 (add y0 z0))" by (simp only:add02)
  also have "... = Suc (add (add x0 y0) z0)" by (simp only:HI)
  also have "... = add (add x0 y0) (Suc z0)" by (simp only:add02)
  finally show "add x0 (add y0 (Suc z0)) = add (add x0 y0) (Suc z0)" by simp
qed
qed

primrec mult::"nat \<Rightarrow> nat \<Rightarrow> nat"
where
  mult01: "mult x 0 = 0" |
  mult02: "mult x (Suc y) = add x (mult x y)"

theorem mult1:"\<forall>x .  (mult x y)  = (x * y)"
proof (induction y)
 show "\<forall>x .  (mult x 0)  = (x * 0)"
 proof
  fix x0::nat
  have "(mult x0 0) = 0" by (simp only:mult01)
  also have "... = (x*0)" by simp
  finally show "(mult x0 0) = (x0*0)" by simp
qed
next
  fix y0::nat
  assume HI: "\<forall>x .  (mult x y0)  = (x * y0)"
  show  "\<forall>x .  (mult x (Suc y0))  = (x * Suc(y0))"
  proof
    fix x0 :: nat
    have "mult x (Suc y0) = add x (mult x y0)" by (simp only:mult02)
    also have "... = add x (x * y0)" by (simp only:HI)

end