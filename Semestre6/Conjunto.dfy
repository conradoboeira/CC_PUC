class ConjuntoNat
{
    var conj: array<nat>;
    var tail: nat;

    ghost var Conteudo: seq<nat>;

    predicate InvarianteClasse()
    reads this, conj
    {
        conj.Length != 0
        && 0 <= tail <= conj.Length
        && conj[0..tail] == Conteudo
    }

    constructor ()
    ensures InvarianteClasse()
    ensures Conteudo == []
    {
        conj := new nat[5];
        Conteudo := [];
        tail := 0;
    }

    method Tamanho() returns (n:nat)
    requires InvarianteClasse()
    ensures InvarianteClasse()
    ensures n == |Conteudo|
    {
        return tail;
    }

    method Existe(e:nat) returns (b:bool)
    requires InvarianteClasse()
    ensures InvarianteClasse()
    ensures e in Conteudo ==> b == true;
    ensures !(e in Conteudo) ==> b == false;
    {
        // var pos := Array.IndexOf(conj, e);
        // if(pos > -1) {
        //     return true;
        // }
        // else {
        //     return false;
        // }
        b := false;
        for(var i:= 0; i < tail; i:= i+1)
        {
            if(conj[i] == e) {
                b := true;
            }
        }
    }

    method Adiciona(e:nat) returns (b:bool)
    requires InvarianteClasse()
    ensures InvarianteClasse()
    ensures e in Conteudo ==> (old(Conteudo) == Conteudo && b == false)
    ensures !(e in Conteudo) ==> (Conteudo == old(Conteudo) + [e] 
              && b == true && tail == old(tail) + 1)
    
    {
        // O array contem o elemento e
        if (Array.IndexOf(conj, e) > -1){
            return false;
        }
        // O array nao contem o elemento e
        else{
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
            return true;

            
        }
    }
}