import T "Types";
import C "Constants";
import L "mo:base/List";
import I "mo:base/Iter";
import DQ "mo:base/Deque";
import {trap} "mo:base/Debug";
import {fromArray = arrayToBlob; hash = hashBlob} "mo:base/Blob";

module {

  type Type = T.Type;

  public type Field = T.Field;

  public type Schema = T.Schema;

  public func countBytes(schema: Schema): Nat {
    func rec(i: I.Iter<Field>, n: Nat): Nat {
      switch(i.next()){
        case null n;
        case (?fx) switch fx {
          case (#o t) rec(i, n + _type_size(t));
          case (#n len) rec(i, n + len + C.SIZE_TAG);
          case (#i len) rec(i, n + len + C.SIZE_TAG);
          case (#s len) rec(i, n + len + C.SIZE_TAG);
          case (#t len) rec(i, n + len + C.SIZE_TAG);
          case (#b) rec(i, n + C.SIZE_BOOL + C.SIZE_TAG);
          case (#p) rec(i, n + C.SIZE_PRIN + C.SIZE_TAG);
      }}};
    rec(schema.vals(), 0)
  };

  public func hash(schema: Schema): Nat32 {
    func rec(i: I.Iter<Field>, list: L.List<Nat8>): Nat32 {
      switch (i.next()){
        case null hashBlob(arrayToBlob(L.toArray(list)));
        case (?fx) switch fx {
          case (#o typ) rec(i, _type_bytes(typ, ?(0x00, list)));
          case (#n len) rec(i, _push(_nat_bytes(len), ?(C.TAG_NAT, list)));
          case (#i len) rec(i, _push(_nat_bytes(len), ?(C.TAG_INT, list)));
          case (#s len) rec(i, _push(_nat_bytes(len), ?(C.TAG_BLOB, list)));
          case (#t len) rec(i, _push(_nat_bytes(len), ?(C.TAG_TEXT, list)));
          case (#b) rec(i, _push(_nat_bytes(C.SIZE_BOOL), ?(C.TAG_BOOL, list)));
          case (#p) rec(i, _push(_nat_bytes(C.SIZE_PRIN), ?(C.TAG_PRIN, list)));
    }}};
    rec(schema.vals(), null);
  };

  public func properties(schema: Schema): (Nat, Nat32) {
    func rec(i: I.Iter<Field>, bc: Nat, list: L.List<Nat8>): (Nat, Nat32) {
      switch (i.next()){
        case null (bc, hashBlob(arrayToBlob(L.toArray(list))));
        case (?fx) switch fx {
          case (#o typ) rec(i, bc + _type_size(typ), _type_bytes(typ, ?(0x00, list)));
          case (#n len) rec(i, bc + len + C.SIZE_TAG, _push(_nat_bytes(len), ?(C.TAG_NAT, list)));
          case (#i len) rec(i, bc + len + C.SIZE_TAG, _push(_nat_bytes(len), ?(C.TAG_INT, list)));
          case (#s len) rec(i, bc + len + C.SIZE_TAG, _push(_nat_bytes(len), ?(C.TAG_BLOB, list)));
          case (#t len) rec(i, bc + len + C.SIZE_TAG, _push(_nat_bytes(len), ?(C.TAG_TEXT, list)));
          case (#b) rec(i, bc + C.SIZE_BOOL+C.SIZE_TAG, _push(_nat_bytes(C.SIZE_BOOL), ?(C.TAG_BOOL, list)));
          case (#p) rec(i, bc + C.SIZE_PRIN+C.SIZE_TAG, _push(_nat_bytes(C.SIZE_PRIN), ?(C.TAG_PRIN, list)));
      }}};
    rec(schema.vals(), 0, null)
  };

  func _push(i: I.Iter<Nat8>, l: L.List<Nat8>): L.List<Nat8> {
    switch (i.next()){ case (?nat8) _push(i, ?(nat8, l)); case null l;
  }};

  func _type_size(t: Type): Nat {
    switch t {
      case (#n len) len + C.SIZE_TAG;
      case (#i len) len + C.SIZE_TAG;
      case (#s len) len + C.SIZE_TAG;
      case (#t len) len + C.SIZE_TAG;
      case (#b) C.SIZE_BOOL + C.SIZE_TAG;
      case (#p) C.SIZE_PRIN + C.SIZE_TAG;
    }
  };

  func _type_bytes(t: Type, list: L.List<Nat8>): L.List<Nat8> {
    switch t {
      case (#n len) _push(_nat_bytes(len), ?(C.TAG_NAT, list));
      case (#i len) _push(_nat_bytes(len), ?(C.TAG_INT, list));
      case (#s len) _push(_nat_bytes(len), ?(C.TAG_BLOB, list));
      case (#t len) _push(_nat_bytes(len), ?(C.TAG_TEXT, list));
      case (#b) _push(_nat_bytes(C.SIZE_BOOL), ?(C.TAG_BOOL, list));
      case (#p) _push(_nat_bytes(C.SIZE_PRIN), ?(C.TAG_PRIN, list));
    }
  };

  func _nat_bytes(n: Nat): {next: ()->?Nat8} = object {
    var q: Nat = n;
    var null_: Bool = false;
    public func next(): ?Nat8 {
      if null_ return null;
      var byte: Nat8 = 0x00;
      var bitpos: Nat8 = 0x00;
      label loopdy loop {
        if (q == 0) break loopdy;
        if (bitpos > 0x07) break loopdy;
        if (q % 2 == 1) byte |= 1 << bitpos;
        bitpos += 1;
        q /= 2;
      };
      if (q == 0) null_ := true;
      ?byte
    };
  };

};