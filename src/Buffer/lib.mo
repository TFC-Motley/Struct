import T "Types";
import {print} "mo:base/Debug";
import {countBytes} "Schema";
import {range} "mo:base/Iter";
import {tabulate} "mo:base/Array";
import {get = decoder} "Decoder";
import {get = encoder} "Encoder";
import {stream; add = append; empty = init} "Sequence";
import {fromArray = blobFromArray; toArray = blobToArray} "mo:base/Blob";

module {

  type Mode = {
    #read: [Nat8];
    #write: T.Sequence;
  };

  public type Value = T.Value;
  public type Schema = T.Schema;

  public class Buffer(_schema: T.Schema) = {
    
    var _offset: Nat = 0;
    var _field_offset: Nat = 0;
    var _size: Nat = countBytes(_schema);
    var _mode: Mode = #write(init());

    public func mode(): {#read; #write} = switch _mode {
      case (#write _) #write;
      case (#read _) #read;
    };

    public func clear(): () {
      _offset := 0;
      _field_offset := 0;
      _mode := #write(init());
    };

    public func read(): ?Blob {
      switch _mode {
        case ( #write _ ) null;
        case ( #read array) {
          let size : Nat = _size - _offset;
          _offset := 0;
          _field_offset := 0;
          _mode := #write(init());
          if ( _offset == 0 ) ?blobFromArray(array)
          else ?blobFromArray(tabulate<Nat8>(
            size, func(i){  array[_offset+i] }
          ));
        }
      }
    };

    public func write(b: Blob): Bool {
      switch _mode {
        case ( #read _ ) false;
        case ( #write _ ) {
          if ( b.size() != _size ) false
          else {
            _offset := 0;
            _field_offset := 0;
            _mode := #read(blobToArray(b));
            true
          }
        }
      }
    };

    public func poll(): ?T.Value {
      switch _mode {
        case ( #write _ ) null;
        case ( #read array ){
          let (len, valueFn) = decoder(_schema[_field_offset]);
          let (tag, offset, size) = _params(len, array);
          switch( valueFn(tag, size, func(i: Nat){array[offset+i]}) ){
            case (?v){ _update(len); ?v };
            case null null
          }
        }
      }
    };

    public func offer(value: T.Value): Bool {
      switch _mode {
        case ( #read _) false;
        case ( #write seq ) {
          switch ( encoder(_schema[_field_offset], value) ) {
            case null false;
            case ( ?(len, size, genFn) ){
              append(seq, len, size, genFn);
              _update(len);
              true
            }
          }
        }
      }
    };

    func _params(len: Nat, window: [Nat8]): (Nat8, Nat, Nat) {
      func slide(t: Nat8, i: Nat): (Nat8, Nat, Nat) {
        if (t == 0x00) slide(window[i], i+1)
        else (t, i, _offset + len - i)
      };
      slide(window[_offset], _offset+1)
    };

    func _update(n: Nat): () {
      _offset += n;
      _field_offset += 1;
      if ( _offset >= _size ){
        _offset := 0;
        _field_offset := 0;
        _mode := switch _mode {
          case ( #read _) #write(init());
          case ( #write seq) #read(tabulate<Nat8>(_size, stream(seq)));
        }
      }
    };

  };

};