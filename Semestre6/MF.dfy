predicate elementosDistintos(s: seq<int>)
{
    forall i :: 0 <= i < |s| ==> forall j :: 0 <= j < |s| && j != i ==> s[i] != s[j]
}

class Conjunto{
    var c : seq<nat>

    constructor()
    ensures |c| == 0
    ensures elementosDistintos(c);
    {
        c := [];
    }

    method size()  returns (s:nat)
    ensures s == |c|
    {
        s := |c|;
    }

    method contains(v : nat) returns (b:bool)
    ensures b <==> v in c
    {
        b := v in c;
    }

    method add(v : nat) returns (b:bool)
    modifies this
    // v estará lá depois do metodo
    ensures v in c

    //comportamento esperado
    ensures old(v !in c) ==> b
    ensures old(v in c) ==> !b

    //todos os outros continuam lá
    ensures forall e :: e in c && e != v ==> e in c
    //só mudou o inserido
    ensures old(v !in c) && b ==> v in c

    ensures b ==> old(|c|) + 1 == |c|
    ensures !b ==> old(|c|) == |c|
    ensures forall e :: (old(!( e in c)) && (e != v) ==> e !in c)
    ensures old(|c|) == |c| ==> (b == false)
    {
        b := true;
        var x := contains(v);
        if(x){
            b:=false;
        }else{
            c := c + [v];
            b := true;
        }

    }

    method inter(b : Conjunto) returns (d: Conjunto)
    //requires elementosDistintos(c) && elementosDistintos(b.c)
    ensures forall e :: e in d.c <==> (e in c && e in b.c)
    ensures elementosDistintos(d.c)
    {
        
        d := new Conjunto();
        var aux := 0;
        var x : bool;
        d.c := [];

        while (aux < |c|)
        invariant aux <= |c|
        invariant forall e :: e in c[..aux] && e in b.c ==> e in d.c 
        invariant forall e :: e in d.c ==> (e in c && e in b.c)
        invariant forall i, j :: 0 <= i < |d.c|  && 0 <= j < |d.c| && i != j ==> d.c[i] != d.c[j]
        decreases |c| - aux
        {
            x := c[aux] in b.c && c[aux] !in d.c;
            if (x) {
                d.c := d.c +  [c[aux]];
            }
            aux := aux + 1;
        }
    }

  method union(b : Conjunto) returns (d: Conjunto)
    //requires elementosDistintos(c) && elementosDistintos(b.c)
    ensures forall e :: (e in c || e in b.c) <==> e in d.c
    //ensures elementosDistintos(d.c)
    ensures |d.c| <= |c + b.c|
    {
        d := new Conjunto();
        d.c := c;
        var aux := 0;
        var x : bool;

        while (aux < |b.c|)
        invariant aux <= |b.c|
        invariant forall e :: e in c ==> e in d.c
        invariant forall e :: e in b.c[..aux] ==> e in d.c
        invariant forall e :: e in d.c ==> (e in c || e in b.c)
        //invariant forall i, j :: 0 <= i < |d.c|  && 0 <= j < |d.c| && i != j ==> d.c[i] != d.c[j]
        invariant |d.c| <= |c + b.c[..aux]|
        decreases |b.c| - aux
        {
            x := b.c[aux] !in d.c;
            if (x) {
                d.c := d.c + [b.c[aux]];
            }
            aux := aux + 1;
        }
    }

    method diff(b : Conjunto) returns (d: Conjunto)
    //requires elementosDistintos(c) && elementosDistintos(b.c)
    ensures forall e :: (e in c && e !in b.c) <==> e in d.c
    ensures elementosDistintos(d.c)
    {
        d := new Conjunto();
        d.c := [];
        var aux := 0;
        var x : bool;

        while (aux < |c|)
        invariant aux <= |c|
        invariant forall e :: e in c[..aux] && e !in b.c <==> (e in d.c)
        invariant forall i, j :: 0 <= i < |d.c|  && 0 <= j < |d.c| && i != j ==> d.c[i] != d.c[j]
        decreases |c| - aux
        {
            x := c[aux] !in b.c && c[aux] !in d.c;
            if (x) {
                d.c := d.c + [c[aux]];
            }
            aux := aux + 1;
        }
    }
    
}


method testeAdd()
{
    var ins : bool;
    var tam : nat;

    var s := new Conjunto();
    tam := s.size();
    assert tam == 0;

    assert 1 !in s.c;
    ins := s.add(1);
    assert ins;
    assert 1 in s.c;

    //--------------
    //teste elemento repetido
    ins := s.add(1);
    assert !ins;
    //--------------
    ins := s.add(2);
    assert ins;

    assert 3 !in s.c;
    ins := s.add(3);
    assert ins;

    assert 1128374623412341234 !in s.c;
    ins := s.add(1128374623412341234);
    assert ins;
    
}

method testeSize()
{
    var con : bool;
    var ins : bool;
    var tam : nat;
    
    var c := new Conjunto();

    tam := c.size();
    assert tam == 0;

    ins := c.add(1);
    tam := c.size();
    assert tam == 1;

    ins := c.add(100);
    tam := c.size();
    assert tam == 2;
}

method testeContains()
{
    var con : bool;
    var ins : bool;
    var tam : nat;
    
    var c := new Conjunto();

    assert 1 !in c.c;
    con := c.contains(1);
    assert !con;

    ins := c.add(1);

    assert 1 in c.c;
    con := c.contains(1);
    assert con;
}



method Main(){
    testeAdd();
    testeSize();
    testeContains();
    var s := new Conjunto();
    var ins := s.add(1);  assert ins;
    ins := s.add(1);      assert !ins;
    ins := s.add(2);      assert ins;
    ins := s.add(3);      assert ins;
    ins := s.add(5);      assert ins;
    ins := s.add(8);      assert ins;
    ins := s.add(13);     assert ins;

    var tam := s.size();
    assert tam == 6;


    var p := new Conjunto();
    ins := p.add(2);        assert ins;
    ins := p.add(4);        assert ins;
    ins := p.add(6);        assert ins;
    ins := p.add(8);        assert ins;
    ins := p.add(10);       assert ins;
    ins := p.add(12);       assert ins;
    ins := p.add(12);        assert !ins;


    tam := s.size();
    assert tam == 6;
    print("s == ");
    print(s.c); print("\n");
    print("p == "); 
    print(p.c); print("\n"); 

    var con := s.contains(1);
    print ("1 esta em s ? ");
    print(con); print("\n");
    con := p.contains(1);
    print ("1 esta em p ? ");
    print(con); print("\n");

    var intrr := s.inter(p);
    print ("s interseccao com p == ");
    print(intrr.c); //{2,8}
    print("\n");


    var diff := s.diff(p);
    print ("s - p == "); //{1,3,5,13}
    print (diff.c);
    print("\n");

    diff := p.diff(s);
    print ("p - s == "); 
    print (diff.c);
    print("\n");


    var u := s.union(p);
    print("s uniao p == ");
    print(u.c);
    
}

