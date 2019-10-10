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
        && forall i,j :: 0<=i < tail  && 0<=j < tail && i != j ==> conj[i] != Conteudo[j]
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
        // var pos := Array.IndexOf(conj, e);
        // if(pos > -1) {
        //     return true;
        // }
        // else {
        //     return false;
        // }
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
    }

    // method Adiciona(e:nat) returns (b:bool)
    // requires InvarianteClasse()
    // ensures InvarianteClasse()
    // ensures e in Conteudo ==> (old(Conteudo) == Conteudo && b == false)
    // ensures !(e in Conteudo) ==> (Conteudo == old(Conteudo) + [e] 
    //           && b == true && tail == old(tail) + 1)
    
    // {
    //     // O array contem o elemento e
    //     var test:= Existe(e);
    //     if (test){
    //         return false;
    //     }
    //     // O array nao contem o elemento e
    //     else{
    //         if (tail == conj.Length)
    //         {
    //             var aux := new nat[2 * conj.Length];
    //             forall(i | 0 <= i < conj.Length)
    //             {
    //                 aux[i] := conj[i];
    //             }
    //             conj := aux;
    //         }

    //         conj[tail] := e;
    //         tail := tail +1;
    //         Conteudo := Conteudo + [e];
    //         return true;

            
    //     }
    // }
}