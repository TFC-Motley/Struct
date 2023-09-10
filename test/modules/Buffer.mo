import {test; suite} "mo:test";
import {print = debug_print} "mo:base/Debug";
import {get} "mo:base/Option";
import Struct "../../src/lib";
import Value "../../src/Buffer/Value";
import T "../../src/Types";


module {

  func print(desc: Text, a: Text, e: Text): () {
    debug_print("Desc: " # desc # "\nActual: " # a # "\nExpected: " # e)
  };

  public func main(): () = suite("Buffer Tests", func(){

    test("Pack/Unpack - Natural Number", func() {
      let expected: Nat = 123456789;
      let SCHEMA = [#n(10)];
      let REGISTER = [#n(expected)];
      let ?packed: ?Blob = Struct.pack(SCHEMA, REGISTER) else {return assert false};
      let ?register: ?T.Register = Struct.unpack(SCHEMA, packed) else {return assert false};
      let actual: Nat = Value.toNat(register[0]);
      // print("", debug_show(actual), debug_show(expected));
      assert actual == expected;
    });

    test("Pack/Unpack - Signed Integers", func() {
      let expected: Int = -123456789;
      let SCHEMA = [#i(10)];
      let REGISTER = [#i(expected)];
      let ?packed: ?Blob = Struct.pack(SCHEMA, REGISTER) else {return assert false};
      let ?register: ?T.Register = Struct.unpack(SCHEMA, packed) else {return assert false};
      let actual: Int = Value.toInt(register[0]);
      // print("", debug_show(actual), debug_show(expected));
      assert actual == expected;
    });

    test("Pack/Unpack - Text Literals", func() {
      let expected: Text = "S0m3 cr@zy text JuSt CUZ!";
      let SCHEMA = [#t(32)];
      let REGISTER = [#t(expected)];
      let ?packed: ?Blob = Struct.pack(SCHEMA, REGISTER) else {return assert false};
      let ?register: ?T.Register = Struct.unpack(SCHEMA, packed) else {return assert false};
      let actual: Text = Value.toText(register[0]);
      // print("", debug_show(actual), debug_show(expected));
      assert actual == expected;
    });

    // //
    // // Packing Multiple Values
    // //
    test("Pack/Unpack - Mixed Types", func() {
      let e_nat: Nat = 123456789;
      let e_int: Int = -123456789;
      let e_txt: Text = "S0m3 cr@zy text JuSt CUZ!";
      let SCHEMA = [#n(16), #i(24), #t(32)]; // field lengths shown here are arbitrary; they just need to be long enough to hold the expected value
      let REGISTER = [#n(e_nat), #i(e_int), #t(e_txt)];
      let ?packed: ?Blob = Struct.pack(SCHEMA, REGISTER) else {return assert false};
      let ?register: ?T.Register = Struct.unpack(SCHEMA, packed) else {return assert false};
      let a_nat: Nat = Value.toNat(register[0]);
      let a_int: Int = Value.toInt(register[1]);
      let a_txt: Text = Value.toText(register[2]);
      // print("Nat", debug_show(a_nat), debug_show(e_nat));
      // print("Int", debug_show(a_int), debug_show(e_int));
      // print("Text", debug_show(a_txt), debug_show(e_txt));
      assert (a_nat == e_nat) and (a_int == e_int) and (a_txt == e_txt)
    });

  });

}