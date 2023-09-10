import T "Types";
import B "Buffer";
import S "Buffer/Schema";
import {range} "mo:base/Iter";
import {freeze; init} "mo:base/Array";

module {

  class Struct(_schema: T.Schema) = {

    let _buffer = B.Buffer(_schema);

    let _field_count: Nat = _schema.size();

    let (_byte_count, _signature) = S.properties(_schema);

    public func schema(): T.Schema = _schema;

    public func field_count(): Nat = _schema.size();

    public func byte_count(): Nat = _byte_count;

    public func signature(): Nat32 = _signature;

    public func pack(record: T.Register): ?Blob {
      if (record.size() != _field_count) return null;
      for (value in record.vals())
        if ( _buffer.offer(value) == false){
          _buffer.clear();
          return null
        };
      switch ( _buffer.mode() ){
        case ( #read ) _buffer.read();
        case _ {
          _buffer.clear();
          null
        };
      }
    };

    public func unpack(blob: Blob): ?T.Register {
      if (_buffer.write(blob) == false) return null;
      let record = init<T.Value>(_field_count, #b(false));
      for (i in range(0, _field_count-1)){
        switch ( _buffer.poll() ){
          case ( ?value ) record[i] := value;
          case null {_buffer.clear(); return null}
      }};
      switch( _buffer.mode() ){
        case ( #write ) ?freeze<T.Value>(record);
        case _ {
          _buffer.clear();
          null
        };
      }
    };

  };

}