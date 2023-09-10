import {range} "mo:base/Iter";
import {test; suite} "mo:test";
import {tabulate} "mo:base/Array";
import {print = debug_print} "mo:base/Debug";
import {get = decoder} "../../src/Buffer/Decoder";
import {get = encoder} "../../src/Buffer/Encoder";
import {toBlob = blobOfPrincipal; fromBlob = principalOfBlob} "mo:base/Principal";
import {fromArray = arrayToBlob; toArray = blobToArray} "mo:base/Blob";
import Value "../../src/Buffer/Value";
import Schema "../../src/Buffer/Schema";
import Seq "../../src/Buffer/Sequence";
import T "../../src/Types";

module {

  func print(desc: Text, a: Text, e: Text): () {
    debug_print("Desc: " # desc # "\nActual: " # a # "\nExpected: " # e)
  };
  
  public func main(): () = suite("Sequencer Tests", func(){

    let seq: Seq.Sequence =Seq.empty();

    let expected: Blob = "\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\40\10\53\30\6D\33\20\63\72\40\7A\79\20\74\65\78\74\20\4A\75\53\74\20\43\55\5A\21\00\00\00\00\01\FF\FF\FF\FF\03\7F\FF\FF\FF";

    let schema: T.Schema = [#p, #t(25), #n(8), #i(4)];

    let register: T.Register = [
      Value.fromPrincipal(principalOfBlob("")),
      Value.fromText("S0m3 cr@zy text JuSt CUZ!"),
      Value.fromNat(4294967295),
      Value.fromInt(-2147483647)
    ];

    test("Map Register Values", func(){
      for (i in range(0, schema.size()-1)){
        let ?(len, size, genFn) = encoder(schema[i], register[i]) else {return assert false};
        Seq.add(seq, len, size, genFn)
      }
    });

    test("Generate Packed Binary", func(){
      let actual: Blob = arrayToBlob(tabulate<Nat8>(Schema.countBytes(schema), Seq.stream(seq)));
      // print("", debug_show(actual), debug_show(expected));
      assert actual == expected;
    });

  });

}