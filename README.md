# Struct

## Install
```
mops add Struct
```

## Usage
```motoko
import Struct "mo:Struct";

// <Schema>: Defines the format of your packed binary record as an array of fields
//
// Where each <Field> can be one of:
//   #n - Natural Number
//   #i - Signed Integer
//   #t - Text Literal
//   #s - Byte Sequence (Blob)
//   #p - Principal Identifier
//   #b - Boolean
//
// The length of all Nat, Int, Text, and Blob fields must be defined as a natural number.
//
// The length of all Boolean fields are set to 0. Boolean value is represented in the tag.
//
// The length of all Principal fields are set to 29 per the IC Interface Specification.
//
// ALL fields will have an additional single-byte tag prepended to their value. 
//
// The total length = Static Fields (Bool/Principal) + Dynamic Fields (Nat,Int,Text,Blob) + Number of fields

let schema: Struct.Schema = [#n(8), #i(4), #t(32)];

// The Register module contains helper functions for wrapping and unwrapping values
//
// Where each <Value> can be one of:
//   #n - Natural Number
//   #i - Signed Integer
//   #t - Text Literal
//   #s - Byte Sequence (Blob)
//   #p - Principal Identifier
//   #b - Boolean
//
// TODO: Other primitive types, such as Nat8, Int16, Float, Char, ..., are all converted to one of these base values
// when passed to a helper function. (These functions don't exist, yet).

let { Register } = Struct;

// <Register>: A register is an array of values that must mirror the field order defined in the schema

let register: Struct.Register = [
  Register.wrapNat(123456789),
  Register.wrapInt(-123456789),
  Register.wrapText("Motoko is fun!...")
];

// The pack & unpack methods are used to serialize and deserialize packed binary records

Struct.pack(schema, register)

```