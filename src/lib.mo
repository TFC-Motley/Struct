import T "Types";
import B "Buffer";
import S "Buffer/Schema";
import {print} "mo:base/Debug";
import {range} "mo:base/Iter";
import {freeze; init} "mo:base/Array";

module {
  
  public func pack(schema: T.Schema, register: T.Register): ?Blob {
    if (register.size() != schema.size()) return null;
    let buffer = B.Buffer(schema);
    for ( value in register.vals() )
      if ( buffer.offer(value) == false) return null;
    buffer.read()
  };

  public func unpack(schema: T.Schema, blob: Blob): ?T.Register {
    let fc: Nat = schema.size();
    let buffer = B.Buffer(schema);
    let register = init<T.Value>(fc, #b(false));
    if (buffer.write(blob) == false) return null;
    for (i in range(0, fc-1)){
      switch ( buffer.poll() ){
        case ( ?value ) register[i] := value;
        case null return null;
    }};
    switch( buffer.mode() ){
      case ( #write ) ?freeze<T.Value>(register);
      case _ null;
    }
  };

};