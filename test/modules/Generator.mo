import {test; suite} "mo:test";
import {tabulate} "mo:base/Array";
import C "../../src/Buffer/Constants";
import Gen "../../src/Buffer/Generator";
import {print = debug_print} "mo:base/Debug";
import {toBlob = blobOfPrincipal; fromBlob = principalOfBlob} "mo:base/Principal";
import {fromArray = arrayToBlob; toArray = blobToArray} "mo:base/Blob";


module {

  func print(desc: Text, a: Text, e: Text): () {
    debug_print("Desc: " # desc # "\nActual: " # a # "\nExpected: " # e)
  };
  
  public func main(): () = suite("Generator Tests", func(){

    test("Binary Blobs", func(){

      let tests: [(Text, Blob, Blob)] = [
        ("Empty", "", "\08"),
        ("Standard", "\00\AB\CD\EF\01\02\03", "\08\00\AB\CD\EF\01\02\03"),
      ];

      for (entry in tests.vals()){

        let origin: Blob = entry.1;

        let (size, genFn) = Gen.fromBlob(origin);
        let actual_enc: Blob = arrayToBlob(tabulate<Nat8>(size, genFn));
        let expected_enc: Blob = entry.2;
        // print("Encoding - Principal Identifiers - " # entry.0, debug_show(actual_enc), debug_show(expected_enc));
        assert actual_enc == expected_enc;

        let array: [Nat8] = blobToArray(actual_enc);
        let genFn2 = func(i: Nat): Nat8 {array[i+1]};
        let #ok(actual_dec) = Gen.toBlob(array[0], size-1, genFn2) else {return assert false};
        // print("Decoding - Principal Identifiers - " # entry.0, debug_show(actual_dec), debug_show(origin));
        assert actual_dec == origin;

      };

    });
    
    test("Text Literals", func(){

      let origin: Text = "S0m3 cr@zy text JuSt CUZ!";

      let (size, genFn) = Gen.fromText(origin);
      let actual_enc: Blob = arrayToBlob(tabulate<Nat8>(size, genFn));
      let expected_enc: Blob = "\10\53\30\6D\33\20\63\72\40\7A\79\20\74\65\78\74\20\4A\75\53\74\20\43\55\5A\21";
      //print("Encoding - Alphanumeric String", debug_show(actual_enc), debug_show(expected_enc));
      assert actual_enc == expected_enc;

      let tag: Nat8 = genFn(0);
      let genFn2 = func(i: Nat): Nat8 {genFn(i+1)};
      let #ok(actual_dec) = Gen.toText(tag, size-1, genFn2) else {return assert false};
      //print("Decoding - Alphanumeric String", actual_dec, origin);
      assert actual_dec == origin;

    });

    test("Natural Numbers", func(){

      let tests: [(Text, Nat, Blob)] = [
        ("One", 1, "\01\01"),
        ("Zero", 0, "\01\00"),
        ("8-bit", 255, "\01\FF"),
        ("16-bit", 65535, "\01\FF\FF"),
        ("32-bit", 4294967295, "\01\FF\FF\FF\FF"),
        ("64-bit", 18446744073709551615, "\01\FF\FF\FF\FF\FF\FF\FF\FF")
      ];

      for (entry in tests.vals()){

        let origin: Nat = entry.1;

        let (size, genFn) = Gen.fromNat(origin);
        let actual_enc: Blob = arrayToBlob(tabulate<Nat8>(size, genFn));
        let expected_enc: Blob = entry.2;
        // print("Encoding - Natural Numbers - " # entry.0, debug_show(actual_enc), debug_show(expected_enc));
        assert actual_enc == expected_enc;

        let array: [Nat8] = blobToArray(actual_enc);
        let genFn2 = func(i: Nat): Nat8 {array[i+1]};
        let #ok(actual_dec) = Gen.toNat(array[0], size-1, genFn2) else {return assert false};
        // print("Decoding - Natural Numbers - " # entry.0, debug_show(actual_dec), debug_show(origin));
        assert actual_dec == origin;

      };

    });

    test("Signed Integers", func(){

      let tests: [(Text, Int, Blob)] = [
        ("One", -1, "\03\01"),
        ("Zero", 0, "\02\00"),
        ("8-bit", -127, "\03\7F"),
        ("16-bit", 32767, "\02\7F\FF"),
        ("32-bit", -2147483647, "\03\7F\FF\FF\FF"),
        ("64-bit", 9223372036854775807, "\02\7F\FF\FF\FF\FF\FF\FF\FF")
      ];

      for (entry in tests.vals()){

        let origin: Int = entry.1;

        let (size, genFn) = Gen.fromInt(origin);
        let actual_enc: Blob = arrayToBlob(tabulate<Nat8>(size, genFn));
        let expected_enc: Blob = entry.2;
        // print("Encoding - Signed Integers - " # entry.0, debug_show(actual_enc), debug_show(expected_enc));
        assert actual_enc == expected_enc;

        let array: [Nat8] = blobToArray(actual_enc);
        let genFn2 = func(i: Nat): Nat8 {array[i+1]};
        let #ok(actual_dec) = Gen.toInt(array[0], size-1, genFn2) else {return assert false};
        // print("Decoding - Signed Integers - " # entry.0, debug_show(actual_dec), debug_show(origin));
        assert actual_dec == origin;

      };

    });

    test("Booleans - True", func(){

      let origin: Bool = true;

      let (size, genFn) = Gen.fromBool(origin);
      let actual_enc: Blob = arrayToBlob(tabulate<Nat8>(size, genFn));
      let expected_enc: Blob = "\05";
      // print("Encoding - Boolean (True)", debug_show(actual_enc), debug_show(expected_enc));
      assert actual_enc == expected_enc;

      let tag: Nat8 = genFn(0);
      let genFn2 = func(i: Nat): Nat8 {genFn(i+1)};
      let #ok(actual_dec) = Gen.toBool(tag, size-1, genFn2) else {return assert false};
      // print("Decoding - Boolean (True)", debug_show(actual_dec), debug_show(origin));
      assert actual_dec == origin;

    });

    test("Booleans - False", func(){

      let origin: Bool = false;

      let (size, genFn) = Gen.fromBool(origin);
      let actual_enc: Blob = arrayToBlob(tabulate<Nat8>(size, genFn));
      let expected_enc: Blob = "\04";
      // print("Encoding - Boolean (False)", debug_show(actual_enc), debug_show(expected_enc));
      assert actual_enc == expected_enc;

      let tag: Nat8 = genFn(0);
      let genFn2 = func(i: Nat): Nat8 {genFn(i+1)};
      let #ok(actual_dec) = Gen.toBool(tag, size-1, genFn2) else {return assert false};
      // print("Decoding - Boolean (False)", debug_show(actual_dec), debug_show(origin));
      assert actual_dec == origin;

    });

    test("Principal Identifiers", func(){

      let tests: [(Text, Blob, Blob)] = [
        ("IC Management", "", "\40"),
        ("Standard", "\00\AB\CD\EF\01\02\03", "\47\00\AB\CD\EF\01\02\03"),
        ("Zeroes", "\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00", "\5D\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00"),
      ];

      for (entry in tests.vals()){

        let origin: Principal = principalOfBlob(entry.1);

        let (size, genFn) = Gen.fromPrincipal(origin);
        let actual_enc: Blob = arrayToBlob(tabulate<Nat8>(size, genFn));
        let expected_enc: Blob = entry.2;
        // print("Encoding - Principal Identifiers - " # entry.0, debug_show(actual_enc), debug_show(expected_enc));
        assert actual_enc == expected_enc;

        let array: [Nat8] = blobToArray(actual_enc);
        let genFn2 = func(i: Nat): Nat8 {array[i+1]};
        let #ok(actual_dec) = Gen.toPrincipal(array[0], size-1, genFn2) else {return assert false};
        // print("Decoding - Principal Identifiers - " # entry.0, debug_show(actual_dec), debug_show(origin));
        assert actual_dec == origin;

      };

    });

  });

}