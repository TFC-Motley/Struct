import T "Types";
import {Buffer} "Buffer";
import Value "Buffer/Value";
import {print} "mo:base/Debug";
import {range} "mo:base/Iter";
import {freeze; init} "mo:base/Array";

module {

  public type Field = T.Field;

  public type Schema = T.Schema;

  public type Value = T.Value;

  public type Register = T.Register;

  public let {toNat = unwrapNat; fromNat = wrapNat} = Value;

  public let {toInt = unwrapInt; fromInt = wrapInt} = Value;
  
  public let {toText = unwrapText; fromText = wrapText} = Value;

  public let {toBlob = unwrapBlob; fromBlob = wrapBlob} = Value;

  public let {toBool = unwrapBool; fromBool = wrapBool} = Value;

  public let {toPrincipal = unwrapPrincipal; fromPrincipal = wrapPrincipal} = Value;

  //
  // Attempt to pack register values into a binary structure defined by the schema
  //
  public func pack(schema: Schema, register: Register): ?Blob {

    if (register.size() != schema.size()) return null;

    let buffer = Buffer(schema);

    for ( value in register.vals() )

      if ( buffer.offer(value) == false) return null;

    buffer.read()
  };

  //
  // Attempt to unpack register values from a binary structure defined by the schema
  //
  public func unpack(schema: Schema, blob: Blob): ?Register {

    let fc: Nat = schema.size();
    let buffer = Buffer(schema);
    let register = init<T.Value>(fc, #b(false));

    if (buffer.write(blob) == false) return null;

    for (i in range(0, fc-1)){

      switch ( buffer.poll() ){
        case ( ?value ) register[i] := value;
        case null return null;
      }
    
    };

    switch( buffer.mode() ){
      case ( #write ) ?freeze<T.Value>(register);
      case _ null;
    }
    
  };

};