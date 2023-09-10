import T "Types";
import C "Constants";
import {abs} "mo:base/Int";
import {print} "mo:base/Debug";
import {tabulate} "mo:base/Array";
import {encodeUtf8; decodeUtf8} "mo:base/Text";
import {toBlob = blobOfPrincipal; fromBlob = principalOfBlob} "mo:base/Principal";
import {fromArray = arrayToBlob; toArray = blobToArray} "mo:base/Blob";
import {toNat = nat8ToNat; fromNat = natToNat8} "mo:base/Nat8";
import {btstNat8} "mo:⛔";
module {

   
  public type Tag = T.Tag;
  public type Bytecount = T.Bytecount;
  public type Generator = T.Generator;
  public type Return<X> = T.Return<X>;
  public type Constructor<X> = T.Constructor<X>;

  public func toOpt<T>(tag: Nat8, size: Bytecount, genFn: Generator, fn: Constructor<T>): Return<?T> {
    if (tag == C.TAG_NULL) #ok(null)
    else switch ( fn(tag, size, genFn) ){
      case (#ok b) #ok(?b);
      case (#err) #err;
    }
  };

  public func fromOpt<T>(opt: ?T, fn: (T) -> (Bytecount, Generator)): (Bytecount, Generator) {
    switch opt {
      case null (C.SIZE_TAG, func(i: Nat) = if (i == 0) C.TAG_NULL else 0xFF);
      case (?val) fn(val)
    };
  };

  public func toBlob(tag: Nat8, size: Nat, genFn: Generator): Return<Blob> {
    if (tag != C.TAG_BLOB and tag != C.TAG_DIDL) #err
    else #ok(arrayToBlob(tabulate<Nat8>(size, genFn)))
  };

  public func fromBlob(x: Blob): (Bytecount, Generator) {
    let array: [Nat8] = blobToArray(x);
    let size: Nat = x.size();
    (size + C.SIZE_TAG, func(i: Nat){
      if (i == 0) C.TAG_BLOB
      else if (i > size) 0xFF
      else array[i-1]
    })
  };

  public func toBool(tag: Tag, size: Bytecount, genFn: Generator): Return<Bool> {
    if (size > 0) #err
    else if (tag == C.TAG_BOOL) #ok(false)
    else if (tag == C.TAG_BOOL | C.BIT_TRUE) #ok(true)
    else #err
  };

  public func fromBool(x: Bool): (Bytecount, Generator) = (C.SIZE_TAG, func(i){
    if (i > 0) 0xFF
    else if x C.TAG_BOOL | C.BIT_TRUE
    else C.TAG_BOOL
  });

  public func toText(tag: Tag, size: Bytecount, genFn: Generator): Return<Text> {
    if (tag != C.TAG_TEXT) #err
    else if (size == 0) #ok("")
    else switch ( decodeUtf8(arrayToBlob(tabulate<Nat8>(size, genFn))) ) {
      case (?t) #ok(t);
      case null #err;
    };
  };

  public func fromText(x: Text): (Bytecount, Generator) {
    let array: [Nat8] = blobToArray(encodeUtf8(x));
    let size: Nat = array.size();
    (size + C.SIZE_TAG, func(i: Nat){
      if (i == 0) C.TAG_TEXT
      else if (i > size) 0xFF
      else array[i-1]
    })
  };

  public func toPrincipal(tag: Tag, size: Bytecount, genFn: Generator): Return<Principal> {
    if (btstNat8(tag, C.BIT_PRIN) == false) return #err;
    let size_: Nat = nat8ToNat(tag & ^(1 << C.BIT_PRIN));
    if (size_ != size) #err
    else if (size == 0) #ok(principalOfBlob(""))
    else #ok(principalOfBlob(arrayToBlob(tabulate<Nat8>(size_, genFn))))
  };

  public func fromPrincipal(x: Principal): (Bytecount, Generator) {
    let array: [Nat8] = blobToArray(blobOfPrincipal(x));
    let size: Nat = array.size();
    (size + C.SIZE_TAG, func(i: Nat){
      if (i == 0) C.TAG_PRIN | natToNat8(size)
      else if (i > size) 0xFF
      else array[i-1]
    })
  };

  public func fromNat(n: Nat): (Bytecount, Generator) = fromBigNat(C.TAG_NAT, n);

  public func toNat(tag: Tag, size: Bytecount, genFn: Generator): Return<Nat> {
    if (tag != C.TAG_NAT) return #err;
    #ok(toBigNat(size, genFn))
  };

  public func toInt(tag: Tag, size: Bytecount, genFn: Generator): Return<Int> {
    if (tag == C.TAG_INT | C.BIT_NEG) #ok(-toBigNat(size, genFn))
    else if (tag == C.TAG_INT) #ok(toBigNat(size, genFn))
    else #err
  };

  public func fromInt(i: Int): (Bytecount, Generator) {
    if (i < 0) fromBigNat(C.TAG_INT | C.BIT_NEG, abs(i))
    else fromBigNat(C.TAG_INT, abs(i))
  };

  func toBigNat(size: Nat, genFn: Generator): Nat {
    func evaluate(num: Nat, byte: Nat8, bit: Nat8): Nat {
      if (btstNat8(byte, bit))
        if (bit != 0x00) evaluate(num*2+1, byte, bit-1)
        else num * 2 + 1
      else 
        if (bit != 0x00) evaluate(num*2, byte, bit-1)
        else num * 2
    };
    func sum(num: Nat, cnt: Nat): Nat {
      if (cnt == size) num
      else sum(
        evaluate(num, genFn(cnt), 0x07),
        cnt+1
    )};
    sum(0,0)
  };

  func fromBigNat(tag: Tag, n: Nat): (Bytecount, Generator) {
    var q: Nat = n;
    var b: Nat = calcSize(n);
    func genFn(i: Nat): Nat8 {
      if (i > b) return 0xFF;
      if (i == 0) return tag;
      func rec(count: Nat, div: Nat, byte: Nat8): Nat8 {
        if (q == 0 or count == 8) return byte;
        if (q / div == 1){ q %= div; rec(
          count + 1,
          2 ** (((b-i+1)*8) - (count+1)) / 2,
          byte | 1 << natToNat8(7-count)
        )} else rec(
          count + 1,
          2 ** (((b-i+1)*8) - (count+1)) / 2,
          byte
      )};
      rec(0, 2**((b-i+1)*8)/2, 0x00)
    };
    (b + C.SIZE_TAG, genFn)
  };

  public func calcSize(n: Nat): Bytecount {
    func rec(i: Nat): Nat {
      if (((256 ** i) - 1: Nat) >= n) i else rec(i+1)
    }; 
    rec(1)
  };

};