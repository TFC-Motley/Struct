import {test; suite} "mo:test";
import {print = debug_print} "mo:base/Debug";

module {

  func print(desc: Text, a: Text, e: Text): () {
    debug_print("Desc: " # desc # "\nActual: " # a # "\nExpected: " # e)
  };
  
  public func main(): () = suite("TEST NAME HERE", func(){});

}