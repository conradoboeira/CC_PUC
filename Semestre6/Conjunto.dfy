// {:autocontract}
class {:autocontracts} ConjuntoNat
{
    var conj: array<nat>;
    var tail: nat;

    ghost var Conteudo: seq<nat>;

    predicate Valid()
    {
        conj.Length > 0
        && 0 <= tail <= conj.Length
        && conj[0..tail] == Conteudo
        // && forall i,j :: 0<=i < tail  && 0<=j < tail && i != j ==> conj[i] != conj[j]
        && tail == |Conteudo|
        && forall i,j :: 0<=i < tail  && 0<=j < tail && i != j ==> Conteudo[i] != Conteudo[j]
    }

    constructor ()
    ensures Conteudo == []
    {
        // TODO: add nao tem repeticao
        conj := new nat[5];
        Conteudo := [];
        tail := 0;
    }

    method Tamanho() returns (n:nat)
    ensures n == |Conteudo|
    ensures Conteudo == old(Conteudo)
    ensures conj == old(conj)
    ensures tail == old(tail)
    {
        return tail;
    }

    // trocar nome para pertence ou contem
    method Existe(e:nat) returns (b:bool)
    ensures b == (e in Conteudo)
    ensures Conteudo == old(Conteudo)
    ensures conj == old(conj)
    ensures tail == old(tail)
    {
        b := false;
        var i:=0;
        while (i < tail)
        invariant 0<=i<=tail
        invariant (i==0) ==> !b
        invariant (i > 0) ==> b == (e in Conteudo[0..i])
        invariant Conteudo == old(Conteudo)
        invariant conj == old(conj)
        invariant tail == old(tail)
        {
          if(conj[i] == e) {
               b := true;
           }
           i := i+1;
        }
        return b;
    }

    method Adiciona(e:nat) returns (b:bool)
    ensures e in old(Conteudo) ==> (Conteudo == old(Conteudo)) && b == false
    ensures !(e in old(Conteudo)) ==> (Conteudo == old(Conteudo) + [e] 
              && b == true && tail == old(tail) + 1)
    
    {
        // O array contem o elemento e
        // var test:= Existe(e);
        // if (test){
        //     b:= false;
        // }
        b := Existe(e);
        // O array nao contem o elemento e
        if(!b){
            if (tail == conj.Length)
            {
                var aux := new nat[2 * conj.Length];
                forall(i | 0 <= i < conj.Length)
                {
                    aux[i] := conj[i];
                }
                conj := aux;
            }

            conj[tail] := e;
            tail := tail +1;
            Conteudo := Conteudo + [e];
            b:= true;
        } else {
            b := false;
        }
    }

    // method Uniao(c:ConjuntoNat) returns (r:ConjuntoNat)
    // ensures forall i:: (i in Conteudo || i in c.Conteudo) <==> i in r.Conteudo
    // ensures forall i,j :: 0<=i < |r.Conteudo|  && 0<=j < |r.Conteudo| && i != j ==> r.Conteudo[i] != r.Conteudo[j]
    // ensures |r.Conteudo| <= | Conteudo + c.Conteudo|
    // {
    //     // r := c;
    //     // var i := 0;
    //     // while(i < tail){
    //     //     var b:= r.Adiciona(conj[i]);
    //     //     i := i+1;
    //     // }
    //     r := new ConjuntoNat();
    //     r.conj := new nat[tail + c.tail];
    //     r.tail := tail;
    //     var i := 0;
    //     while(i<tail)
    //     invariant 0<= i <= |Conteudo|
    //     invariant i == |Conteudo| ==> r.Conteudo == Conteudo
    //     invariant r.Conteudo == Conteudo[..i]
    //     {
    //         r.conj[i] := conj[i];
    //         r.Conteudo := r.Conteudo + [conj[i]];
    //         i := i +1;
    //     }
    //     var j := 0;
    //     while(j < c.tail)
    //     invariant 0 <= j <= c.tail
    //     invariant j <= |c.Conteudo|
    //     // invariant Conteudo == old(r.Conteudo)
    //     invariant forall e :: e in Conteudo ==> e in r.Conteudo
    //     invariant forall e :: e in c.Conteudo[..j] ==> e in r.Conteudo
    //     invariant forall e :: e in r.Conteudo ==> (e in Conteudo || e in c.Conteudo)
    //     invariant |r.Conteudo| <= | Conteudo + c.Conteudo[..j]|

    //     {
    //         var to_add := c.conj[tail+j];
    //         var dentro := Existe(to_add);
    //         if(!dentro){
    //             r.conj[tail+j]:= to_add;
    //             r.Conteudo := r.Conteudo + [to_add];
    //         }
    //         j:= j+1;
    //         r.tail := r.tail + 1;
    //     }
    // }

    // method intersecao(c : ConjuntoNat) returns (r: ConjuntoNat)
    // ensures forall e :: e in r.Conteudo ==> (e in Conteudo && e in c.Conteudo)
    // ensures forall i,j :: 0<=i < |r.Conteudo|  && 0<=j < |r.Conteudo| && i != j ==> r.Conteudo[i] != r.Conteudo[j]
    // ensures r.tail <= r.conj.Length
    // ensures forall i,j :: 0<=i < r.tail  && 0<=j < r.tail && i != j ==> r.conj[i] != r.conj[j]
    // ensures tail == old(tail)
    // ensures c.tail == old(c.tail)
    // ensures Conteudo == old(Conteudo)
    // ensures conj == old(conj)
    // ensures c.Conteudo == old(c.Conteudo)
    // ensures c.conj == old(c.conj)
    // {
        
    //     r := new ConjuntoNat();

