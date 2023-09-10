import T "Types";
import {trap} "mo:base/Debug";
import {tabulate} "mo:base/Array";

module {

  public type Range = T.Range;
  public type Sequence = T.Sequence;
  public type Generator = T.Generator;

  public func empty(): Sequence {{var next = null}};

  public func add(seq: Sequence, len: Nat, size: Nat, streamFn: Generator): () {
    let ?range = seq.next else { seq.next := ?{
        length = len;
        padding = len - size;
        stream = streamFn;
        var offset = 0;
        var next = null;
      }; return };
    func append(ix: Range): () {
      switch( ix.next ){
        case (?iy) append(iy);
        case null ix.next := ?{
          length = len;
          padding = len - size;
          stream = streamFn;
          var offset = 0;
          var next = null;
        };
    }};
    append(range)
  };

  public func stream(seq: Sequence): Generator = func(_){
    switch( seq.next ){
      case null 0xFF;
      case( ?range ){
        range.offset += 1;
        if (range.offset == range.length) seq.next := range.next;
        if (range.offset > range.padding) range.stream(range.offset - range.padding -1)
        else 0x00
      }
    }
  };

};