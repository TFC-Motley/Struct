import {test; suite} "mo:test";
import {print = debug_print} "mo:base/Debug";
import {arrayToBlob; hashBlob} "mo:⛔";
import S "../../src/Buffer/Schema";
import C "../../src/Buffer/Constants";
import T "../../src/Types";

module {

  func print(desc: Text, a: Text, e: Text): () {
    debug_print("Desc: " # desc # "\nActual: " # a # "\nExpected: " # e)
  };

  public func main(): () = suite("Schema Tests", func(){

    let schema: T.Schema = [
      #n(1),     // 2 bytes
      #i(4),     // 5 bytes
      #s(8),     // 9 bytes
      #t(8),     // 9 bytes
      #b,        // 1 bytes
      #p,        // 30 bytes
      #o(#n(1)), // 2 bytes
      #o(#i(4)), // 5 bytes
      #o(#s(8)), // 9 bytes 
      #o(#t(8)), // 9 bytes
      #o(#b),    // 1 bytes
      #o(#p),    // 30 bytes
    ];

    //
    // Calculate the size of a schema
    //
    test("Calculate Size", func(){
      let expected: Nat = 112;
      let actual= S.countBytes(schema);
      // print("Schema size", debug_show(actual), debug_show(expected));
      assert actual == expected;
    });

    //
    // Calculate the Hash of a schema
    //
    test("Calculate Hash", func(){
      let actual: Nat32 = S.hash(schema);
      let expected: Nat32 = hashBlob(arrayToBlob([
        0x1D, C.TAG_PRIN, 0x00, 
        0x00, C.TAG_BOOL, 0x00,
        0x08, C.TAG_TEXT, 0x00,
        0x08, C.TAG_BLOB, 0x00,
        0x04, C.TAG_INT, 0x00,
        0x01, C.TAG_NAT, 0x00,
        0x1D, C.TAG_PRIN,
        0x00, C.TAG_BOOL,
        0x08, C.TAG_TEXT,
        0x08, C.TAG_BLOB,
        0x04, C.TAG_INT,
        0x01, C.TAG_NAT,
      ]));
      // print("Schema hash", debug_show(actual), debug_show(expected));
      assert actual == expected;
    });

    //
    // Make sure properties returns expected values 
    //
    test("Valid Properties", func(){
      let expected_size: Nat = S.countBytes(schema);
      let expected_hash: Nat32 = S.hash(schema);
      let (actual_size, actual_hash) = S.properties(schema);
      assert actual_size == expected_size;
      assert actual_hash == expected_hash;
    });

  });

}