// {:autocontract}
class {:autocontracts} ConjuntoNat
{
    var conj: array<nat>;
    var tail: nat;

    ghost var Conteudo: seq<nat>;

    predicate Valid()
    {
        conj.Length != 0
        && 0 <= tail <= conj.Length
        && conj[0..tail] == Conteudo
        && forall i,j :: 0<=i < tail  && 0<=j < tail && i != j ==> conj[i] != conj[j]
        && tail == |Conteudo|
        // && forall i,j :: 0<=i < tail  && 0<=j < tail && i != j ==> conj[i] != Conteudo[j]
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
    {
        return tail;
    }

    // trocar nome para pertence ou contem
    method Existe(e:nat) returns (b:bool)
    ensures b == (e in Conteudo)
    {
        b := false;
        var i:=0;
        while i < tail
        invariant 0<=i<=|Conteudo|
        invariant (i==0) ==> !b
        invariant (i > 0) ==> b == (e in Conteudo[0..i])
        {
          if(conj[i] == e) {
               b := true;
           }
           i := i+1;
        }
        return b;
    }

    method Adiciona(e:nat) returns (b:bool)
    ensures e in Conteudo ==> (Conteudo == old(Conteudo)) && (!b)
    ensures !(e in Conteudo) ==> (Conteudo == old(Conteudo) + [e] 
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
        }
    }

    method Uniao(c:ConjuntoNat) returns (r:ConjuntoNat)
    ensures forall i:: 0<=i< |c.Conteudo|-1 ==>  c.Conteudo[i] in r.Conteudo
    ensures forall i:: 0<=i< |Conteudo|-1 ==>  Conteudo[i] in r.Conteudo
    ensures forall i,j :: 0<=i < r.tail  && 0<=j < r.tail && i != j ==> r.conj[i] != r.conj[j]
    {
        r := c;
        forall(i | 0 <= i < conj.Length){
            var b:= r.Adiciona(conj[i]);
        }
    }
}