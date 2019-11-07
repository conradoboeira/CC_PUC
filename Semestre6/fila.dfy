class {:autocontracts}  FilaNat
{
    //Implementação
    var a: array<nat>;
    var tail: nat;
    //Abstração
    ghost var Conteudo: seq<nat>;

    predicate Valid()
    {
        a.Length != 0
        && 0 <= tail <= a.Length
        && a[0..tail] == Conteudo
    }
    constructor ()
    ensures Conteudo == []
    {
        a := new nat[5];
        tail := 0;
        Conteudo := [];
    }

    method Tamanho() returns (n:nat)
    ensures n == |Conteudo|
    {
        return tail;
    }

    method Enfileira(e:nat)
    ensures Conteudo == old(Conteudo) + [e]
    ensures |Conteudo| == |old(Conteudo)| + 1
    {
        if (tail == a.Length)
        {
            var b := new nat[2 * a.Length];
            forall(i | 0 <= i < a.Length)
            {
                b[i] := a[i];
            }
            a := b;
        }
        a[tail] := e;
        tail := tail + 1;
        Conteudo := Conteudo + [e];
    }

    method Desenfileira() returns (e:nat)
    requires |Conteudo| > 0
    ensures e == old(Conteudo)[0]
    ensures Conteudo == old(Conteudo)[1..]
    ensures |Conteudo| == |old(Conteudo)| - 1
    {
        e := a[0];
        tail := tail - 1;
        forall(i | 0 <= i < tail)
        {
            a[i] := a[i+1];
        }
        Conteudo := a[0..tail];
    }
}

method Main()
{
    var fila := new FilaNat();
    fila.Enfileira(1);
    fila.Enfileira(2);
    assert fila.Conteudo == [1,2];
    var e := fila.Desenfileira();
    assert e == 1;
    assert fila.Conteudo == [2];
}
