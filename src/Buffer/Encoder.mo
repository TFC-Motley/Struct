import T "Types";
import C "Constants";
import {print} "mo:base/Debug";
import Generator "Generator";

module {

  public type Field = T.Field;

  public type Value = T.Value;
  
  public type Generator = T.Generator;

  public func get(field: Field, value: Value): ?(Nat, Nat, Generator) {
      switch field {
        case ( #o(typ) ) {
          switch( value ){
            case (#o val) {
              switch typ {
                case ( #n(len) ) {
                  let optNat = switch(val){case(#n(x)) x; case _ return null};
                  let (size, genFn) = Generator.fromOpt<Nat>(optNat, Generator.fromNat);
                  if (size <= len + C.SIZE_TAG) ?(len + C.SIZE_TAG, size, genFn) else null
                };
                case ( #i(len) ) {
                  let optInt = switch(val){case(#i(x)) x; case _ return null};
                  let (size, genFn) = Generator.fromOpt<Int>(optInt, Generator.fromInt);
                  if (size <= len + C.SIZE_TAG) ?(len + C.SIZE_TAG, size, genFn) else null
                };
                case ( #s(len) ) {
                  let optBlob = switch(val){case(#s(x)) x; case _ return null};
                  let (size, genFn) = Generator.fromOpt<Blob>(optBlob, Generator.fromBlob);
                  if (size <= len + C.SIZE_TAG) ?(len + C.SIZE_TAG, size, genFn) else null
                };
                case ( #t(len) ) {
                  let optText = switch(val){case(#t(x)) x; case _ return null};
                  let (size, genFn) = Generator.fromOpt<Text>(optText, Generator.fromText);
                  if (size <= len + C.SIZE_TAG) ?(len + C.SIZE_TAG, size, genFn) else null
                };
                case ( #b ) {
                  let optBool = switch(val){case(#b(x)) x; case _ return null};
                  let (size, genFn) = Generator.fromOpt<Bool>(optBool, Generator.fromBool);
                  if (size <= C.SIZE_BOOL + C.SIZE_TAG) ?(C.SIZE_BOOL + C.SIZE_TAG, size, genFn) else null
                };
                case ( #p ) {
                  let optPrin = switch(val){case(#p(x)) x; case _ return null};
                  let (size, genFn) = Generator.fromOpt<Principal>(optPrin, Generator.fromPrincipal);
                  if (size <= C.SIZE_PRIN + C.SIZE_TAG) ?(C.SIZE_PRIN + C.SIZE_TAG, size, genFn) else null
                };
              };
            };
            case _ null;
          };
        };
        case ( #n(len) ){
          let nat = switch(value){case(#n(x)) x; case _ return null};
          let (size, genFn) = Generator.fromNat(nat);
          if (size <= len + C.SIZE_TAG) ?(len + C.SIZE_TAG, size, genFn) else null
        };
        case ( #i(len) ){
          let int = switch(value){case(#i(x)) x; case _ return null};
          let (size, genFn) = Generator.fromInt(int);
          if (size <= len + C.SIZE_TAG) ?(len + C.SIZE_TAG, size, genFn) else null
        };
        case ( #s(len) ){
          let blob = switch(value){case (#s(x)) x; case _ return null};
          let (size, genFn) = Generator.fromBlob(blob);
          if (size <= len + C.SIZE_TAG) ?(len + C.SIZE_TAG, size, genFn) else null
        };
        case ( #t(len) ){
          let txt = switch(value){case(#t(x)) x; case _ return null};
          let (size, genFn) = Generator.fromText(txt);
          if (size <= len + C.SIZE_TAG) ?(len + C.SIZE_TAG, size, genFn) else null
        };
        case ( #b ){
          let bool = switch(value){case(#b(x)) x; case _ return null};
          let (size, genFn) = Generator.fromBool(bool);
          if (size <= C.SIZE_BOOL + C.SIZE_TAG) ?(C.SIZE_BOOL + C.SIZE_TAG, size, genFn) else null
        };
        case ( #p ){
          let prin = switch(value){case(#p(x)) x; case _ return null};
          let (size, genFn) = Generator.fromPrincipal(prin);
          if (size <= C.SIZE_PRIN + C.SIZE_TAG) ?(C.SIZE_PRIN + C.SIZE_TAG, size, genFn) else null
        };
      }
  }

};