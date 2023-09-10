import T "Types";
import C "Constants";
import Generator "Generator";

module {

  public type Field = T.Field;

  public type Value = T.Value;
  
  public type Generator = T.Generator;

  public func get(field: Field): (Nat, (Nat8, Nat, Generator) -> ?Value) {
    switch field {
      case ( #o(typ) ) switch typ {
        case ( #n(len) ) (len + C.SIZE_TAG, func(tag: Nat8, size: Nat, genFn: Generator){
          switch( Generator.toOpt<Nat>(tag, size, genFn, Generator.toNat) ){
            case (#ok optNat) ?#o(#n(optNat)); case _ null;
        }});
        case ( #i(len) ) (len + C.SIZE_TAG, func(tag: Nat8, size: Nat, genFn: Generator){
          switch( Generator.toOpt<Int>(tag, size, genFn, Generator.toInt) ){
            case (#ok opt) ?#o(#i(opt)); case _ null;
        }});
        case ( #s(len) ) (len + C.SIZE_TAG, func(tag: Nat8, size: Nat, genFn: Generator){
          switch( Generator.toOpt<Blob>(tag, size, genFn, Generator.toBlob) ){
            case (#ok opt) ?#o(#s(opt)); case _ null;
        }});
        case ( #t(len) ) (len + C.SIZE_TAG, func(tag: Nat8, size: Nat, genFn: Generator){
          switch( Generator.toOpt<Text>(tag, size, genFn, Generator.toText) ){
            case (#ok opt) ?#o(#t(opt)); case _ null;
        }});
        case ( #b ) (C.SIZE_BOOL + C.SIZE_TAG, func(tag: Nat8, size: Nat, genFn: Generator){
          switch( Generator.toOpt<Bool>(tag, size, genFn, Generator.toBool) ){
            case (#ok opt) ?#o(#b(opt)); case _ null;
        }});
        case ( #p ) (C.SIZE_PRIN + C.SIZE_TAG, func(tag: Nat8, size: Nat, genFn: Generator){
          switch( Generator.toOpt<Principal>(tag, size, genFn, Generator.toPrincipal) ){
            case (#ok opt) ?#o(#p(opt)); case _ null;
        }});
      };
      case ( #n(len) ) (len + C.SIZE_TAG, func(tag: Nat8, size: Nat, genFn: Generator){
        switch( Generator.toNat(tag, size, genFn) ) { case (#ok x) ?#n(x); case _ null };
      });
      case ( #i(len) ) (len + C.SIZE_TAG, func(tag: Nat8, size: Nat, genFn: Generator){
        switch( Generator.toInt(tag, size, genFn) ) { case (#ok x) ?#i(x); case _ null };
      });
      case ( #s(len) ) (len + C.SIZE_TAG, func(tag: Nat8, size: Nat, genFn: Generator){
        switch( Generator.toBlob(tag, size, genFn) ) { case (#ok x) ?#s(x); case _ null };
      });
      case ( #t(len) ) (len + C.SIZE_TAG, func(tag: Nat8, size: Nat, genFn: Generator){
        switch( Generator.toText(tag, size, genFn) ) { case (#ok x) ?#t(x); case _ null };
      });
      case ( #b ) (C.SIZE_BOOL + C.SIZE_TAG, func(tag: Nat8, size: Nat, genFn: Generator){
        switch( Generator.toBool(tag, size, genFn) ) { case (#ok x) ?#b(x); case _ null };
      });
      case ( #p ) (C.SIZE_PRIN + C.SIZE_TAG, func(tag: Nat8, size: Nat, genFn: Generator){
        switch( Generator.toPrincipal(tag, size, genFn) ) { case (#ok x) ?#p(x); case _ null };
    })}
  }

};