import T "Types";
import { trap } "mo:⛔";

module {
  
  public type Value = T.Value;

  public type Concrete = T.Concrete;

  public type Optional = T.Optional;

  public func fromNat(n: Nat): Value = #n(n);

  public func toNat(val: Value): Nat {
    let #n(x) = val else {
      trap("Struct.getNat - type mismatch")
    }; x
  };

  public func fromInt(i: Int): Value = #i(i);

  public func toInt(val: Value): Int {
    let #i(x) = val else {
      trap("Struct.getInt - type mismatch")
    }; x
  };

  public func fromBlob(s: Blob): Value = #s(s);

  public func toBlob(val: Value): Blob {
    let #s(x) = val else {
      trap("Struct.getBlob - type mismatch")
    }; x
  };

  public func fromText(t: Text): Value = #t(t);

  public func toText(val: Value): Text {
    let #t(x) = val else {
      trap("Struct.getText - type mismatch")
    }; x
  };

  public func fromBool(b: Bool): Value = #b(b);

  public func toBool(val: Value): Bool {
    let #b(x) = val else {
      trap("Struct.getBool - type mismatch")
    }; x
  };

  public func fromPrincipal(p: Principal): Value = #p(p);

  public func toPrincipal(val: Value): Principal {
    let #p(x) = val else {
      trap("Struct.getPrincipal - type mismatch")
    }; x
  };

  public func fromOptNat(n: ?Nat): Value = #o(#n(n));

  public func toOptNat(val: Value): ?Nat {
    let #n(x) = getOpt(val) else {
      trap("Struct.getOptNat - type mismatch")
    }; x
  };

  public func fromOptInt(i: ?Int): Value = #o(#i(i));

  public func toOptInt(val: Value): ?Int {
    let #i(x) = getOpt(val) else {
      trap("Struct.getOptInt - type mismatch")
    }; x
  };

  public func fromOptBlob(s: ?Blob): Value = #o(#s(s));

  public func toOptBlob(val: Value): ?Blob {
    let #s(x) = getOpt(val) else {
      trap("Struct.getBlob - type mismatch")
    }; x
  };

  public func fromOptText(t: ?Text): Value = #o(#t(t));

  public func toOptText(val: Value): ?Text {
    let #t(x) = getOpt(val) else {
      trap("Struct.getOptText - type mismatch")
    }; x
  };

  public func fromOptBool(b: ?Bool): Value = #o(#b(b));

  public func toOptBool(val: Value): ?Bool {
    let #b(x) = getOpt(val) else {
      trap("Struct.getOptBool - type mismatch")
    }; x
  };

  public func fromOptPrincipal(p: ?Principal): Value = #o(#p(p));

  public func toOptPrincipal(val: Value): ?Principal {
    let #p(x) = getOpt(val) else {
      trap("Struct.getOptPrincipal - type mismatch")
    }; x
  };

  func getOpt(val: Value): Optional {
    let #o(opt) = val else {
      trap("Value.getOpt() - type mismatch")
    }; opt
  };

}