    //     var i := 0;
    //     while (i < tail)
    //     invariant 0 <= i <= |Conteudo|
    //     invariant forall e :: e in Conteudo[..i] && e in c.Conteudo ==> e in r.Conteudo 
    //     invariant forall e :: e in r.Conteudo ==> (e in Conteudo && e in c.Conteudo)
    //     invariant forall i,j :: 0<=i < |r.Conteudo|  && 0<=j < |r.Conteudo| && i != j ==> r.Conteudo[i] != r.Conteudo[j]
    //     invariant r.tail == |r.Conteudo|
    //     invariant r.tail <= r.conj.Length
    //     invariant forall i,j :: 0<=i < r.tail  && 0<=j < r.tail && i != j ==> r.conj[i] != r.conj[j]
    //     invariant c.tail == old(c.tail)
    //     invariant tail == old(tail)
    //     invariant conj.Length == old(conj.Length)
    //     invariant c.conj.Length == old(c.conj.Length)
    //     invariant conj == old(conj)
    //     invariant c.conj == old(c.conj)
    //     invariant Conteudo == old(Conteudo)
    //     invariant c.Conteudo == old(c.Conteudo)
    //     {
    //         var val := conj[i];
    //         var x := c.Existe(val);
    //         if (x) {
    //             if (r.tail == r.conj.Length)
    //             {
    //                 var aux := new nat[2 * r.conj.Length];
    //                 forall(i | 0 <= i < r.conj.Length)
    //                 {
    //                     aux[i] := r.conj[i];
    //                 }
    //                 r.conj := aux;
    //             }
    //             r.Conteudo := r.Conteudo + [conj[i]];
    //             r.conj[r.tail] := conj[i];
    //             r.tail := r.tail + 1;
    //         }
    //         i := i + 1;
    //     }
    //     // conj.Length != 0
    //     // && 0 <= tail <= conj.Length
    //     // && conj[0..tail] == Conteudo
    //     // && forall i,j :: 0<=i < tail  && 0<=j < tail && i != j ==> conj[i] != conj[j]
    //     // && tail == |Conteudo|
    //     // && forall i,j :: 0<=i < tail  && 0<=j < tail && i != j ==> Conteudo[i] != Conteudo[j]
    // }

    method diff(c : ConjuntoNat) returns (r: ConjuntoNat)
    
    ensures forall e:: (e in Conteudo && e !in c.Conteudo) <==> e in r.Conteudo

    ensures forall i,j :: 0<=i < |r.Conteudo|  && 0<=j < |r.Conteudo| && i != j ==> r.Conteudo[i] != r.Conteudo[j]
    ensures r.tail <= r.conj.Length
    ensures forall i,j :: 0<=i < r.tail  && 0<=j < r.tail && i != j ==> r.conj[i] != r.conj[j]
    ensures tail == old(tail)
    ensures c.tail == old(c.tail)
    ensures Conteudo == old(Conteudo)
    ensures conj == old(conj)
    ensures c.Conteudo == old(c.Conteudo)
    ensures c.conj == old(c.conj)
    {
        
        r := new ConjuntoNat();

        var i := 0;
        while (i < tail)
        invariant 0 <= i <= |Conteudo|
        invariant forall e :: e in Conteudo[..i] && e !in c.Conteudo ==> e in r.Conteudo 
        invariant forall e :: e in r.Conteudo ==> (e in Conteudo && e !in c.Conteudo)
        invariant forall i,j :: 0<=i < |r.Conteudo|  && 0<=j < |r.Conteudo| && i != j ==> r.Conteudo[i] != r.Conteudo[j]
        invariant r.tail == |r.Conteudo|
        invariant r.tail <= r.conj.Length
        invariant forall i,j :: 0<=i < r.tail  && 0<=j < r.tail && i != j ==> r.conj[i] != r.conj[j]
        invariant c.tail == old(c.tail)
        invariant tail == old(tail)
        invariant conj.Length == old(conj.Length)
        invariant c.conj.Length == old(c.conj.Length)
        invariant conj == old(conj)
        invariant c.conj == old(c.conj)
        invariant Conteudo == old(Conteudo)
        invariant c.Conteudo == old(c.Conteudo)
        {
            var val := conj[i];
            var x := c.Existe(val);
            if (!x) {
                if (r.tail == r.conj.Length)
                {
                    var aux := new nat[2 * r.conj.Length];
                    forall(i | 0 <= i < r.conj.Length)
                    {
                        aux[i] := r.conj[i];
                    }
                    r.conj := aux;
                }
                r.Conteudo := r.Conteudo + [conj[i]];
                r.conj[r.tail] := conj[i];
                r.tail := r.tail + 1;
            }
            i := i + 1;
        }
    }
}

method main(){
    var c1 := new ConjuntoNat();
    var c2 := new ConjuntoNat();

    var b := c1.Adiciona(1);
    var b2 := c1.Adiciona(1);
    var b3 := c1.Adiciona(2);
    var b4 := c1.Adiciona(3);
    assert b;
    assert !b2;
    assert b3;
    assert b4;

    var b5 := c2.Adiciona(2);
    var b6 := c2.Adiciona(3);
    var b7 := c2.Adiciona(4);
    var size := c2.Tamanho();
    assert b5;
    assert b6;
    assert b7;

    assert size == 3;

    var contain1 := c1.Existe(2);
    var contain2 := c2.Existe(5);

    assert contain1;
    assert !contain2;

    var intersec := c1.intersecao(c2).Tamanho();
    assert intersec == 2;

    var uni := c1.Uniao(c2).Tamanho();
    assert uni == 4;

    var dif := c1.diff(c2).Tamanho();
    assert dif == 1;
    
}