module {

  type List = ?(Nat8, List);

  public type Tag = Nat8;

  public type Bytecount = Nat;

  public type Schema = [Field];

  public type Generator = Nat -> Nat8;

  public type Return<T> = {#ok: T; #err};

  public type Sequence = { var next: ?Range };

  public type Constructor<T> = (Tag, Bytecount, Generator) -> Return<T>;

  public type Range = {
    length: Nat;
    padding: Nat;
    stream: Generator;
    var offset: Nat;
    var next: ?Range;
  };

  public type Type = {
    #n: Nat;
    #i: Nat;
    #s: Nat;
    #t: Nat;
    #b;
    #p;
  };

  public type Concrete = {
    #n: Nat;
    #i: Int;
    #s: Blob;
    #t: Text;
    #b: Bool;
    #p: Principal
  };

  public type Optional = {
    #n: ?Nat;
    #i: ?Int;
    #s: ?Blob;
    #t: ?Text;
    #b: ?Bool;
    #p: ?Principal
  };

  public type Field = Type or {#o: Type};

  public type Value = Concrete or {#o: Optional};
}